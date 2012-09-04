//
//  FSProgressAlertView.m
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
    
    dispatch_async(dispatch_get_main_queue(), ^ {
        [self.progressView setProgress:progress animated:animated];
    });
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
