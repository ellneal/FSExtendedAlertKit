//
//  FSActivityIndicatorAlertView.h
//  FSExtendedAlertKit
//
//  Created by Elliot Neal on 21/08/2012.
//  Copyright (c) 2012 emdentec. All rights reserved.
//


@interface FSActivityIndicatorAlertView : NSObject


- (id)initWithTitle:(NSString *)title message:(NSString *)message;

- (void)show;
- (void)dismiss:(BOOL)animated;


- (void)setCancelBlock:(void (^)())block;
- (void)setWillPresentBlock:(void (^)())block;
- (void)setDidPresentBlock:(void (^)())block;
- (void)setWillDismissBlock:(void (^)())block;
- (void)setDidDismissBlock:(void (^)())block;

@end
