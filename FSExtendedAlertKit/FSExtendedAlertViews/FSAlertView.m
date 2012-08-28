//
//  FSAlertView.m
//  FSExtendedAlertKit
//
//	Copyright (c) 2012, emdentec (Elliot Neal)
//	All rights reserved.
//
//	Redistribution and use in source and binary forms, with or without
//	modification, are permitted provided that the following conditions are met:
//		* Redistributions of source code must retain the above copyright
//		  notice, this list of conditions and the following disclaimer.
//		* Redistributions in binary form must reproduce the above copyright
//		  notice, this list of conditions and the following disclaimer in the
//		  documentation and/or other materials provided with the distribution.
//		* Neither the name of emdentec nor the
//		  names of its contributors may be used to endorse or promote products
//		  derived from this software without specific prior written permission.
//
//	THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
//	ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
//	WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
//	DISCLAIMED. IN NO EVENT SHALL COPYRIGHT HOLDERS OR CONTRIBUTORS BE LIABLE FOR ANY
//	DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
//	(INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
//	LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
//	ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
//	(INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
//	SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
//
//  Based on PSAlertView by Peter Steinberger (part of PSFoundation - https://github.com/steipete/PSFoundation)
//

#import "FSAlertView.h"


@interface FSAlertView () <UIAlertViewDelegate> {
    
    NSMutableArray *_buttonBlocks;
    
    void (^_cancelBlock)();
    void (^_willPresentBlock)();
    void (^_didPresentBlock)();
    void (^_willDismissBlock)();
    void (^_didDismissBlock)();
}

@property (strong, nonatomic) UIAlertView *alertView;

@end


@implementation FSAlertView


- (id)initWithTitle:(NSString *)title message:(NSString *)message cancelButtonTitle:(NSString *)cancelButtonTitle cancelButtonBlock:(void (^)())block {
    
    self = [super init];
    
    if (self) {
        
        _alertView = [[UIAlertView alloc] initWithTitle:title message:message delegate:self cancelButtonTitle:cancelButtonTitle otherButtonTitles:nil];
        _buttonBlocks = [[NSMutableArray alloc] init];
        
        if ([cancelButtonTitle length] > 0) {
            if (block != nil) {
                [_buttonBlocks addObject:[block copy]];
            }
            else {
                [_buttonBlocks addObject:[NSNull null]];
            }
        }
    }
    
    return self;
}


#pragma mark - Wrapper Methods

- (NSString *)title {
    
    return [self.alertView title];
}

- (void)setTitle:(NSString *)title {
    
    [self.alertView setTitle:title];
}

- (NSString *)message {
    
    return [self.alertView message];
}

- (void)setMessage:(NSString *)message {
    
    [self.alertView setMessage:message];
}

- (NSString *)buttonTitleAtIndex:(NSInteger)buttonIndex {
    
    return [self.alertView buttonTitleAtIndex:buttonIndex];
}

- (NSInteger)cancelButtonIndex {
    
    return [self.alertView cancelButtonIndex];
}

- (void)setCancelButtonIndex:(NSInteger)cancelButtonIndex {
    
    [self.alertView setCancelButtonIndex:cancelButtonIndex];
}

- (NSInteger)firstOtherButtonIndex {
    
    return [self.alertView firstOtherButtonIndex];
}

- (BOOL)isVisible {
    
    return [self.alertView isVisible];
}

- (void)show {
    
    [self.alertView show];
    [[[self class] activeAlertViews] addObject:self];
}


#pragma mark - Buttons

- (NSInteger)addButtonWithTitle:(NSString *)title block:(void (^)())block {
    
    NSInteger buttonIndex = [self.alertView addButtonWithTitle:title];
    
    if (block) {
        [_buttonBlocks insertObject:[block copy] atIndex:buttonIndex];
    }
    else {
        [_buttonBlocks insertObject:[NSNull null] atIndex:buttonIndex];
    }
    
    return buttonIndex;
}


- (void)dismissWithClickedButtonIndex:(NSInteger)buttonIndex animated:(BOOL)animated {
    
    [self.alertView dismissWithClickedButtonIndex:buttonIndex animated:animated];
    [self performBlockForButtonAtIndex:buttonIndex];
}

- (void)performBlockForButtonAtIndex:(NSInteger)buttonIndex {
    
    if (buttonIndex >= 0 && buttonIndex < [_buttonBlocks count]) {
        
        id obj = [_buttonBlocks objectAtIndex:buttonIndex];
        
        if (![obj isEqual:[NSNull null]]) {
            ((void (^)())obj)();
        }
    }
}


#pragma mark - Other Delegate Methods Blocks

- (void)setCancelBlock:(void (^)())block {
    
    _cancelBlock = [block copy];
}

- (void)setWillPresentBlock:(void (^)())block {
    
    _willPresentBlock = [block copy];
}

- (void)setDidPresentBlock:(void (^)())block {
    
    _didPresentBlock = [block copy];
}

- (void)setWillDismissBlock:(void (^)())block {
    
    _willDismissBlock = [block copy];
}

- (void)setDidDismissBlock:(void (^)())block {
    
    _didDismissBlock = [block copy];
}


#pragma mark - UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    [self performBlockForButtonAtIndex:buttonIndex];
}

- (void)alertViewCancel:(UIAlertView *)alertView {
    
    if (_cancelBlock != nil) {
        _cancelBlock();
    }
    else {
        [self performBlockForButtonAtIndex:[self.alertView cancelButtonIndex]];
    }
}

- (void)willPresentAlertView:(UIAlertView *)alertView {
    
    if (_willPresentBlock != nil) {
        _willPresentBlock();
    }
}

- (void)didPresentAlertView:(UIAlertView *)alertView {
    
    if (_didPresentBlock != nil) {
        _didPresentBlock();
    }
}

- (void)alertView:(UIAlertView *)alertView willDismissWithButtonIndex:(NSInteger)buttonIndex {
    
    if (_willDismissBlock != nil) {
        _willDismissBlock();
    }
}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
    
    if (_didDismissBlock != nil) {
        _didDismissBlock();
    }
    
    [[[self class] activeAlertViews] removeObject:self];
}


#pragma mark - Alert View Storage

+ (NSMutableArray *)activeAlertViews {
    
    static NSMutableArray *activeAlertViews = nil;
    
    if (activeAlertViews == nil) {
        activeAlertViews = [[NSMutableArray alloc] init];
    }
    
    return activeAlertViews;
}

@end
