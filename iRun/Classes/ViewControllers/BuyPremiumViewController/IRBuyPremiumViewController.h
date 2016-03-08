//
//  IRBuyPremiumViewController.h
//  ExpenseMobile
//
//  Created by Shibin S on 05/06/15.
//  Copyright (c) 2015 Shibin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <StoreKit/StoreKit.h>

@interface IRBuyPremiumViewController : UIViewController<SKProductsRequestDelegate,SKPaymentTransactionObserver>

@end
