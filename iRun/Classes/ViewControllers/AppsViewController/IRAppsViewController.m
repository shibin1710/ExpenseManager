//
//  IRAppsViewController.m
//  ExpenseMobile
//
//  Created by Shibin S on 05/06/15.
//  Copyright (c) 2015 Shibin. All rights reserved.
//

#import "IRAppsViewController.h"
#import "IRCommon.h"
#import "IRAppsTableViewCell.h"

@interface IRAppsViewController ()

@property (weak, nonatomic) IBOutlet UITableView *appsTableView;

@end

@implementation IRAppsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = [IRCommon localizeText:@"Developer Apps"];

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
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 4;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    IRAppsTableViewCell *cell = (IRAppsTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"AppsCell" forIndexPath:indexPath];
    if (cell == nil) {
        cell = [[IRAppsTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"AppsCell"];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    switch (indexPath.row) {
        case 0:
            cell.appTitle.text = @"Kuku Kube Shade Spotter Game";
            cell.appCategory.text = @"Games";
            cell.appImage.image = [UIImage imageNamed:@"KukuKube.png"];
            break;
        case 1:
            cell.appTitle.text = @"Spot the Color";
            cell.appCategory.text = @"Games";
            cell.appImage.image = [UIImage imageNamed:@"SpotTheColor.png"];
            break;
        case 2:
            cell.appTitle.text = @"World Cup Cricket Quiz";
            cell.appCategory.text = @"Games";
            cell.appImage.image = [UIImage imageNamed:@"Cricket.png"];
            break;
        case 3:
            cell.appTitle.text = @"Any Unit Converter";
            cell.appCategory.text = @"Utilities";
            cell.appImage.image = [UIImage imageNamed:@"AnyUnit.png"];
            break;
        default:
            break;
    }
    
    cell.appTitle.font = [IRCommon getDefaultFontForSize:14 isBold:YES];
    cell.appCategory.font = [IRCommon getDefaultFontForSize:12 isBold:NO];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.row) {
        case 0:
            [[UIApplication sharedApplication]openURL:[NSURL URLWithString:@"itms-apps://itunes.apple.com/app/id944673793"]];
            break;
        case 1:
            [[UIApplication sharedApplication]openURL:[NSURL URLWithString:@"itms-apps://itunes.apple.com/app/id954343792"]];
            break;
        case 2:
            [[UIApplication sharedApplication]openURL:[NSURL URLWithString:@"itms-apps://itunes.apple.com/app/id961413969"]];
            break;
        case 3:
            [[UIApplication sharedApplication]openURL:[NSURL URLWithString:@"itms-apps://itunes.apple.com/app/id932486799"]];
            break;
        default:
            break;
    }
}

@end
