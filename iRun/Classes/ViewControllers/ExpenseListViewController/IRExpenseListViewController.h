//
//  IRExpenseDetailViewController.h
//  ExpenseManager
//
//  Created by Shibin S on 08/09/14.
//  Copyright (c) 2014 Shibin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@interface IRExpenseListViewController : UIViewController <UITableViewDataSource,UITableViewDelegate,UIAlertViewDelegate,NSFetchedResultsControllerDelegate>

@property (strong, nonatomic) NSString *categoryName;
@property (assign, nonatomic) float categoryExpense;
@property (assign, nonatomic) BOOL isExpense;
@property (nonatomic,strong) NSManagedObjectContext* managedObjectContext;
@property (nonatomic, retain) NSFetchedResultsController *fetchedResultsController;

@end
