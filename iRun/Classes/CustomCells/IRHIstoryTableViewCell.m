//
//  IRHIstoryTableViewCell.m
//  ExpenseManager
//
//  Created by Shibin S on 15/09/14.
//  Copyright (c) 2014 Shibin. All rights reserved.
//

#import "IRHIstoryTableViewCell.h"

@implementation IRHIstoryTableViewCell

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
