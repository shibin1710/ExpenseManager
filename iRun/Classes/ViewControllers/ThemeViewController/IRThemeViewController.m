//
//  IRThemeViewController.m
//  ExpenseManager
//
//  Created by Shibin S on 13/09/14.
//  Copyright (c) 2014 Shibin. All rights reserved.
//

#import "IRThemeViewController.h"
#import "IRCommon.h"
#import "IRThemeCollectionViewCell.h"
#import <QuartzCore/QuartzCore.h>

@interface IRThemeViewController () {
    NSNumber *selectedIndex;
}
@property (weak, nonatomic) IBOutlet UISwitch *themeSwitch;
@property (weak, nonatomic) IBOutlet UILabel *applyThemeColorLabel;

@end

@implementation IRThemeViewController

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
    self.applyThemeColorLabel.text = [IRCommon localizeText:@"Apply theme color to category icons"];
    self.navigationItem.title = [IRCommon localizeText:@"Theme"];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:[IRCommon localizeText:@"Apply"] style:UIBarButtonItemStylePlain target:self action:@selector(didTouchUpInsideApplyButton)];
    selectedIndex = [[NSUserDefaults standardUserDefaults]objectForKey:@"color"];
    self.themeSwitch.onTintColor = [IRCommon getThemeColor];
    self.themeSwitch.on = ([[[NSUserDefaults standardUserDefaults]objectForKey:@"applyThemeForIcons"]boolValue]) ? YES : NO;
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UICollectionView Datasource Methods

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 12;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    IRThemeCollectionViewCell *cell = (IRThemeCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"ThemeCell" forIndexPath:indexPath];
    cell.backgroundColor = [IRCommon getColorForColorCode:(int)indexPath.row];
    cell.layer.cornerRadius = 4.0f;
    cell.selectionLabel.hidden = (indexPath.row == selectedIndex.intValue) ? NO : YES;
    return cell;
}

#pragma mark - UICollectionViewLayout Delegate Methods

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(94, 94);
}

- (UIEdgeInsets)collectionView: (UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(8, 8, 8, 8);
}

#pragma mark - UICollectionView Delegate Methods

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    IRThemeCollectionViewCell *cell = (IRThemeCollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
    if (selectedIndex) {
        IRThemeCollectionViewCell *selectedCell = (IRThemeCollectionViewCell *)[collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForRow:selectedIndex.intValue inSection:0]];
        selectedCell.selectionLabel.hidden = YES;
    }
    cell.selectionLabel.hidden = NO;
    selectedIndex = [NSNumber numberWithInt:(int)indexPath.row];
}

- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath
{
    IRThemeCollectionViewCell *cell = (IRThemeCollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
    cell.selectionLabel.hidden = YES;
}

- (void)didTouchUpInsideApplyButton
{
    [IRCommon updateAppUsagePointsWithValue:1];
    self.navigationController.navigationBar.barTintColor = [IRCommon getColorForColorCode:selectedIndex.intValue];
    [[NSUserDefaults standardUserDefaults]setObject:selectedIndex forKey:@"color"];
    BOOL applyThemeForIcons = self.themeSwitch.on ? YES : NO;
    [[NSUserDefaults standardUserDefaults]setObject:[NSNumber numberWithBool:applyThemeForIcons] forKey:@"applyThemeForIcons"];
    self.themeSwitch.onTintColor = [IRCommon getColorForColorCode:selectedIndex.intValue];
    [IRCommon showAlertWithTitle:APPLICATION_NAME message:[IRCommon localizeText:@"The theme has been applied."] dismissButtonText:[IRCommon localizeText:OK_TEXT]];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
