//
//  IRApplicationController.m
//  ExpenseManager
//
//  Created by Shibin S on 30/09/14.
//  Copyright (c) 2014 Shibin. All rights reserved.
//

#import "IRApplicationController.h"
#import "IRNotification.h"

static IRApplicationController *sharedInstance = nil;

@implementation IRApplicationController

+ (IRApplicationController *)sharedInstance
{
    if (!sharedInstance) {
        sharedInstance = [[self alloc]init];
    }
    return sharedInstance;
}

- (void)showAlertForDailyReminder
{
    IRNotification *notification = [[IRNotification alloc]init];
    [notification cancelAllNotifications];
    if ([[[NSUserDefaults standardUserDefaults]objectForKey:@"dailyReminder"]boolValue]) {
        notification.notificationAlertBody = @"Don't forget to track your expense and income.";
        notification.notificationFireDate = [[NSUserDefaults standardUserDefaults]objectForKey:@"reminderTime"];
        notification.notificationRepeatInterval = NSCalendarUnitDay;
        [notification showNotification:notification];
    }
}

@end
