//
//  IRMenuTableViewCell.m
//  iRun
//
//  Created by Shibin S on 30/08/14.
//  Copyright (c) 2014 Shibin. All rights reserved.
//

#import "IRMenuTableViewCell.h"

@implementation IRMenuTableViewCell

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
