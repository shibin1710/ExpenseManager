//
//  FPNumberPadView.m
//  FPNumberPadView
//
//  Created by Fabrizio Prosperi on 5/11/12.
//  Copyright (c) 2012 Absolutely iOS. All rights reserved.
//

// Permission is hereby granted, free of charge, to any person obtaining a copy of this
// software and associated documentation files (the "Software"), to deal in the Software
// without restriction, including without limitation the rights to use, copy, modify, merge,
// publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons
// to whom the Software is furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in all copies or
// substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED,
// INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR
// PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE
// FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR
// OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER
// DEALINGS IN THE SOFTWARE.

/*
 This is heavily inspired by the following post on Stack Overflow
 http://stackoverflow.com/questions/13205160/how-do-i-retrieve-keystrokes-from-a-custom-keyboard-on-an-ios-app
 */


#import "FPNumberPadView.h"
#import "IRCommon.h"
#import <QuartzCore/QuartzCore.h>

@interface FPNumberPadView () <UIInputViewAudioFeedback>

@property (weak, nonatomic) IBOutlet UITextField *numberTextField;
@property (weak, nonatomic) IBOutlet UILabel *currencySymbol;
@property (weak, nonatomic) IBOutlet UIButton *cancelButton;
@property (weak, nonatomic) IBOutlet UIButton *okButton;

@end

@implementation FPNumberPadView

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        
        [self loadWithNIB];
        [_numberTextField becomeFirstResponder];
        [self.okButton setTitle:[IRCommon localizeText:OK_TEXT] forState:UIControlStateNormal];
        [self.cancelButton setTitle:[IRCommon localizeText:@"Cancel"] forState:UIControlStateNormal];
        UIView *view = [[UIView alloc]initWithFrame:CGRectZero];
        _numberTextField.inputView = view;
        self.layer.borderWidth = 1.0f;
        self.layer.borderColor = [UIColor lightGrayColor].CGColor;
        self.layer.shadowOpacity = 0.2;
        self.layer.shadowColor = [UIColor darkGrayColor].CGColor;
        self.layer.cornerRadius = 10.0f;
        self.layer.backgroundColor = [UIColor whiteColor].CGColor;
        NSString *currencyCode = [[NSUserDefaults standardUserDefaults]objectForKey:@"currency"];
        self.currencySymbol.text = [IRCommon getCurrencySymbolFromCode:currencyCode];
        self.cancelButton.titleLabel.font = [IRCommon getDefaultFontForSize:14 isBold:NO];
        self.okButton.titleLabel.font = [IRCommon getDefaultFontForSize:14 isBold:NO];
        

    }
    return self;
}

- (UIView *)loadWithNIB {
    NSArray *aNib = [[NSBundle mainBundle]loadNibNamed:NSStringFromClass([self class]) owner:self options:nil];
    UIView *view = [aNib objectAtIndex:0];
    [self addSubview:view];
    return view;
}

- (IBAction)clicked:(UIButton *)sender {
    // search for an existing dot
    
    NSRange dot = [_numberTextField.text rangeOfString:@"."];
    
    switch (sender.tag) {
        case 10:
            if (_numberTextField.text.length >= 8) {
                return;
            }
            if (dot.location == NSNotFound) {
                // only 1 decimal dot allowed
                [_numberTextField insertText:@"."];
                [[UIDevice currentDevice] playInputClick];
            }
            break;
        case 11:
            [_numberTextField deleteBackward];
            [[UIDevice currentDevice] playInputClick];
            break;
        default:
            if (_numberTextField.text.length >= 8) {
                return;
            }
            // max 2 decimals
            if (dot.location == NSNotFound || _numberTextField.text.length <= dot.location + 2) {
                [_numberTextField insertText:[NSString stringWithFormat:@"%ld", (long)sender.tag]];
                [[UIDevice currentDevice] playInputClick];
            }
            break;
    }
}

#pragma mark - UIInputViewAudioFeedback delegate

- (BOOL)enableInputClicksWhenVisible {
    return YES;
}
- (IBAction)didTouchUpInsideOkButton:(id)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(didTapOkButton:)]) {
        [self.delegate didTapOkButton:_numberTextField.text];
    }
    [self removeFromSuperview];
}
- (IBAction)didTouchUpInsideCancelButton:(id)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(didTapCancelButton:)]) {
        [self.delegate didTapCancelButton:_numberTextField.text];
    }
    [self removeFromSuperview];
}

- (void)dealloc
{
    
}

@end
