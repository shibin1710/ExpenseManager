//
//  IRApplicationController.h
//  ExpenseManager
//
//  Created by Shibin S on 30/09/14.
//  Copyright (c) 2014 Shibin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface IRApplicationController : NSObject

+ (IRApplicationController *)sharedInstance;
- (void)showAlertForDailyReminder;

@end
