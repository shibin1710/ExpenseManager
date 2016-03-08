//
//  IRCategoryViewController.h
//  ExpenseManager
//
//  Created by Shibin S on 04/09/14.
//  Copyright (c) 2014 Shibin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FPNumberPadView.h"
#import "IRCalenderViewController.h"
#import "IRCategoryTableViewCell.h"
#import "IRExpense.h"

typedef enum {
    EMAdd,
    EMEdit
}
ExpenseMode;

@interface IRAddExpenseViewController : UIViewController<NumberPadDelegate,UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate,IRCalenderViewDelegate,CategoryCellDelegate>

@property (assign, nonatomic) ExpenseMode type;
//@property (assign ,nonatomic) float expenseAmount;
//@property (strong, nonatomic) NSDate *selectedDate;
@property (strong, nonatomic) NSIndexPath *selectedIndexPath;
//@property (assign, nonatomic) BOOL isExpense;
//@property (strong, nonatomic) NSString *expenseIdForEditedExpense;
@property (strong, nonatomic) IRExpense *expenseDetails;

@end
