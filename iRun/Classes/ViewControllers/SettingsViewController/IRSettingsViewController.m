//
//  IRSettingsViewController.m
//  iRun
//
//  Created by Shibin S on 30/08/14.
//  Copyright (c) 2014 Shibin. All rights reserved.
//

#import "IRSettingsViewController.h"
#import "SWRevealViewController.h"
#import "IRCurrencyViewController.h"
#import "IRThemeViewController.h"
#import "IRCommon.h"
#import "IRGeneralSettingsViewController.h"
#import "IRCategoryViewController.h"
#import "IRCoreDataController.h"
#import "IRExpense.h"
#import "IRContactViewController.h"
#import "IRAppsViewController.h"

@interface IRSettingsViewController ()

@property (weak, nonatomic) IBOutlet UIButton *menuButton;
@property (strong, nonatomic) MFMailComposeViewController *mailComposeViewController;
@property (weak, nonatomic) IBOutlet UITableView *settingsTableView;

@end

@implementation IRSettingsViewController

#pragma mark - View lifecycle

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [IRCommon updateAppUsagePointsWithValue:1];
    self.navigationItem.title = [IRCommon localizeText:@"Settings"];
    [_menuButton addTarget:self.revealViewController action:@selector(revealToggle:) forControlEvents:UIControlEventTouchUpInside];
    // Set the gesture
    [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
    [self.view addGestureRecognizer:self.revealViewController.tapGestureRecognizer];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.settingsTableView reloadData];
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
}

#pragma mark - UITableView Datasource Methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 20;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    switch (section) {
        case 0:
            return 3;
            break;
//        case 1:
//            return 2;
//            break;
        case 1:
            return 2;
            break;
        case 2:
            return 5;
            break;
//        case 3:
//            return 0;
//            break;
//        case 3:
//            return 0;
//            break;
        default:
            return 1;
            break;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SettingsCell" forIndexPath:indexPath];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"SettingsCell"];
    }
    cell.textLabel.textColor = [UIColor darkGrayColor];
    cell.textLabel.font = [IRCommon getDefaultFontForSize:15.0f isBold:NO];
    cell.accessoryType = UITableViewCellAccessoryNone;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (indexPath.section == 0) {
        switch (indexPath.row) {
            case 0:
                cell.textLabel.text = [IRCommon localizeText:@"General"];
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                break;
//            case 1:
//                cell.textLabel.text = [IRCommon localizeText:@"Category"];
//                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
//                break;
            case 1:
                cell.textLabel.text = [IRCommon localizeText:@"Currency"];
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                break;
            case 2:
                cell.textLabel.text = [IRCommon localizeText:@"Theme"];
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                break;
            case 3:
                cell.textLabel.text = [IRCommon localizeText:@"Screen Lock"];
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                break;
            default:
                break;
        }
//    } else if (indexPath.section == 1) {
//        switch (indexPath.row) {
//            case 0:
//                cell.textLabel.text = @"Theme";
//                break;
//            case 1:
//                cell.textLabel.text = @"Passcode";
//                break;
//            default:
//                break;
//        }
    } else if (indexPath.section == 1) {
        switch (indexPath.row) {
//            case 0:
//                cell.textLabel.text = @"Backup Data";
//                break;
//            case 1:
//                cell.textLabel.text = @"Restore Data";
//                break;
            case 0:
                cell.textLabel.text = [IRCommon localizeText:@"Export Data"];
                break;
            case 1:
                cell.textLabel.text = [IRCommon localizeText:@"Reset All Data"];
                break;
            default:
                break;
        }
//    } else if (indexPath.section == 2) {
//        switch (indexPath.row) {
//            case 0:
//                cell.textLabel.text = @"Share On Facebook";
//                break;
//            case 1:
//                cell.textLabel.text = @"Share On Twitter";
//                break;
//            default:
//                break;
//        }
    } else if (indexPath.section == 2) {
        switch (indexPath.row) {
//            case 0:
//                cell.textLabel.text = @"Privacy Policy";
//                break;
            case 0:
                cell.textLabel.text = [IRCommon localizeText:@"Feedback"];
                break;
            case 1:
                cell.textLabel.text = [IRCommon localizeText:@"Rate App"];
                break;
            case 2:
                cell.textLabel.text = [IRCommon localizeText:@"Contact Us"];
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                break;
            case 3:
                cell.textLabel.text = [IRCommon localizeText:@"Social"];
                break;
            case 4:
                cell.textLabel.text = [IRCommon localizeText:@"Developer Apps"];
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                break;
            default:
                break;
        }
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section
{
    view.tintColor = [UIColor groupTableViewBackgroundColor];
}

#pragma mark - UITableView Delegate Methods

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        IRCurrencyViewController *currencyViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"CurrencyViewController"];
        IRGeneralSettingsViewController *generalSettingsViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"GeneralSettingsViewController"];
        IRThemeViewController *themeViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"ThemeViewController"];
        switch (indexPath.row) {
            case 0:
               [self.navigationController pushViewController:generalSettingsViewController animated:YES];
                break;
//            case 1:
//                [self.navigationController pushViewController:categoryViewController animated:YES];
//                break;
            case 1:
                [self.navigationController pushViewController:currencyViewController animated:YES];
                break;
            case 2:
            
                [self.navigationController pushViewController:themeViewController animated:YES];

                break;
            case 3:
                
                
                break;
                
            default:
                break;
        }
//    } else if (indexPath.section == 1) {
//        IRThemeViewController *themeViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"ThemeViewController"];
//        switch (indexPath.row) {
//            case 0:
//                [self.navigationController pushViewController:themeViewController animated:YES];
//                break;
//                
//            default:
//                break;
//        }
    } else if (indexPath.section == 1) {
        UIAlertView *resetDataAlert = [[UIAlertView alloc]initWithTitle:@"Caution!" message:[IRCommon localizeText:@"This will delete all data from your app. Do you wish to continue?"] delegate:self cancelButtonTitle:[IRCommon localizeText:[IRCommon localizeText:@"Cancel"]] otherButtonTitles:[IRCommon localizeText:@"OK"], nil];
        
        switch (indexPath.row) {
            case 0:
                [IRCommon updateAppUsagePointsWithValue:1];
                [self createCSVFile];
                break;
            case 1:
                [IRCommon updateAppUsagePointsWithValue:1];
                resetDataAlert.tag = 6766;
                [resetDataAlert show];
                break;
                
            default:
                break;
        }
//    } else if (indexPath.section == 2) {
//        switch (indexPath.row) {
//            case 0:
//                [self postToFacebook];
//                break;
//            case 1:
//                [self postToTwitter];
//                break;
//            default:
//                break;
//        }
        
    } else if (indexPath.section == 2) {
        IRContactViewController *contactViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"ContactViewController"];
        IRAppsViewController *appsViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"IRAppsViewController"];
        switch (indexPath.row) {
            
//            case 0:
//                [[UIApplication sharedApplication]openURL:[NSURL URLWithString:@"http://www.privacychoice.org/policy/mobile?policy=766d7893129bb727b00a9564fe068c38"]];
//                break;
            case 0:
                [IRCommon updateAppUsagePointsWithValue:1];
                [self sendFeedback];
                break;
            case 1:
                [IRCommon updateAppUsagePointsWithValue:15];
                [[UIApplication sharedApplication]openURL:[NSURL URLWithString:@"https://itunes.apple.com/us/app/expensemobile/id931178948?ls=1&mt=8"]];
                break;
            case 2:
                [self.navigationController pushViewController:contactViewController animated:YES];
                break;
            case 3:
                
                [self showSocialSharingActionSheet];
                break;
            case 4:
                [self.navigationController pushViewController:appsViewController animated:YES];

            default:
                break;
        }
    }
}

- (void)showSocialSharingActionSheet
{
//    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
//    UIAlertAction *fbAction = [UIAlertAction actionWithTitle:@"Facebook" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
//        [self postToFacebook];
//    }];
//    UIAlertAction *twitterAction = [UIAlertAction actionWithTitle:@"Twitter" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
//        [self postToTwitter];
//    }];
//    UIAlertAction *whatzAppAction = [UIAlertAction actionWithTitle:@"WhatzApp" style: UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
//        [self shareInWhatzApp];
//
//    }];
//    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:[IRCommon localizeText:@"Cancel"] style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
//    }];
//    [alertController addAction:fbAction];
//    [alertController addAction:twitterAction];
//    [alertController addAction:whatzAppAction];
//    [alertController addAction:cancelAction];
//    [self presentViewController:alertController animated:YES completion:nil];
    
    NSString *text = [IRCommon localizeText:@"I use to track my mobile expenses using Expense Manager. Download it from AppStore. \n https://itunes.apple.com/us/app/expensemobile/id931178948?ls=1&mt=8"];
    UIImage *socialImage = [UIImage imageNamed:@"AppImage.png"];
    UIActivityViewController *shareController = [[UIActivityViewController alloc]initWithActivityItems:@[text,socialImage] applicationActivities:nil];
    [self presentViewController:shareController animated:YES completion:nil];
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
            [IRCommon showAlertWithTitle:APPLICATION_NAME message:[IRCommon localizeText:@"Your mail has been sent."] dismissButtonText:[IRCommon localizeText:OK_TEXT]];
            break;
        case MFMailComposeResultFailed:
            [IRCommon showAlertWithTitle:APPLICATION_NAME message:[IRCommon localizeText:@"Sorry, Your mail cannot be send. Please try again."] dismissButtonText:[IRCommon localizeText:OK_TEXT]];
            break;
        default:
            break;
    }
    [controller dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - UIAlertView Delegate Methods

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 6766) {
        if (buttonIndex == 1) {
            if ([[IRCoreDataController sharedInstance]deleteAllExpenseData] &&
                [[IRCoreDataController sharedInstance]deleteAllCategories]) {
                [IRCommon showAlertWithTitle:APPLICATION_NAME message:[IRCommon localizeText:@"Your data has been reset."] dismissButtonText:[IRCommon localizeText:@"OK"]];
            } else {
                [IRCommon showAlertWithTitle:APPLICATION_NAME message:[IRCommon localizeText:@"An error has occured!. Please try again."] dismissButtonText:[IRCommon localizeText:@"OK"]];
            }
        }
    }
}

#pragma mark - Private Methods

- (void)postToFacebook
{
    if([SLComposeViewController isAvailableForServiceType:SLServiceTypeFacebook]) {
        SLComposeViewController *controller = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeFacebook];
        [controller setInitialText:[IRCommon localizeText:@"I use to track my mobile expenses using Expense Manager. Download it from AppStore. \n https://itunes.apple.com/us/app/expensemobile/id931178948?ls=1&mt=8"]];
        [self presentViewController:controller animated:YES completion:Nil];
        [IRCommon updateSocialPoints];
    } else {
        [IRCommon showAlertWithTitle:APPLICATION_NAME message:[IRCommon localizeText:@"Please configure Facebook on your device settings."] dismissButtonText:[IRCommon localizeText:OK_TEXT]];
    }
}

- (void)postToTwitter
{
    if ([SLComposeViewController isAvailableForServiceType:SLServiceTypeTwitter]) {
        SLComposeViewController *tweetSheet = [SLComposeViewController
                                               composeViewControllerForServiceType:SLServiceTypeTwitter];
        [tweetSheet setInitialText:[IRCommon localizeText:@"I use to track my mobile expenses using Expense Manager. Download it from AppStore. \n https://itunes.apple.com/us/app/expensemobile/id931178948?ls=1&mt=8"]];
        [self presentViewController:tweetSheet animated:YES completion:nil];
        [IRCommon updateSocialPoints];
    } else {
        [IRCommon showAlertWithTitle:APPLICATION_NAME message:[IRCommon localizeText:@"Please configure Twitter on your device settings."] dismissButtonText:[IRCommon localizeText:OK_TEXT]];
    }
}


- (void)shareInWhatzApp
{
    NSString *text = [IRCommon localizeText:@"I use to track my mobile expenses using Expense Manager. Download it from AppStore. \n https://itunes.apple.com/us/app/expensemobile/id931178948?ls=1&mt=8"];
    NSString * urlWhats = [NSString stringWithFormat:@"whatsapp://send?text=%@",text];
    NSURL * whatsappURL = [NSURL URLWithString:[urlWhats stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    if ([[UIApplication sharedApplication] canOpenURL: whatsappURL]) {
        [[UIApplication sharedApplication] openURL: whatsappURL];
        [IRCommon updateSocialPoints];

    } else {
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:APPLICATION_NAME message:[IRCommon localizeText:@"Sorry, Whatzapp is not installed on your device."] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
    }
}
- (void)createCSVFile
{
    NSArray *expenseArray = [[IRCoreDataController sharedInstance]fetchExpenseData:YES];
    NSArray *incomeArray = [[IRCoreDataController sharedInstance]fetchExpenseData:YES];
    if ([[NSFileManager defaultManager] fileExistsAtPath:[self dataFilePath]]) {
        [[NSFileManager defaultManager]removeItemAtPath:[self dataFilePath] error:nil];
    }
    [[NSFileManager defaultManager] createFileAtPath: [self dataFilePath] contents:nil attributes:nil];
    NSMutableString *writeString = [NSMutableString stringWithCapacity:0];
    [writeString appendString:@"\nExpense\n"];
    [writeString appendString:@"Date, Category, Amount, Note \n"];
    for (IRExpense *expense in expenseArray) {
        [writeString appendString:[NSString stringWithFormat:@"%@, %@, %@, %@\n",[IRCommon getDate:expense.date inFormat:@"dd-MM-yy hh:mm aa"],expense.category,[NSString stringWithFormat:@"%@ %f",[IRCommon getCurrencySymbolFromCode:[[NSUserDefaults standardUserDefaults]objectForKey:@"currency"]],expense.amount],expense.note]];
    }
    [writeString appendString:@"\nIncome\n"];
    [writeString appendString:@"Date, Category, Amount, Note \n"];
    for (IRExpense *expense in incomeArray) {
        [writeString appendString:[NSString stringWithFormat:@"%@, %@, %@, %@\n",[IRCommon getDate:expense.date inFormat:@"dd-MM-yy hh:mm aa"],expense.category,[NSString stringWithFormat:@"%@ %f",[IRCommon getCurrencySymbolFromCode:[[NSUserDefaults standardUserDefaults]objectForKey:@"currency"]],expense.amount],expense.note]];
    }
    NSFileHandle *handle;
    handle = [NSFileHandle fileHandleForWritingAtPath: [self dataFilePath] ];
    [handle truncateFileAtOffset:[handle seekToEndOfFile]];
    [handle writeData:[writeString dataUsingEncoding:NSUTF8StringEncoding]];
    [self exportSpreadsheet];
}

- (NSString *)dataFilePath
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    return [documentsDirectory stringByAppendingPathComponent:@"ExpenseMobile.csv"];
}

- (void)sendFeedback
{
    self.mailComposeViewController = [[MFMailComposeViewController alloc]init];
    self.mailComposeViewController.mailComposeDelegate = self;
    NSString *toAddress = @"expensemobile.inno@gmail.com";
    [self.mailComposeViewController setToRecipients:[NSArray arrayWithObjects:toAddress,nil]];
    [self.mailComposeViewController setSubject:[IRCommon localizeText:@"Feedback"]];
    NSString *messageContent = [NSString stringWithFormat:@"\n\niOS Version : %@ \nApp Version : %@",[IRCommon getiOSVersion],[IRCommon getCurrentAppVersion]];
    [self.mailComposeViewController setMessageBody:messageContent isHTML:NO];
    if(self.mailComposeViewController) {
        [self.navigationController presentViewController:self.mailComposeViewController animated:YES completion:nil];
    }
    
}

- (void)exportSpreadsheet
{
    self.mailComposeViewController = [[MFMailComposeViewController alloc]init];
    self.mailComposeViewController.mailComposeDelegate = self;
    [self.mailComposeViewController setSubject:@"Expense Mobile Data Backup"];
    NSData *data = [NSData dataWithContentsOfFile:[self dataFilePath]];
    [self.mailComposeViewController addAttachmentData:data mimeType:@"text/csv" fileName:@"Expense Mobile"];
    if (self.mailComposeViewController) {
        [self.navigationController presentViewController:self.mailComposeViewController animated:YES completion:nil];
    }
    
}

@end
