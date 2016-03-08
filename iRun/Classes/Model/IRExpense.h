//
//  IRExpense.h
//  ExpenseManager
//
//  Created by Shibin S on 04/09/14.
//  Copyright (c) 2014 Shibin. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Expense;

@interface IRExpense : NSObject

@property (nonatomic, strong) NSString *expenseId;
@property (nonatomic, strong) NSString * category;
@property (nonatomic, assign) double amount;
@property (nonatomic, strong) NSDate * date;
@property (nonatomic, strong) NSString * note;
@property (nonatomic, assign) BOOL isExpense;
@property (nonatomic, strong) NSString * image;
@property (nonatomic, strong) NSString * currency;
@property (nonatomic, assign) BOOL isRecurring;
@property (nonatomic, assign) double recurringDuration;

- (IRExpense *)readFromEntity:(Expense *)expense;

@end
