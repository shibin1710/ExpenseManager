//
//  IRCategoryViewController.m
//  ExpenseManager
//
//  Created by Shibin S on 04/09/14.
//  Copyright (c) 2014 Shibin. All rights reserved.
//

#import "IRAddExpenseViewController.h"
#import "FPNumberPadView.h"
#import "IRCategoryTableViewCell.h"
#import "IRExpense.h"
#import "IRCoreDataController.h"
#import "IRCommon.h"
#import "IRCalenderViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "IRCategory.h"
#import "IRCategoryDetailViewController.h"

@interface IRAddExpenseViewController ()
{
    NSNumber *trackMode;
    NSString *category, *notes, *currencySymbol;
}
@property (weak, nonatomic) IBOutlet UIView *backgroundView;
@property (strong, nonatomic) NSArray *categories;
@property (weak, nonatomic) IBOutlet UIButton *addedAmount;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *saveButton;
@property (weak, nonatomic) IBOutlet UITableView *categoryTableView;
@property (weak, nonatomic) IBOutlet UISegmentedControl *categorySegment;
@property (weak, nonatomic) IBOutlet UILabel *infoLabel;

@end

#pragma mark - View lifecycle

@implementation IRAddExpenseViewController

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
    [IRCommon updateAppUsagePointsWithValue:1];
    [self.categorySegment setTitle:[IRCommon localizeText:@"Expense"] forSegmentAtIndex:0];
    [self.categorySegment setTitle:[IRCommon localizeText:@"Income"] forSegmentAtIndex:1];
    trackMode = [[NSUserDefaults standardUserDefaults]objectForKey:@"trackMode"];
    self.categorySegment.hidden = (trackMode.intValue == 0) ? YES : NO;
    self.categorySegment.selectedSegmentIndex = 0;
    self.navigationItem.title = [IRCommon localizeText:@"Categories"];
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName: [UIColor whiteColor],NSFontAttributeName:[IRCommon getDefaultFontForSize:17.0 isBold:YES]};
    [self.categorySegment setTitleTextAttributes:[NSDictionary dictionaryWithObject:[IRCommon getDefaultFontForSize:14 isBold:NO] forKey:NSFontAttributeName] forState:UIControlStateNormal];
    self.categoryTableView.tintColor = [IRCommon getThemeColor];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleDataModelChange:) name:NSManagedObjectContextObjectsDidChangeNotification object:[[IRCoreDataController sharedInstance]managedObjectContext]];
    currencySymbol = [IRCommon getCurrencySymbolFromCode:[[NSUserDefaults standardUserDefaults]objectForKey:@"currency"]];
    [self.addedAmount setTitleColor:[IRCommon getThemeColor] forState:UIControlStateNormal];
    self.categorySegment.tintColor = [IRCommon getThemeColor];
    self.addedAmount.titleLabel.font = [IRCommon getDefaultFontForSize:22 isBold:YES];
    self.categorySegment.selectedSegmentIndex = (self.expenseDetails) ? (self.expenseDetails.isExpense ? 0 : 1) : 0;
    self.categories = [[IRCoreDataController sharedInstance]fetchCategoriesForExpense:(self.categorySegment.selectedSegmentIndex == 0)? YES:NO];
    if (self.type == EMAdd) {
        self.expenseDetails = [[IRExpense alloc]init];
        category = @"Others";
        [self addNumberPadView];
        self.selectedIndexPath = [NSIndexPath indexPathForItem:0 inSection:0];
        self.expenseDetails.date = [NSDate date];
        [self.addedAmount setTitle:[NSString stringWithFormat:@"%@ 0.00",currencySymbol] forState:UIControlStateNormal];
    } else {
        IRCategory *categoryGroup = [self.categories objectAtIndex:self.selectedIndexPath.row];
        category = categoryGroup.categoryName;
        self.backgroundView.alpha = 0;
        [self.addedAmount setTitle:[NSString stringWithFormat:@"%@ %0.2f",currencySymbol,self.expenseDetails.amount] forState:UIControlStateNormal];
    }
    self.categorySegment.hidden = (trackMode.intValue == 0) ? YES : NO;
    if (trackMode.intValue == 0) {
        self.categorySegment.selectedSegmentIndex = 0;
    }
    self.infoLabel.hidden = (trackMode.intValue == 0) ? NO : YES;
    self.infoLabel.text = @"Select expense amount, category and date and click on Save.";
    self.infoLabel.font = [IRCommon getDefaultFontForSize:14 isBold:NO];
    [self.navigationItem.rightBarButtonItem setTitleTextAttributes:[NSDictionary dictionaryWithObject:[IRCommon getDefaultFontForSize:16 isBold:YES] forKey:NSFontAttributeName] forState:UIControlStateNormal];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    // Remove text from back button.
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
}

#pragma mark - Notification Callback Methods

- (void)handleDataModelChange:(NSNotification *)notification
{
    self.categories = [[IRCoreDataController sharedInstance]fetchCategoriesForExpense:(self.categorySegment.selectedSegmentIndex == 0)? YES:NO];
    [self.categoryTableView reloadData];
}

#pragma mark - Private Methods

- (void)addNumberPadView
{
    self.backgroundView.backgroundColor = [UIColor lightGrayColor];
    self.backgroundView.userInteractionEnabled = YES;
    self.backgroundView.alpha = 0.8;
    self.saveButton.enabled = NO;
    FPNumberPadView *numberPadView = [[FPNumberPadView alloc]initWithFrame:CGRectMake(40, 134, 240, 270)];
    numberPadView.delegate = self;
    [self.view addSubview:numberPadView];
}

#pragma mark - IBAction Methods

- (void)didTapCancelButton:(NSString *)number
{
    self.saveButton.enabled = YES;
    self.backgroundView.userInteractionEnabled = NO;
    self.backgroundView.backgroundColor = [UIColor clearColor];
    self.backgroundView.alpha = 1;
}

- (void)didTapOkButton:(NSString *)number
{
    if (![[number stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]isEqualToString:@""]) {
        self.expenseDetails.amount = number.floatValue;
        [self.addedAmount setTitle:[NSString stringWithFormat:@"%@ %0.2f",currencySymbol,self.expenseDetails.amount] forState:UIControlStateNormal];
    }
    self.saveButton.enabled = YES;
    self.backgroundView.userInteractionEnabled = NO;
    self.backgroundView.backgroundColor = [UIColor clearColor];
    self.backgroundView.alpha = 1;
}

- (IBAction)didTouchUpInsideAmountButton:(id)sender
{
    [IRCommon updateAppUsagePointsWithValue:1];
    [self addNumberPadView];
}

- (IBAction)didTouchUpInsideSaveButton:(id)sender
{
    if (self.expenseDetails.amount <=0) {
        [IRCommon showAlertWithTitle:APPLICATION_NAME message:[IRCommon localizeText:@"Please enter expense for the category."] dismissButtonText:[IRCommon localizeText:OK_TEXT]];
        return;
    }
    IRExpense *expense = [[IRExpense alloc]init];
    expense.expenseId = [NSString stringWithFormat:@"%@%i",[NSDate date],(arc4random())];
    expense.category = category;
    expense.date = self.expenseDetails.date;
    expense.note = notes;
    expense.isExpense = !self.categorySegment.selectedSegmentIndex;
    expense.image = nil;
    expense.currency = [[NSUserDefaults standardUserDefaults]objectForKey:@"currency"];
    expense.isRecurring = NO;;
    expense.recurringDuration = 0;
    expense.amount = self.expenseDetails.amount;
    (self.type == EMAdd) ? [[IRCoreDataController sharedInstance]saveExpense:expense] : [[IRCoreDataController sharedInstance]updateExpense:expense forId:self.expenseDetails.expenseId];
    [IRCommon updateAppUsagePointsWithValue:15];
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (IBAction)didChangedValueForCategorySegment:(id)sender
{
    self.categories = [[IRCoreDataController sharedInstance]fetchCategoriesForExpense:(self.categorySegment.selectedSegmentIndex == 0)? YES:NO];
    self.selectedIndexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    IRCategory *categoryModal = [self.categories objectAtIndex:0];
    category = categoryModal.categoryName;
    [self.categoryTableView reloadData];
}

#pragma mark - UITableView Datasource Methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return (section == 0) ?[self.categories count] + 1:2;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 30;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"AddExpenseHeaderCell"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"AddExpenseHeaderCell"];
    }
    cell.textLabel.textColor = [UIColor darkGrayColor];
    cell.backgroundColor = [UIColor groupTableViewBackgroundColor];
    cell.textLabel.font = [IRCommon getDefaultFontForSize:14 isBold:YES];
    switch (section) {
        case 0:
            cell.textLabel.text = [IRCommon localizeText:@"Category"];
            break;
        case 1:
            cell.textLabel.text = [IRCommon localizeText:@"Additional Details"];
            break;
        default:
            break;
    }
    return cell;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    IRCategoryTableViewCell *cell = (IRCategoryTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"CategoryCell" forIndexPath:indexPath];
    if (cell == nil) {
        cell = [[IRCategoryTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"CategoryCell"];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.categoryName.font = [IRCommon getDefaultFontForSize:14.0f isBold:NO];
    if (indexPath.section == 0) {
        cell.additionalInfoTextField.hidden = YES;
        cell.calenderButton.hidden = YES;
        cell.colorLabel.hidden = NO;
        if (indexPath.row == self.categories.count ) {
            cell.categoryName.text = [IRCommon localizeText:@"Add New Category"];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            cell.colorLabel.backgroundColor = [IRCommon getThemeColor];
            cell.colorLabel.text = @"+";
        } else {
            cell.accessoryType = [self.selectedIndexPath isEqual:indexPath] ? UITableViewCellAccessoryCheckmark : UITableViewCellAccessoryNone;
            IRCategory *categoryModal = [self.categories objectAtIndex:indexPath.row];
            NSString *categoryName = categoryModal.categoryName;
            NSString *firstLetter = [IRCommon getFirstLetterFromString:categoryName];
            cell.colorLabel.backgroundColor = [IRCommon isThemeApplicableForCategoryIcons] ? [IRCommon getThemeColor] : [IRCommon getColorForColorCode:categoryModal.colorCode];
            cell.colorLabel.text = firstLetter;
            cell.categoryName.text = categoryName;
        }
    } else {
        cell.accessoryType = UITableViewCellAccessoryNone;
        cell.colorLabel.hidden = YES;
        switch (indexPath.row) {
            case 0:
                cell.delegate = self;
                cell.additionalInfoTextField.hidden = YES;
                cell.calenderButton.hidden = NO;
                cell.categoryName.text = [IRCommon localizeText:@"Date"];
                cell.calenderButton.titleLabel.font = [IRCommon getDefaultFontForSize:14.0 isBold:YES];
                if (self.type == EMAdd) {
                    [cell.calenderButton setTitle:[IRCommon localizeText:@"Today"] forState:UIControlStateNormal];
                } else {
                    if ([IRCommon isToday:self.expenseDetails.date]) {
                        [cell.calenderButton setTitle:[IRCommon localizeText:@"Today"] forState:UIControlStateNormal];
                    } else if ([IRCommon isYesterday:self.expenseDetails.date]) {
                        [cell.calenderButton setTitle:[IRCommon localizeText:@"Yesterday"] forState:UIControlStateNormal];
                    } else if ([IRCommon isTomorrow:self.expenseDetails.date]) {
                        [cell.calenderButton setTitle:[IRCommon localizeText:@"Tomorrow"] forState:UIControlStateNormal];
                    } else {
                        [cell.calenderButton setTitle:[IRCommon getDateStringFromDate:self.expenseDetails.date] forState:UIControlStateNormal];
                    }
                }
                [cell.calenderButton setBackgroundColor:[IRCommon getThemeColor]];
                cell.calenderButton.layer.cornerRadius = 3.0f;
                break;
            case 1:
                cell.calenderButton.hidden = YES;
                cell.additionalInfoTextField.hidden = NO;
                cell.additionalInfoTextField.text = self.expenseDetails.note;
                cell.additionalInfoTextField.tag = 1;
                cell.categoryName.text = [IRCommon localizeText:@"Notes"];
                cell.additionalInfoTextField.font = [IRCommon getDefaultFontForSize:14.0 isBold:NO];
                break;
            default:
                break;
        }
    }
    return cell;
}

#pragma mark - UITableView Delegate Methods

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        if (indexPath.row == self.categories.count) {
            IRCategoryDetailViewController *categoryDetailViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"CategoryDetailViewController"];
            categoryDetailViewController.type = CTAdd;
            categoryDetailViewController.isExpense = !self.categorySegment.selectedSegmentIndex;
            [self.navigationController pushViewController:categoryDetailViewController animated:YES];
        } else {
            if (self.selectedIndexPath) {
                IRCategoryTableViewCell *selectedCell = (IRCategoryTableViewCell *)[tableView cellForRowAtIndexPath:self.selectedIndexPath];
                selectedCell.accessoryType = UITableViewCellAccessoryNone;
                self.selectedIndexPath = nil;
            }
            IRCategoryTableViewCell *cell = (IRCategoryTableViewCell *)[tableView cellForRowAtIndexPath:indexPath];
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
            self.selectedIndexPath = indexPath;
            category = cell.categoryName.text;
            [IRCommon updateAppUsagePointsWithValue:1];
        }
    }
}

#pragma mark - UITextField Delegate Methods

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (textField.tag == 1) {
        notes = textField.text;
    }
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if (textField.tag == 1) {
        notes = textField.text;
    }
    [textField resignFirstResponder];
}

#pragma mark - Notification Callback Methods

- (void)keyboardWillShow:(NSNotification *)notification
{
    CGSize keyboardSize = [[[notification userInfo] objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    UIEdgeInsets contentInsets;
    if (UIInterfaceOrientationIsPortrait([[UIApplication sharedApplication] statusBarOrientation])) {
        contentInsets = UIEdgeInsetsMake(0.0, 0.0, (keyboardSize.height), 0.0);
    } else {
        contentInsets = UIEdgeInsetsMake(0.0, 0.0, (keyboardSize.width), 0.0);
    }
    NSNumber *rate = notification.userInfo[UIKeyboardAnimationDurationUserInfoKey];
    [UIView animateWithDuration:rate.floatValue animations:^{
        self.categoryTableView.contentInset = contentInsets;
        self.categoryTableView.scrollIndicatorInsets = contentInsets;
    }];
}

- (void)keyboardWillHide:(NSNotification *)notification
{
//    NSNumber *rate = notification.userInfo[UIKeyboardAnimationDurationUserInfoKey];
//    [UIView animateWithDuration:rate.floatValue animations:^{
//        self.categoryTableView.contentInset = UIEdgeInsetsZero;
//        self.categoryTableView.scrollIndicatorInsets = UIEdgeInsetsZero;
//    }];
}

#pragma mark - CalenderView Delegate Methods

- (void)didSelectDate:(NSDate *)date
{
    IRCategoryTableViewCell *selectedCell = (IRCategoryTableViewCell *)[self.categoryTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:1]];
    if ([IRCommon isToday:date]) {
        [selectedCell.calenderButton setTitle:[IRCommon localizeText:@"Today"] forState:UIControlStateNormal];
    } else if ([IRCommon isYesterday:date]) {
        [selectedCell.calenderButton setTitle:[IRCommon localizeText:@"Yesterday"] forState:UIControlStateNormal];
    } else if ([IRCommon isTomorrow:date]) {
        [selectedCell.calenderButton setTitle:[IRCommon localizeText:@"Tomorrow"] forState:UIControlStateNormal];
    } else {
        [selectedCell.calenderButton setTitle:[IRCommon getDateStringFromDate:date] forState:UIControlStateNormal];
    }
    self.expenseDetails.date = date;
}

- (void)didTapCalenderButton
{
    IRCalenderViewController *calenderViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"CalenderView"];
    calenderViewController.delegate = self;
    calenderViewController.calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    calenderViewController.calendar.locale = [NSLocale currentLocale];
    UINavigationController *calenderNavigationController = [[UINavigationController alloc]initWithRootViewController:calenderViewController];
    [self.navigationController presentViewController:calenderNavigationController animated:YES completion:nil];
    [IRCommon updateAppUsagePointsWithValue:1];
}

#pragma mark - Dealloc Methods

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
