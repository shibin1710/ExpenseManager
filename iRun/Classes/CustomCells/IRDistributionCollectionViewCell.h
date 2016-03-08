//
//  IRDistributionCollectionViewCell.h
//  ExpenseMobile
//
//  Created by Shibin S on 20/12/14.
//  Copyright (c) 2014 Shibin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XYPieChart.h"

@interface IRDistributionCollectionViewCell : UICollectionViewCell<XYPieChartDataSource,XYPieChartDelegate>

@property (weak, nonatomic) IBOutlet XYPieChart *pieChart;
@property (weak, nonatomic) IBOutlet UILabel *typeLabel;

- (void)configureCell;

@end
