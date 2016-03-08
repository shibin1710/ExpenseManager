//
//  IRCategoryExpenseTableViewCell.h
//  ExpenseManager
//
//  Created by Shibin S on 08/09/14.
//  Copyright (c) 2014 Shibin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface IRCategoryExpenseTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *note;
@property (weak, nonatomic) IBOutlet UILabel *amount;
@property (weak, nonatomic) IBOutlet UILabel *date;

@end
