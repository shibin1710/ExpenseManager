//
//  IRCategoryDetailViewController.h
//  ExpenseManager
//
//  Created by Shibin S on 07/09/14.
//  Copyright (c) 2014 Shibin. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    CTAdd,
    CTEdit
}
CategoryType;

@interface IRCategoryDetailViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate>

@property (strong, nonatomic) NSString *name;
@property (assign, nonatomic) int colorCode;
@property (assign, nonatomic) CategoryType type;
@property (assign, nonatomic) BOOL isExpense;

@end
