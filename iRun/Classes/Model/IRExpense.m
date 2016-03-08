//
//  IRExpense.m
//  ExpenseManager
//
//  Created by Shibin S on 04/09/14.
//  Copyright (c) 2014 Shibin. All rights reserved.
//

#import "IRExpense.h"
#import "Expense.h"

@implementation IRExpense

- (id)init
{
    self = [super init];
    if (self) {
        self.expenseId = @"";
        self.category = @"Others";
        self.amount = 0.00;
        self.date = [NSDate date];
        self.note = @"";
        self.isExpense = YES;
        self.image = @"";
        self.currency = @"$";
        self.isRecurring = NO;
        self.recurringDuration = 0;
    }
    return self;
}

- (IRExpense *)readFromEntity:(Expense *)expense
{
    self.expenseId = expense.expenseId;
    self.category = expense.category;
    self.amount = expense.amount.doubleValue;
    self.date = expense.date;
    self.note = expense.note;
    self.isExpense = expense.isExpense.boolValue;
    self.image = expense.image;
    self.currency = expense.currency;
    self.isRecurring = expense.isRecurring;
    self.recurringDuration = expense.recurringDuration.doubleValue;
    return self;
}

@end
