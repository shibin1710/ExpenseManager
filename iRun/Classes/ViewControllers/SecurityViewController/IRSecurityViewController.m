//
//  IRSecurityViewController.m
//  ExpenseMobile
//
//  Created by Shibin S on 04/07/15.
//  Copyright (c) 2015 Shibin. All rights reserved.
//

#import "IRSecurityViewController.h"
#import "IRCommon.h"
#import "PAPasscodeViewController.h"

@interface IRSecurityViewController ()
{
    NSIndexPath *currentType;
    NSIndexPath *selectedType;


}

@property (weak, nonatomic) IBOutlet UITableView *securityTableView;
@end

@implementation IRSecurityViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [IRCommon updateAppUsagePointsWithValue:1];
    self.securityTableView.tintColor = [IRCommon getThemeColor];

    self.navigationItem.title = [IRCommon localizeText:@"Screen Lock"];
    currentType = [NSIndexPath indexPathForRow:[[[NSUserDefaults standardUserDefaults]objectForKey:@"lockType"]intValue] inSection:0];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 4;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SecurityCell" forIndexPath:indexPath];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"SecurityCell"];
    }
    cell.textLabel.font = [IRCommon getDefaultFontForSize:15 isBold:NO];
    cell.textLabel.textColor = [UIColor darkGrayColor];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    if (currentType.row == indexPath.row)
    {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }

    switch (indexPath.row) {
        case 0:
            cell.textLabel.text = @"None";
            break;
        case 1:
            cell.textLabel.text = @"PIN";
            break;
        case 2:
            cell.textLabel.text = @"Password";
            break;
        case 3:
            cell.textLabel.text = @"Fingerprint";

            break;
        default:
            break;
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    selectedType = indexPath;
    PAPasscodeViewController *passwordViewController;
   
    int lockType = [[[NSUserDefaults standardUserDefaults]objectForKey:@"lockType"]intValue];
    NSString *passCode = [[NSUserDefaults standardUserDefaults]objectForKey:@"passCode"];
    
    switch (lockType)
    {
        case 0:
            
            if (indexPath.row == 1)
            {
                passwordViewController = [[PAPasscodeViewController alloc]initForAction:PasscodeActionSet];
                passwordViewController.simple = YES;
            }
            else if (indexPath.row == 2)
            {
                passwordViewController = [[PAPasscodeViewController alloc]initForAction:PasscodeActionSet];
                passwordViewController.simple = NO;
            }
       
            
            break;
          
        case 1:
            
            if (indexPath.row == 0)
            {
                passwordViewController = [[PAPasscodeViewController alloc]initForAction:PasscodeActionEnter];
                passwordViewController.simple = YES;
                passwordViewController.passcode = passCode;
                
            }
            
            if (indexPath.row == 1)
            {
                passwordViewController = [[PAPasscodeViewController alloc]initForAction:PasscodeActionChange];
                passwordViewController.simple = YES;
                
            }
            else if (indexPath.row == 2)
            {
                passwordViewController = [[PAPasscodeViewController alloc]initForAction:PasscodeActionEnter];
                passwordViewController.simple = YES;
                [passwordViewController setPasscode:passCode];
            }
            
            break;
        case 2:
            
            if (indexPath.row == 0)
            {
                passwordViewController = [[PAPasscodeViewController alloc]initForAction:PasscodeActionEnter];
                passwordViewController.simple = NO;
                passwordViewController.passcode = passCode;
                
            }
            
            if (indexPath.row == 1)
            {
                
                passwordViewController = [[PAPasscodeViewController alloc]initForAction:PasscodeActionEnter];
                passwordViewController.simple = NO;
                passwordViewController.passcode = passCode;

                
            }
            else if (indexPath.row == 2)
            {
                passwordViewController = [[PAPasscodeViewController alloc]initForAction:PasscodeActionChange];
                passwordViewController.simple = NO;
            }
            
            break;
        default:
            break;
    }
    
    
//    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    switch (indexPath.row) {
        case 0:
            [[NSUserDefaults standardUserDefaults]setObject:[NSNumber numberWithInt:(int)indexPath.row] forKey:@"lockType"];
            break;
        
        case 1:
            self.view.userInteractionEnabled = NO;
            break;
         
        case 2:
            self.view.userInteractionEnabled = NO;
            break;
            
        default:
            break;
    }
    
    if (passwordViewController)
    {
        passwordViewController.delegate = self;
        id rootPasswordViewController = [[UINavigationController alloc] initWithRootViewController:passwordViewController];
        [self presentViewController:rootPasswordViewController animated:YES completion:nil];
    }
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
//    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
//    cell.accessoryType = UITableViewCellAccessoryNone;
}

- (void)dismissPasslockView:(PasscodeAction)actiontype
{
    self.view.userInteractionEnabled = YES;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (void)PAPasscodeViewControllerDidSetPasscode:(PAPasscodeViewController *)controller
{
    NSString *passCode = controller.passcode;
    [[NSUserDefaults standardUserDefaults]setObject:[NSNumber numberWithInt:(int)selectedType.row] forKey:@"lockType"];
    [[NSUserDefaults standardUserDefaults]setObject:passCode forKey:@"passCode"];
   UITableViewCell *newCell =  [self.securityTableView cellForRowAtIndexPath:selectedType];
    newCell.accessoryType = UITableViewCellAccessoryCheckmark;
    
    UITableViewCell *oldCell =  [self.securityTableView cellForRowAtIndexPath:currentType];
    oldCell.accessoryType = UITableViewCellAccessoryNone;
    currentType = selectedType;
    
}

- (void)PAPasscodeViewController:(PAPasscodeViewController *)controller didFailToEnterPasscode:(NSInteger)attempts
{
    
}

-(void)PAPasscodeViewControllerDidCancel:(PAPasscodeViewController *)controller
{
    self.view.userInteractionEnabled = YES;
    

}

- (void)PAPasscodeViewControllerDidChangePasscode:(PAPasscodeViewController *)controller
{
    NSString *passCode = controller.passcode;
    [[NSUserDefaults standardUserDefaults]setObject:passCode forKey:@"passCode"];
    
    
    UITableViewCell *newCell =  [self.securityTableView cellForRowAtIndexPath:selectedType];
    newCell.accessoryType = UITableViewCellAccessoryCheckmark;
    
    UITableViewCell *oldCell =  [self.securityTableView cellForRowAtIndexPath:currentType];
    oldCell.accessoryType = UITableViewCellAccessoryNone;
    currentType = selectedType;
}

- (void)PAPasscodeViewControllerDidEnterPasscode:(PAPasscodeViewController *)controller
{
//    NSString *passCode = controller.passcode;
    
    
    
    // Compare and do other actions.
//    [[NSUserDefaults standardUserDefaults]setObject:passCode forKey:@"passCode"];
    PAPasscodeViewController *passwordViewController;
    if (selectedType.row != 0 )
    {
        if (currentType.row == 1) {
            passwordViewController = [[PAPasscodeViewController alloc]initForAction:PasscodeActionSet];
            passwordViewController.simple = NO;
        } else if (currentType.row == 2) {
            passwordViewController = [[PAPasscodeViewController alloc]initForAction:PasscodeActionSet];
            passwordViewController.simple = YES;
        }
        
        if (passwordViewController)
        {
            passwordViewController.delegate = self;
            id rootPasswordViewController = [[UINavigationController alloc] initWithRootViewController:passwordViewController];
            [self presentViewController:rootPasswordViewController animated:YES completion:nil];
        }
    }
    else
    {
        UITableViewCell *newCell =  [self.securityTableView cellForRowAtIndexPath:selectedType];
        newCell.accessoryType = UITableViewCellAccessoryCheckmark;
        
        UITableViewCell *oldCell =  [self.securityTableView cellForRowAtIndexPath:currentType];
        oldCell.accessoryType = UITableViewCellAccessoryNone;
        
        currentType = selectedType;
    }

    
}


@end
