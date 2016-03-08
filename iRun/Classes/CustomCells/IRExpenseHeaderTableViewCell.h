//
//  IRExpenseHeaderTableViewCell.h
//  ExpenseManager
//
//  Created by Shibin S on 08/09/14.
//  Copyright (c) 2014 Shibin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface IRExpenseHeaderTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *categoryName;
@property (weak, nonatomic) IBOutlet UILabel *totalExpense;

@end
