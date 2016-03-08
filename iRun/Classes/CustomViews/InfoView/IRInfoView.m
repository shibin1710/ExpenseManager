//
//  IRInfoView.m
//  iRun
//
//  Created by Shibin S on 30/08/14.
//  Copyright (c) 2014 Shibin. All rights reserved.
//

#import "IRInfoView.h"
#import <QuartzCore/QuartzCore.h>
#import "IRConstants.h"

@implementation IRInfoView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)drawRect:(CGRect)rect
{
    self.infoBaseView.layer.cornerRadius = 12.0f;
}

- (id)init
{
    NSArray *subviewArray = [[NSBundle mainBundle] loadNibNamed:@"IRInfoView" owner:self options:nil];
    id mainView = [subviewArray objectAtIndex:0];
    return mainView;
}
- (IBAction)didTouchUpInsideCloseButton:(id)sender {
    [UIView animateWithDuration:INFO_VIEW_ANIMATION_DURATION animations:^{
        self.infoBaseView.alpha = 0;
        self.infoBaseView.backgroundColor = [UIColor clearColor];
        [self.closeButton setTitleColor:[UIColor clearColor] forState:UIControlStateNormal];
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
