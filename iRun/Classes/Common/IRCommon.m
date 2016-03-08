//
//  IRCommon.m
//  iRun
//
//  Created by Shibin S on 30/08/14.
//  Copyright (c) 2014 Shibin. All rights reserved.
//

#import "IRCommon.h"
#import "IRExpense.h"
#import "IRCoreDataController.h"
#import "IRCategory.h"
#import <GameKit/GameKit.h>
#import "Reachability.h"

@implementation IRCommon

+ (void)showAlertWithTitle:(NSString *)title message:(NSString *)message dismissButtonText:(NSString *)dismissButtonText
{
    UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:title message:message delegate:self cancelButtonTitle:dismissButtonText otherButtonTitles: nil];
    [alertView show];
}

+ (UIImage *)loadImage:(NSString *)imageName ofType:(NSString *)type
{
    NSString *imagePath = [[NSBundle mainBundle]pathForResource:imageName ofType:type];
    UIImage *image = [UIImage imageWithContentsOfFile:imagePath];
    return image;
}

+ (NSDate *)startOfMonth
{
    NSCalendar * calendar = [NSCalendar currentCalendar];
    NSDateComponents * currentDateComponents = [calendar components: NSYearCalendarUnit | NSMonthCalendarUnit fromDate: [NSDate date]];
    NSDate * startOfMonth = [calendar dateFromComponents: currentDateComponents];
    return startOfMonth;
}

+ (NSDate *)dateByAddingMonths: (NSInteger) monthsToAdd
{
    NSCalendar * calendar = [NSCalendar currentCalendar];
    NSDateComponents * months = [[NSDateComponents alloc] init];
    [months setMonth: monthsToAdd];
    return [calendar dateByAddingComponents: months toDate:[NSDate date] options: 0];
}

+ (NSDate *)endOfMonth
{
    NSCalendar * calendar = [NSCalendar currentCalendar];
    NSDate * plusOneMonthDate = [self dateByAddingMonths: 1];
    NSDateComponents * plusOneMonthDateComponents = [calendar components: NSYearCalendarUnit | NSMonthCalendarUnit fromDate: plusOneMonthDate];
    NSDate * endOfMonth = [[calendar dateFromComponents: plusOneMonthDateComponents] dateByAddingTimeInterval: -1]; // One second before the start of next month
    return endOfMonth;
}

+ (NSArray *)filterExpenseByCategory:(NSArray *)expenseArray
{
    NSMutableArray *categoryArray = [NSMutableArray array];
    float expenseAmount = 0;
    NSString *category;
    for (IRExpense *expense in expenseArray) {
        NSMutableDictionary *categoryDictionary = [NSMutableDictionary dictionary];
        expenseAmount = expense.amount;
        category = expense.category;
        float previousExpenseAmount = 0;
        for (NSDictionary *dict in categoryArray) {
            if ([[dict objectForKey:@"category"]isEqualToString:category]) {
                previousExpenseAmount = [[dict objectForKey:@"totalExpense"]doubleValue];
                [categoryArray removeObject:dict];
                break;
            }
        }
        [categoryDictionary setObject:category forKey:@"category"];
        [categoryDictionary setObject:[NSNumber numberWithDouble:expenseAmount+previousExpenseAmount] forKey:@"totalExpense"];
        [categoryDictionary setObject:[NSNumber numberWithBool:expense.isExpense] forKey:@"isExpense"];
        [categoryArray addObject:categoryDictionary];
    }
    NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"totalExpense" ascending:NO];
    NSArray *sortedArray = [categoryArray sortedArrayUsingDescriptors:@[sortDescriptor]];
    return sortedArray;
}

+ (NSString *)getCurrentMonth
{
    NSDateFormatter* dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"MMMM"];
    NSString *dateString = [dateFormatter stringFromDate:[NSDate date]];
    return dateString;
}

+ (NSString *)getCurrentYear
{
    NSDateFormatter* dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"YYYY"];
    NSString *dateString = [dateFormatter stringFromDate:[NSDate date]];
    return dateString;
}

+ (double)getTotalExpenseForCurrentMonth:(NSArray *)expenseArray
{
    double totalExpense = 0;
    for (IRExpense *expense in expenseArray) {
        totalExpense += expense.amount;
    }
    return totalExpense;
}

+ (UIColor *)getColorForColorCode:(int)code
{
    switch (code) {
        case 0:
            return THEME_COLOR;
            break;
        case 1:
            return [UIColor colorWithRed:29.0/255.0 green:98.0/255.0 blue:240.0/255.0 alpha:1.0];
            break;
        case 2:
            return [UIColor colorWithRed:90.0/255.0 green:160.0/255.0 blue:39.0/255.0 alpha:1.0];
            break;
        case 3:
            return [UIColor colorWithRed:205.0/255.0 green:205.0/255.0 blue:32.0/255.0 alpha:1.0];
            break;
        case 4:
            return [UIColor colorWithRed:88.0/255.0 green:86.0/255.0 blue:214.0/255.0 alpha:1.0];
            break;
        case 5:
            return [UIColor colorWithRed:255.0/255.0 green:45.0/255.0 blue:85.0/255.0 alpha:1.0];
            break;
        case 6:
            return [UIColor colorWithRed:255.0/255.0 green:80.0/255.0 blue:58.0/255.0 alpha:1.0];
            break;
        case 7:
            return [UIColor colorWithRed:198.0/255.0 green:67.0/255.0 blue:252.0/255.0 alpha:1.0];
            break;
        case 8:
            return [UIColor colorWithRed:255.0/255.0 green:19.0/255.0 blue:0.0/255.0 alpha:1.0];
            break;
        case 9:
            return [UIColor colorWithRed:52.0/255.0 green:170.0/255.0 blue:220.0/255.0 alpha:1.0];
            break;
        case 10:
            return [UIColor colorWithRed:43.0/255.0 green:43.0/255.0 blue:43.0/255.0 alpha:1.0];
            break;
        case 11:
            return [UIColor colorWithRed:137.0/255.0 green:140.0/255.0 blue:144.0/255.0 alpha:1.0];
            break;
        default:
            return THEME_COLOR;
            break;
    }
    return nil;
}

+ (NSString *)getFirstLetterFromString:(NSString *)text
{
    NSString *firstLetter = [text substringToIndex:1];
    return [firstLetter uppercaseString];
}

+ (int)getColorCodeForCategory:(NSString *)category andIsExpense:(BOOL)isExpense
{
    NSArray *categories = [[IRCoreDataController sharedInstance]fetchCategoriesForExpense:isExpense];
    for (IRCategory *categoryModal in categories) {
        if ([categoryModal.categoryName isEqualToString:category]) {
            return categoryModal.colorCode;
        }
    }
    return 0;
}

+ (BOOL)isCategoryAddedinDB:(IRCategory *)category forExpense:(BOOL)isExpense addToDB:(BOOL)toAdd
{
    NSArray *categories = [[IRCoreDataController sharedInstance]fetchCategoriesForExpense:isExpense];
    for (IRCategory *categoryModal in categories) {
        if ([categoryModal.categoryName isEqualToString:category.categoryName] && categoryModal.isExpense == category.isExpense) {
            return toAdd ? YES:((categoryModal.colorCode == category.colorCode) ? YES : NO);
        }
    }
    return NO;
}

+ (NSString *)getCurrencySymbolFromCode:(NSString *)code
{
    NSLocale *locale = [[NSLocale alloc] initWithLocaleIdentifier:code];
    return [NSString stringWithFormat:@"%@",[locale displayNameForKey:NSLocaleCurrencySymbol value:code]];
}

+ (BOOL)isToday:(NSDate *)date
{
    NSDate *startDate = [self getDateOnlyFromDate:date];
    NSDate *endDate = [self getDateOnlyFromDate:[NSDate date]];
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSUInteger unitFlags = NSMonthCalendarUnit | NSDayCalendarUnit;
    NSDateComponents *components = [gregorian components:unitFlags
                                                fromDate:startDate
                                                  toDate:endDate options:0];
    return ([components day] == 0 && [components month] == 0) ? YES : NO;
}

+ (BOOL)isYesterday:(NSDate *)date
{
    NSDate *startDate = [self getDateOnlyFromDate:date];
    NSDate *endDate = [self getDateOnlyFromDate:[NSDate date]];
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSUInteger unitFlags = NSMonthCalendarUnit | NSDayCalendarUnit;
    NSDateComponents *components = [gregorian components:unitFlags
                                                fromDate:startDate
                                                  toDate:endDate options:0];
    return ([components day] == 1 && [components month] == 0) ? YES : NO;
}

+ (BOOL)isTomorrow:(NSDate *)date
{
    NSDate *startDate = [self getDateOnlyFromDate:date];
    NSDate *endDate = [self getDateOnlyFromDate:[NSDate date]];
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSUInteger unitFlags = NSMonthCalendarUnit | NSDayCalendarUnit;
    NSDateComponents *components = [gregorian components:unitFlags
                                                fromDate:startDate
                                                  toDate:endDate options:0];
    return ([components day] == -1 && [components month] == 0) ? YES : NO;
}

+ (NSDate *)getDateOnlyFromDate:(NSDate *)date
{
    unsigned int flags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit;
    NSCalendar* calendar = [NSCalendar currentCalendar];
    NSDateComponents* components = [calendar components:flags fromDate:date];
    return [calendar dateFromComponents:components];
}

+ (NSString *)getDateStringFromDate:(NSDate *)date
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"dd/MM/YY"];
    NSString *dateString = [dateFormatter stringFromDate:date];
    return dateString;
}

+ (NSString *)getWeekDayFromDate:(NSDate *)date
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"EE"];
    NSString *dayString = [[dateFormatter stringFromDate:date] capitalizedString];
    return dayString;
}

+ (UIColor *)getThemeColor
{
    if ([[NSUserDefaults standardUserDefaults]objectForKey:@"color"]) {
        int colorCode = [[[NSUserDefaults standardUserDefaults]objectForKey:@"color"]intValue];
        return [self getColorForColorCode:colorCode];
    }
    return THEME_COLOR;
}

+ (BOOL)isThemeApplicableForCategoryIcons;
{
    if ([[[NSUserDefaults standardUserDefaults]objectForKey:@"applyThemeForIcons"]boolValue]) {
        return YES;
    }
    return NO;
}

+ (NSString *)getCurrentAppVersion
{
    return [[[NSBundle mainBundle] infoDictionary] valueForKey:@"CFBundleShortVersionString"];
}

+(NSString *)getDeviceName
{
    return [[UIDevice currentDevice] name];
}

+ (NSString *)getiOSVersion
{
    return [[UIDevice currentDevice] systemVersion];
}

+ (Grouping)getGroupingName
{
    if ([[NSUserDefaults standardUserDefaults]objectForKey:@"grouping"]) {
        switch ([[[NSUserDefaults standardUserDefaults]objectForKey:@"grouping"]intValue]) {
            case 0:
                return WeeklyGrouping;
                break;
            case 1:
                return MonthlyGrouping;
                break;
            case 2:
                return YearlyGrouping;
                break;
            default:
                return MonthlyGrouping;
                break;
        }
    }
    return MonthlyGrouping;
}

+ (float)getTotalProfitForArray:(NSArray *)expenseArray
{
    double totalExpense = 0;
    for (IRExpense *expense in expenseArray) {
        totalExpense = (expense.isExpense) ? (totalExpense - expense.amount) : (totalExpense + expense.amount);
    }
    return totalExpense;
}

+ (NSString *)getDayNameFromDate:(NSDate *)date
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"EEE"];
    return [dateFormatter stringFromDate:date];
}

+ (NSString *)getDate:(NSDate *)date inFormat:(NSString *)format
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:format];
    return [dateFormatter stringFromDate:date];
}

+ (int)getIndexForCategory:(NSString *)category isExpense:(BOOL)isExpense
{
    NSArray *categoryList = [[IRCoreDataController sharedInstance]fetchCategoriesForExpense:isExpense];
    for (int i = 0; i < [categoryList count] ; i++) {
        IRCategory *categoryModel = [categoryList objectAtIndex:i];
        if ([categoryModel.categoryName isEqualToString:category]) {
            return i;
        }
    }
    return -1;
}

+ (void)saveCategoriesToDB
{
    if (![[[IRCoreDataController sharedInstance]fetchCategoriesForExpense:YES]count]) {
        NSArray *categories = [NSArray arrayWithContentsOfFile:[[NSBundle mainBundle]pathForResource:@"ExpenseCategory" ofType:@"plist"]];
        for (NSDictionary *categoryDict in categories) {
            IRCategory *category = [[IRCategory alloc]init];
            category.categoryName = [categoryDict objectForKey:@"category"];
            category.colorCode = [[categoryDict objectForKey:@"color"]intValue];
            category.isExpense = YES;
            category.categoryID = [[categoryDict objectForKey:@"categoryID"]intValue];
            [[IRCoreDataController sharedInstance]addCategory:category];
        }
    }
    if (![[[IRCoreDataController sharedInstance]fetchCategoriesForExpense:NO]count]) {
        NSArray *categories = [NSArray arrayWithContentsOfFile:[[NSBundle mainBundle]pathForResource:@"IncomeCategory" ofType:@"plist"]];
        for (NSDictionary *categoryDict in categories) {
            IRCategory *category = [[IRCategory alloc]init];
            category.categoryName = [categoryDict objectForKey:@"category"];
            category.colorCode = [[categoryDict objectForKey:@"color"]intValue];
            category.isExpense = NO;
            category.categoryID = [[categoryDict objectForKey:@"categoryID"]intValue];
            [[IRCoreDataController sharedInstance]addCategory:category];
        }
    }
}

+ (UIFont *)getDefaultFontForSize:(float)size isBold:(BOOL)isBold
{
    return [UIFont fontWithName:[NSString stringWithFormat:@"%@%@",DEFAULT_FONT_NAME,isBold ? @"-Bold":@""] size:size];
}

+ (UIColor *)lighterColorForColor:(UIColor *)c
{
    CGFloat r, g, b, a;
    if ([c getRed:&r green:&g blue:&b alpha:&a])
        return [UIColor colorWithRed:MIN(r + 0.2, 1.0)
                               green:MIN(g + 0.2, 1.0)
                                blue:MIN(b + 0.2, 1.0)
                               alpha:a];
    return nil;
}

+ (UIColor *)darkerColorForColor:(UIColor *)c
{
    CGFloat r, g, b, a;
    if ([c getRed:&r green:&g blue:&b alpha:&a])
        return [UIColor colorWithRed:MAX(r - 0.2, 0.0)
                               green:MAX(g - 0.2, 0.0)
                                blue:MAX(b - 0.2, 0.0)
                               alpha:a];
    return nil;
}

+ (NSString *)localizeText:(NSString *)textToLocalize
{
    NSNumber *languageCode = [[NSUserDefaults standardUserDefaults]objectForKey:@"languageCode"];
    if (languageCode.intValue == 0) {
        return NSLocalizedString(textToLocalize, nil);
    }
    return textToLocalize;
}

+ (void)updateSocialPoints
{
    int socialPoints = [[[NSUserDefaults standardUserDefaults]objectForKey:@"socialPoints"]intValue];
    socialPoints += 25;
    [[NSUserDefaults standardUserDefaults]setObject:[NSNumber numberWithInt:socialPoints] forKey:@"socialPoints"];
    [self shareScore];
    [self updateAchievements];

}

+ (void)updateAdPoints
{
    int adClicks = [[[NSUserDefaults standardUserDefaults]objectForKey:@"adClickPoints"]intValue];
    adClicks += 30;
    [[NSUserDefaults standardUserDefaults]setObject:[NSNumber numberWithInt:adClicks] forKey:@"adClickPoints"];
    [self shareScore];
    [self updateAchievements];

}

+ (void)updateAppUsagePointsWithValue:(int)val
{
    int appUsagePoints = [[[NSUserDefaults standardUserDefaults]objectForKey:@"appUsagePoints"]intValue];
    appUsagePoints += val;
    [[NSUserDefaults standardUserDefaults]setObject:[NSNumber numberWithInt:appUsagePoints] forKey:@"appUsagePoints"];
    [self shareScore];
    [self updateAchievements];

}

+ (int)calculateAggregatePoints
{
    int socialPoints = [[[NSUserDefaults standardUserDefaults]objectForKey:@"socialPoints"]intValue];
    int adClicks = [[[NSUserDefaults standardUserDefaults]objectForKey:@"adClickPoints"]intValue];
    int appUsagePoints = [[[NSUserDefaults standardUserDefaults]objectForKey:@"appUsagePoints"]intValue];
    return socialPoints + adClicks + appUsagePoints;
}


+ (void)shareScore
{
    if ([[[NSUserDefaults standardUserDefaults]objectForKey:@"shareScore"]boolValue]) {
        // Create a GKScore object to assign the score and report it as a NSArray object.
        
        GKScore *score = [[GKScore alloc] initWithLeaderboardIdentifier:@"MyScore"];
        score.value = [self calculateAggregatePoints];
        
        [GKScore reportScores:@[score] withCompletionHandler:^(NSError *error) {
            if (error != nil) {
                NSLog(@"%@", [error localizedDescription]);
            }
        }];
    }
}

+ (void)updateAchievements{
    int currentScore = [self calculateAggregatePoints];
    // Each achievement identifier will be assigned to this string.
    NSString *achievementIdentifier;
    // The calculated progress percentage will be assigned to the next variable.
    float progressPercentage = 0.0;
    
    // This flag will indicate if any progress regarding the level should be reported to achievements.
    //    BOOL progressInLevelAchievement = NO;
    
    // Declare a couple of GKAchievement objects to use in this method.
    //    GKAchievement *levelAchievement = nil;
    GKAchievement *scoreAchievement = nil;
    
    // When the currentAdditionCounter equals to 0, then a new level has been started so the progress
    // should be reported.
    //    if (_currentAdditionCounter == 0) {
    //        if (_level <= 3) {
    //            progressPercentage = _level * 100 / 3;
    //            achievementIdentifier = @"Achievement_Level3";
    //            progressInLevelAchievement = YES;
    //        }
    //        else if (_level < 6){
    //            progressPercentage = _level * 100 / 5;
    //            achievementIdentifier = @"Achievement_Level5Complete";
    //            progressInLevelAchievement = YES;
    //        }
    //    }
    //
    //    // When the next flag is YES then initiate the levelAchievement object to report the level-related progress.
    //    if (progressInLevelAchievement) {
    //        levelAchievement = [[GKAchievement alloc] initWithIdentifier:achievementIdentifier];
    //        levelAchievement.percentComplete = progressPercentage;
    //    }
    
    
    // Calculate the progress percentage and set the identifier for each achievement regarding the score.
    if (currentScore >= 1000000) {
        //        progressPercentage = _score * 100 / 50;
        achievementIdentifier = @"Level11";
        progressPercentage = 100;
    } else if (currentScore >= 500000) {
        //        progressPercentage = _score * 100 / 50;
        achievementIdentifier = @"Level10";
        progressPercentage = 100;
    } else if (currentScore >= 100000) {
        //        progressPercentage = _score * 100 / 50;
        achievementIdentifier = @"Level9";
        progressPercentage = 100;
    } else if (currentScore >= 50000) {
        //        progressPercentage = _score * 100 / 50;
        achievementIdentifier = @"Level8";
        progressPercentage = 100;
    } else if (currentScore >= 25000) {
        //        progressPercentage = _score * 100 / 50;
        achievementIdentifier = @"Level7";
        progressPercentage = 100;
    } else if (currentScore >= 15000) {
        //        progressPercentage = _score * 100 / 50;
        achievementIdentifier = @"Level6";
        progressPercentage = 100;
    } else if (currentScore >= 10000) {
        //        progressPercentage = _score * 100 / 50;
        achievementIdentifier = @"Level5";
        progressPercentage = 100;
    } else if (currentScore >= 5000) {
        //        progressPercentage = _score * 100 / 50;
        achievementIdentifier = @"Level4";
        progressPercentage = 100;
    } else if (currentScore >= 2500) {
        //        progressPercentage = _score * 100 / 50;
        achievementIdentifier = @"Level3";
        progressPercentage = 100;
    } else if (currentScore >= 1000) {
        //        progressPercentage = _score * 100 / 50;
        achievementIdentifier = @"Level2";
        progressPercentage = 100;
    } else if (currentScore >= 500) {
        //        progressPercentage = _score * 100 / 50;
        achievementIdentifier = @"Level1";
        progressPercentage = 100;
    } else{
        //        progressPercentage = _score * 100 / 180;
        achievementIdentifier = @"Level1";
        progressPercentage = (currentScore/500);
    }
    
    // Initialize the scoreAchievement object and assign the progress.
    scoreAchievement = [[GKAchievement alloc] initWithIdentifier:achievementIdentifier];
    scoreAchievement.percentComplete = progressPercentage;
    
    // Depending on the progressInLevelAchievement flag value create a NSArray containing either both
    // or just the scores achievement.
    NSArray *achievements =  @[scoreAchievement];
    
    // Report the achievements.
    [GKAchievement reportAchievements:achievements withCompletionHandler:^(NSError *error) {
        if (error != nil) {
            NSLog(@"%@", [error localizedDescription]);
        }
    }];
}

+ (void)resetAchievements
{
    // Just call the next method to reset the achievements.
    [GKAchievement resetAchievementsWithCompletionHandler:^(NSError *error) {
        if (error != nil) {
            NSLog(@"%@", [error localizedDescription]);
        }
    }];
}

+ (int)getCategoryIDToSave:(BOOL)isExpense
{
    NSArray *categories = [[IRCoreDataController sharedInstance]fetchCategoriesForExpense:isExpense];
    
    return (int)[categories count] + 1;
}

+ (int)getIndexOfOtherCategory:(BOOL)isExpense
{
    NSArray *categories = [[IRCoreDataController sharedInstance]fetchCategoriesForExpense:isExpense];

    for (IRCategory *category in categories) {
        if ([category.categoryName isEqualToString:@"Others"]) {
            return category.categoryID - 1;
        }
    }
    
    return -1;
}

+ (BOOL)isFullVersion
{
    BOOL isFullVersion = [[[NSUserDefaults standardUserDefaults]objectForKey:@"isFullVersion"]boolValue];
    return isFullVersion;
}

+ (BOOL)isNetworkAvailable
{
    Reachability *reachability = [Reachability reachabilityForInternetConnection];
    NetworkStatus internetStatus = [reachability currentReachabilityStatus];
    if (internetStatus != NotReachable) {
        return YES;
        //my web-dependent code
    }
    else {
        return NO;
    }
}

+ (NSArray *)getArrayFromPlist:(NSString *)plistName
{
    NSArray *plistArray = [NSArray arrayWithContentsOfFile:[[NSBundle mainBundle]pathForResource:plistName ofType:@"plist"]];
    return plistArray;
}

@end
