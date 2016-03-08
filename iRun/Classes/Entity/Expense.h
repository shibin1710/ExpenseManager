//
//  Expense.h
//  ExpenseManager
//
//  Created by Shibin S on 13/09/14.
//  Copyright (c) 2014 Shibin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class CategoryGroup;

@interface Expense : NSManagedObject

@property (nonatomic) NSNumber * amount;
@property (nonatomic) NSString * category;
@property (nonatomic) NSString * currency;
@property (nonatomic) NSDate * date;
@property (nonatomic) NSString * expenseId;
@property (nonatomic) NSString * image;
@property (nonatomic) NSNumber * isExpense;
@property (nonatomic) NSNumber * isRecurring;
@property (nonatomic) NSString * note;
@property (nonatomic) NSNumber * recurringDuration;
@property (nonatomic) NSString * sectionIdentifier;
@property (nonatomic) NSDate *timeStamp;
@property (nonatomic) NSString *misc;
@property (nonatomic) CategoryGroup *categoryRelationship;

@end
