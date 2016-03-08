//
//  IRBuyPremiumViewController.m
//  ExpenseMobile
//
//  Created by Shibin S on 05/06/15.
//  Copyright (c) 2015 Shibin. All rights reserved.
//

#import "IRBuyPremiumViewController.h"
#import "SWRevealViewController.h"
#import "IRCommon.h"

@interface IRBuyPremiumViewController () {
    SKProductsRequest *productsRequest;
}

@property (weak, nonatomic) IBOutlet UIButton *menuButton;
@property (weak, nonatomic) IBOutlet UILabel *label1;
@property (weak, nonatomic) IBOutlet UILabel *label2;
@property (weak, nonatomic) IBOutlet UILabel *label3;
@property (weak, nonatomic) IBOutlet UILabel *label4;
@property (weak, nonatomic) IBOutlet UILabel *label5;
@property (weak, nonatomic) IBOutlet UIButton *upgradeButton;
@property (weak, nonatomic) IBOutlet UILabel *orLabel;
@property (weak, nonatomic) IBOutlet UIButton *restorePurchaseButton;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *upgradeActivityIndicator;

@end

@implementation IRBuyPremiumViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [_menuButton addTarget:self.revealViewController action:@selector(revealToggle:) forControlEvents:UIControlEventTouchUpInside];
    // Set the gesture
    [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
    [self.view addGestureRecognizer:self.revealViewController.tapGestureRecognizer];
    self.navigationItem.title = [IRCommon localizeText:@"Upgrade"];
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName: [UIColor whiteColor],NSFontAttributeName:[IRCommon getDefaultFontForSize:17.0 isBold:YES]};
    self.label1.textColor = self.label2.textColor = self.label3.textColor = self.label4.textColor = self.label5.textColor = self.orLabel.textColor = [UIColor darkGrayColor];
    self.label1.font = [IRCommon getDefaultFontForSize:14 isBold:NO];
    self.label1.text = [IRCommon localizeText:@"Get full version to unlock many features."];
    self.label2.text = [IRCommon localizeText:@"• Remove all adverts."];
    self.label3.text = [IRCommon localizeText:@"• New themes."];
    self.label4.text = [IRCommon localizeText:@"• And many more future updates."];
    self.label5.text = [IRCommon localizeText:@""];
//    self.label4.text = [IRCommon localizeText:@"• iCloud sync."];
//    self.label5.text = [IRCommon localizeText:@"• Get information using widgets."];
    [self.upgradeButton setTitle:[IRCommon localizeText:@"Upgrade"] forState:UIControlStateNormal];
    [self.restorePurchaseButton setTitle:[IRCommon localizeText:@"Restore Purchase"] forState:UIControlStateNormal];

    self.label2.font = [IRCommon getDefaultFontForSize:14 isBold:NO];
    self.label3.font = [IRCommon getDefaultFontForSize:14 isBold:NO];
    self.label4.font = [IRCommon getDefaultFontForSize:14 isBold:NO];
    self.label5.font = [IRCommon getDefaultFontForSize:14 isBold:NO];
    self.orLabel.font = [IRCommon getDefaultFontForSize:14 isBold:NO];
    self.restorePurchaseButton.titleLabel.font = [IRCommon getDefaultFontForSize:17 isBold:NO];
    self.upgradeButton.titleLabel.font = [IRCommon getDefaultFontForSize:17 isBold:NO];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)upgradeButtonClicked {
    if ([IRCommon isNetworkAvailable]) {
        self.upgradeActivityIndicator.color = [IRCommon getThemeColor];
        self.upgradeButton.userInteractionEnabled = NO;
        self.restorePurchaseButton.userInteractionEnabled = NO;
        [self.upgradeActivityIndicator startAnimating];
        [self removeAds];
    } else {
        [IRCommon showAlertWithTitle:APPLICATION_NAME message:[IRCommon localizeText:@"Sorry, no network connection available. Please try again later." ] dismissButtonText:@"OK"];
    }
    
}
- (IBAction)restorePurchaseButtonClicked {
    if ([IRCommon isNetworkAvailable]) {
        self.upgradeActivityIndicator.color = [IRCommon getThemeColor];
        [self.upgradeActivityIndicator startAnimating];
        self.upgradeButton.userInteractionEnabled = NO;
        self.restorePurchaseButton.userInteractionEnabled = NO;
        [self restorePurchase];
    } else {
        [IRCommon showAlertWithTitle:APPLICATION_NAME message:[IRCommon localizeText:@"Sorry, no network connection available. Please try again later."] dismissButtonText:@"OK"];
    }
   
}

- (void)removeAds
{
    if([SKPaymentQueue canMakePayments]){
        productsRequest = [[SKProductsRequest alloc] initWithProductIdentifiers:[NSSet setWithObject:@"ExpenseMobile.removeAds"]];
        productsRequest.delegate = self;
        [productsRequest start];
        
    }
    else{
        self.upgradeButton.userInteractionEnabled = YES;
        self.restorePurchaseButton.userInteractionEnabled = YES;
        [self.upgradeActivityIndicator stopAnimating];
        NSLog(@"User cannot make payments due to parental controls");
        UIAlertView *errorAlert = [[UIAlertView alloc]initWithTitle:APPLICATION_NAME message:[IRCommon localizeText:@"Sorry, Unable to make payments."] delegate:self cancelButtonTitle:OK_TEXT otherButtonTitles: nil];
        [errorAlert show];
    }
}

- (void)productsRequest:(SKProductsRequest *)request didReceiveResponse:(SKProductsResponse *)response{
    SKProduct *validProduct = nil;
    int count = (int)[response.products count];
    if(count > 0){
        validProduct = [response.products objectAtIndex:0];
        NSLog(@"Products Available!");
        [self purchase:validProduct];
    }
    else if(!validProduct){
        NSLog(@"No products available");
        self.upgradeButton.userInteractionEnabled = YES;
        self.restorePurchaseButton.userInteractionEnabled = YES;
        [self.upgradeActivityIndicator stopAnimating];
        UIAlertView *errorAlert = [[UIAlertView alloc]initWithTitle:APPLICATION_NAME message:[IRCommon localizeText:@"Sorry, Unable to purchase now. Please try later."] delegate:self cancelButtonTitle:OK_TEXT otherButtonTitles: nil];
        [errorAlert show];
        //this is called if your product id is not valid, this shouldn't be called unless that happens.
    }
}

- (void)purchase:(SKProduct *)product
{
    SKPayment *payment = [SKPayment paymentWithProduct:product];
    [[SKPaymentQueue defaultQueue] addTransactionObserver:self];
    [[SKPaymentQueue defaultQueue] addPayment:payment];
}

- (void)restorePurchase
{
    [[SKPaymentQueue defaultQueue] addTransactionObserver:self];
    [[SKPaymentQueue defaultQueue] restoreCompletedTransactions];
}

- (void) paymentQueueRestoreCompletedTransactionsFinished:(SKPaymentQueue *)queue
{
    NSLog(@"received restored transactions: %lu", (unsigned long)queue.transactions.count);
    for (SKPaymentTransaction *transaction in queue.transactions)
    {
        if(SKPaymentTransactionStateRestored){
            NSLog(@"Transaction state -> Restored");
            //called when the user successfully restores a purchase
            [self doRemoveAds];
            [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
            UIAlertView *errorAlert = [[UIAlertView alloc]initWithTitle:APPLICATION_NAME message:[IRCommon localizeText:@"Your purchase was restored successfully."] delegate:self cancelButtonTitle:OK_TEXT otherButtonTitles: nil];
            [errorAlert show];
            break;
        }
        
    }
    
}

- (void)paymentQueue:(SKPaymentQueue *)queue restoreCompletedTransactionsFailedWithError:(NSError *)error
{
    self.upgradeButton.userInteractionEnabled = YES;
    self.restorePurchaseButton.userInteractionEnabled = YES;
    [self.upgradeActivityIndicator stopAnimating];
    UIAlertView *errorAlert = [[UIAlertView alloc]initWithTitle:APPLICATION_NAME message:[IRCommon localizeText:@"Sorry, Unable to restore purchase now. Please try later."] delegate:self cancelButtonTitle:OK_TEXT otherButtonTitles: nil];
    [errorAlert show];
}

- (void)paymentQueue:(SKPaymentQueue *)queue updatedTransactions:(NSArray *)transactions{
    UIAlertView *errorAlert = [[UIAlertView alloc]initWithTitle:APPLICATION_NAME message:[IRCommon localizeText:@"Your purchase was successful. Thank you for upgrading."] delegate:self cancelButtonTitle:OK_TEXT otherButtonTitles: nil];
    for(SKPaymentTransaction *transaction in transactions){
        switch (transaction.transactionState){
            case SKPaymentTransactionStatePurchasing: NSLog(@"Transaction state -> Purchasing");
                //called when the user is in the process of purchasing, do not add any of your own code here.
                break;
            case SKPaymentTransactionStatePurchased:
                //this is called when the user has successfully purchased the package (Cha-Ching!)
                
                [errorAlert show];
                [self doRemoveAds]; //you can add your code for what you want to happen when the user buys the purchase here, for this tutorial we use removing ads
                [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
                NSLog(@"Transaction state -> Purchased");
                break;
            case SKPaymentTransactionStateRestored:
                NSLog(@"Transaction state -> Restored");
                //add the same code as you did from SKPaymentTransactionStatePurchased here
                [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
                break;
            case SKPaymentTransactionStateFailed:
                self.upgradeButton.userInteractionEnabled = YES;
                self.restorePurchaseButton.userInteractionEnabled = YES;
                [self.upgradeActivityIndicator stopAnimating];
                //called when the transaction does not finnish
                if(transaction.error.code != SKErrorPaymentCancelled){
                    NSLog(@"Transaction state -> Cancelled");
                    
                    UIAlertView *errorAlert = [[UIAlertView alloc]initWithTitle:APPLICATION_NAME message:[IRCommon localizeText:@"Sorry, Unable to purchase now. Please try later."] delegate:self cancelButtonTitle:OK_TEXT otherButtonTitles: nil];
                    [errorAlert show];
                    //the user cancelled the payment ;(
                }
                [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
                
                break;
            default:
                break;
        }
    }
}

- (void)doRemoveAds
{
    self.upgradeButton.userInteractionEnabled = YES;
    self.restorePurchaseButton.userInteractionEnabled = YES;
    [self.upgradeActivityIndicator stopAnimating];
    
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"isFullVersion"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)dealloc
{
    if (productsRequest) {
        productsRequest.delegate = nil;
        [productsRequest cancel];
    }
}

@end
