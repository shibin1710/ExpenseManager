//
//  CategoryGroup.h
//  ExpenseMobile
//
//  Created by Shibin S on 28/05/15.
//  Copyright (c) 2015 Shibin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Expense;

@interface CategoryGroup : NSManagedObject

@property (nonatomic, retain) NSString * categoryName;
@property (nonatomic, retain) NSNumber * colorCode;
@property (nonatomic, retain) NSDate * date;
@property (nonatomic, retain) NSNumber * isExpense;
@property (nonatomic, retain) NSString * misc;
@property (nonatomic, retain) NSNumber * categoryID;
@property (nonatomic, retain) Expense *expenseRelationship;

@end
