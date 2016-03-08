//
//  IRHistoryHeaderTableViewCell.h
//  ExpenseManager
//
//  Created by Shibin S on 15/09/14.
//  Copyright (c) 2014 Shibin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface IRHistoryHeaderTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *headerText;
@property (weak, nonatomic) IBOutlet UILabel *arrowImage;
@property (weak, nonatomic) IBOutlet UILabel *profit;
@property (weak, nonatomic) IBOutlet UILabel *profitArrow;

@end
