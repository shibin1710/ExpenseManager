//
//  IRAppDelegate.h
//  iRun
//
//  Created by Shibin S on 29/08/14.
//  Copyright (c) 2014 Shibin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PAPasscodeViewController.h"

@interface IRAppDelegate : UIResponder <UIApplicationDelegate,PAPasscodeViewControllerDelegate>

@property (strong, nonatomic) UIWindow *window;

@end
