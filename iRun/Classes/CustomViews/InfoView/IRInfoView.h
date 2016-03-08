//
//  IRInfoView.h
//  iRun
//
//  Created by Shibin S on 30/08/14.
//  Copyright (c) 2014 Shibin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface IRInfoView : UIView

@property (weak, nonatomic) IBOutlet UIButton *closeButton;
@property (weak, nonatomic) IBOutlet UIView *infoBaseView;
@property (weak, nonatomic) IBOutlet UITextView *infoTextView;

@end
