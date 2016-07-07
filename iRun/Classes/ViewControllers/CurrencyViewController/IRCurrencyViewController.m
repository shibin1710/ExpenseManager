
//
//  IRCurrencyViewController.m
//  ExpenseManager
//
//  Created by Shibin S on 07/09/14.
//  Copyright (c) 2014 Shibin. All rights reserved.
//

#import "IRCurrencyViewController.h"
#import "IRCommon.h"

@interface IRCurrencyViewController () {
    NSString *selectedCurrency;
    NSIndexPath *selectedIndexPath;
}

@property (strong, nonatomic) NSMutableArray *currencyCodeList;
@property (strong, nonatomic) NSMutableArray *currencyNameList;
@property (strong, nonatomic) NSArray *searchResults;
@property (weak, nonatomic) IBOutlet UITableView *currencyTableView;

@end

@implementation IRCurrencyViewController

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
    self.navigationItem.title = [IRCommon localizeText:@"Currency"];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemSearch target:self action:@selector(didTouchUpInsideSearchButton)];
    self.currencyCodeList = [[NSMutableArray alloc]init];
    self.currencyNameList = [[NSMutableArray alloc]init];
    int counter = 0;
    NSLocale *locale = [NSLocale currentLocale];
    for (NSString *code in [NSLocale commonISOCurrencyCodes]) {
        [self.currencyCodeList addObject:[NSString stringWithFormat:@"%@", code]];
        NSString *currencyName = [locale displayNameForKey:NSLocaleCurrencyCode value:code];
        !currencyName ? [self.currencyNameList addObject:[NSString stringWithFormat:@"%@",code]] : [self.currencyNameList addObject:[NSString stringWithFormat:@"%@ : %@",code,currencyName]];
        if ([code isEqualToString:[[NSUserDefaults standardUserDefaults]objectForKey:@"currency"]]) {
            selectedCurrency = [NSString stringWithFormat:@"%@", [[NSUserDefaults standardUserDefaults]objectForKey:@"currency"]];
            selectedIndexPath = [NSIndexPath indexPathForRow:counter inSection:0];
        }
        counter ++;
    }
    
    [self.currencyTableView scrollToRowAtIndexPath:selectedIndexPath atScrollPosition:UITableViewScrollPositionMiddle animated:NO];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)didTouchUpInsideSearchButton
{
    [self.searchDisplayController.searchBar becomeFirstResponder];
}

#pragma mark - UITableView Datasource Methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return (tableView == self.searchDisplayController.searchResultsTableView) ? self.searchResults.count : self.currencyCodeList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CurrencyCell" forIndexPath:indexPath];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"CurrencyCell"];
    }
    cell.textLabel.font = [IRCommon getDefaultFontForSize:12.0 isBold:NO];
    cell.textLabel.text = (tableView == self.searchDisplayController.searchResultsTableView) ? [self.searchResults objectAtIndex:indexPath.row] : [self.currencyNameList objectAtIndex:indexPath.row];
    cell.accessoryType = ([[[cell.textLabel.text componentsSeparatedByString:@" "]firstObject] isEqualToString:selectedCurrency]) ? UITableViewCellAccessoryCheckmark : UITableViewCellAccessoryNone;
    cell.tintColor = [IRCommon getThemeColor];
    cell.selectionStyle = UITableViewCellEditingStyleNone;
    return cell;
}

#pragma mark - UITableView Delegate Methods

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *previousCell = [tableView cellForRowAtIndexPath:selectedIndexPath];
    if (previousCell) {
        previousCell.accessoryType = UITableViewCellAccessoryNone;
    }
    selectedIndexPath = indexPath;
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    cell.accessoryType = UITableViewCellAccessoryCheckmark;
    selectedCurrency = [[cell.textLabel.text componentsSeparatedByString:@" "]firstObject];
    [[NSUserDefaults standardUserDefaults]setObject:selectedCurrency forKey:@"currency"];
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    cell.accessoryType = UITableViewCellAccessoryNone;
}

- (void)filterContentForSearchText:(NSString*)searchText scope:(NSString*)scope
{
    NSPredicate *resultPredicate = [NSPredicate predicateWithFormat:@"self contains[c] %@", searchText];
    self.searchResults = [self.currencyNameList filteredArrayUsingPredicate:resultPredicate];
}


-(BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString
{
    [self filterContentForSearchText:searchString scope:[[self.searchDisplayController.searchBar scopeButtonTitles] objectAtIndex:[self.searchDisplayController.searchBar selectedScopeButtonIndex]]];
    return YES;
}

- (void) searchDisplayControllerDidEndSearch:(UISearchDisplayController *)controller
{
    [self.currencyTableView reloadData];
}

@end
