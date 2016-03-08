//
//  IRAddCategoryViewController.m
//  ExpenseManager
//
//  Created by Shibin S on 05/09/14.
//  Copyright (c) 2014 Shibin. All rights reserved.
//

#import "IRCategoryViewController.h"
#import "SWRevealViewController.h"
#import "IRCategoryTableViewCell.h"
#import "IRCommon.h"
#import <QuartzCore/QuartzCore.h>
#import "IRCategoryDetailViewController.h"
#import "IRCoreDataController.h"
#import "IRCategory.h"

@interface IRCategoryViewController () {
    NSNumber *trackMode;
    int sourceCellID;
    int destinationCellID;
}

@property (strong, nonatomic) NSMutableArray *expenseCategories;
@property (strong, nonatomic) NSMutableArray *incomeCategories;
@property (weak, nonatomic) IBOutlet UITableView *categoryTableView;
@property (weak, nonatomic) IBOutlet UIView *swipeView;
@property (weak, nonatomic) IBOutlet UISegmentedControl *categorySegment;
@property (weak, nonatomic) IBOutlet UILabel *categoryInfoLabel;
@property (weak, nonatomic) IBOutlet UIButton *menuButton;


@end

@implementation IRCategoryViewController

#pragma mark - View lifecycle

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    if (![IRCommon isFullVersion]) {
        self.interstitialPresentationPolicy = ADInterstitialPresentationPolicyAutomatic;
    }
    [_menuButton addTarget:self.revealViewController action:@selector(revealToggle:) forControlEvents:UIControlEventTouchUpInside];
    // Set the gesture
//    [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
    [self.view addGestureRecognizer:self.revealViewController.tapGestureRecognizer];
    self.expenseCategories = [[NSMutableArray alloc]init];
    self.incomeCategories = [[NSMutableArray alloc]init];
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressGestureRecognized:)];
    [self.categoryTableView addGestureRecognizer:longPress];
    [self.categorySegment setTitle:[IRCommon localizeText:@"Expense"] forSegmentAtIndex:0];
    [self.categorySegment setTitle:[IRCommon localizeText:@"Income"] forSegmentAtIndex:1];
    [IRCommon updateAppUsagePointsWithValue:1];
    trackMode = [[NSUserDefaults standardUserDefaults]objectForKey:@"trackMode"];
    self.categorySegment.hidden = (trackMode.intValue == 0) ? YES : NO;
    self.categoryInfoLabel.hidden = (trackMode.intValue == 0) ? NO : YES;
    self.navigationItem.title = [IRCommon localizeText:@"Category"];
   self.categoryInfoLabel.text = @"Tap on '+' to add new expense category.";
    self.categoryInfoLabel.font = [IRCommon getDefaultFontForSize:15 isBold:NO];
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName: [UIColor whiteColor],NSFontAttributeName:[IRCommon getDefaultFontForSize:17.0 isBold:YES]};
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    self.navigationController.navigationBar.barTintColor = [IRCommon getThemeColor];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleDataModelChange:) name:NSManagedObjectContextObjectsDidChangeNotification object:[[IRCoreDataController sharedInstance]managedObjectContext]];
    self.expenseCategories = (NSMutableArray *)[[IRCoreDataController sharedInstance]fetchCategoriesForExpense:YES];
    self.incomeCategories = (NSMutableArray *)[[IRCoreDataController sharedInstance]fetchCategoriesForExpense:NO];
    self.categorySegment.tintColor = [IRCommon getThemeColor];
    [self.categorySegment setTitleTextAttributes:[NSDictionary dictionaryWithObject:[IRCommon getDefaultFontForSize:14 isBold:NO] forKey:NSFontAttributeName] forState:UIControlStateNormal];
    [IRCommon saveCategoriesToDB];
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [self.categoryTableView setEditing:NO];
    [super viewWillDisappear:animated];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Notification Callback Methods

- (void)handleDataModelChange:(NSNotification *)notification
{
        self.expenseCategories = (NSMutableArray *)[[IRCoreDataController sharedInstance]fetchCategoriesForExpense:YES];
        self.incomeCategories = (NSMutableArray *)[[IRCoreDataController sharedInstance]fetchCategoriesForExpense:NO];
        [self.categoryTableView reloadData];
    
    
}

#pragma mark - UITableView Datasource Methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return (self.categorySegment.selectedSegmentIndex == 0) ? [self.expenseCategories count] : [self.incomeCategories count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    IRCategoryTableViewCell *cell = (IRCategoryTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"AddCategoryCell" forIndexPath:indexPath];
    if (cell == nil) {
        cell = [[IRCategoryTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"AddCategoryCell"];
    }
    IRCategory *category = (self.categorySegment.selectedSegmentIndex == 0) ? [self.expenseCategories objectAtIndex:indexPath.row] : [self.incomeCategories objectAtIndex:indexPath.row];
    NSString *categoryName = category.categoryName;
    
    cell.categoryName.font = [IRCommon getDefaultFontForSize:14.0f isBold:NO];
    cell.categoryName.text = categoryName;
    cell.colorLabel.backgroundColor = [IRCommon isThemeApplicableForCategoryIcons] ? [IRCommon getThemeColor] : [IRCommon getColorForColorCode:category.colorCode];
    cell.colorLabel.text = [IRCommon getFirstLetterFromString:categoryName];
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    int otherIndex = [IRCommon getIndexOfOtherCategory:!self.categorySegment.selectedSegmentIndex];
    
    if (indexPath.row == otherIndex)
    {
        return NO;
    }
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:APPLICATION_NAME message:[IRCommon localizeText:@"Do you want to delete the category?"] delegate:self cancelButtonTitle:[IRCommon localizeText:@"Cancel"] otherButtonTitles:[IRCommon localizeText:OK_TEXT], nil];
        alertView.tag = indexPath.row + 9999;
        [alertView show];
    }
//    else
//    {
//        if (self.categorySegment.selectedSegmentIndex == 0) {
//            [self.expenseCategories removeObjectAtIndex:indexPath.row];
//            [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
//        }
//        else {
//            [self.incomeCategories removeObjectAtIndex:indexPath.row];
//            [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
//        }
//    }
}

- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath
{
    
}

#pragma mark - UITableView Delegate Methods

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    IRCategoryDetailViewController *categoryDetailViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"CategoryDetailViewController"];
    IRCategory *category = [[IRCategory alloc]init];
    category = (self.categorySegment.selectedSegmentIndex == 0) ? [self.expenseCategories objectAtIndex:indexPath.row] : [self.incomeCategories objectAtIndex:indexPath.row];
    categoryDetailViewController.name = category.categoryName;
    categoryDetailViewController.colorCode = category.colorCode;
    categoryDetailViewController.isExpense = category.isExpense;
    categoryDetailViewController.type = CTEdit;
    [self.navigationController pushViewController:categoryDetailViewController animated:YES];
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewCellEditingStyleDelete;
}


#pragma mark - UIAlertView Delegate Methods

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        int deletedIndex = (int)alertView.tag - 9999;
        IRCategoryTableViewCell *cell = (IRCategoryTableViewCell *)[self.categoryTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:deletedIndex inSection:0]];
        
        [[IRCoreDataController sharedInstance]deleteCategoryWithName:cell.categoryName.text];
        [[IRCoreDataController sharedInstance]updateExpenseForCategory:cell.categoryName.text with:@"Others"];
        
        int isExpense = (int)self.categorySegment.selectedSegmentIndex;
        NSArray *categories = [[IRCoreDataController sharedInstance]fetchCategoriesForExpense:!isExpense];
        
        for (IRCategory *category in categories)
        {
            if (category.categoryID >= deletedIndex + 1) {
                category.categoryID --;
            }
            [[IRCoreDataController sharedInstance]updateCategory:category.categoryName withCategory:category];
        }

        
    }
}

#pragma mark - IBAction Button

- (IBAction)didTouchUpInsideAddCategoryButton:(id)sender
{
    IRCategoryDetailViewController *categoryDetailViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"CategoryDetailViewController"];
    categoryDetailViewController.type = CTAdd;
    categoryDetailViewController.isExpense = (self.categorySegment.selectedSegmentIndex == 0) ? YES : NO;
    [self.navigationController pushViewController:categoryDetailViewController animated:YES];
}

- (IBAction)didChangeValueOfCategorySegment:(id)sender
{
    self.expenseCategories = (NSMutableArray *)[[IRCoreDataController sharedInstance]fetchCategoriesForExpense:YES];
    self.incomeCategories = (NSMutableArray *)[[IRCoreDataController sharedInstance]fetchCategoriesForExpense:NO];
    [self.categoryTableView reloadData];
}

- (IBAction)longPressGestureRecognized:(id)sender {
    
    UILongPressGestureRecognizer *longPress = (UILongPressGestureRecognizer *)sender;
    UIGestureRecognizerState state = longPress.state;
    
    CGPoint location = [longPress locationInView:self.categoryTableView];
    NSIndexPath *indexPath = [self.categoryTableView indexPathForRowAtPoint:location];
    
    static UIView       *snapshot = nil;        ///< A snapshot of the row user is moving.
    static NSIndexPath  *sourceIndexPath = nil; ///< Initial index path, where gesture begins.
    
    switch (state) {
        case UIGestureRecognizerStateBegan: {
            if (indexPath) {
                sourceCellID = (int)indexPath.row + 1;
                

                sourceIndexPath = indexPath;
                
                UITableViewCell *cell = [self.categoryTableView cellForRowAtIndexPath:indexPath];
                
                // Take a snapshot of the selected row using helper method.
                snapshot = [self customSnapshoFromView:cell];
                
                // Add the snapshot as subview, centered at cell's center...
                __block CGPoint center = cell.center;
                snapshot.center = center;
                snapshot.alpha = 0.0;
                [self.categoryTableView addSubview:snapshot];
                [UIView animateWithDuration:0.25 animations:^{
                    
                    // Offset for gesture location.
                    center.y = location.y;
                    snapshot.center = center;
                    snapshot.transform = CGAffineTransformMakeScale(1.05, 1.05);
                    snapshot.alpha = 0.98;
                    cell.alpha = 0.0;
                    
                } completion:^(BOOL finished) {
                    
                    cell.hidden = YES;
                    
                }];
            }
            break;
        }
            
        case UIGestureRecognizerStateChanged: {
           
            CGPoint center = snapshot.center;
            center.y = location.y;
            snapshot.center = center;
            
            // Is destination valid and is it different from source?
            if (indexPath && ![indexPath isEqual:sourceIndexPath]) {
                
                // ... update data source.
                if (self.categorySegment.selectedSegmentIndex == 0 ) {
                     [self.expenseCategories exchangeObjectAtIndex:indexPath.row withObjectAtIndex:sourceIndexPath.row];
                } else {
                    [self.incomeCategories exchangeObjectAtIndex:indexPath.row withObjectAtIndex:sourceIndexPath.row];
                }
               
                
                // ... move the rows.
                [self.categoryTableView moveRowAtIndexPath:sourceIndexPath toIndexPath:indexPath];
                
                // ... and update source so it is in sync with UI changes.
                sourceIndexPath = indexPath;
            }
            break;
        }
            
        default: {
            
            
            destinationCellID = (int)indexPath.row + 1;
            // Clean up.
            UITableViewCell *cell = [self.categoryTableView cellForRowAtIndexPath:indexPath];
            cell.hidden = NO;
            cell.alpha = 0.0;
            
            [UIView animateWithDuration:0.25 animations:^{
                
                snapshot.center = cell.center;
                snapshot.transform = CGAffineTransformIdentity;
                snapshot.alpha = 0.0;
                cell.alpha = 1.0;
                
            } completion:^(BOOL finished) {
                
                sourceIndexPath = nil;
                [snapshot removeFromSuperview];
                snapshot = nil;
                [self reorderCategoryInDB];
            }];
            
            break;
        }
    }
}

- (void)reorderCategoryInDB
{
    if (sourceCellID == destinationCellID) {
        return;
    }
    
    int isExpense = (int)self.categorySegment.selectedSegmentIndex;
    NSArray *categories = [[IRCoreDataController sharedInstance]fetchCategoriesForExpense:!isExpense];
    
    for (IRCategory *category in categories)
    {
        if (sourceCellID < destinationCellID)
        {
            if (category.categoryID >= sourceCellID && category.categoryID <= destinationCellID)
            {
                if (category.categoryID == sourceCellID) {
                    category.categoryID = destinationCellID;
                }
                else {
                    category.categoryID --;
                }
            }
        }
        else {
            if (category.categoryID <= sourceCellID && category.categoryID >= destinationCellID)
            {
                if (category.categoryID == sourceCellID) {
                    category.categoryID = destinationCellID;
                }
                else {
                    category.categoryID ++;
                }
            }
        }
        [[IRCoreDataController sharedInstance]updateCategory:category.categoryName withCategory:category];
    }
}

/** @brief Returns a customized snapshot of a given view. */
- (UIView *)customSnapshoFromView:(UIView *)inputView {
    
    // Make an image from the input view.
    UIGraphicsBeginImageContextWithOptions(inputView.bounds.size, NO, 0);
    [inputView.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    // Create an image view.
    UIView *snapshot = [[UIImageView alloc] initWithImage:image];
    snapshot.layer.masksToBounds = NO;
    snapshot.layer.cornerRadius = 0.0;
    snapshot.layer.shadowOffset = CGSizeMake(-5.0, 0.0);
    snapshot.layer.shadowRadius = 5.0;
    snapshot.layer.shadowOpacity = 0.4;
    
    return snapshot;
}

@end
