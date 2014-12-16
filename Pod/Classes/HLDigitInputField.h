//
//  IVDigitInputTextField.h
//  Hedwig
//
//  Created by Ken Kuan on 12/15/14.
//  Copyright (c) 2014 invisibi. All rights reserved.
//

#import <UIKit/UIKit.h>

@class HLDigitInputField;

@protocol HLDigitInputFieldDelegate <NSObject>

- (void)digitInputTextField:(HLDigitInputField *)textField didFinishWithText:(NSString *)text;

@end

@interface HLDigitInputField : UIView

@property (nonatomic) id<HLDigitInputFieldDelegate> delegate;

@property (nonatomic) NSInteger digits;
@property (nonatomic) UIKeyboardType keyboardType;
@property (nonatomic) UIFont *font;
@property (nonatomic) UIColor *textColor;
@property (nonatomic) UIColor *borderColor;
@property (nonatomic) NSString *text;
@property (nonatomic) UIEdgeInsets digitEdgeInsets;
@property (nonatomic) BOOL upperString;

@end
