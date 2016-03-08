//
//  IRGamification.h
//  ExpenseManager
//
//  Created by Shibin S on 30/09/14.
//  Copyright (c) 2014 Shibin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface IRGamification : NSObject

+ (IRGamification *)sharedInstance;
- (NSArray *)getArrayOfOverViewText;
- (NSArray *)getArrayOfOverViewTextForExpenseOnly;

@end
