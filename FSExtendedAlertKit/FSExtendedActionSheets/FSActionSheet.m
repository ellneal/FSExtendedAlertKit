//
//  FSActionSheet.m
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

#import "FSActionSheet.h"
#import "FSBlockButton.h"


@interface FSActionSheet () <UIActionSheetDelegate> {
    
    NSMutableArray *_blockButtons;
    
    void (^_cancelBlock)();
    void (^_willPresentBlock)();
    void (^_didPresentBlock)();
    void (^_willDismissBlock)();
    void (^_didDismissBlock)();
}

@property (strong, nonatomic) UIActionSheet *actionSheet;

@end


@implementation FSActionSheet


- (id)initWithTitle:(NSString *)title cancelButton:(FSBlockButton *)cancelButton destructiveButton:(FSBlockButton *)destructiveButton otherButtons:(FSBlockButton *)otherButtons, ... {
    
    self = [super init];
    
    if (self) {
        
        _actionSheet = [[UIActionSheet alloc] initWithTitle:title delegate:self cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles:nil];
        _blockButtons = [[NSMutableArray alloc] init];
        
        if (destructiveButton != nil) {
            NSInteger index = [self addButton:destructiveButton];
            [self setDestructiveButtonIndex:index];
        }
        
        va_list buttons;
        va_start(buttons, otherButtons);
        
        for (FSBlockButton *button = otherButtons; button != nil; button = va_arg(buttons, FSBlockButton*)) {
            [self addButton:button];
        }
        
        va_end(buttons);
        
        if (cancelButton != nil) {
            NSInteger index = [self addButton:cancelButton];
            [self setCancelButtonIndex:index];
        }
    }
    
    return self;
}


#pragma mark - Wrapper Methods

- (NSString *)title {
    
    return [self.actionSheet title];
}

- (void)setTitle:(NSString *)title {
    
    [self.actionSheet setTitle:title];
}

- (UIActionSheetStyle)actionSheetStyle {
    
    return [self.actionSheet actionSheetStyle];
}

- (void)setActionSheetStyle:(UIActionSheetStyle)actionSheetStyle {
    
    [self.actionSheet setActionSheetStyle:actionSheetStyle];
}

- (NSString *)buttonTitleAtIndex:(NSInteger)buttonIndex {
    
    return [self.actionSheet buttonTitleAtIndex:buttonIndex];
}

- (NSInteger)cancelButtonIndex {
    
    return [self.actionSheet cancelButtonIndex];
}

- (void)setCancelButtonIndex:(NSInteger)cancelButtonIndex {
    
    [self.actionSheet setCancelButtonIndex:cancelButtonIndex];
}

- (NSInteger)destructiveButtonIndex {
    
    return [self.actionSheet destructiveButtonIndex];
}

- (void)setDestructiveButtonIndex:(NSInteger)destructiveButtonIndex {
    
    [self.actionSheet setDestructiveButtonIndex:destructiveButtonIndex];
}

- (NSInteger)firstOtherButtonIndex {
    
    return [self.actionSheet firstOtherButtonIndex];
}

- (BOOL)isVisible {
    
    return [self.actionSheet isVisible];
}

- (void)showFromToolbar:(UIToolbar *)view {
    
    [self.actionSheet showFromToolbar:view];
    [[[self class] activeActionSheets] addObject:self];
}

- (void)showFromTabBar:(UITabBar *)view {
    
    [self.actionSheet showFromTabBar:view];
    [[[self class] activeActionSheets] addObject:self];
}

- (void)showFromBarButtonItem:(UIBarButtonItem *)item animated:(BOOL)animated {
    
    [self.actionSheet showFromBarButtonItem:item animated:animated];
    [[[self class] activeActionSheets] addObject:self];
}

- (void)showFromRect:(CGRect)rect inView:(UIView *)view animated:(BOOL)animated {
    
    [self.actionSheet showFromRect:rect inView:view animated:animated];
    [[[self class] activeActionSheets] addObject:self];
}

- (void)showInView:(UIView *)view {
    
    [self.actionSheet showInView:view];
    [[[self class] activeActionSheets] addObject:self];
}


#pragma mark - Buttons

- (NSInteger)addButtonWithTitle:(NSString *)title block:(void (^)())block {
    
    FSBlockButton *blockButton = [FSBlockButton blockButtonWithTitle:title block:block];
    
    return [self addButton:blockButton];
}

- (NSInteger)addButton:(FSBlockButton *)button {
    
    NSInteger buttonIndex = [self.actionSheet addButtonWithTitle:[button title]];
    
    [_blockButtons insertObject:button atIndex:buttonIndex];
    
    return buttonIndex;
}

- (void)dismissWithClickedButtonIndex:(NSInteger)buttonIndex animated:(BOOL)animated {
    
    [self.actionSheet dismissWithClickedButtonIndex:buttonIndex animated:animated];
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


#pragma mark - UIActionSheetDelegate

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    [self performBlockForButtonAtIndex:buttonIndex];
}

- (void)actionSheetCancel:(UIActionSheet *)actionSheet {
    
    if (_cancelBlock != nil) {
        _cancelBlock();
    }
    else {
        [self performBlockForButtonAtIndex:[actionSheet cancelButtonIndex]];
    }
}

- (void)willPresentActionSheet:(UIActionSheet *)actionSheet {
    
    if (_willPresentBlock != nil) {
        _willPresentBlock();
    }
}

- (void)didPresentActionSheet:(UIActionSheet *)actionSheet {
    
    if (_didPresentBlock != nil) {
        _didPresentBlock();
    }
}

- (void)actionSheet:(UIActionSheet *)actionSheet willDismissWithButtonIndex:(NSInteger)buttonIndex {
    
    if (_willDismissBlock != nil) {
        _willDismissBlock();
    }
}

- (void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex {
    
    if (_didDismissBlock != nil) {
        _didDismissBlock();
    }
    
    [[[self class] activeActionSheets] removeObject:self];
}


#pragma mark - Action Sheet Storage

+ (NSMutableArray *)activeActionSheets {
    
    static dispatch_once_t dispatchToken;
    static NSMutableArray *activeActionSheets = nil;
    
    dispatch_once(&dispatchToken, ^ {
        activeActionSheets = [[NSMutableArray alloc] init];
    });
    
    return activeActionSheets;
}

@end
