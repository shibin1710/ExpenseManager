//
//  IROverviewTableViewCell.m
//  ExpenseManager
//
//  Created by Shibin S on 06/09/14.
//  Copyright (c) 2014 Shibin. All rights reserved.
//

#import "IROverviewTableViewCell.h"
#import "SBStackedBarChart.h"

@interface IROverviewTableViewCell ()

@property (strong, nonatomic) SBBarChart *barChart;

@end

@implementation IROverviewTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)awakeFromNib
{
    
}

- (void)createStackedBarChart
{
    [self.barChart removeFromSuperview];
    self.barChart = [[SBBarChart alloc] initWithFrame:CGRectMake(20, 30, 280, 10)];
    [self.barChart setHorizontal:YES];
    [self addSubview:self.barChart];
    NSMutableArray *segments = [[NSMutableArray alloc] initWithCapacity:2];
    for (int i = 0; i <= 1; i++) {
        SBBarSegment *segment;
        switch (i) {
            case 0:
                segment = [SBBarSegment barComponentWithValue:self.expense];
                segment.color = self.color;
                break;
            case 1:
                segment = [SBBarSegment barComponentWithValue:100 - self.expense];
                segment.color = [UIColor clearColor];
                break;
            default:
                break;
        }
        [segments addObject:segment];
    }
    [self.barChart setSegments:segments];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
}

@end
