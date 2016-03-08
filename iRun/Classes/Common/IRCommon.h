//
//  IRCommon.h
//  iRun
//
//  Created by Shibin S on 30/08/14.
//  Copyright (c) 2014 Shibin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IRCategory.h"

@interface IRCommon : NSObject

+ (void)showAlertWithTitle:(NSString *)title message:(NSString *)message dismissButtonText:(NSString *)dismissButtonText;
+ (UIImage *)loadImage:(NSString *)imageName ofType:(NSString *)type;
+ (NSDate *)startOfMonth;
+ (NSDate *)endOfMonth;
+ (NSArray *)filterExpenseByCategory:(NSArray *)expenseArray;
+ (NSString *)getCurrentMonth;
+ (NSString *)getCurrentYear;
+ (double)getTotalExpenseForCurrentMonth:(NSArray *)expenseArray;
+ (UIColor *)getColorForColorCode:(int)code;
+ (NSString *)getFirstLetterFromString:(NSString *)text;
+ (int)getColorCodeForCategory:(NSString *)category andIsExpense:(BOOL)isExpense;
+ (BOOL)isCategoryAddedinDB:(IRCategory *)category forExpense:(BOOL)isExpense addToDB:(BOOL)toAdd;
+ (NSString *)getCurrencySymbolFromCode:(NSString *)code;
+ (BOOL)isToday:(NSDate *)date;
+ (BOOL)isYesterday:(NSDate *)date;
+ (BOOL)isTomorrow:(NSDate *)date;
+ (NSDate *)getDateOnlyFromDate:(NSDate *)date;
+ (NSString *)getDateStringFromDate:(NSDate *)date;
+ (NSString *)getWeekDayFromDate:(NSDate *)date;
+ (UIColor *)getThemeColor;
+ (BOOL)isThemeApplicableForCategoryIcons;
+ (NSString *)getCurrentAppVersion;
+ (NSString *)getDeviceName;
+ (NSString *)getiOSVersion;
+ (Grouping)getGroupingName;
+ (float)getTotalProfitForArray:(NSArray *)expenseArray;
+ (NSString *)getDayNameFromDate:(NSDate *)date;
+ (NSString *)getDate:(NSDate *)date inFormat:(NSString *)format;
+ (int)getIndexForCategory:(NSString *)category isExpense:(BOOL)isExpense;
+ (void)saveCategoriesToDB;
+ (UIFont *)getDefaultFontForSize:(float)size isBold:(BOOL)isBold;
+ (UIColor *)lighterColorForColor:(UIColor *)c;
+ (UIColor *)darkerColorForColor:(UIColor *)c;
+ (NSString *)localizeText:(NSString *)textToLocalize;
+ (void)updateSocialPoints;
+ (void)updateAdPoints;
+ (void)updateAppUsagePointsWithValue:(int)val;
+ (int)calculateAggregatePoints;
+ (void)resetAchievements;
+ (int)getCategoryIDToSave:(BOOL)isExpense;
+ (int)getIndexOfOtherCategory:(BOOL)isExpense;
+ (BOOL)isFullVersion;
+ (BOOL)isNetworkAvailable;
+ (NSArray *)getArrayFromPlist:(NSString *)plistName;

@end
