//
//  IRCategoryDetailViewController.m
//  ExpenseManager
//
//  Created by Shibin S on 07/09/14.
//  Copyright (c) 2014 Shibin. All rights reserved.
//

#import "IRCategoryDetailViewController.h"
#import "IRCommon.h"
#import "IRCategory.h"
#import "IRCoreDataController.h"
#import <QuartzCore/QuartzCore.h>

@interface IRCategoryDetailViewController () {
    int selectedColorCode;
    NSNumber *trackMode;
}

@property (weak, nonatomic) IBOutlet UITextField *categoryName;
@property (weak, nonatomic) IBOutlet UIButton *colorButton;
@property (weak, nonatomic) IBOutlet UITableView *colorTableView;
@property (strong, nonatomic) UITapGestureRecognizer *tapGesture;
@property (weak, nonatomic) IBOutlet UISegmentedControl *categoryTypeSegment;
@property (weak, nonatomic) IBOutlet UILabel *colorLabel;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *typeLabel;

@end

@implementation IRCategoryDetailViewController

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
    [IRCommon updateAppUsagePointsWithValue:1];
    self.nameLabel.text = [IRCommon localizeText:@"Name"];
    self.typeLabel.text = [IRCommon localizeText:@"Type"];
    self.colorLabel.text = [IRCommon localizeText:@"Color"];
    [self.categoryTypeSegment setTitle:[IRCommon localizeText:@"Expense"] forSegmentAtIndex:0];
    [self.categoryTypeSegment setTitle:[IRCommon localizeText:@"Income"] forSegmentAtIndex:1];
    trackMode = [[NSUserDefaults standardUserDefaults]objectForKey:@"trackMode"];
    self.typeLabel.hidden = (trackMode.intValue == 0) ? YES : NO;
    self.categoryTypeSegment.hidden = (trackMode.intValue == 0) ? YES : NO;
//    self.tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(handleGesture:)];
//    [self.view addGestureRecognizer:self.tapGesture];
    self.colorButton.layer.borderWidth = 1.0f;
    self.colorButton.layer.borderColor = [UIColor whiteColor].CGColor;
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:@selector(didTouchUpInsideSaveButton)];
    self.categoryTypeSegment.tintColor = [IRCommon getThemeColor];
    self.categoryTypeSegment.selectedSegmentIndex = !self.isExpense;
    [self.categoryTypeSegment setTitleTextAttributes:[NSDictionary dictionaryWithObject:[IRCommon getDefaultFontForSize:14 isBold:NO] forKey:NSFontAttributeName] forState:UIControlStateNormal];
    self.colorLabel.hidden = self.colorButton.hidden = [IRCommon isThemeApplicableForCategoryIcons] ? YES : NO;
    self.categoryName.font = [IRCommon getDefaultFontForSize:14.0f isBold:NO];
    if (self.type == CTAdd) {
        selectedColorCode = 0;
        self.navigationItem.title = [IRCommon localizeText:@"Add Category"];
        self.colorButton.backgroundColor = [IRCommon getThemeColor];
    } else {
        selectedColorCode = self.colorCode;
        self.navigationItem.title = [IRCommon localizeText:@"Edit Category"];
        self.colorButton.backgroundColor = [IRCommon getColorForColorCode:self.colorCode];
        self.categoryName.text = self.name;
        self.navigationItem.rightBarButtonItem.enabled = [self.name isEqualToString:@"Others"] ? NO:YES;
    }
    [self.navigationItem.rightBarButtonItem setTitleTextAttributes:[NSDictionary dictionaryWithObject:[IRCommon getDefaultFontForSize:16 isBold:YES] forKey:NSFontAttributeName] forState:UIControlStateNormal];
    self.nameLabel.font = [IRCommon getDefaultFontForSize:14 isBold:NO];
    self.typeLabel.font = [IRCommon getDefaultFontForSize:14 isBold:NO];
    self.colorLabel.font = [IRCommon getDefaultFontForSize:14 isBold:NO];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableView Datasource Methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 12;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 30;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"ColorCell"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"ColorCell"];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.layer.borderWidth = 1.0f;
    cell.layer.borderColor = [UIColor whiteColor].CGColor;
    cell.backgroundColor = [IRCommon getColorForColorCode:(int)indexPath.row];
    return cell;
}

#pragma mark - UITableView Delegate Methods

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    selectedColorCode = (int)indexPath.row;
    self.colorButton.backgroundColor = [IRCommon getColorForColorCode:selectedColorCode];
    self.colorTableView.hidden = YES;
    self.colorButton.selected = NO;
}

#pragma mark - UITextField Delegate Methods

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    self.colorTableView.hidden = YES;
    self.colorButton.selected = NO;
}

#pragma mark - IBAction Methods

- (IBAction)didTouchUpInsideColorButton:(id)sender
{
    [self.categoryName resignFirstResponder];
    if (self.colorButton.selected) {
        self.colorTableView.hidden = YES;
        self.colorButton.selected = NO;
    } else {
        self.colorButton.selected = YES;
        self.colorTableView.hidden = NO;
    }
}

- (void)didTouchUpInsideSaveButton
{
    if ([[self.categoryName.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]isEqualToString:@""]) {
        [IRCommon showAlertWithTitle:APPLICATION_NAME message:[IRCommon localizeText:@"Please enter a category name."] dismissButtonText:[IRCommon localizeText:OK_TEXT]];
        return;
    }
    IRCategory *categoryModel = [[IRCategory alloc]init];
    categoryModel.categoryName = self.categoryName.text;
    categoryModel.colorCode = selectedColorCode;
    categoryModel.isExpense = !self.categoryTypeSegment.selectedSegmentIndex;
    if ([IRCommon isCategoryAddedinDB:categoryModel forExpense:(self.categoryTypeSegment.selectedSegmentIndex == 0)?YES:NO addToDB:(self.type == CTAdd)?YES:NO]) {
        [IRCommon showAlertWithTitle:APPLICATION_NAME message:[IRCommon localizeText:@"The category you entered already exists."] dismissButtonText:[IRCommon localizeText:OK_TEXT]];
        return;
    }
    if (self.type == CTAdd) {
        IRCategory *category = [[IRCategory alloc]init];
        category.categoryName = self.categoryName.text;
        category.colorCode = selectedColorCode;
        category.isExpense = !self.categoryTypeSegment.selectedSegmentIndex;
        category.categoryID = [IRCommon getCategoryIDToSave:!self.categoryTypeSegment.selectedSegmentIndex];
        [[IRCoreDataController sharedInstance]addCategory:category];
    } else {
        IRCategory *category = [[IRCategory alloc]init];
        category.categoryName = self.categoryName.text;
        category.colorCode = selectedColorCode;
        category.isExpense = !self.categoryTypeSegment.selectedSegmentIndex;
        [[IRCoreDataController sharedInstance]updateCategory:self.name withCategory:category];
        [[IRCoreDataController sharedInstance]updateExpenseForCategory:self.name with:category.categoryName];
    }
    [IRCommon updateAppUsagePointsWithValue:1];
     [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - Private Methods

- (void)handleGesture:(UIGestureRecognizer *)gesture
{
    [self.categoryName endEditing:YES];
    self.colorTableView.hidden = YES;
    self.colorButton.selected = NO;
}

@end
