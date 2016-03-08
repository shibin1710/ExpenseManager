//
//  IRHomeCollectionCell.h
//  ExpenseManager
//
//  Created by Shibin S on 17/09/14.
//  Copyright (c) 2014 Shibin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface IRHomeCollectionCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *amount;

@end
