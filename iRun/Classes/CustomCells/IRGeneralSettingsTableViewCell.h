//
//  IRGeneralSettingsTableViewCell.h
//  ExpenseManager
//
//  Created by Shibin S on 14/09/14.
//  Copyright (c) 2014 Shibin. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol IRGeneralSettingsDelegate <NSObject>

- (void)reminderSwitchValueChanged:(UISwitch *)reminderSwitch;

@end

@interface IRGeneralSettingsTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UISwitch *reminderSwitch;
@property (assign, nonatomic) id<IRGeneralSettingsDelegate> delegate;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;

@end
