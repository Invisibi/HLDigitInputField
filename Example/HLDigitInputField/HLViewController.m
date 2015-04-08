//
//  HLViewController.m
//  HLDigitInputField
//
//  Created by KenKuan on 12/16/2014.
//  Copyright (c) 2014 KenKuan. All rights reserved.
//

#import "HLViewController.h"
#import "HLDigitInputField.h"

@interface HLViewController ()<HLDigitInputFieldDelegate>

@end

@implementation HLViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.digitInputTextField.digitEdgeInsets = (UIEdgeInsets) {.left = 7.5f, .right = 7.5f, .top = 20.f, .bottom =  15.f};
    self.digitInputTextField.digits = 6;
    self.digitInputTextField.keyboardType = UIKeyboardTypeNumberPad;
    self.digitInputTextField.delegate = self;
    self.digitInputTextField.textColor = [UIColor blackColor];
    self.digitInputTextField.borderColor = [UIColor blackColor];
    self.digitInputTextField.style = HLDigitInputFieldStyleMiddle;
    [self.digitInputTextField becomeFirstResponder];
}

#pragma mark - HLDigitInputTextField

- (void)digitInputTextField:(HLDigitInputField *)textField didFinishWithText:(NSString *)text {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Code" message:text delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alert show];
}

@end
