//
//  FSActivityIndicatorAlertView.m
//  FSExtendedAlertKit
//
//  Created by Elliot Neal on 21/08/2012.
//  Copyright (c) 2012 emdentec. All rights reserved.
//

#import "FSActivityIndicatorAlertView.h"
#import "_FSAlertView.h"


@interface FSActivityIndicatorAlertView () <UIAlertViewDelegate, _FSAlertViewLayoutDelegate> {
    
    void (^_cancelBlock)();
    void (^_willPresentBlock)();
    void (^_didPresentBlock)();
    void (^_willDismissBlock)();
    void (^_didDismissBlock)();
}

@property (strong, nonatomic) _FSAlertView *alertView;

@end


@implementation FSActivityIndicatorAlertView


- (id)initWithTitle:(NSString *)title message:(NSString *)message {
    
    self = [super init];
    
    if (self) {
        
        _FSAlertView *alertView = [[_FSAlertView alloc] initWithTitle:title message:message delegate:self cancelButtonTitle:nil otherButtonTitles:nil];
        [alertView setLayoutDelegate:self];
        
        UIActivityIndicatorView *activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
        [activityIndicator setAutoresizingMask:UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleLeftMargin];
        [activityIndicator startAnimating];
        
        CGRect alertViewFrame = [alertView frame];
        CGRect activityIndicatorFrame = [activityIndicator frame];
        
        [activityIndicator setCenter:CGPointMake(CGRectGetMidX(alertViewFrame), CGRectGetMaxY(alertViewFrame) - (activityIndicatorFrame.size.height / 2) - 27)];
        [alertView addSubview:activityIndicator];
        
        _alertView = alertView;
    }
    
    return self;
}


#pragma mark - Show/Hide

- (void)show {
    
    [self.alertView show];
    [[[self class] activeAlertViews] addObject:self];
}

- (void)dismiss:(BOOL)animated {
    
    [self.alertView dismissWithClickedButtonIndex:[self.alertView cancelButtonIndex] animated:animated];
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

- (void)alertViewCancel:(UIAlertView *)alertView {
    
    if (_cancelBlock != nil) {
        _cancelBlock();
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
