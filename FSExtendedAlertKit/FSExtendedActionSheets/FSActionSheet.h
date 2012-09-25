//
//  FSActionSheet.h
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
//  Based on PSActionSheet by Peter Steinberger (part of PSFoundation - https://github.com/steipete/PSFoundation)
//


@class FSBlockButton;

@interface FSActionSheet : NSObject


- (id)initWithTitle:(NSString *)title cancelButton:(FSBlockButton *)cancelButton destructiveButton:(FSBlockButton *)destructiveButton otherButtons:(FSBlockButton *)otherButtons, ... NS_REQUIRES_NIL_TERMINATION;


@property (copy, nonatomic) NSString *title;
@property (nonatomic) UIActionSheetStyle actionSheetStyle;


- (NSInteger)addButtonWithTitle:(NSString *)title block:(void (^)())block;
- (NSInteger)addButton:(FSBlockButton *)button;
- (NSString *)buttonTitleAtIndex:(NSInteger)buttonIndex;

@property (readonly, nonatomic) NSInteger numberOfButtons;
@property (nonatomic) NSInteger cancelButtonIndex;
@property (nonatomic) NSInteger destructiveButtonIndex;
@property (nonatomic, readonly) NSInteger firstOtherButtonIndex;


@property (readonly, nonatomic, getter=isVisible) BOOL visible;

- (void)showFromToolbar:(UIToolbar *)view;
- (void)showFromTabBar:(UITabBar *)view;
- (void)showFromBarButtonItem:(UIBarButtonItem *)item animated:(BOOL)animated;
- (void)showFromRect:(CGRect)rect inView:(UIView *)view animated:(BOOL)animated;
- (void)showInView:(UIView *)view;
- (void)dismissWithClickedButtonIndex:(NSInteger)buttonIndex animated:(BOOL)animated;


- (void)setCancelBlock:(void (^)())block;
- (void)setWillPresentBlock:(void (^)())block;
- (void)setDidPresentBlock:(void (^)())block;
- (void)setWillDismissBlock:(void (^)())block;
- (void)setDidDismissBlock:(void (^)())block;

@end
