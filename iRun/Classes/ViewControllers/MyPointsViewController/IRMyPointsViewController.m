//
//  IRMyPointsViewController.m
//  ExpenseMobile
//
//  Created by Shibin S on 14/01/15.
//  Copyright (c) 2015 Shibin. All rights reserved.
//

#import "IRMyPointsViewController.h"
#import "SWRevealViewController.h"
#import "IRCommon.h"
#import "IRPointsTableViewCell.h"

@interface IRMyPointsViewController ()

@property (weak, nonatomic) IBOutlet UIButton *menuButton;
@property (weak, nonatomic) IBOutlet UITableView *pointsTableView;

@end

@implementation IRMyPointsViewController
{
    BOOL isShareScoreEnabled;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    isShareScoreEnabled = [[[NSUserDefaults standardUserDefaults]objectForKey:@"shareScore"]boolValue];
    [IRCommon updateAppUsagePointsWithValue:1];
    [_menuButton addTarget:self.revealViewController action:@selector(revealToggle:) forControlEvents:UIControlEventTouchUpInside];
    // Set the gesture
    [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
    [self.view addGestureRecognizer:self.revealViewController.tapGestureRecognizer];
    self.navigationItem.title = [IRCommon localizeText:@"My Points"];
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName: [UIColor whiteColor],NSFontAttributeName:[IRCommon getDefaultFontForSize:17.0 isBold:YES]};
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    switch (section) {
        case 0:
            return 3;
            break;
        case 1:
            return 4;
            break;
        case 2:
            return 3;
            break;
        default:
            break;
    }
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 30;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return (indexPath.section == 0 && indexPath.row == 0) ? 90 : 44;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PointsHeaderCell"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"PointsHeaderCell"];
    }
    cell.textLabel.font = [IRCommon getDefaultFontForSize:14 isBold:YES];
    cell.textLabel.textColor = [UIColor darkGrayColor];
    cell.backgroundColor = [UIColor groupTableViewBackgroundColor];
    switch (section) {
        case 0:
            cell.textLabel.text = [IRCommon localizeText:@"Leaderboard"];
            break;
        case 1:
            cell.textLabel.text = [IRCommon localizeText:@"My Points"];
            break;
//        case 2:
//            cell.textLabel.text = [IRCommon localizeText:@"Top Users"];
//            break;
        default:
            cell.textLabel.text = @"";
            break;
    }
    return cell;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    IRPointsTableViewCell *cell = (IRPointsTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"PointsCell" forIndexPath:indexPath];
    if (cell == nil) {
        cell = [[IRPointsTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"PointsCell"];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.delegate = self;
    cell.textLabel.textColor = [UIColor darkGrayColor];
    cell.nameLabel.textColor = [UIColor darkGrayColor];
    cell.pointsLabel.textColor = [UIColor darkGrayColor];
    cell.shareSwitch.hidden = YES;
    cell.textLabel.backgroundColor = [UIColor clearColor];
    switch (indexPath.section) {
        case 0:
            if (indexPath.row == 0) {
                cell.textLabel.font = [IRCommon getDefaultFontForSize:12 isBold:NO];
                cell.textLabel.numberOfLines = -1;
                cell.pointsLabel.hidden = YES;
                cell.textLabel.text = [IRCommon localizeText:@"The more you interact with the app, the more points you can collect. Adding expense or income, Sharing in Social, Rating App in Appstore and clicking Ads will fetch more points. Get maximum points and become #1 in Top Users."];
            }
            else if (indexPath.row == 1) {
                cell.textLabel.font = [IRCommon getDefaultFontForSize:15 isBold:NO];
                cell.textLabel.text = [IRCommon localizeText:@"View Leaderboard"];
                cell.pointsLabel.hidden = YES;
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            } else {
                cell.textLabel.font = [IRCommon getDefaultFontForSize:15 isBold:NO];
                cell.textLabel.text = [IRCommon localizeText:@"Share Scores"];
                cell.pointsLabel.hidden = YES;
                cell.shareSwitch.onTintColor = [IRCommon getThemeColor];
                cell.shareSwitch.on = isShareScoreEnabled;
//                cell.shareSwitch.tintColor = [IRCommon getThemeColor];
                cell.shareSwitch.hidden = NO;
            }
            break;
        case 1:
            if (indexPath.row == 0) {
                cell.nameLabel.text = [IRCommon localizeText:@"Overall Points"];
                int totalPoints = [IRCommon calculateAggregatePoints];
                cell.pointsLabel.text = [NSString stringWithFormat:@"%i Points",totalPoints];

            } else if (indexPath.row == 1) {
                cell.nameLabel.text = [IRCommon localizeText:@"App Usage"];
                int appUsagePoints = [[[NSUserDefaults standardUserDefaults]objectForKey:@"appUsagePoints"]intValue];
                cell.pointsLabel.text = [NSString stringWithFormat:@"%i Points",appUsagePoints];

            } else if (indexPath.row == 2) {
                cell.nameLabel.text = [IRCommon localizeText:@"Social Sharing"];
                int socialPoints = [[[NSUserDefaults standardUserDefaults]objectForKey:@"socialPoints"]intValue];
                cell.pointsLabel.text = [NSString stringWithFormat:@"%i Points",socialPoints];

            } else if (indexPath.row == 3) {
                cell.nameLabel.text = [IRCommon localizeText:@"Ad Clicks"];
                int adClicks = [[[NSUserDefaults standardUserDefaults]objectForKey:@"adClickPoints"]intValue];
                cell.pointsLabel.text = [NSString stringWithFormat:@"%i Points",adClicks];

            }
            cell.nameLabel.font = [IRCommon getDefaultFontForSize:15 isBold:NO];
            cell.pointsLabel.font = [IRCommon getDefaultFontForSize:13 isBold:YES];
            break;
//        case 2:
//            if (indexPath.row == 0) {
//                cell.nameLabel.text = @"#1 John Doe";
//                
//            } else if (indexPath.row == 1) {
//                cell.nameLabel.text = @"#2 Mathew";
//                
//            } else if (indexPath.row == 2) {
//                cell.nameLabel.text = @"#3 Nabi";
//                
//            }
//            cell.nameLabel.font = [IRCommon getDefaultFontForSize:15 isBold:NO];
//            cell.pointsLabel.font = [IRCommon getDefaultFontForSize:13 isBold:YES];
//            cell.pointsLabel.text = @"1234576 Points";
//            break;
        default:
            break;
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.section) {
        case 0:
            if (indexPath.row == 1) {
                [self showLeaderboardAndAchievements:YES];
            }
            break;
            
        default:
            break;
    }
}

- (void)switchTapped:(id)sender
{
    UISwitch *shareSwitch = (UISwitch *)sender;
    [[NSUserDefaults standardUserDefaults]setObject:[NSNumber numberWithInt:shareSwitch.on ? 1 : 0] forKey:@"shareScore"];
}

-(void)showLeaderboardAndAchievements:(BOOL)shouldShowLeaderboard{
    // Init the following view controller object.
    GKGameCenterViewController *gcViewController = [[GKGameCenterViewController alloc] init];
    
    // Set self as its delegate.
    gcViewController.gameCenterDelegate = self;
    
    // Depending on the parameter, show either the leaderboard or the achievements.
    if (shouldShowLeaderboard) {
        gcViewController.viewState = GKGameCenterViewControllerStateLeaderboards;
    }
    else{
        gcViewController.viewState = GKGameCenterViewControllerStateAchievements;
    }
    
    // Finally present the view controller.
    [self presentViewController:gcViewController animated:YES completion:nil];
}


#pragma mark - GKGameCenterControllerDelegate method implementation

-(void)gameCenterViewControllerDidFinish:(GKGameCenterViewController *)gameCenterViewController
{
    [gameCenterViewController dismissViewControllerAnimated:YES completion:nil];
}

@end
