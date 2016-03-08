//
//  IRNotification.h
//  ExpenseManager
//
//  Created by Shibin S on 29/09/14.
//  Copyright (c) 2014 Shibin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface IRNotification : NSObject

- (void)showNotification:(IRNotification *)notifcationParams;
- (void)cancelAllNotifications;
- (void)cancelNotification:(IRNotification *)notifcationParams;

@property (strong, nonatomic) NSString *notificationAlertBody;
@property (strong, nonatomic) NSDate *notificationFireDate;
@property (assign, nonatomic) NSCalendarUnit notificationRepeatInterval;
@property (strong, nonatomic) UILocalNotification *localNotification;

@end
