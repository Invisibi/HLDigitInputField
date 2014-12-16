//
//  IVDigitInputTextField.h
//  Hedwig
//
//  Created by Ken Kuan on 12/15/14.
//  Copyright (c) 2014 invisibi. All rights reserved.
//

#import <UIKit/UIKit.h>

@class HLDigitInputTextField;

@protocol HLDigitInputTextFieldDelegate <NSObject>

- (void)digitInputTextField:(HLDigitInputTextField *)textField didFinishWithText:(NSString *)text;

@end

@interface HLDigitInputTextField : UIView

@property (nonatomic) id<HLDigitInputTextFieldDelegate> delegate;

@property (nonatomic) NSInteger digits;
@property (nonatomic) UIKeyboardType keyboardType;
@property (nonatomic) UIFont *font;
@property (nonatomic) UIColor *textColor;
@property (nonatomic) UIColor *borderColor;
@property (nonatomic) NSString *text;
@property (nonatomic) UIEdgeInsets digitEdgeInsets;
@property (nonatomic) BOOL upperString;

@end
