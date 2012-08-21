//
//  FSAlertView.m
//  FSExtendedAlertKit
//
//  Created by Elliot Neal on 21/08/2012.
//  Copyright (c) 2012 emdentec. All rights reserved.
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
