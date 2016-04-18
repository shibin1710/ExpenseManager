
//
//  IRViewController.m
//  iRun
//
//  Created by Shibin S on 29/08/14.
//  Copyright (c) 2014 Shibin. All rights reserved.
//

#import "IRMainViewController.h"
#import "SWRevealViewController.h"
#import "IRConstants.h"
#import "FPNumberPadView.h"
#import "IRCoreDataController.h"
#import "IRCommon.h"
#import "IROverviewTableViewCell.h"
#import "IRCategory.h"
#import "IRExpenseListViewController.h"
#import "IRHomeCollectionCell.h"
#import "IRAddExpenseViewController.h"
#import "IRGamification.h"
#import <GameKit/GameKit.h>

@interface IRMainViewController () {
    double maxExpense;
    NSString *currencySymbol;
    double profitForCurrentMonth;
    NSNumber *trackMode;
}

@property (weak, nonatomic) IBOutlet UIButton *menuButton;
@property (strong, nonatomic) NSArray *expenseForCurrentMonth;
@property (strong, nonatomic) NSArray *incomeForCurrentMonth;
@property (strong, nonatomic) NSArray *filteredExpenseForCurrentMonth;
@property (strong, nonatomic) NSArray *filteredIncomeForCurrentMonth;
@property (weak, nonatomic) IBOutlet UITableView *overviewTableView;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (strong, nonatomic) NSArray *overviewTextArray;
@property (weak, nonatomic) IBOutlet UIPageControl *pageControl;
@property (weak, nonatomic) IBOutlet UILabel *noDateEnteredLabel;
@property (weak, nonatomic) IBOutlet ADBannerView *bannerView;
@property (strong, nonatomic) UIViewController *gameCenterViewController;
@property (assign, nonatomic) BOOL gameCenterEnabled;
@property (assign, nonatomic) NSString *leaderBoardIdentifier;

@end

@implementation IRMainViewController

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.gameCenterEnabled = NO;
    if (![IRCommon isFullVersion]) {
        self.interstitialPresentationPolicy = ADInterstitialPresentationPolicyAutomatic;
    } else {
        self.bannerView.alpha = 0;
    }
    // Set navigation properties.
    [IRCommon updateAppUsagePointsWithValue:1];
    self.navigationItem.title = [IRCommon localizeText:@"Overview"];
    trackMode = [[NSUserDefaults standardUserDefaults]objectForKey:@"trackMode"];
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName: [UIColor whiteColor],NSFontAttributeName:[IRCommon getDefaultFontForSize:17.0 isBold:YES]};
    self.navigationController.navigationBar.barTintColor = [IRCommon getThemeColor];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    // Set the side bar button action. When it's tapped, it will show up the sidebar.
    [_menuButton addTarget:self.revealViewController action:@selector(revealToggle:) forControlEvents:UIControlEventTouchUpInside];
    // Set the gesture
    [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
    [self.view addGestureRecognizer:self.revealViewController.tapGestureRecognizer];
    // Add notification observer to track changes in DB.
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleDataModelChange:) name:NSManagedObjectContextObjectsDidChangeNotification object:[[IRCoreDataController sharedInstance]managedObjectContext]];
    currencySymbol = [IRCommon getCurrencySymbolFromCode:[[NSUserDefaults standardUserDefaults]objectForKey:@"currency"]];
    self.pageControl.pageIndicatorTintColor = [UIColor lightGrayColor];
    self.pageControl.currentPageIndicatorTintColor = [IRCommon getThemeColor];
    // Load expense data to overview view.
    [IRCommon saveCategoriesToDB];
    [self loadDataToView];
    if (trackMode.intValue == 1) {
        self.overviewTextArray = [[IRGamification sharedInstance]getArrayOfOverViewText];
    } else {
        self.overviewTextArray = [[IRGamification sharedInstance]getArrayOfOverViewTextForExpenseOnly];
    }
    self.pageControl.numberOfPages = self.overviewTextArray.count;
//    [self authenticateLocalPlayer];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    // Remove text from back button.
    self.bannerView.delegate = self;
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [self hideBanner];
    self.bannerView.delegate = nil;
    [super viewWillDisappear:animated];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Notification Callback Methods

- (void)handleDataModelChange:(NSNotification *)notification
{
    [self loadDataToView];
    self.overviewTextArray = [[IRGamification sharedInstance]getArrayOfOverViewText];
    self.pageControl.numberOfPages = self.overviewTextArray.count;
    [self.collectionView reloadData];
    [self.overviewTableView reloadData];
}

- (void)showBanner
{
    if ([IRCommon isFullVersion]) {
        return;
    }
    self.bannerView.hidden = NO;
    self.collectionView.hidden = YES;
}

- (void)hideBanner
{
    self.bannerView.hidden = YES;
    self.collectionView.hidden = NO;
}

#pragma mark - Private Methods

- (void)loadDataToView
{
    self.expenseForCurrentMonth = [[IRCoreDataController sharedInstance]fetchExpenseForCurrentMonth:YES];
    if (trackMode.intValue == 1) {
        self.incomeForCurrentMonth = [[IRCoreDataController sharedInstance]fetchExpenseForCurrentMonth:NO];
    }
    
    
    if (trackMode.intValue == 0) {
        profitForCurrentMonth = [IRCommon getTotalProfitForArray:[[IRCoreDataController sharedInstance]fetchExpenseForCurrentMonth:YES]];
    } else {
        profitForCurrentMonth = [IRCommon getTotalProfitForArray:[[IRCoreDataController sharedInstance]fetchExpenseForCurrentMonth]];
    }
    self.filteredExpenseForCurrentMonth = [IRCommon filterExpenseByCategory:self.expenseForCurrentMonth];
    if (trackMode.intValue == 1) {
        self.filteredIncomeForCurrentMonth = [IRCommon filterExpenseByCategory:self.incomeForCurrentMonth];
    }
    
    
//    self.monthName.text = [[IRCommon getCurrentMonth]uppercaseString];
//    self.monthExpense.text = [NSString stringWithFormat:@"%@ %0.2f",currencySymbol,[IRCommon getTotalExpenseForCurrentMonth:self.expenseForCurrentMonth]];
    maxExpense = [[[self.filteredExpenseForCurrentMonth firstObject]objectForKey:@"totalExpense"]doubleValue] >= [[[self.filteredIncomeForCurrentMonth firstObject]objectForKey:@"totalExpense"]doubleValue] ? [[[self.filteredExpenseForCurrentMonth firstObject]objectForKey:@"totalExpense"]doubleValue] : [[[self.filteredIncomeForCurrentMonth firstObject]objectForKey:@"totalExpense"]doubleValue];
    if (!self.expenseForCurrentMonth.count && !self.incomeForCurrentMonth.count) {
        self.noDateEnteredLabel.hidden = NO;
        if (trackMode.intValue == 0) {
            self.noDateEnteredLabel.text = [NSString stringWithFormat:[IRCommon localizeText:@"You have not added expense for the month of %@.\n\nTap on + to add now."],[IRCommon getCurrentMonth]];
        } else {
            self.noDateEnteredLabel.text = [NSString stringWithFormat:[IRCommon localizeText:@"You have not added income or expense for the month of %@.\n\nTap on + to add now."],[IRCommon getCurrentMonth]];
        }
        
        self.noDateEnteredLabel.font = [IRCommon getDefaultFontForSize:15 isBold:NO];
    } else {
        self.noDateEnteredLabel.hidden = YES;
    }
}

#pragma mark - UITableView Datasource Methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (trackMode.intValue == 0) {
        return (self.filteredExpenseForCurrentMonth.count || self.filteredIncomeForCurrentMonth.count) ? 2 : 0;
    }
    return (self.filteredExpenseForCurrentMonth.count || self.filteredIncomeForCurrentMonth.count) ? 3 : 0;
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    switch (section) {
        case 0:
            return 0;
            break;
        case 1:
            return self.filteredExpenseForCurrentMonth.count;
            break;
        case 2:
            return self.filteredIncomeForCurrentMonth.count;
            break;
        default:
            return 0;
            break;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 45;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (trackMode.intValue == 0) {
        if (section == 1) {
            return 0;
        }
    }
    return 45;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"OverViewHeaderCell"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"OverViewHeaderCell"];
    }
    switch (section) {
        case 0:
            cell.textLabel.textAlignment = NSTextAlignmentCenter;
            cell.textLabel.font = [IRCommon getDefaultFontForSize:14.0f isBold:YES];
            if (trackMode.intValue == 0) {
                cell.textLabel.text = [NSString stringWithFormat:@"%@ : %@ %0.2f",[IRCommon getCurrentMonth],[IRCommon getCurrencySymbolFromCode:[[NSUserDefaults standardUserDefaults]objectForKey:@"currency"]],fabs(profitForCurrentMonth)];
                cell.textLabel.textColor = [IRCommon getThemeColor];
            } else {
                cell.textLabel.text = [NSString stringWithFormat:@"%@ : %@ %0.2f %@",[IRCommon getCurrentMonth],[IRCommon getCurrencySymbolFromCode:[[NSUserDefaults standardUserDefaults]objectForKey:@"currency"]],fabs(profitForCurrentMonth),(profitForCurrentMonth > 0) ? @"⬆︎" : @"⬇︎"];
                cell.textLabel.textColor = (profitForCurrentMonth > 0) ? [UIColor colorWithRed:0.0/255.0 green:153.0/255.0 blue:100.0/255.0 alpha:1.0] : [UIColor redColor];
            }
            
            cell.backgroundColor = [UIColor groupTableViewBackgroundColor];
            break;
        case 1:
            cell.textLabel.textColor = [UIColor redColor];
            cell.textLabel.text = [NSString stringWithFormat:[IRCommon localizeText:@"Total Expense : %@ %0.2f"],[IRCommon getCurrencySymbolFromCode:[[NSUserDefaults standardUserDefaults]objectForKey:@"currency"]],[IRCommon getTotalExpenseForCurrentMonth:self.expenseForCurrentMonth]];
            cell.backgroundColor = [UIColor colorWithRed:255.0/255.0 green:115.0/255.0 blue:0.0/255.0 alpha:0.1];
            cell.textLabel.font = [IRCommon getDefaultFontForSize:14.0f isBold:YES];
            break;
        case 2:
            cell.textLabel.textColor = [UIColor colorWithRed:0.0/255.0 green:153.0/255.0 blue:0.0/255.0 alpha:1.0];
            cell.textLabel.text = [NSString stringWithFormat:[IRCommon localizeText:@"Total Income : %@ %0.2f"],[IRCommon getCurrencySymbolFromCode:[[NSUserDefaults standardUserDefaults]objectForKey:@"currency"]],[IRCommon getTotalExpenseForCurrentMonth:self.incomeForCurrentMonth]];
            cell.backgroundColor = [UIColor colorWithRed:0.0/255.0 green:153.0/255.0 blue:100.0/255.0 alpha:0.1];
            cell.textLabel.font = [IRCommon getDefaultFontForSize:14.0f isBold:YES];
            break;
        default:
            break;
    }
    return cell;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    IROverviewTableViewCell *cell = (IROverviewTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"MainTableViewCell" forIndexPath:indexPath];
    if (cell == nil) {
        cell = [[IROverviewTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"MainTableViewCell"];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    NSString *category,*expenseString;
    double expense;
    int colorCode;
    cell.expenseLabel.font = [IRCommon getDefaultFontForSize:14.0 isBold:YES];
    if (indexPath.section == 1) {
        category = [[self.filteredExpenseForCurrentMonth objectAtIndex:indexPath.row]objectForKey:@"category"];
        expense = [[[self.filteredExpenseForCurrentMonth objectAtIndex:indexPath.row]objectForKey:@"totalExpense"]doubleValue];
        expenseString = [NSString stringWithFormat:@"%@ %@ %0.2f",category,currencySymbol,expense];
        colorCode = [IRCommon getColorCodeForCategory:category andIsExpense:YES];
    } else if (indexPath.section == 2) {
        category = [[self.filteredIncomeForCurrentMonth objectAtIndex:indexPath.row]objectForKey:@"category"];
        expense = [[[self.filteredIncomeForCurrentMonth objectAtIndex:indexPath.row]objectForKey:@"totalExpense"]doubleValue];
        expenseString = [NSString stringWithFormat:@"%@ %@ %0.2f",category,currencySymbol,expense];
        colorCode = [IRCommon getColorCodeForCategory:category andIsExpense:NO];
    } else {
        colorCode = 0;
    }
    cell.expenseLabel.text = expenseString;
    cell.expenseLabel.textColor = [UIColor darkGrayColor];
    cell.expense = expense/maxExpense *100;
    cell.totalExpense = [IRCommon getTotalExpenseForCurrentMonth:self.expenseForCurrentMonth];
    cell.color = [IRCommon isThemeApplicableForCategoryIcons] ? [IRCommon getThemeColor] : [IRCommon getColorForColorCode:colorCode];
    [cell createStackedBarChart];
    return cell;
}

#pragma mark - UITableView Delegate Methods

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    IRExpenseListViewController *expenseDetailViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"ExpenseListViewController"];
    switch (indexPath.section) {
        case 1:
            expenseDetailViewController.categoryName = [[self.filteredExpenseForCurrentMonth objectAtIndex:indexPath.row]objectForKey:@"category"] ;
            expenseDetailViewController.categoryExpense = [[[self.filteredExpenseForCurrentMonth objectAtIndex:indexPath.row]objectForKey:@"totalExpense"]doubleValue];
            expenseDetailViewController.isExpense = YES;
            break;
        case 2:
            expenseDetailViewController.categoryName = [[self.filteredIncomeForCurrentMonth objectAtIndex:indexPath.row]objectForKey:@"category"];
            expenseDetailViewController.categoryExpense = [[[self.filteredIncomeForCurrentMonth objectAtIndex:indexPath.row]objectForKey:@"totalExpense"]doubleValue];
            expenseDetailViewController.isExpense = NO;
            break;
        default:
            break;
    }
    [IRCommon updateAppUsagePointsWithValue:1];
    [self.navigationController pushViewController:expenseDetailViewController animated:YES];
}

#pragma mark - UICollectionView Datasource Methods

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.overviewTextArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    IRHomeCollectionCell *cell = (IRHomeCollectionCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"HomeCollectionView" forIndexPath:indexPath];
    cell.titleLabel.text = [self.overviewTextArray objectAtIndex:indexPath.row];
    cell.titleLabel.textColor = [UIColor darkGrayColor];
    cell.titleLabel.font = [IRCommon getDefaultFontForSize:12.0 isBold:NO];
//    cell.amount.textColor = [IRCommon getThemeColor];
    return cell;
}

#pragma mark - UICollectionViewLayout Delegate Methods

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(320, 100);
}

#pragma mark - UIScrollView Delegate Methods

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat pageWidth = self.collectionView.frame.size.width;
    self.pageControl.currentPage = (self.collectionView.contentOffset.x + pageWidth / 2) / pageWidth;
}

#pragma mark - ADBannerView Delegate Methods

- (BOOL)bannerViewActionShouldBegin:(ADBannerView *)banner willLeaveApplication:(BOOL)willLeave
{
    [IRCommon updateAdPoints];
    return YES;
}

- (void)bannerViewDidLoadAd:(ADBannerView *)banner
{
    [self showBanner];
}

- (void)bannerViewActionDidFinish:(ADBannerView *)banner
{
    [self hideBanner];
}

- (void)bannerView:(ADBannerView *)banner didFailToReceiveAdWithError:(NSError *)error
{
    [self hideBanner];
}

#pragma mark - IBAction Methods

- (IBAction)didChangePageControlValue:(id)sender {
}

- (IBAction)didTouchUpInsideAddExpenseButton:(id)sender {
    IRAddExpenseViewController *addExpenseViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"AddExpenseViewController"];
    addExpenseViewController.type = EMAdd;
    [self.navigationController pushViewController:addExpenseViewController animated:YES];
}

#pragma mark - Dealloc Method

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

#pragma mark - GameCenter Methods

- (void)authenticateLocalPlayer
{
    // Instantiate a GKLocalPlayer object to use for authenticating a player.
    GKLocalPlayer *localPlayer = [GKLocalPlayer localPlayer];
    
    localPlayer.authenticateHandler = ^(UIViewController *viewController, NSError *error){
        if (viewController != nil) {
            self.gameCenterViewController = viewController;
            // If it's needed display the login view controller.
            UIAlertView *gameCenterAlert = [[UIAlertView alloc]initWithTitle:APPLICATION_NAME message:[IRCommon localizeText:@"Do you want to sign in to Game Center?"] delegate:self cancelButtonTitle:@"Yes" otherButtonTitles:@"No", nil];
            [gameCenterAlert show];
        }
        else{
            if ([GKLocalPlayer localPlayer].authenticated) {
                // If the player is already authenticated then indicate that the Game Center features can be used.
                _gameCenterEnabled = YES;
                
                // Get the default leaderboard identifier.
                [[GKLocalPlayer localPlayer] loadDefaultLeaderboardIdentifierWithCompletionHandler:^(NSString *leaderboardIdentifier, NSError *error) {
                    
                    if (error != nil) {
                        NSLog(@"%@", [error localizedDescription]);
                    }
                    else{
                        _leaderBoardIdentifier = leaderboardIdentifier;
                    }
                }];
            }
            
            else{
                _gameCenterEnabled = NO;
            }
        }
    };
    
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        [self presentViewController:self.gameCenterViewController animated:YES completion:nil];
        
    }
}





@end
