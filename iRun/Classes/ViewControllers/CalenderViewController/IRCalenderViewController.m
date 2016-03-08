//
//  IRCalenderViewController.m
//  ExpenseManager
//
//  Created by Shibin S on 06/09/14.
//  Copyright (c) 2014 Shibin. All rights reserved.
//

#import "IRCalenderViewController.h"
#import "IRCalenderRowCell.h"
#import "IRCommon.h"

@interface IRCalenderViewController ()

@end

@interface TSQCalendarView (AccessingPrivateStuff)

@property (nonatomic, readonly) UITableView *tableView;

@end

@implementation IRCalenderViewController

#pragma mark - View lifecycle

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationController.navigationBar.barTintColor = [IRCommon getThemeColor];
    self.navigationItem.title = @"Select Date";
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName: [UIColor whiteColor],NSFontAttributeName:[IRCommon getDefaultFontForSize:17.0 isBold:YES]};
    UIBarButtonItem *closeButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(didTouchUpInsideCancelButton)];
    self.navigationItem.rightBarButtonItem = closeButton;
    [self.navigationItem.rightBarButtonItem setTitleTextAttributes:[NSDictionary dictionaryWithObject:[IRCommon getDefaultFontForSize:16 isBold:YES] forKey:NSFontAttributeName] forState:UIControlStateNormal];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)loadView;
{
    TSQCalendarView *calendarView = [[TSQCalendarView alloc] init];
    calendarView.delegate = self;
    calendarView.calendar = self.calendar;
    calendarView.rowCellClass = [IRCalenderRowCell class];
    calendarView.firstDate = [NSDate dateWithTimeIntervalSinceNow:-60 * 60 * 24 * 365 * 1];
    calendarView.lastDate = [NSDate dateWithTimeIntervalSinceNow:60 * 60 * 24 * 365 * 5];
    calendarView.backgroundColor = [UIColor whiteColor];
    calendarView.pagingEnabled = YES;
    CGFloat onePixel = 1.0f / [UIScreen mainScreen].scale;
    calendarView.contentInset = UIEdgeInsetsMake(0.0f, onePixel, 0.0f, onePixel);
    self.view = calendarView;
}

- (void)viewDidLayoutSubviews;
{
    // Set the calendar view to show today date on start
    [(TSQCalendarView *)self.view scrollToDate:[NSDate date] animated:NO];
}

#pragma mark - Setter Methods

- (void)setCalendar:(NSCalendar *)calendar;
{
    _calendar = calendar;
    self.navigationItem.title = calendar.calendarIdentifier;
    self.tabBarItem.title = calendar.calendarIdentifier;
}

#pragma mark - IBAction Methods

- (void)didTouchUpInsideCancelButton
{
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - CalenderView Delegate Methods

- (void)calendarView:(TSQCalendarView *)calendarView didSelectDate:(NSDate *)date
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(didSelectDate:)]) {
        [self.delegate didSelectDate:date];
    }
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

@end
