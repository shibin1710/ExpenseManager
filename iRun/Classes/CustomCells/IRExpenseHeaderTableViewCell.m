//
//  IRExpenseHeaderTableViewCell.m
//  ExpenseManager
//
//  Created by Shibin S on 08/09/14.
//  Copyright (c) 2014 Shibin. All rights reserved.
//

#import "IRExpenseHeaderTableViewCell.h"

@implementation IRExpenseHeaderTableViewCell

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

@end
