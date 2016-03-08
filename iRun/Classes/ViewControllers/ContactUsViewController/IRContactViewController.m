//
//  IRContactViewController.m
//  ExpenseManager
//
//  Created by Shibin S on 11/10/14.
//  Copyright (c) 2014 Shibin. All rights reserved.
//

#import "IRContactViewController.h"
#import "IRCommon.h"
#import "IRConstants.h"
#import <QuartzCore/QuartzCore.h>

@interface IRContactViewController ()

@property (weak, nonatomic) IBOutlet UILabel *copyrightLabel;
@property (weak, nonatomic) IBOutlet UILabel *appVersionLabel;
@property (weak, nonatomic) IBOutlet UILabel *appNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *queryTextLabel;
@property (weak, nonatomic) IBOutlet UILabel *combatibleLabel;
@property (weak, nonatomic) IBOutlet UITextView *suggestionTextField;
@property (weak, nonatomic) IBOutlet UIButton *sendMailButton;
@property (weak, nonatomic) IBOutlet UITextView *emailTextView;
@property (weak, nonatomic) IBOutlet UILabel *supportMailLabel;

@end

@implementation IRContactViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [IRCommon updateAppUsagePointsWithValue:1];
    self.suggestionTextField.text = [IRCommon localizeText:@"Type your query / suggestion here."];
    [self.sendMailButton setTitle:[IRCommon localizeText:@"Send Mail"] forState:UIControlStateNormal];
    self.supportMailLabel.text = [IRCommon localizeText:@"Support Mail"];
    self.navigationItem.title = [IRCommon localizeText:@"Contact Us"];
    self.combatibleLabel.text = [IRCommon localizeText:@"Compatible with iOS 7 and above."];
    self.copyrightLabel.text = [NSString stringWithFormat:[IRCommon localizeText:@"Copyright © %@"],[IRCommon getCurrentYear]];
    self.copyrightLabel.font = [IRCommon getDefaultFontForSize:14 isBold:YES];
    self.appNameLabel.text = [NSString stringWithFormat:@"%@",APPLICATION_NAME];
    self.appNameLabel.font = [IRCommon getDefaultFontForSize:15 isBold:YES];
    self.appVersionLabel.text = [NSString stringWithFormat:[IRCommon localizeText:@"App Version %@"],[IRCommon getCurrentAppVersion]];
    self.appVersionLabel.font = [IRCommon getDefaultFontForSize:14 isBold:YES];
    self.queryTextLabel.font = [IRCommon getDefaultFontForSize:14 isBold:NO];
    self.queryTextLabel.text = [IRCommon localizeText:@"If you have any queries or suggestions for improvement, please provide below."];
    self.combatibleLabel.font = [IRCommon getDefaultFontForSize:14 isBold:YES];
    self.suggestionTextField.font = [IRCommon getDefaultFontForSize:12 isBold:NO];
    self.suggestionTextField.layer.borderWidth = 1.0;
    self.suggestionTextField.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.sendMailButton.backgroundColor = [IRCommon getThemeColor];
    self.sendMailButton.layer.cornerRadius = 3.0;
    self.sendMailButton.titleLabel.font = [IRCommon getDefaultFontForSize:14 isBold:YES];
    [self.sendMailButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.emailTextView.font = [IRCommon getDefaultFontForSize:12 isBold:NO];
    self.supportMailLabel.font = [IRCommon getDefaultFontForSize:14 isBold:YES];
    self.supportMailLabel.textColor = [UIColor darkGrayColor];
    UIToolbar* toolbar = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, 320, 50)];
    toolbar.barStyle = UIBarStyleDefault;
    toolbar.items = [NSArray arrayWithObjects:
                           [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil],
                           [[UIBarButtonItem alloc]initWithTitle:@"Done" style:UIBarButtonItemStyleDone target:self action:@selector(doneWithKeyPad)],
                           nil];
    [toolbar sizeToFit];
    self.suggestionTextField.inputAccessoryView = toolbar;
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)textViewDidBeginEditing:(UITextView *)textView
{
    if ([textView.text isEqualToString:[IRCommon localizeText:@"Type your query / suggestion here."]]) {
        textView.text = @"";
        textView.textColor = [UIColor darkGrayColor];
    }
    [self.suggestionTextField becomeFirstResponder];
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
    if ([textView.text isEqualToString:@""]) {
        textView.text = [IRCommon localizeText:@"Type your query / suggestion here."];
        textView.textColor = [UIColor lightGrayColor];
    }
    [self.suggestionTextField resignFirstResponder];
}

-(void)doneWithKeyPad
{
    [self.suggestionTextField resignFirstResponder];
}
- (IBAction)sendMailAction:(id)sender
{
    if ([self.suggestionTextField.text isEqualToString:[IRCommon localizeText:@"Type your query / suggestion here."]] || [[self.suggestionTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] isEqualToString:@""]) {
        [IRCommon showAlertWithTitle:APPLICATION_NAME message:[IRCommon localizeText:@"Please enter your query and/or suggestions."] dismissButtonText:[IRCommon localizeText:OK_TEXT]];
        return;
    }
    MFMailComposeViewController *mailComposeViewController = [[MFMailComposeViewController alloc]init];
    mailComposeViewController.mailComposeDelegate = self;
    NSString *toAddress = @"expensemobile.inno@gmail.com";
    [mailComposeViewController setToRecipients:[NSArray arrayWithObjects:toAddress,nil]];
    [mailComposeViewController setSubject:@"Query / Suggestion"];
    NSString *messageContent = [NSString stringWithFormat:@"%@",self.suggestionTextField.text];
    [mailComposeViewController setMessageBody:messageContent isHTML:NO];
    [self.navigationController presentViewController:mailComposeViewController animated:YES completion:nil];
}

- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error
{
    switch (result)
    {
        case MFMailComposeResultCancelled:
            break;
        case MFMailComposeResultSaved:
            break;
        case MFMailComposeResultSent:
            [IRCommon showAlertWithTitle:APPLICATION_NAME message:@"Your mail has been sent." dismissButtonText:[IRCommon localizeText:OK_TEXT]];
            break;
        case MFMailComposeResultFailed:
            [IRCommon showAlertWithTitle:APPLICATION_NAME message:@"Sorry, Your mail cannot be send. Please try again." dismissButtonText:[IRCommon localizeText:OK_TEXT]];
            break;
        default:
            break;
    }
    [controller dismissViewControllerAnimated:YES completion:nil];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
