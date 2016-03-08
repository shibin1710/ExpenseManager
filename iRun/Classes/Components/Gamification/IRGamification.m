//
//  IRGamification.m
//  ExpenseManager
//
//  Created by Shibin S on 30/09/14.
//  Copyright (c) 2014 Shibin. All rights reserved.
//

#import "IRGamification.h"
#import "IRCoreDataController.h"
#import "IRCommon.h"

static IRGamification *instance = nil;

@implementation IRGamification

+ (IRGamification *)sharedInstance
{
    if (!instance) {
        instance = [[self alloc]init];
    }
    return instance;
}

- (NSArray *)getArrayOfOverViewText
{
    NSMutableArray *overViewTextArray = [[NSMutableArray alloc]init];
    NSArray *incomeArray = [[IRCoreDataController sharedInstance]fetchExpenseForCurrentMonth:NO];
    NSArray *expenseArray = [[IRCoreDataController sharedInstance]fetchExpenseForCurrentMonth:YES];
    double totalExpenseForMonth = [IRCommon getTotalExpenseForCurrentMonth:expenseArray];
    double totalIncomeForMonth = [IRCommon getTotalExpenseForCurrentMonth:incomeArray];
    double profit = totalIncomeForMonth - totalExpenseForMonth;
    if (totalExpenseForMonth > 0 && totalIncomeForMonth > 0) {
        if (profit > 0) {
            [overViewTextArray addObject:[NSString stringWithFormat:[IRCommon localizeText:@"You saved %@ %0.2f in the month of %@."],[IRCommon getCurrencySymbolFromCode:[[NSUserDefaults standardUserDefaults]objectForKey:@"currency"]],profit,[IRCommon getCurrentMonth]]];
            //[overViewTextArray addObject:[NSString stringWithFormat:@"You spend %@ %0.2f in the month of %@",[IRCommon getCurrencySymbolFromCode:[[NSUserDefaults standardUserDefaults]objectForKey:@"currency"]],totalExpenseForMonth,[IRCommon getCurrentMonth]]];
            //[overViewTextArray addObject:[NSString stringWithFormat:@"You earned %@ %0.2f in the month of %@",[IRCommon getCurrencySymbolFromCode:[[NSUserDefaults standardUserDefaults]objectForKey:@"currency"]],totalIncomeForMonth,[IRCommon getCurrentMonth]]];
        } else {
            [overViewTextArray addObject:[NSString stringWithFormat:[IRCommon localizeText:@"You spend %@ %0.2f extra in the month of %@."],[IRCommon getCurrencySymbolFromCode:[[NSUserDefaults standardUserDefaults]objectForKey:@"currency"]],fabs(profit),[IRCommon getCurrentMonth]]];
            //[overViewTextArray addObject:[NSString stringWithFormat:@"You spend %@ %0.2f in the month of %@",[IRCommon getCurrencySymbolFromCode:[[NSUserDefaults standardUserDefaults]objectForKey:@"currency"]],totalExpenseForMonth,[IRCommon getCurrentMonth]]];
            //[overViewTextArray addObject:[NSString stringWithFormat:@"You earned %@ %0.2f in the month of %@",[IRCommon getCurrencySymbolFromCode:[[NSUserDefaults standardUserDefaults]objectForKey:@"currency"]],totalIncomeForMonth,[IRCommon getCurrentMonth]]];
        }
    } else if (totalIncomeForMonth > 0) {
        //[overViewTextArray addObject:@"It seems you have not added any expense for this month. Tap on + button to add expense."];
        [overViewTextArray addObject:[NSString stringWithFormat:[IRCommon localizeText:@"You earned %@ %0.2f in the month of %@"],[IRCommon getCurrencySymbolFromCode:[[NSUserDefaults standardUserDefaults]objectForKey:@"currency"]],totalIncomeForMonth,[IRCommon getCurrentMonth]]];
    } else if (totalExpenseForMonth > 0) {
        //[overViewTextArray addObject:@"It seems you have not added any income for this month. Tap on + button to add expense."];
        [overViewTextArray addObject:[NSString stringWithFormat:[IRCommon localizeText:@"You spend %@ %0.2f in the month of %@"],[IRCommon getCurrencySymbolFromCode:[[NSUserDefaults standardUserDefaults]objectForKey:@"currency"]],totalExpenseForMonth,[IRCommon getCurrentMonth]]];
    } else {
        [overViewTextArray addObject:[IRCommon localizeText:@"No expense or income is added for this month. Tap on + button to add."]];
    }
    return overViewTextArray;
}

- (NSArray *)getArrayOfOverViewTextForExpenseOnly
{
    
    NSMutableArray *overViewTextArray = [[NSMutableArray alloc]init];
    NSArray *expenseArray = [[IRCoreDataController sharedInstance]fetchExpenseForCurrentMonth:YES];
    double totalExpenseForMonth = [IRCommon getTotalExpenseForCurrentMonth:expenseArray];
    if (totalExpenseForMonth > 0) {
        [overViewTextArray addObject:[NSString stringWithFormat:[IRCommon localizeText:@"You spend %@ %0.2f in the month of %@"],[IRCommon getCurrencySymbolFromCode:[[NSUserDefaults standardUserDefaults]objectForKey:@"currency"]],totalExpenseForMonth,[IRCommon getCurrentMonth]]];
    } else {
        [overViewTextArray addObject:[IRCommon localizeText:@"No expense is added for this month. Tap on + button to add."]];
    }
    return overViewTextArray;

}

@end
