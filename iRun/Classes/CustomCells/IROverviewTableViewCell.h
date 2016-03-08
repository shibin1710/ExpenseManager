//
//  IROverviewTableViewCell.h
//  ExpenseManager
//
//  Created by Shibin S on 06/09/14.
//  Copyright (c) 2014 Shibin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface IROverviewTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *expenseLabel;
@property (assign, nonatomic) double expense;
@property (assign, nonatomic) double totalExpense;
@property (strong, nonatomic) UIColor *color;

- (void)createStackedBarChart;

@end
