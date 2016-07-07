//
//  IRMenuTableViewController.m
//  iRun
//
//  Created by Shibin S on 30/08/14.
//  Copyright (c) 2014 Shibin. All rights reserved.
//

#import "IRMenuTableViewController.h"
#import "IRMenuTableViewCell.h"
#import "IRConstants.h"
#import "IRCommon.h"
#import "IRSettingsViewController.h"
#import "SWRevealViewController.h"
#import "IRMainViewController.h"
#import "IRCategoryViewController.h"
#import "IRHistoryViewController.h"
#import "IRBuyPremiumViewController.h"
#import "IRMenuTableViewController.h"
#import "IRFAQViewController.h"
#import "IRSyncViewController.h"

@interface IRMenuTableViewController ()

@property (weak, nonatomic) IBOutlet UILabel *appName;
@property (weak, nonatomic) IBOutlet UITableView *menuTableView;

@end

@implementation IRMenuTableViewController

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
    self.appName.text = APPLICATION_NAME;
    self.appName.font = [IRCommon getDefaultFontForSize:17.0 isBold:YES];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.menuTableView reloadData];
    self.view.backgroundColor = [IRCommon getThemeColor];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableView Datasource Methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
//    return [IRCommon isFullVersion] ? 7 : 8;
    return [IRCommon isFullVersion] ? 6 : 7;

}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    IRMenuTableViewCell *cell = (IRMenuTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"MenuTableView" forIndexPath:indexPath];
    if (cell == nil) {
        cell = [[IRMenuTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"MenuTableView"];
    }
    cell.name.textColor = [UIColor darkTextColor];
    cell.name.font = [IRCommon getDefaultFontForSize:15.0f isBold:NO];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    switch (indexPath.row) {
        case 0:
            cell.name.text = [IRCommon localizeText:@"Overview"];
            break;
        case 1:
            cell.name.text = [IRCommon localizeText:@"History"];
            break;
        case 2:
            cell.name.text = [IRCommon localizeText:@"Category"];
            break;
        case 3:
            cell.name.text = [IRCommon localizeText:@"Settings"];
            break;
//        case 4:
//            cell.name.text = [IRCommon localizeText:@"My Points"];
//            break;
//        case 5:
//            cell.name.text = [IRCommon localizeText:@"Sync"];
//            break;
        case 4:
            cell.name.text = [IRCommon localizeText:@"Upgrade"];
            break;
        case 5:
            cell.name.text = [IRCommon localizeText:@"FAQ"];
            break;
        default:
            break;
    }
    return cell;
}

#pragma mark - UITableView Delegate Methods

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        IRMainViewController *viewController = (IRMainViewController*)[self.storyboard instantiateViewControllerWithIdentifier:@"ViewController"];
        UINavigationController* navController = (UINavigationController*)self.revealViewController.frontViewController;
        [navController setViewControllers: @[viewController] animated: NO ];
        [self.revealViewController setFrontViewPosition: FrontViewPositionLeft animated: YES];
    } else if (indexPath.row == 1) {
        IRHistoryViewController *historyViewController = (IRHistoryViewController*)[self.storyboard instantiateViewControllerWithIdentifier:@"HistoryViewController"];
        UINavigationController* navController = (UINavigationController*)self.revealViewController.frontViewController;
        [navController setViewControllers: @[historyViewController] animated: NO ];
        [self.revealViewController setFrontViewPosition: FrontViewPositionLeft animated: YES];
    } else if (indexPath.row == 2) {
        IRCategoryViewController *categoryViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"AddCategory"];
        UINavigationController* navController = (UINavigationController*)self.revealViewController.frontViewController;
        [navController setViewControllers: @[categoryViewController] animated: NO ];
        [self.revealViewController setFrontViewPosition: FrontViewPositionLeft animated: YES];
    } else if (indexPath.row == 3) {
        IRSettingsViewController *settingsViewController = (IRSettingsViewController*)[self.storyboard instantiateViewControllerWithIdentifier:@"SettingsViewController"];
        UINavigationController* navController = (UINavigationController*)self.revealViewController.frontViewController;
        [navController setViewControllers: @[settingsViewController] animated: NO ];
        [self.revealViewController setFrontViewPosition: FrontViewPositionLeft animated: YES];
    } //else if (indexPath.row == 4) {
//        IRDistributionViewController *distributionViewController = (IRDistributionViewController*)[self.storyboard instantiateViewControllerWithIdentifier:@"IRDistributionViewController"];
//        UINavigationController* navController = (UINavigationController*)self.revealViewController.frontViewController;
//        [navController setViewControllers: @[distributionViewController] animated: NO ];
//        [self.revealViewController setFrontViewPosition: FrontViewPositionLeft animated: YES];
//        IRMyPointsViewController *myPointsViewController = (IRMyPointsViewController*)[self.storyboard instantiateViewControllerWithIdentifier:@"IRMyPointsViewController"];
//        UINavigationController* navController = (UINavigationController*)self.revealViewController.frontViewController;
//        [navController setViewControllers: @[myPointsViewController] animated: NO ];
//        [self.revealViewController setFrontViewPosition: FrontViewPositionLeft animated: YES];
//    }
//    else if (indexPath.row == 5) {
//        
//        if ([IRCommon isFullVersion]) {
//            IRSyncViewController *syncController = (IRSyncViewController*)[self.storyboard instantiateViewControllerWithIdentifier:@"IRSyncViewController"];
//            UINavigationController* navController = (UINavigationController*)self.revealViewController.frontViewController;
//            [navController setViewControllers: @[syncController] animated: NO ];
//            [self.revealViewController setFrontViewPosition: FrontViewPositionLeft animated: YES];
//        } else {
//            [IRCommon showAlertWithTitle:APPLICATION_NAME message:@"This feature is available only in 'Pro' version. Go to 'Upgrade' option in menu to get 'Pro' version." dismissButtonText:OK_TEXT];
//            return;
//        }
//        
//    }
    else if (indexPath.row == 4) {
        IRBuyPremiumViewController *buyPremiumViewController = (IRBuyPremiumViewController*)[self.storyboard instantiateViewControllerWithIdentifier:@"IRBuyPremiumViewController"];
        UINavigationController* navController = (UINavigationController*)self.revealViewController.frontViewController;
        [navController setViewControllers: @[buyPremiumViewController] animated: NO ];
        [self.revealViewController setFrontViewPosition: FrontViewPositionLeft animated: YES];
    }
    else if (indexPath.row == 5) {
        IRFAQViewController *faqViewController = (IRFAQViewController*)[self.storyboard instantiateViewControllerWithIdentifier:@"IRFAQViewController"];
        UINavigationController* navController = (UINavigationController*)self.revealViewController.frontViewController;
        [navController setViewControllers: @[faqViewController] animated: NO ];
        [self.revealViewController setFrontViewPosition: FrontViewPositionLeft animated: YES];
    }
}

@end
