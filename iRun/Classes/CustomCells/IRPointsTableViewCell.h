//
//  IRPointsTableViewCell.h
//  ExpenseMobile
//
//  Created by Shibin S on 14/01/15.
//  Copyright (c) 2015 Shibin. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol PointTableDelegate <NSObject>

- (void)switchTapped:(id)sender;

@end

@interface IRPointsTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *pointsLabel;
@property (weak, nonatomic) IBOutlet UISwitch *shareSwitch;
@property (assign, nonatomic) id<PointTableDelegate> delegate;

@end
