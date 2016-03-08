//
//  IRAppsTableViewCell.h
//  ExpenseMobile
//
//  Created by Shibin S on 05/06/15.
//  Copyright (c) 2015 Shibin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface IRAppsTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *appTitle;
@property (weak, nonatomic) IBOutlet UILabel *appCategory;
@property (weak, nonatomic) IBOutlet UIImageView *appImage;

@end
