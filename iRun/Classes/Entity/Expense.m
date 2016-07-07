//
//  Expense.m
//  ExpenseManager
//
//  Created by Shibin S on 13/09/14.
//  Copyright (c) 2014 Shibin. All rights reserved.
//

#import "Expense.h"
#import "CategoryGroup.h"
#import "IRCommon.h"

@interface Expense ()

@property (nonatomic) NSDate *primitiveTimeStamp;
@property (nonatomic) NSString *primitiveSectionIdentifier;

@end


@implementation Expense

@dynamic amount;
@dynamic category;
@dynamic currency;
@dynamic date;
@dynamic expenseId;
@dynamic image;
@dynamic isExpense;
@dynamic isRecurring;
@dynamic note;
@dynamic recurringDuration;
@dynamic sectionIdentifier;
@dynamic categoryRelationship;
@dynamic primitiveSectionIdentifier;
@synthesize primitiveTimeStamp;
@dynamic timeStamp;
@dynamic misc;

#pragma mark - Transient properties

- (NSString *)sectionIdentifier
{
    // Create and cache the section identifier on demand.
    
    [self willAccessValueForKey:@"sectionIdentifier"];
    NSString *tmp = [self primitiveSectionIdentifier];
    [self didAccessValueForKey:@"sectionIdentifier"];
    
    if (!tmp)
    {
        /*
         Sections are organized by month and year. Create the section identifier as a string representing the number (year * 1000) + month; this way they will be correctly ordered chronologically regardless of the actual name of the month.
         */
        NSCalendar *calendar = [NSCalendar currentCalendar];
        NSDateComponents *components = [calendar components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitWeekOfYear | NSCalendarUnitDay) fromDate:[self date]];
        switch ([IRCommon getGroupingName]) {
            case WeeklyGrouping:
                tmp = [NSString stringWithFormat:@"%ld", ([components year] * 100000) + [components month]*100 + [components weekOfYear]];
                break;
            case MonthlyGrouping:
                tmp = [NSString stringWithFormat:@"%ld", ([components year] * 1000) + [components month]];
                break;
            case YearlyGrouping:
                tmp = [NSString stringWithFormat:@"%ld", [components year]];
                break;
            default:
                break;
        }
        [self setPrimitiveSectionIdentifier:tmp];
    }
    return tmp;
}


#pragma mark - Time stamp setter

- (void)setTimeStamp:(NSDate *)newDate
{
    // If the time stamp changes, the section identifier become invalid.
    [self willChangeValueForKey:@"date"];
    [self setPrimitiveTimeStamp:newDate];
    [self didChangeValueForKey:@"date"];
    [self setPrimitiveSectionIdentifier:nil];
}


#pragma mark - Key path dependencies

+ (NSSet *)keyPathsForValuesAffectingSectionIdentifier
{
    // If the value of timeStamp changes, the section identifier may change as well.
    return [NSSet setWithObject:@"date"];
}

@end
