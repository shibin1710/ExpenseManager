//
//  IRDistributionCollectionViewCell.m
//  ExpenseMobile
//
//  Created by Shibin S on 20/12/14.
//  Copyright (c) 2014 Shibin. All rights reserved.
//

#import "IRDistributionCollectionViewCell.h"
#import "IRCommon.h"
#import "IRCoreDataController.h"

@interface IRDistributionCollectionViewCell ()
{
    double totalExpense, totalIncome;
}

@property (strong, nonatomic) NSArray *dataArray;
@property (strong, nonatomic) NSArray *expenseForCurrentMonth;
@property (strong, nonatomic) NSArray *incomeForCurrentMonth;


@end

@implementation IRDistributionCollectionViewCell

- (void)configureCell
{

    self.expenseForCurrentMonth = [[IRCoreDataController sharedInstance]fetchExpenseForCurrentMonth:YES];
    self.incomeForCurrentMonth = [[IRCoreDataController sharedInstance]fetchExpenseForCurrentMonth:NO];
    totalExpense = [IRCommon getTotalExpenseForCurrentMonth:self.expenseForCurrentMonth];
    totalIncome =  [IRCommon getTotalExpenseForCurrentMonth:self.incomeForCurrentMonth];
    self.dataArray = (self.tag == 100001) ? [IRCommon filterExpenseByCategory:self.expenseForCurrentMonth] : [IRCommon filterExpenseByCategory:self.incomeForCurrentMonth] ;
    [self.pieChart setDataSource:self];
    [self.pieChart setStartPieAngle:M_PI_2];
    [self.pieChart setAnimationSpeed:1.0];
//    [self.pieChart setLabelFont:(self.tag == 100000) ? [IRCommon getDefaultFontForSize:15 isBold:YES] :[IRCommon getDefaultFontForSize:11 isBold:YES]];
    [self.pieChart setLabelFont:[IRCommon getDefaultFontForSize:11 isBold:YES]];
//    [self.pieChart setLabelRadius:(self.tag == 100000) ? 120 : 90];
    [self.pieChart setLabelRadius:70];
    [self.pieChart setShowPercentage:NO];
    [self.pieChart setPieBackgroundColor:[UIColor colorWithWhite:0.95 alpha:1]];
    [self.pieChart setUserInteractionEnabled:NO];
    [self.pieChart setLabelShadowColor:[UIColor blackColor]];
    [self.pieChart reloadData];
//    [self.pieChart setDelegate:self];
//    [self.pieChart setDataSource:self];
//    [self.pieChart setPieCenter:CGPointMake(240, 240)];
//    [self.pieChart setShowPercentage:NO];
//    [self.pieChart setLabelColor:[UIColor blackColor]];
    
//    [self.percentageLabel.layer setCornerRadius:90];
//    
//    self.sliceColors =[NSArray arrayWithObjects:
//                       [UIColor colorWithRed:246/255.0 green:155/255.0 blue:0/255.0 alpha:1],
//                       [UIColor colorWithRed:129/255.0 green:195/255.0 blue:29/255.0 alpha:1],
//                       [UIColor colorWithRed:62/255.0 green:173/255.0 blue:219/255.0 alpha:1],
//                       [UIColor colorWithRed:229/255.0 green:66/255.0 blue:115/255.0 alpha:1],
//                       [UIColor colorWithRed:148/255.0 green:141/255.0 blue:139/255.0 alpha:1],nil];
//    
//    //rotate up arrow
//    self.downArrow.transform = CGAffineTransformMakeRotation(M_PI);
}

- (NSUInteger)numberOfSlicesInPieChart:(XYPieChart *)pieChart
{
    if (self.tag == 100000) {
        return 2;
    } else {
        return self.dataArray.count;

    }
}

- (CGFloat)pieChart:(XYPieChart *)pieChart valueForSliceAtIndex:(NSUInteger)index
{
    if (self.tag == 100000) {

        switch (index) {
            case 0:
                return totalExpense;
                break;
            case 1:
                return totalIncome;
                break;
            default:
                return 100;
                break;
        }
    } else {
        double expense = [[[self.dataArray objectAtIndex:index]objectForKey:@"totalExpense"]doubleValue];
        return expense;
    }
    
}

- (UIColor *)pieChart:(XYPieChart *)pieChart colorForSliceAtIndex:(NSUInteger)index
{
    if (self.tag == 100000) {
        switch (index) {
            case 0:
                return [UIColor redColor];
                break;
            case 1:
                return [UIColor colorWithRed:0.0/255.0 green:200.0/255.0 blue:0.0/255.0 alpha:1.0];
                break;
            default:
                return [UIColor greenColor];
                break;
        }
        
    } else {
        NSString *category = [[self.dataArray objectAtIndex:index]objectForKey:@"category"];
        int colorCode = [IRCommon getColorCodeForCategory:category andIsExpense:self.tag == 100001 ? YES : NO];
        return [IRCommon getColorForColorCode:colorCode];
    }
   
}

- (NSString *)pieChart:(XYPieChart *)pieChart textForSliceAtIndex:(NSUInteger)index
{
    if (self.tag == 100000) {
        switch (index) {
            case 0:
                return [NSString stringWithFormat:@"Expense : %@ %i",[IRCommon getCurrencySymbolFromCode:[[NSUserDefaults standardUserDefaults]objectForKey:@"currency"]],(int)totalExpense];
                break;
            case 1:
                return [NSString stringWithFormat:@"Income : %@ %i",[IRCommon getCurrencySymbolFromCode:[[NSUserDefaults standardUserDefaults]objectForKey:@"currency"]],(int)totalIncome];
                break;
            default:
                return @"Expense";
                break;
        }
    } else {
        return [[self.dataArray objectAtIndex:index]objectForKey:@"category"];

    }
}

@end
