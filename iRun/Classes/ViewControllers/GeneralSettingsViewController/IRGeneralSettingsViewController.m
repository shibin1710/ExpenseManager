//
//  IRGeneralSettingsViewController.m
//  ExpenseManager
//
//  Created by Shibin S on 13/09/14.
//  Copyright (c) 2014 Shibin. All rights reserved.
//

#import "IRGeneralSettingsViewController.h"
#import "IRCommon.h"
#import "IRGeneralSettingsTableViewCell.h"
#import "IRApplicationController.h"

@interface IRGeneralSettingsViewController () {
    NSNumber *groupingCode;
    BOOL isReminderEnabled;
    BOOL isAdapterReminderEnabled;
    NSDate *pickerDate;
    NSNumber *trackMode;
    NSNumber *languageCode;
}
@property (weak, nonatomic) IBOutlet UITableView *generalSettingsTableView;
@property (weak, nonatomic) IBOutlet UIDatePicker *datePicker;
@property (weak, nonatomic) IBOutlet UIView *datePickerView;
@property (weak, nonatomic) IBOutlet UIView *backgroundView;
@property (weak, nonatomic) IBOutlet UILabel *selectTimeLabel;

@end

@implementation IRGeneralSettingsViewController

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
    self.selectTimeLabel.text = [IRCommon localizeText:@"Select Time"];
    self.navigationItem.title = [IRCommon localizeText:@"General"];
    self.generalSettingsTableView.tintColor = [IRCommon getThemeColor];
    groupingCode = [[NSUserDefaults standardUserDefaults]objectForKey:@"grouping"];
    languageCode = [[NSUserDefaults standardUserDefaults]objectForKey:@"languageCode"];

    self.datePickerView.layer.borderWidth = 1.0;
    self.datePickerView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.datePickerView.layer.shadowRadius = 2.0f;
    self.datePickerView.layer.shadowColor = [UIColor lightGrayColor].CGColor;
    pickerDate = [[NSUserDefaults standardUserDefaults]objectForKey:@"reminderTime"];
    trackMode = [[NSUserDefaults standardUserDefaults]objectForKey:@"trackMode"];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 4;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    switch (section) {
        case 0:
            return 3;
            break;
        case 1:
            return 2;
            break;
        case 2:
            return 2;
            break;
        case 3:
            return 2;
            break;
        default:
            return 1;
            break;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 30;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"GeneralHeaderCell"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"GeneralHeaderCell"];
    }
    cell.textLabel.font = [IRCommon getDefaultFontForSize:14 isBold:YES];
    cell.textLabel.textColor = [UIColor darkGrayColor];
    cell.backgroundColor = [UIColor groupTableViewBackgroundColor];
    switch (section) {
        case 0:
            cell.textLabel.text = [IRCommon localizeText:@"Grouping"];
            break;
        case 1:
            cell.textLabel.text = [IRCommon localizeText:@"Language"];
            break;
        case 2:
            cell.textLabel.text = [IRCommon localizeText:@"Mode"];
            break;
        case 3:
            cell.textLabel.text = [IRCommon localizeText:@"Reminder"];
            break;
        default:
            cell.textLabel.text = @"";
            break;
    }
    return cell;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    IRGeneralSettingsTableViewCell *cell = (IRGeneralSettingsTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"GeneralSettingsCell" forIndexPath:indexPath];
    isReminderEnabled = [[[NSUserDefaults standardUserDefaults]objectForKey:@"dailyReminder"]boolValue];
    isAdapterReminderEnabled = [[[NSUserDefaults standardUserDefaults]objectForKey:@"isAdapterReminderEnabled"]boolValue];
    if (cell == nil) {
        cell = [[IRGeneralSettingsTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"GeneralSettingsCell"];
    }
    cell.name.font = cell.timeLabel.font = [IRCommon getDefaultFontForSize:15.0f isBold:NO];
    cell.reminderSwitch.onTintColor = [IRCommon getThemeColor];
    cell.selectionStyle = UITableViewCellEditingStyleNone;
    cell.timeLabel.hidden = YES;
    if (indexPath.section == 0) {
        cell.reminderSwitch.hidden = YES;
        cell.accessoryType = (groupingCode.intValue == (int)indexPath.row) ? UITableViewCellAccessoryCheckmark : UITableViewCellAccessoryNone;
        switch (indexPath.row) {
            case 0:
                cell.name.text = [IRCommon localizeText:@"Weekly"];
                break;
            case 1:
                cell.name.text = [IRCommon localizeText:@"Monthly"];
                break;
            case 2:
                cell.name.text = [IRCommon localizeText:@"Yearly"];
                break;
            default:
                break;
        }
    } else if (indexPath.section == 1) {
        cell.reminderSwitch.hidden = YES;
        cell.accessoryType = (languageCode.intValue == (int)indexPath.row) ? UITableViewCellAccessoryCheckmark : UITableViewCellAccessoryNone;
        switch (indexPath.row) {
            case 0:
                cell.name.text = [IRCommon localizeText:@"Default"];
                break;
            case 1:
                cell.name.text = [IRCommon localizeText:@"English"];
                break;
            default:
                break;
        }
        cell.reminderSwitch.hidden = YES;
        
    } else if (indexPath.section == 3) {
        cell.delegate = self;
        switch (indexPath.row) {
            case 0:
                cell.reminderSwitch.hidden = NO;
                cell.reminderSwitch.on = isReminderEnabled;
                cell.reminderSwitch.tag = 0;
                cell.name.text = [IRCommon localizeText:@"Daily Reminder"];
                break;
            case 1:
                cell.reminderSwitch.hidden = YES;
                cell.name.text = [IRCommon localizeText:@"Time of day"];
                cell.timeLabel.hidden = NO;
                cell.timeLabel.text = [IRCommon getDate:[[NSUserDefaults standardUserDefaults]objectForKey:@"reminderTime"] inFormat:@"hh:mm aa"];
                cell.name.alpha = isReminderEnabled ? 1 : 0.6;
                cell.timeLabel.alpha = isReminderEnabled ? 1 : 0.6;
                break;
            case 2:
                cell.name.alpha = isReminderEnabled ? 1 : 0.6;
                cell.userInteractionEnabled = isReminderEnabled ? YES : NO;
                cell.timeLabel.alpha = isReminderEnabled ? 1 : 0.6;
                cell.reminderSwitch.hidden = NO;
                cell.reminderSwitch.on = isReminderEnabled ? isAdapterReminderEnabled : NO;
                cell.reminderSwitch.tag = 1;
                cell.name.text = [IRCommon localizeText:@"Adapted Reminder"];
                break;
            default:
                break;
        }
    } else if (indexPath.section == 2) {
        cell.reminderSwitch.hidden = YES;
        cell.accessoryType = (trackMode.intValue == (int)indexPath.row) ? UITableViewCellAccessoryCheckmark : UITableViewCellAccessoryNone;
        switch (indexPath.row) {
            case 0:
                cell.name.text = [IRCommon localizeText:@"Expense"];
                break;
            case 1:
                cell.name.text = [IRCommon localizeText:@"Expense And Income"];
                break;
            default:
                break;
        }
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.section) {
        case 0:
        {
            if (groupingCode) {
                UITableViewCell *selectedCell = [tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:groupingCode.intValue inSection:0]];
                selectedCell.accessoryType = UITableViewCellAccessoryNone;
            }
            UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
            groupingCode = [NSNumber numberWithInt:(int)indexPath.row];
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
            [[NSUserDefaults standardUserDefaults]setObject:[NSNumber numberWithInt:(int)indexPath.row] forKey:@"grouping"];
            break;
        }
        case 1:
        {
            if (languageCode) {
                UITableViewCell *selectedCell = [tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:languageCode.intValue inSection:1]];
                selectedCell.accessoryType = UITableViewCellAccessoryNone;
            }
            UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
            languageCode = [NSNumber numberWithInt:(int)indexPath.row];
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
            [[NSUserDefaults standardUserDefaults]setObject:[NSNumber numberWithInt:(int)indexPath.row] forKey:@"languageCode"];
            [self.generalSettingsTableView reloadData];
            break;
        }
        case 2:
        {
            if (trackMode) {
                UITableViewCell *selectedCell = [tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:trackMode.intValue inSection:2]];
                selectedCell.accessoryType = UITableViewCellAccessoryNone;
            }
            UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
            trackMode = [NSNumber numberWithInt:(int)indexPath.row];
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
            [[NSUserDefaults standardUserDefaults]setObject:[NSNumber numberWithInt:(int)indexPath.row] forKey:@"trackMode"];
            break;
        }
         case 3:
        {
            if (indexPath.row == 1) {
                if (!isReminderEnabled) return;
                self.datePickerView.backgroundColor = [UIColor whiteColor];
                self.datePicker.date = [[NSUserDefaults standardUserDefaults]objectForKey:@"reminderTime"];
                self.datePickerView.hidden = NO;
                self.backgroundView.hidden = NO;
                self.backgroundView.alpha = 0.3;
            } else if (indexPath.row == 2) {
                if (!isReminderEnabled)
                    return;
//                self.datePickerView.backgroundColor = [UIColor whiteColor];
//                self.datePicker.date = [[NSUserDefaults standardUserDefaults]objectForKey:@"reminderTime"];
//                self.datePickerView.hidden = NO;
//                self.backgroundView.hidden = NO;
                self.backgroundView.alpha = 0.3;
            }
        }
        default:
            break;
    }
}

#pragma mark - Settings Delegate Methods

- (void)reminderSwitchValueChanged:(UISwitch *)reminderSwitch
{
    switch (reminderSwitch.tag) {
        case 0:
            reminderSwitch.on ? [[NSUserDefaults standardUserDefaults]setObject:[NSNumber numberWithBool:YES] forKey:@"dailyReminder"] : [[NSUserDefaults standardUserDefaults]setObject:[NSNumber numberWithBool:NO] forKey:@"dailyReminder"];
            if (!reminderSwitch.on) {
                [[NSUserDefaults standardUserDefaults]setObject:[NSNumber numberWithBool:NO] forKey:@"isAdapterReminderEnabled"];
            }
            break;
            
        case 1:
            reminderSwitch.on ? [[NSUserDefaults standardUserDefaults]setObject:[NSNumber numberWithBool:YES] forKey:@"isAdapterReminderEnabled"] : [[NSUserDefaults standardUserDefaults]setObject:[NSNumber numberWithBool:NO] forKey:@"isAdapterReminderEnabled"];
            break;
        default:
            break;
    }
    [self.generalSettingsTableView reloadData];

    [[IRApplicationController sharedInstance]showAlertForDailyReminder];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
- (IBAction)didTouchUpInsideOkButton:(id)sender
{
    self.datePickerView.hidden = YES;
    self.backgroundView.hidden = YES;
    [[NSUserDefaults standardUserDefaults]setObject:pickerDate forKey:@"reminderTime"];
    [self.generalSettingsTableView reloadData];
    [[IRApplicationController sharedInstance]showAlertForDailyReminder];
}

- (IBAction)didTouchUpInsideCancelButton:(id)sender
{
    self.datePickerView.hidden = YES;
    self.backgroundView.hidden = YES;
}
- (IBAction)didChangeValueOfDatePicker:(id)sender
{
    UIDatePicker *picker = (UIDatePicker *)sender;
    pickerDate = picker.date;
}

@end
