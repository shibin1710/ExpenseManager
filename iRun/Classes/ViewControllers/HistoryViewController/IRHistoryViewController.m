//
//  IRHistoryViewController.m
//  ExpenseManager
//
//  Created by Shibin S on 13/09/14.
//  Copyright (c) 2014 Shibin. All rights reserved.
//

#import "IRHistoryViewController.h"
#import "SWRevealViewController.h"
#import "IRCommon.h"
#import "Expense.h"
#import "IRCoreDataController.h"
#import "IRHistoryHeaderTableViewCell.h"
#import "IRHIstoryTableViewCell.h"
#import "IRExpense.h"
#import "IRAddExpenseViewController.h"

@interface IRHistoryViewController ()
{
    int selectedSection;
    NSIndexPath *deletedIndexPath;
    NSNumber *trackMode;
}

@property (weak, nonatomic) IBOutlet UIButton *menuButton;
@property (nonatomic) NSFetchedResultsController *fetchedResultsController;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UILabel *noEntryLabel;

@end

@implementation IRHistoryViewController

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
    [self commenceOperations];
    [self prepareView];
    [IRCommon updateAppUsagePointsWithValue:1];
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.tableView setEditing:NO];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Private Methods

- (void)prepareView
{
    if (![IRCommon isFullVersion]) {
        self.interstitialPresentationPolicy = ADInterstitialPresentationPolicyAutomatic;
    }    [_menuButton addTarget:self.revealViewController action:@selector(revealToggle:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(didTouchUpInsideAddButton)];
    self.navigationItem.rightBarButtonItem = addButton;
//    [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
    [self.view addGestureRecognizer:self.revealViewController.tapGestureRecognizer];
    self.navigationItem.title = [IRCommon localizeText:@"History"];
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName: [UIColor whiteColor],NSFontAttributeName:[IRCommon getDefaultFontForSize:17.0 isBold:YES]};
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    self.navigationController.navigationBar.barTintColor = [IRCommon getThemeColor];
    self.noEntryLabel.hidden = [[self.fetchedResultsController sections] count] ? YES : NO;
    self.noEntryLabel.font = [IRCommon getDefaultFontForSize:15 isBold:NO];
    self.noEntryLabel.textColor = [UIColor darkGrayColor];
    self.noEntryLabel.text = [IRCommon localizeText:@"No entries found.\n\nTap on + to add a new entry."];
}

- (void)commenceOperations
{
    trackMode = [[NSUserDefaults standardUserDefaults]objectForKey:@"trackMode"];
    selectedSection = -1;
    deletedIndexPath = nil;
    NSError *error;
    if (![self.fetchedResultsController performFetch:&error]) {
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    [IRCommon saveCategoriesToDB];
    if ([[self.fetchedResultsController sections] count]) {
        [self expandRowAtSection:0 forTableView:self.tableView];
    }
}

- (void)configureHeaderCell:(IRHistoryHeaderTableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath
{
    id <NSFetchedResultsSectionInfo> theSection = [[self.fetchedResultsController sections] objectAtIndex:indexPath.section];
    static NSDateFormatter *formatter = nil;
    if (!formatter) {
        formatter = [[NSDateFormatter alloc] init];
        [formatter setCalendar:[NSCalendar currentCalendar]];
    }
    NSString *titleString;
    float profit;
    switch ([IRCommon getGroupingName]) {
        case WeeklyGrouping:{
            NSString *formatTemplate = [NSDateFormatter dateFormatFromTemplate:@"yyyy-dd-MM" options:0 locale:[NSLocale currentLocale]];
            [formatter setDateFormat:formatTemplate];
            NSInteger numericSection = [[theSection name] integerValue];
            NSInteger year = numericSection / 100000;
            NSInteger month = (numericSection / 100) - (year * 1000);
            NSInteger week = numericSection - (year * 100000) - (month * 100);
            NSDateComponents *dateComponents = [[NSDateComponents alloc] init];
            dateComponents.weekday = 1;
            dateComponents.year = year;
            dateComponents.yearForWeekOfYear = year;
            dateComponents.month = month;
            dateComponents.weekOfYear = week;
            NSCalendar *calender = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
            NSDate *date = [calender dateFromComponents:dateComponents];
            titleString = [formatter stringFromDate:date];
        }
            break;
        case MonthlyGrouping:
        {
            NSString *formatTemplate = [NSDateFormatter dateFormatFromTemplate:@"MMMM YYYY" options:0 locale:[NSLocale currentLocale]];
            [formatter setDateFormat:formatTemplate];
            NSInteger numericSection = [[theSection name] integerValue];
            NSInteger year = numericSection / 1000;
            NSInteger month = numericSection - (year * 1000);
            NSDateComponents *dateComponents = [[NSDateComponents alloc] init];
            dateComponents.year = year;
            dateComponents.month = month;
            NSDate *date = [[NSCalendar currentCalendar] dateFromComponents:dateComponents];
            titleString = [formatter stringFromDate:date];
        }
            break;
        case YearlyGrouping:
        {
            NSString *formatTemplate = [NSDateFormatter dateFormatFromTemplate:@"YYYY" options:0 locale:[NSLocale currentLocale]];
            [formatter setDateFormat:formatTemplate];
            NSInteger numericSection = [[theSection name] integerValue];
            NSInteger year = numericSection;
            NSDateComponents *dateComponents = [[NSDateComponents alloc] init];
            dateComponents.year = year;
            NSDate *date = [[NSCalendar currentCalendar] dateFromComponents:dateComponents];
            titleString = [formatter stringFromDate:date];
        }
            break;
        default:
            break;
    }
    id expandedDataArray = [[self.fetchedResultsController sections]objectAtIndex:indexPath.section];
    NSArray *objects = [expandedDataArray objects];
    NSMutableArray *expenseModalArray = [NSMutableArray array];
    for (Expense *expenseEntity in objects) {
        IRExpense *expenseModal = [[IRExpense alloc]init];
        expenseModal = [expenseModal readFromEntity:expenseEntity];
        [expenseModalArray addObject:expenseModal];
    }
    profit = [IRCommon getTotalProfitForArray:expenseModalArray];
    cell.backgroundColor = [UIColor colorWithRed:245.0/255.0 green:245.0/255.0 blue:245.0/255.0 alpha:1];
    cell.arrowImage.textColor = [IRCommon getThemeColor];
    cell.selectionStyle = UITableViewCellEditingStyleNone;
    cell.headerText.text = titleString;
    cell.headerText.font = [IRCommon getDefaultFontForSize:14 isBold:YES];
    cell.arrowImage.text = (selectedSection == indexPath.section) ? @"▼" : @"▶︎";
    cell.profit.font = [IRCommon getDefaultFontForSize:14 isBold:YES];
    cell.profit.text = [NSString stringWithFormat:@"%@ %0.2f",[IRCommon getCurrencySymbolFromCode:[[NSUserDefaults standardUserDefaults]objectForKey:@"currency"]],fabsf(profit)];
    cell.profitArrow.hidden = (trackMode.intValue == 0) ? YES : NO;
    cell.profitArrow.text = (profit < 0) ? @"⬇︎" : @"⬆︎";
    cell.profitArrow.textColor = (profit < 0) ? [UIColor redColor] : [UIColor colorWithRed:90.0/255.0 green:212.0/255.0 blue:39.0/255.0 alpha:1.0];
}

- (void)configureCell:(IRHIstoryTableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath
{
    Expense *expense = [self.fetchedResultsController objectAtIndexPath:[NSIndexPath indexPathForRow:indexPath.row - 1 inSection:indexPath.section]];
    IRExpense *expenseModal = [[IRExpense alloc]init];
    expenseModal = [expenseModal readFromEntity:expense];
    cell.amount.text = [NSString stringWithFormat:@"%@ %0.2f",[IRCommon getCurrencySymbolFromCode:[[NSUserDefaults standardUserDefaults]objectForKey:@"currency"]],expenseModal.amount];
    cell.expenseArrow.text = (expenseModal.isExpense) ? @"⬇︎" : @"⬆︎";
    cell.expenseArrow.hidden = (trackMode.intValue == 0) ? YES : NO;
    cell.expenseArrow.textColor = (expenseModal.isExpense) ? [UIColor redColor] : [UIColor colorWithRed:90.0/255.0 green:212.0/255.0 blue:39.0/255.0 alpha:1.0];
    cell.colorView.backgroundColor = [IRCommon isThemeApplicableForCategoryIcons] ? [IRCommon getThemeColor] : [IRCommon getColorForColorCode:[IRCommon getColorCodeForCategory:expense.category andIsExpense:expenseModal.isExpense]];
    cell.dayLabel.text = [[IRCommon getDayNameFromDate:expense.date]uppercaseString];
    NSString *dateString;
    if ([IRCommon isToday:expense.date]) {
        dateString = [NSString stringWithFormat:@"Today at %@",[IRCommon getDate:expense.date inFormat:@"hh:mm aa"]];
    } else if ([IRCommon isYesterday:expense.date]) {
        dateString = [NSString stringWithFormat:@"Yesterday at %@",[IRCommon getDate:expense.date inFormat:@"hh:mm aa"]];
    } else if ([IRCommon isTomorrow:expense.date]) {
        dateString = [NSString stringWithFormat:@"Tomorrow at %@",[IRCommon getDate:expense.date inFormat:@"hh:mm aa"]];
    } else {
        dateString = [[IRCommon getDate:expense.date inFormat:@"dd MMM YYYY"]uppercaseString];
    }
    cell.dateLabel.text = dateString;
    cell.categoryLabel.text = expense.category;
    cell.dateLabel.font = [IRCommon getDefaultFontForSize:12 isBold:YES];
    cell.categoryLabel.font = [IRCommon getDefaultFontForSize:12 isBold:NO];
    cell.amount.font = [IRCommon getDefaultFontForSize:12 isBold:NO];
}

- (void)expandRowAtSection:(int)section forTableView:(UITableView *)tableView
{
    selectedSection = section;
    id expandedDataArray = [[self.fetchedResultsController sections]objectAtIndex:section];
    NSMutableArray *indexPathArray = [NSMutableArray array];
    for (int i = 0; i < [expandedDataArray numberOfObjects]; i ++) {
        NSIndexPath *newIndexPath = [NSIndexPath indexPathForRow:i+1 inSection:section];
        [indexPathArray addObject:newIndexPath];
    }
    [tableView insertRowsAtIndexPaths:indexPathArray withRowAnimation:UITableViewRowAnimationFade];
}

- (void)collapseRowAtSection:(int)section forTableView:(UITableView *)tableView
{
    id collpasedDataArray = [[self.fetchedResultsController sections]objectAtIndex:section];
    NSMutableArray *indexPathArray = [NSMutableArray array];
    for (int i = 0; i < [collpasedDataArray numberOfObjects]; i ++) {
        NSIndexPath *newIndexPath = [NSIndexPath indexPathForRow:i+1 inSection:section];
        [indexPathArray addObject:newIndexPath];
    }
    [tableView deleteRowsAtIndexPaths:indexPathArray withRowAnimation:UITableViewRowAnimationFade];
}

- (void)reloadHeaderViewForSection:(int)section
{
    IRHistoryHeaderTableViewCell *cell = (IRHistoryHeaderTableViewCell *)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:section]];
    if ([self.fetchedResultsController sections].count <= section) return;
    id expandedDataArray = [[self.fetchedResultsController sections]objectAtIndex:section];
    NSArray *objects = [expandedDataArray objects];
    NSMutableArray *expenseModalArray = [NSMutableArray array];
    for (Expense *expenseEntity in objects) {
        IRExpense *expenseModal = [[IRExpense alloc]init];
        expenseModal = [expenseModal readFromEntity:expenseEntity];
        [expenseModalArray addObject:expenseModal];
    }
    float profit = [IRCommon getTotalProfitForArray:expenseModalArray];
    cell.profit.text = [NSString stringWithFormat:@"%@ %0.2f",[IRCommon getCurrencySymbolFromCode:[[NSUserDefaults standardUserDefaults]objectForKey:@"currency"]],fabsf(profit)];
    cell.profitArrow.text = (profit < 0) ? @"⬇︎" : @"⬆︎";
    cell.profitArrow.textColor = (profit < 0) ? [UIColor redColor] : [UIColor colorWithRed:90.0/255.0 green:212.0/255.0 blue:39.0/255.0 alpha:1.0];
}

#pragma mark - UITableView Datasource Methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
	return [[self.fetchedResultsController sections] count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return (selectedSection >= 0 && selectedSection == section) ? [[[self.fetchedResultsController sections]objectAtIndex:section] numberOfObjects] + 1 : 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        static NSString *CellIdentifier = @"HistoryCell";
        IRHistoryHeaderTableViewCell *cell = (IRHistoryHeaderTableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            cell = [[IRHistoryHeaderTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        }
        [self configureHeaderCell:cell atIndexPath:indexPath];
        return cell;
    } else {
        static NSString *CellIdentifier = @"HistoryChildCell";
        IRHIstoryTableViewCell *cell = (IRHIstoryTableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            cell = [[IRHIstoryTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        }
        [self configureCell:cell atIndexPath:indexPath];
        return cell;
    }
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return (indexPath.row == 0) ? NO:YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:APPLICATION_NAME message:[IRCommon localizeText:@"Do you want to delete the entry?"] delegate:self cancelButtonTitle:[IRCommon localizeText:@"Cancel"] otherButtonTitles:[IRCommon localizeText:OK_TEXT], nil];
        deletedIndexPath = indexPath;
        [alertView show];
    }
}

#pragma mark - UITableView Delegate Methods

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    IRHistoryHeaderTableViewCell *cell = (IRHistoryHeaderTableViewCell *)[tableView cellForRowAtIndexPath:indexPath];
    if (indexPath.row == 0) {
        if (selectedSection == - 1) {
            cell.arrowImage.text = @"▼";
        } else if (selectedSection == indexPath.section) {
            cell.arrowImage.text =  @"▶︎";
        } else {
            IRHistoryHeaderTableViewCell *selectedCell = (IRHistoryHeaderTableViewCell *)[tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:selectedSection]];
            selectedCell.arrowImage.text =  @"▶︎";
            cell.arrowImage.text = @"▼";
        }
        [tableView beginUpdates];
        if (selectedSection != -1 ) {
            [self collapseRowAtSection:selectedSection forTableView:tableView];
            (selectedSection != (int)indexPath.section) ? [self expandRowAtSection:(int)indexPath.section forTableView:tableView]: (selectedSection = -1);
        } else {
            [self expandRowAtSection:(int)indexPath.section forTableView:tableView];
        }
        [tableView endUpdates];
    } else {
        IRAddExpenseViewController *editExpenseViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"AddExpenseViewController"];
        editExpenseViewController.type = EMEdit;
        Expense *expense = [self.fetchedResultsController objectAtIndexPath:[NSIndexPath indexPathForRow:indexPath.row - 1 inSection:indexPath.section]];
        IRExpense *expenseModal = [[IRExpense alloc]init];
        expenseModal = [expenseModal readFromEntity:expense];
        editExpenseViewController.expenseDetails = expenseModal;
        editExpenseViewController.selectedIndexPath = [NSIndexPath indexPathForRow:[IRCommon getIndexForCategory:expense.category isExpense:expenseModal.isExpense] inSection:0];
        [self.navigationController pushViewController:editExpenseViewController animated:YES];
    }
}

#pragma mark - UIAlertView Delegate Methods

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        Expense *expense = [_fetchedResultsController objectAtIndexPath:[NSIndexPath indexPathForRow:deletedIndexPath.row-1 inSection:deletedIndexPath.section]];
        IRExpense *expenseModel = [[IRExpense alloc]init];
        expenseModel = [expenseModel readFromEntity:expense];
        [[IRCoreDataController sharedInstance]deleteExpenseWithExpenseId:expenseModel.expenseId];
    } else {
        deletedIndexPath = nil;
    }
}

#pragma mark - NSFetchedResultsController Method

- (NSFetchedResultsController *)fetchedResultsController
{
    if (_fetchedResultsController != nil) {
        return _fetchedResultsController;
    }
	// Create the fetch request for the entity.
	NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
	// Edit the entity name as appropriate.
	NSEntityDescription *entity = [NSEntityDescription entityForName:@"Expense" inManagedObjectContext:[[IRCoreDataController sharedInstance]managedObjectContext]];
	[fetchRequest setEntity:entity];
	// Set the batch size to a suitable number.
	[fetchRequest setFetchBatchSize:20];
    if (trackMode.intValue == 0) {
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"isExpense == YES"];
        [fetchRequest setPredicate:predicate];
    }
	// Sort using the date property.
	NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"date" ascending:NO];
	[fetchRequest setSortDescriptors:@[sortDescriptor ]];
    // Use the sectionIdentifier property to group into sections.
    _fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:[[IRCoreDataController sharedInstance]managedObjectContext] sectionNameKeyPath:@"sectionIdentifier" cacheName:nil];
    _fetchedResultsController.delegate = self;
	return _fetchedResultsController;
}

#pragma mark - NSFetchResultController Delegate Methods

- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller
{
    // The fetch controller is about to start sending change notifications, so prepare the table view for updates.
    [self.tableView beginUpdates];
}


- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type newIndexPath:(NSIndexPath *)newIndexPath
{
    UITableView *tableView = self.tableView;
    switch(type) {
        case NSFetchedResultsChangeInsert: {
            [self reloadHeaderViewForSection:(int)newIndexPath.section];
            if (selectedSection != newIndexPath.section) return;
            [tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:newIndexPath.row+1 inSection:newIndexPath.section]] withRowAnimation:UITableViewRowAnimationFade];
            break;
    }
        case NSFetchedResultsChangeDelete: {
            [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:indexPath.row+1 inSection:indexPath.section]] withRowAnimation:UITableViewRowAnimationFade];
            [self reloadHeaderViewForSection:(int)indexPath.section];
            break;
        }
        case NSFetchedResultsChangeUpdate:
            [self reloadHeaderViewForSection:(int)newIndexPath.section];
            if (selectedSection != newIndexPath.section) return;
            [tableView deleteRowsAtIndexPaths:[NSArray
                                               arrayWithObject:[NSIndexPath indexPathForRow:indexPath.row+1 inSection:indexPath.section]] withRowAnimation:UITableViewRowAnimationFade];
            [tableView insertRowsAtIndexPaths:[NSArray
                                               arrayWithObject:[NSIndexPath indexPathForRow:indexPath.row+1 inSection:indexPath.section]] withRowAnimation:UITableViewRowAnimationFade];
            break;
        case NSFetchedResultsChangeMove:
            if (selectedSection == indexPath.section) {
                [tableView deleteRowsAtIndexPaths:[NSArray
                                                   arrayWithObject:[NSIndexPath indexPathForRow:indexPath.row+1 inSection:indexPath.section]] withRowAnimation:UITableViewRowAnimationFade];
            }
            if (selectedSection == newIndexPath.section) {
                [tableView insertRowsAtIndexPaths:[NSArray
                                                   arrayWithObject:[NSIndexPath indexPathForRow:newIndexPath.row+1 inSection:newIndexPath.section]] withRowAnimation:UITableViewRowAnimationFade];
            }
            break;
    }
}

- (void)controller:(NSFetchedResultsController *)controller didChangeSection:(id )sectionInfo atIndex:(NSUInteger)sectionIndex forChangeType:(NSFetchedResultsChangeType)type
{
    switch(type) {
        case NSFetchedResultsChangeInsert:
            [self.tableView insertSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
            break;
        case NSFetchedResultsChangeDelete:
            [self.tableView deleteSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
            selectedSection = -1;
            break;
        case NSFetchedResultsChangeMove:
            break;
        case NSFetchedResultsChangeUpdate:
            break;
    }
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller
{
    // The fetch controller has sent all current change notifications, so tell the table view to process all updates.
    [self.tableView endUpdates];
    self.noEntryLabel.hidden = [[self.fetchedResultsController sections] count] ? YES : NO;
}

#pragma mark - IBAction Methods

- (void)didTouchUpInsideAddButton
{
    IRAddExpenseViewController *addExpenseViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"AddExpenseViewController"];
    [self.navigationController pushViewController:addExpenseViewController animated:YES];
}

@end
