//
//  IRCalenderViewController.h
//  ExpenseManager
//
//  Created by Shibin S on 06/09/14.
//  Copyright (c) 2014 Shibin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TSQCalendarCell.h"
#import "TSQCalendarMonthHeaderCell.h"
#import "TSQCalendarRowCell.h"
#import "TSQCalendarView.h"




@protocol IRCalenderViewDelegate <NSObject>

- (void)didSelectDate:(NSDate *)date;

@end

@interface IRCalenderViewController : UIViewController<TSQCalendarViewDelegate>

@property (nonatomic, strong) NSCalendar *calendar;
@property (nonatomic, assign) id<IRCalenderViewDelegate> delegate;

@end
