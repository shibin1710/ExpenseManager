//
//  IRCoreDataController.h
//  ExpenseManager
//
//  Created by Shibin S on 04/09/14.
//  Copyright (c) 2014 Shibin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class IRExpense;
@class IRCategory;

@interface IRCoreDataController : NSObject

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;

// Expense
+ (IRCoreDataController *)sharedInstance;
- (BOOL)saveExpense:(IRExpense *)expenseData;
- (BOOL)updateExpense:(IRExpense *)expense forId:(NSString *)expenseId;
- (NSArray *)fetchExpenseData;
- (NSArray *)fetchExpenseData:(BOOL)isExpense;
- (NSArray *)fetchExpenseForCurrentMonth:(BOOL)isExpense;
- (NSArray *)fetchExpenseForCurrentMonth;
- (BOOL)deleteExpenseWithExpenseId:(NSString *)expenseId;
- (BOOL)deleteAllExpenseData;
- (BOOL)deleteAllCategories;


// Category
- (NSArray *)fetchCategoriesForExpense:(BOOL)isExpense;
- (BOOL)addCategory:(IRCategory *)category;
- (BOOL)updateCategory:(NSString *)categoryName withCategory:(IRCategory *)category;
- (BOOL)deleteCategoryWithName:(NSString *)category;
- (BOOL)updateExpenseForCategory:(NSString *)oldCategory with:(NSString *)newCategory;
- (NSArray *)getExpensesForCurrentMonthForCategory:(NSString *)category;

@end
