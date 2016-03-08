//
//  IRCategory.m
//  ExpenseManager
//
//  Created by Shibin S on 07/09/14.
//  Copyright (c) 2014 Shibin. All rights reserved.
//

#import "IRCategory.h"
#import "CategoryGroup.h"

@implementation IRCategory

- (id)init
{
    self = [super init];
    if (self) {
        self.colorCode = 0;
        self.categoryName = @"Others";
        self.isExpense = YES;
        self.categoryID = -1;
    }
    return self;
}

- (IRCategory *)readFromEntity:(CategoryGroup *)category
{
    self.colorCode = category.colorCode.intValue;
    self.categoryName = category.categoryName;
    self.isExpense = category.isExpense.boolValue;
    self.categoryID = category.categoryID.intValue;
    return self;
}

@end
