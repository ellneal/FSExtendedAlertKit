//
//  FSProgressAlertView.m
//  FSExtendedAlertKit
//
//  Created by Elliot Neal on 21/08/2012.
//  Copyright (c) 2012 emdentec. All rights reserved.
//

#import "FSProgressAlertView.h"
#import "_FSAlertView.h"


@interface FSProgressAlertView () <UIAlertViewDelegate, _FSAlertViewLayoutDelegate> {
    
    void (^_cancelBlock)();
    void (^_willPresentBlock)();
    void (^_didPresentBlock)();
    void (^_willDismissBlock)();
    void (^_didDismissBlock)();
}

@property (strong, nonatomic) _FSAlertView *alertView;
@property (strong, nonatomic) UIProgressView *progressView;

@end


@implementation FSProgressAlertView


- (id)initWithTitle:(NSString *)title message:(NSString *)message {
    
    self = [super init];
    
    if (self) {
        
        _FSAlertView *alertView = [[_FSAlertView alloc] initWithTitle:title message:message delegate:self cancelButtonTitle:nil otherButtonTitles:nil];
        [alertView setLayoutDelegate:self];
        
        UIProgressView *progressView = [[UIProgressView alloc] initWithProgressViewStyle:UIProgressViewStyleBar];
        [progressView setAutoresizingMask:UIViewAutoresizingFlexibleTopMargin];
        
        CGRect alertViewFrame = [alertView frame];
        CGRect progressViewFrame = [progressView frame];
        
        [progressView setFrame:CGRectMake(22, CGRectGetMaxY(alertViewFrame) - (progressViewFrame.size.height) - 37, 240, progressViewFrame.size.height)];
        [alertView addSubview:progressView];
        
        _alertView = alertView;
        _progressView = progressView;
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


#pragma mark - Progress

- (float)progress {
    
    return [self.progressView progress];
}

- (void)setProgress:(float)progress {
    
    [self.progressView setProgress:progress];
}

- (void)setProgress:(float)progress animated:(BOOL)animated {
    
    [self.progressView setProgress:progress animated:animated];
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


#pragma mark - _FSAlertViewLayoutDelegate

- (void)alertViewDidLayoutSubviews:(_FSAlertView *)alertView {
    
    CGRect progressViewFrame = [self.progressView frame];
    CGRect titleLabelFrame = [self.alertView.titleLabel frame];
    
    progressViewFrame.origin.x = titleLabelFrame.origin.x;
    progressViewFrame.size.width = titleLabelFrame.size.width;
    
    [self.progressView setFrame:progressViewFrame];
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
