//
//  FSAlertView.h
//  FSExtendedAlertKit
//
//  Created by Elliot Neal on 21/08/2012.
//  Copyright (c) 2012 emdentec. All rights reserved.
//
//  Based on PSAlertView by Peter Steinberger (part of PSFoundation - https://github.com/steipete/PSFoundation)
//


@interface FSAlertView : NSObject


- (id)initWithTitle:(NSString *)title message:(NSString *)message cancelButtonTitle:(NSString *)cancelButtonTitle cancelButtonBlock:(void (^)())block;


@property (copy, nonatomic) NSString *title;
@property (copy, nonatomic) NSString *message;


- (NSInteger)addButtonWithTitle:(NSString *)title block:(void (^)())block;
- (NSString *)buttonTitleAtIndex:(NSInteger)buttonIndex;

@property (readonly, nonatomic) NSInteger numberOfButtons;
@property (nonatomic) NSInteger cancelButtonIndex;
@property (nonatomic, readonly) NSInteger firstOtherButtonIndex;


@property (readonly, nonatomic, getter=isVisible) BOOL visible;

- (void)show;
- (void)dismissWithClickedButtonIndex:(NSInteger)buttonIndex animated:(BOOL)animated;


- (void)setCancelBlock:(void (^)())block;
- (void)setWillPresentBlock:(void (^)())block;
- (void)setDidPresentBlock:(void (^)())block;
- (void)setWillDismissBlock:(void (^)())block;
- (void)setDidDismissBlock:(void (^)())block;

@end
