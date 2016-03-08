//
//  GSFAQQuestionCell.m
//  GoSafe
//
//  Created by Shibin S on 19/03/14.
//  Copyright (c) 2014 Tata Consultancy Services. All rights reserved.
//

#import "IRFAQQuestionCell.h"
#import "IRCommon.h"

@implementation IRFAQQuestionCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    self.question.font = [IRCommon getDefaultFontForSize:13 isBold:NO];


    // Configure the view for the selected state
}

@end
