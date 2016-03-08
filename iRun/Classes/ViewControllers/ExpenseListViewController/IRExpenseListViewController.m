//
//  IRExpenseDetailViewController.m
//  ExpenseManager
//
//  Created by Shibin S on 08/09/14.
//  Copyright (c) 2014 Shibin. All rights reserved.
//

#import "IRExpenseListViewController.h"
#import "IRCoreDataController.h"
#import "IRExpense.h"
#import "IRCategoryExpenseTableViewCell.h"
#import "IRCommon.h"
#import "IRExpenseHeaderTableViewCell.h"
#import "IRAddExpenseViewController.h"

@interface IRExpenseListViewController () {
    NSString *currencyCode;
}

@property (strong, nonatomic) NSArray *expenseForCategory;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

#pragma mark - View lifecycle

@implementation IRExpenseListViewController

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
    self.navigationItem.title = self.categoryName;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    NSError *error;
    if (![[self fetchedResultsController] performFetch:&error]) {
		NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
		exit(-1);  // Fail
	}
    currencyCode = [[NSUserDefaults standardUserDefaults]objectForKey:@"currency"];
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

#pragma mark - NSFetchResultController Setter Method

- (NSFetchedResultsController *)fetchedResultsController {
    
    if (_fetchedResultsController != nil) {
        return _fetchedResultsController;
    }
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSManagedObjectContext *context = [IRCoreDataController sharedInstance].managedObjectContext;
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Expense" inManagedObjectContext:context];
    [fetchRequest setEntity:entity];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(date >= %@) AND (date <= %@) AND category == %@ AND isExpense == %@",[IRCommon startOfMonth], [IRCommon endOfMonth],self.categoryName,[NSNumber numberWithBool:self.isExpense]];
    [fetchRequest setPredicate:predicate];
    NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"date" ascending:NO];
    [fetchRequest setSortDescriptors:@[sortDescriptor]];
    [fetchRequest setFetchBatchSize:20];
    NSFetchedResultsController *theFetchedResultsController =
    [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:context sectionNameKeyPath:nil cacheName:nil];
    self.fetchedResultsController = theFetchedResultsController;
    _fetchedResultsController.delegate = self;
    return _fetchedResultsController;
}

#pragma mark - UITableView Datasource Methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[[_fetchedResultsController sections] objectAtIndex:section]numberOfObjects];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return self.categoryName;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    IRCategoryExpenseTableViewCell *cell = (IRCategoryExpenseTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"ExpenseDetailCell" forIndexPath:indexPath];
    if (cell == nil) {
        cell = (IRCategoryExpenseTableViewCell *)[[IRCategoryExpenseTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"ExpenseDetailCell"];
    }
    [self configureCell:cell atIndexPath:indexPath];
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    IRExpenseHeaderTableViewCell* expenseHeader = (IRExpenseHeaderTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"ExpenseHeaderCell"];
    if (expenseHeader == nil) {
        expenseHeader = [[IRExpenseHeaderTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"ExpenseHeaderCell"];
    }
    expenseHeader.totalExpense.text = [NSString stringWithFormat:@"%@ %0.2f",[IRCommon getCurrencySymbolFromCode:currencyCode],self.categoryExpense];
    int colorCode = [IRCommon getColorCodeForCategory:self.categoryName andIsExpense:YES];
    expenseHeader.totalExpense.textColor = [IRCommon getColorForColorCode:colorCode];
    expenseHeader.backgroundColor = [UIColor greenColor];
    return expenseHeader;
}

#pragma mark - UITableView Delegate Methods

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    IRAddExpenseViewController *editExpenseViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"AddExpenseViewController"];
    editExpenseViewController.type = EMEdit;
    Expense *expense = [self.fetchedResultsController objectAtIndexPath:[NSIndexPath indexPathForRow:indexPath.row inSection:indexPath.section]];
    IRExpense *expenseModal = [[IRExpense alloc]init];
    expenseModal = [expenseModal readFromEntity:expense];
    editExpenseViewController.expenseDetails = expenseModal;
    editExpenseViewController.selectedIndexPath = [NSIndexPath indexPathForRow:[IRCommon getIndexForCategory:expenseModal.category isExpense:expenseModal.isExpense] inSection:0];
    [self.navigationController pushViewController:editExpenseViewController animated:YES];
}

#pragma mark - UITableView Delegate Methods

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:APPLICATION_NAME message:[IRCommon localizeText:@"Do you want to delete the record?"] delegate:self cancelButtonTitle:[IRCommon localizeText:@"Cancel"] otherButtonTitles:[IRCommon localizeText:OK_TEXT], nil];
        alertView.tag = indexPath.row + 99999;
        [alertView show];
    }
}

#pragma mark - UIAlertView Delegate Methods

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        Expense *expense = [_fetchedResultsController objectAtIndexPath:[NSIndexPath indexPathForRow:alertView.tag - 99999 inSection:0]];
        IRExpense *expenseModel = [[IRExpense alloc]init];
        expenseModel = [expenseModel readFromEntity:expense];
        [[IRCoreDataController sharedInstance]deleteExpenseWithExpenseId:expenseModel.expenseId];
    }
}

#pragma mark - Private Methods

- (void)configureCell:(IRCategoryExpenseTableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath
{
    Expense *expense = [_fetchedResultsController objectAtIndexPath:indexPath];
    IRExpense *expenseModel = [[IRExpense alloc]init];
    expenseModel = [expenseModel readFromEntity:expense];
    cell.date.font = [IRCommon getDefaultFontForSize:11 isBold:YES];
    cell.note.font = [IRCommon getDefaultFontForSize:11 isBold:NO];
    cell.amount.font = [IRCommon getDefaultFontForSize:11 isBold:YES];
    NSString *time = [IRCommon getDate:expenseModel.date inFormat:@"hh:mm aa"];
    NSString *dateString;
    if ([IRCommon isToday:expenseModel.date]) {
        dateString = [NSString stringWithFormat:@"Today %@",time];
    } else if ([IRCommon isYesterday:expenseModel.date]) {
        dateString = [NSString stringWithFormat:@"Yesterday %@",time];
    } else if ([IRCommon isTomorrow:expenseModel.date]) {
        dateString = [NSString stringWithFormat:@"Tomorrow %@",time];
    } else {
        dateString = [IRCommon getDate:expenseModel.date inFormat:@"dd/MM/yy hh:mm aa"];
    }
    cell.date.text = dateString;
    cell.note.text = expenseModel.note;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.amount.text = [NSString stringWithFormat:@"%@ %0.2f",[IRCommon getCurrencySymbolFromCode:currencyCode],expenseModel.amount];
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
        case NSFetchedResultsChangeInsert:
            [tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
        case NSFetchedResultsChangeDelete:
            [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
        case NSFetchedResultsChangeUpdate:
            [self configureCell:(IRCategoryExpenseTableViewCell *)[tableView cellForRowAtIndexPath:indexPath] atIndexPath:indexPath];
            break;
        case NSFetchedResultsChangeMove:
            [tableView deleteRowsAtIndexPaths:[NSArray
                                               arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
            [tableView insertRowsAtIndexPaths:[NSArray
                                               arrayWithObject:newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
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
}

@end
