//
//  IRDistributionViewController.m
//  ExpenseMobile
//
//  Created by Shibin S on 20/12/14.
//  Copyright (c) 2014 Shibin. All rights reserved.
//

#import "IRDistributionViewController.h"
#import "IRCommon.h"
#import "SWRevealViewController.h"
#import "IRDistributionCollectionViewCell.h"
#import "IRCoreDataController.h"

@interface IRDistributionViewController ()
{
    NSNumber *trackMode;
}

@property (weak, nonatomic) IBOutlet UIButton *menuButton;
@property (weak, nonatomic) IBOutlet UISegmentedControl *segmentControl;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;


@end

@implementation IRDistributionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    trackMode = [[NSUserDefaults standardUserDefaults]objectForKey:@"trackMode"];
    [_menuButton addTarget:self.revealViewController action:@selector(revealToggle:) forControlEvents:UIControlEventTouchUpInside];
    // Set the gesture
    [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
    [self.view addGestureRecognizer:self.revealViewController.tapGestureRecognizer];
    self.navigationItem.title = @"Distribution";
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName: [UIColor whiteColor],NSFontAttributeName:[IRCommon getDefaultFontForSize:17.0 isBold:YES]};
    self.segmentControl.tintColor = [IRCommon getThemeColor];
    [self.segmentControl setTitleTextAttributes:[NSDictionary dictionaryWithObject:[IRCommon getDefaultFontForSize:14 isBold:NO] forKey:NSFontAttributeName] forState:UIControlStateNormal];
   
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

#pragma mark - UICollectionView Datasource Methods

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if (trackMode.intValue == 0) {
        return 1;
    } else {
        return 3;
    }
    
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    IRDistributionCollectionViewCell *cell = (IRDistributionCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"IRDistributionCollectionViewCell" forIndexPath:indexPath];
    cell.typeLabel.font = [IRCommon getDefaultFontForSize:18 isBold:YES];
    cell.typeLabel.textColor = [IRCommon getThemeColor];
    switch (indexPath.row) {
        case 0:
            if (trackMode.intValue == 0) {
                cell.tag = 100001;
//                cell.backgroundColor = [UIColor colorWithRed:255.0/255.0 green:80.0/255.0 blue:58.0/255.0 alpha:0.6];
                cell.typeLabel.text = @"Expense";
            }
            else {
                cell.tag = 100000;
//                cell.backgroundColor = [UIColor colorWithRed:16.0/255.0 green:100.0/255.0 blue:180.0/255.0 alpha:0.4];
                cell.typeLabel.text = @"Overall";
            }
            
            break;
        case 1:
            cell.tag = 100001;
//            cell.backgroundColor = [UIColor colorWithRed:255.0/255.0 green:80.0/255.0 blue:58.0/255.0 alpha:0.6];
            cell.typeLabel.text = @"Expense";
            break;
        case 2:
            cell.tag = 100002;
//            cell.backgroundColor = [UIColor colorWithRed:90.0/255.0 green:212.0/255.0 blue:39.0/255.0 alpha:0.7];
            cell.typeLabel.text = @"Income";
            
            break;
        default:
            break;
    }
    [cell configureCell];
    return cell;
}

#pragma mark - UICollectionViewLayout Delegate Methods

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(320, 350);
}


@end
