//
//  IVDigitInputTextField.m
//  Hedwig
//
//  Created by Ken Kuan on 12/15/14.
//  Copyright (c) 2014 invisibi. All rights reserved.
//
#import <PureLayout/PureLayout.h>

#import "HLDigitInputTextField.h"

static const NSInteger kDefaultDigits = 4;

@interface HLDigitInputTextField ()<UITextFieldDelegate>

@property (nonatomic, weak) UITextField *textField;
@property (nonatomic) NSArray *digitLabels;
@property (nonatomic) NSArray *borderViews;
@property (nonatomic) NSMutableArray *labelWidthConstraints;
@property (nonatomic) NSMutableArray *labelHeightConstraints;

@end

@implementation HLDigitInputTextField

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self _setUpView];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self _setUpView];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self _setUpView];
    }
    return self;
}

- (BOOL)canBecomeFirstResponder
{
    return YES;
}

- (BOOL)becomeFirstResponder
{
    return [self.textField becomeFirstResponder];
}

- (BOOL)resignFirstResponder
{
    return [self.textField resignFirstResponder];
}

#pragma mark - Setter

- (void)setFont:(UIFont *)font
{
    _font = font;
    if (![_font isEqual:font]) {
        for (UILabel *label in self.digitLabels) {
            label.font = font;
        }
        [self _updateDigitLabelsSizeConstraints];
    }
}

- (void)setDigits:(NSInteger)digits
{
    if (_digits != digits) {
        _digits = digits;
        [self _setUpDigitLabels];
    }
}

- (void)setTextColor:(UIColor *)textColor
{
    _textColor = textColor;
    for (UILabel *label in self.digitLabels) {
        label.textColor = textColor;
    }
}

- (void)setBorderColor:(UIColor *)borderColor
{
    _borderColor = borderColor;
    for (UIView *view in self.borderViews) {
        view.backgroundColor = borderColor;
    }
}

- (void)setDigitEdgeInsets:(UIEdgeInsets)edgeInsets
{
    if (!UIEdgeInsetsEqualToEdgeInsets(_digitEdgeInsets, edgeInsets)) {
        _digitEdgeInsets = edgeInsets;
        [self _setUpDigitLabels];
    }
}

- (void)setKeyboardType:(UIKeyboardType)keyboardType
{
    _keyboardType = keyboardType;
    self.textField.keyboardType = keyboardType;
}

- (void)setText:(NSString *)text
{
    if (self.upperString) {
        text = [text uppercaseString];
    }
    
    self.textField.text = text;
    for (NSInteger i = 0; i < self.digitLabels.count; i++) {
        UILabel *label = self.digitLabels[i];
        if (i >= text.length) {
            label.text = nil;
        } else {
            label.text = [text substringWithRange:NSMakeRange(i, 1)];
        }
    }
    
    if (text.length == self.digits) {
        [self.delegate digitInputTextField:self didFinishWithText:text];
    }
}

- (NSString *)text
{
    return self.textField.text;
}

#pragma mark - UITextFieldDelegate

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    NSString *result = [textField.text stringByReplacingCharactersInRange:range withString:string];
    self.text = result;
    
    return NO;
}

#pragma mark - Private Helper

- (void)_setUpView
{
    [self _setUpDefaultValues];
    [self _setUpDigitLabels];
    [self _setUpTextField];
    [self _setUpTapGestureRecognizer];
    
}

- (void)_setUpDefaultValues
{
    self.digits = kDefaultDigits;
    self.font = [UIFont boldSystemFontOfSize:24.f];
    self.textColor = [UIColor whiteColor];
    self.borderColor = [UIColor whiteColor];
    self.backgroundColor = [UIColor clearColor];
    self.digitEdgeInsets = UIEdgeInsetsZero;
    self.labelWidthConstraints = [NSMutableArray array];
    self.labelHeightConstraints = [NSMutableArray array];
}

- (void)_setUpDigitLabels
{
    [self.labelWidthConstraints removeAllObjects];
    [self.labelHeightConstraints removeAllObjects];
    
    for (UIView *digitLabel in self.digitLabels) {
        [digitLabel.superview removeFromSuperview];
    }
    
    if (!self.digits) {
        return;
    }
    
    NSMutableArray *digitLabels = [NSMutableArray arrayWithCapacity:self.digits];
    NSMutableArray *borderViews = [NSMutableArray arrayWithCapacity:self.digits];
    UIView *prevContainer;
    CGSize size = [self _sizeForFont:self.font];
    for (NSInteger i = 0; i < self.digits; i++) {
        UIView *containerView = [[UIView alloc] initForAutoLayout];
        
        UILabel *label = [[UILabel alloc] initForAutoLayout];
        label.font = self.font;
        label.textAlignment = NSTextAlignmentCenter;
        label.textColor = self.textColor;
        label.backgroundColor = [UIColor clearColor];
        [digitLabels addObject:label];
        [containerView addSubview:label];
        [self.labelWidthConstraints addObject:[label autoSetDimension:ALDimensionWidth toSize:size.width]];
        [self.labelHeightConstraints addObject:[label autoSetDimension:ALDimensionHeight toSize:size.height]];
        [label autoPinEdgesToSuperviewEdgesWithInsets:self.digitEdgeInsets];
        
        UIView *underLine = [[UIView alloc] initForAutoLayout];
        underLine.backgroundColor = self.borderColor;
        underLine.layer.cornerRadius = 1.f;
        underLine.clipsToBounds = YES;
        [borderViews addObject:underLine];
        [containerView addSubview:underLine];
        [underLine autoSetDimension:ALDimensionHeight toSize:2.f];
        [underLine autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero excludingEdge:ALEdgeTop];
        
        [self addSubview:containerView];
        [containerView autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:0.f];
        [containerView autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:0.f];
        if (i == 0) {
            [containerView autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:0.f];
            prevContainer = containerView;
            continue;
        } else if (i == self.digits - 1) {
            [containerView autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:0.f];
        }
        [containerView autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:prevContainer withOffset:10.f];
        prevContainer = containerView;
    }
    
    self.borderViews = borderViews;
    self.digitLabels = digitLabels;
}

- (CGSize)_sizeForFont:(UIFont *)font
{
    UILabel *placeholder = [[UILabel alloc] init];
    placeholder.text = @"@";
    placeholder.font = font;
    [placeholder sizeToFit];
    return placeholder.bounds.size;
}

- (void)_setUpTextField
{
    UITextField *textField = [[UITextField alloc] initWithFrame:CGRectZero];
    textField.delegate = self;
    textField.keyboardType = UIKeyboardTypeNumberPad;
    [self addSubview:textField];
    self.textField = textField;
}

- (void)_setUpTapGestureRecognizer
{
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(_tapped:)];
    [self addGestureRecognizer:tapGestureRecognizer];
}

- (void)_tapped:(UITapGestureRecognizer *)gestureRecognizer
{
    [self becomeFirstResponder];
}

- (void)_updateDigitLabelsSizeConstraints
{
    CGSize size = [self _sizeForFont:self.font];
    for (NSLayoutConstraint *constraint in self.labelWidthConstraints) {
        constraint.constant = size.width;
    }
    for (NSLayoutConstraint *constraint in self.labelHeightConstraints) {
        constraint.constant = size.height;
    }
}

@end
