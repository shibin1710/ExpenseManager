//
//  IRGeneralSettingsTableViewCell.m
//  ExpenseManager
//
//  Created by Shibin S on 14/09/14.
//  Copyright (c) 2014 Shibin. All rights reserved.
//

#import "IRGeneralSettingsTableViewCell.h"

@implementation IRGeneralSettingsTableViewCell

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
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (IBAction)didChangeValueOfReminderSwitch:(id)sender
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(reminderSwitchValueChanged:)]) {
        [self.delegate reminderSwitchValueChanged:sender];
    }
}

@end
