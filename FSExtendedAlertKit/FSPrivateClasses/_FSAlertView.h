//
//  _FSAlertView.h
//  FSExtendedAlertKit
//
//  Created by Elliot Neal on 28/08/2012.
//  Copyright (c) 2012 emdentec. All rights reserved.
//


@protocol _FSAlertViewLayoutDelegate;

@interface _FSAlertView : UIAlertView


@property (strong, nonatomic, readonly) UILabel *titleLabel;
@property (strong, nonatomic, readonly) UILabel *messageLabel;

@property (weak, nonatomic) id <_FSAlertViewLayoutDelegate> layoutDelegate;

@end


@protocol _FSAlertViewLayoutDelegate <NSObject>
@optional


- (void)alertViewDidLayoutSubviews:(_FSAlertView *)alertView;

@end
