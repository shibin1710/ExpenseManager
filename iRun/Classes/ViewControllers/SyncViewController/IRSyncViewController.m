//
//  IRSyncViewController.m
//  ExpenseMobile
//
//  Created by Shibin S on 05/06/15.
//  Copyright (c) 2015 Shibin. All rights reserved.
//

#import "IRSyncViewController.h"
#import "SWRevealViewController.h"
#import "IRCommon.h"

@interface IRSyncViewController ()

@property (weak, nonatomic) IBOutlet UIButton *menuButton;

@end

@implementation IRSyncViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [_menuButton addTarget:self.revealViewController action:@selector(revealToggle:) forControlEvents:UIControlEventTouchUpInside];
    // Set the gesture
    [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
    [self.view addGestureRecognizer:self.revealViewController.tapGestureRecognizer];
    self.navigationItem.title = [IRCommon localizeText:@"Sync"];
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

@end
