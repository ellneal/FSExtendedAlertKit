//
//  _FSAlertView.m
//  FSExtendedAlertKit
//
//  Created by Elliot Neal on 28/08/2012.
//  Copyright (c) 2012 emdentec. All rights reserved.
//

#import "_FSAlertView.h"


@interface _FSAlertView ()


@property (strong, nonatomic) UILabel *cachedTitleLabel;
@property (strong, nonatomic) UILabel *cachedMessageLabel;

@end


@implementation _FSAlertView


- (void)layoutSubviews {
    [super layoutSubviews];
    
    // work out which subviews are the labels and cache them
    
    for (UIView *subview in [self subviews]) {
        
        if ([subview isKindOfClass:[UILabel class]]) {
            
            UILabel *label = (UILabel *)subview;
            
            if ([[label text] isEqualToString:[self title]]) {
                [self setCachedTitleLabel:label];
            }
            else if ([[label text] isEqualToString:[self message]]) {
                [self setCachedMessageLabel:label];
            }
        }
    }
    
    if ([self.layoutDelegate respondsToSelector:@selector(alertViewDidLayoutSubviews:)]) {
        [self.layoutDelegate alertViewDidLayoutSubviews:self];
    }
}


#pragma mark - Labels

- (UILabel *)titleLabel {
    
    return [self cachedTitleLabel];
}

- (UILabel *)messageLabel {
    
    return [self cachedMessageLabel];
}

@end
