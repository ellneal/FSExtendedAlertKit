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
#import "FSBlockButton.h"


@interface FSAlertView () <UIAlertViewDelegate> {
    
    NSMutableArray *_blockButtons;
    
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
        _blockButtons = [[NSMutableArray alloc] init];
        
        if ([cancelButtonTitle length] > 0) {
            FSBlockButton *cancelButton = [FSBlockButton blockButtonWithTitle:cancelButtonTitle block:block];
            [_blockButtons addObject:cancelButton];
        }
    }
    
    return self;
}

- (id)initWithTitle:(NSString *)title message:(NSString *)message cancelButton:(FSBlockButton *)cancelButton otherButtons:(FSBlockButton *)otherButtons, ... {
    
    self = [super init];
    
    if (self) {
        
        _alertView = [[UIAlertView alloc] initWithTitle:title message:message delegate:self cancelButtonTitle:[cancelButton title] otherButtonTitles:nil];
        _blockButtons = [[NSMutableArray alloc] init];
        
        if (cancelButton != nil) {
            [_blockButtons addObject:cancelButton];
        }
        
        va_list buttons;
        va_start(buttons, otherButtons);
        
        for (FSBlockButton *button = otherButtons; button != nil; button = va_arg(buttons, FSBlockButton*)) {
            [self addButton:button];
        }
        
        va_end(buttons);
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
    
    FSBlockButton *blockButton = [FSBlockButton blockButtonWithTitle:title block:block];
    
    return [self addButton:blockButton];
}

- (NSInteger)addButton:(FSBlockButton *)button {
    
    NSInteger buttonIndex = [self.alertView addButtonWithTitle:[button title]];
    
    [_blockButtons insertObject:button atIndex:buttonIndex];
    
    return buttonIndex;
}

- (void)dismissWithClickedButtonIndex:(NSInteger)buttonIndex animated:(BOOL)animated {
    
    [self.alertView dismissWithClickedButtonIndex:buttonIndex animated:animated];
    [self performBlockForButtonAtIndex:buttonIndex];
}

- (void)performBlockForButtonAtIndex:(NSInteger)buttonIndex {
    
    if (buttonIndex >= 0 && buttonIndex < [_blockButtons count]) {
        
        FSBlockButton *blockButton = [_blockButtons objectAtIndex:buttonIndex];
        
        if ([blockButton block] != nil) {
            blockButton.block();
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
        [self performBlockForButtonAtIndex:[alertView cancelButtonIndex]];
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
    
    static dispatch_once_t dispatchToken;
    static NSMutableArray *activeAlertViews = nil;
    
    dispatch_once(&dispatchToken, ^ {
        activeAlertViews = [[NSMutableArray alloc] init];
    });
    
    return activeAlertViews;
}

@end
