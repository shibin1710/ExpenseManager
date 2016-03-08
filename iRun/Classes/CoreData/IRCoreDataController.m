//
//  IRCoreDataController.m
//  ExpenseManager
//
//  Created by Shibin S on 04/09/14.
//  Copyright (c) 2014 Shibin. All rights reserved.
//

#import "IRCoreDataController.h"
#import "IRExpense.h"
#import "Expense.h"
#import "IRCommon.h"
#import "CategoryGroup.h"
#import "IRCategory.h"

static IRCoreDataController *instance = nil;

@implementation IRCoreDataController

@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;

#pragma mark - Singleton Methods

+ (IRCoreDataController *)sharedInstance
{
    if (instance) {
        return instance;
    }
    instance = [[self alloc]init];
    return instance;
}

- (void)saveContext
{
    NSError *error = nil;
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil) {
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
            // Replace this implementation with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
}

#pragma mark - Core Data stack

// Returns the managed object context for the application.
// If the context doesn't already exist, it is created and bound to the persistent store coordinator for the application.
- (NSManagedObjectContext *)managedObjectContext
{
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (coordinator != nil) {
        _managedObjectContext = [[NSManagedObjectContext alloc] init];
        [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    }
    return _managedObjectContext;
}

// Returns the managed object model for the application.
// If the model doesn't already exist, it is created from the application's model.
- (NSManagedObjectModel *)managedObjectModel
{
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"ExpenseManager" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

// Returns the persistent store coordinator for the application.
// If the coordinator doesn't already exist, it is created and the application's store added to it.
- (NSPersistentStoreCoordinator *)persistentStoreCoordinator
{
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"ExpenseManager.sqlite"];
    
    NSError *error = nil;
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    NSDictionary *options = [NSDictionary dictionaryWithObjectsAndKeys:
                             [NSNumber numberWithBool:YES], NSMigratePersistentStoresAutomaticallyOption,
                             [NSNumber numberWithBool:YES], NSInferMappingModelAutomaticallyOption, nil];
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:options error:&error]) {
        /*
         Replace this implementation with code to handle the error appropriately.
         
         abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
         
         Typical reasons for an error here include:
         * The persistent store is not accessible;
         * The schema for the persistent store is incompatible with current managed object model.
         Check the error message to determine what the actual problem was.
         
         
         If the persistent store is not accessible, there is typically something wrong with the file path. Often, a file URL is pointing into the application's resources directory instead of a writeable directory.
         
         If you encounter schema incompatibility errors during development, you can reduce their frequency by:
         * Simply deleting the existing store:
         [[NSFileManager defaultManager] removeItemAtURL:storeURL error:nil]
         
         * Performing automatic lightweight migration by passing the following dictionary as the options parameter:
         @{NSMigratePersistentStoresAutomaticallyOption:@YES, NSInferMappingModelAutomaticallyOption:@YES}
         
         Lightweight migration will only work for a limited set of schema changes; consult "Core Data Model Versioning and Data Migration Programming Guide" for details.
         
         */
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    return _persistentStoreCoordinator;
}

#pragma mark - Application's Documents directory

// Returns the URL to the application's Documents directory.
- (NSURL *)applicationDocumentsDirectory
{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

#pragma mark - Core Data Methods

- (BOOL)saveExpense:(IRExpense *)expenseData
{
    Expense *expense = [NSEntityDescription insertNewObjectForEntityForName:@"Expense" inManagedObjectContext:[self managedObjectContext]];
    expense.expenseId = expenseData.expenseId;
    expense.amount = [NSNumber numberWithDouble:expenseData.amount];
    expense.category = expenseData.category;
    expense.date = expenseData.date;
    expense.note = expenseData.note;
    expense.isExpense = [NSNumber numberWithBool:expenseData.isExpense];
    expense.image = expenseData.image;
    expense.currency = expenseData.currency;
    expense.isRecurring = [NSNumber numberWithBool:expenseData.isRecurring];
    expense.recurringDuration = [NSNumber numberWithDouble:expenseData.recurringDuration];
    expense.amount = [NSNumber numberWithDouble:expenseData.amount];
    NSError *error;
    if (![[self managedObjectContext] save:&error]) {
        return NO;
    }
    return YES;
}

- (BOOL)updateExpense:(IRExpense *)expense forId:(NSString *)expenseId
{
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Expense" inManagedObjectContext:[self managedObjectContext]];
    [fetchRequest setEntity:entity];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"expenseId == %@",expenseId];
    [fetchRequest setPredicate:predicate];
    NSError *error = nil;
    NSArray *fetchedObjects = [[self managedObjectContext] executeFetchRequest:fetchRequest error:&error];
    Expense *expenseEntity = [fetchedObjects lastObject];
    expenseEntity.amount = [NSNumber numberWithDouble:expense.amount];
    expenseEntity.category = expense.category;
    expenseEntity.currency = expense.currency;
    expenseEntity.date = expense.date;
    expenseEntity.image = expense.image;
    expenseEntity.isExpense = [NSNumber numberWithBool:expense.isExpense];
    expenseEntity.isRecurring = [NSNumber numberWithBool:expense.isRecurring];
    expenseEntity.note = expense.note;
    expenseEntity.recurringDuration = [NSNumber numberWithBool:expense.recurringDuration];
    expenseEntity.timeStamp = expense.date;
    if (![[self managedObjectContext] save:&error]) {
        return NO;
    }
    return YES;
}

- (NSArray *)fetchExpenseData
{
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Expense" inManagedObjectContext:[self managedObjectContext]];
    [fetchRequest setEntity:entity];
    NSError *error = nil;
    NSArray *fetchedObjects = [[self managedObjectContext] executeFetchRequest:fetchRequest error:&error];
    NSMutableArray *expenseModalArray = [[NSMutableArray alloc]init];
    for (Expense *expense in fetchedObjects) {
        IRExpense *expenseModel = [[IRExpense alloc]init];
        [expenseModalArray addObject:[expenseModel readFromEntity:expense]];
    }
    return expenseModalArray;
}

- (NSArray *)fetchExpenseData:(BOOL)isExpense
{
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Expense" inManagedObjectContext:[self managedObjectContext]];
    [fetchRequest setEntity:entity];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"isExpense == %@",[NSNumber numberWithBool:isExpense]];
    [fetchRequest setPredicate:predicate];
    NSError *error = nil;
    NSArray *fetchedObjects = [[self managedObjectContext] executeFetchRequest:fetchRequest error:&error];
    NSMutableArray *expenseModalArray = [[NSMutableArray alloc]init];
    for (Expense *expense in fetchedObjects) {
        IRExpense *expenseModel = [[IRExpense alloc]init];
        [expenseModalArray addObject:[expenseModel readFromEntity:expense]];
    }
    return expenseModalArray;
}

- (NSArray *)fetchExpenseForCurrentMonth:(BOOL)isExpense
{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(date >= %@) AND (date <= %@) AND isExpense == %@",[IRCommon startOfMonth], [IRCommon endOfMonth], [NSNumber numberWithBool:isExpense]];
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:[NSEntityDescription entityForName:@"Expense" inManagedObjectContext:[self managedObjectContext]]];
    [request setPredicate:predicate];
    NSError *error = nil;
    NSArray *fetchedObjects = [[self managedObjectContext] executeFetchRequest:request error:&error];
    NSMutableArray *expenseModalArray = [[NSMutableArray alloc]init];
    for (Expense *expense in fetchedObjects) {
        IRExpense *expenseModel = [[IRExpense alloc]init];
        [expenseModalArray addObject:[expenseModel readFromEntity:expense]];
    }
    return expenseModalArray;
}

- (NSArray *)fetchExpenseForCurrentMonth
{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(date >= %@) AND (date <= %@)",[IRCommon startOfMonth], [IRCommon endOfMonth]];
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:[NSEntityDescription entityForName:@"Expense" inManagedObjectContext:[self managedObjectContext]]];
    [request setPredicate:predicate];
    NSError *error = nil;
    NSArray *fetchedObjects = [[self managedObjectContext] executeFetchRequest:request error:&error];
    NSMutableArray *expenseModalArray = [[NSMutableArray alloc]init];
    for (Expense *expense in fetchedObjects) {
        IRExpense *expenseModel = [[IRExpense alloc]init];
        [expenseModalArray addObject:[expenseModel readFromEntity:expense]];
    }
    return expenseModalArray;
}

- (BOOL)addCategory:(IRCategory *)category
{
    CategoryGroup *categoryGroup = [NSEntityDescription insertNewObjectForEntityForName:@"CategoryGroup" inManagedObjectContext:[self managedObjectContext]];
    categoryGroup.categoryName = category.categoryName;
    categoryGroup.colorCode = [NSNumber numberWithInt:category.colorCode];
    categoryGroup.isExpense = [NSNumber numberWithBool:category.isExpense];
    categoryGroup.date = [NSDate date];
    categoryGroup.categoryID = [NSNumber numberWithInt:category.categoryID];
    NSError *error;
    if (![[self managedObjectContext] save:&error]) {
        
        return NO;
    }
    return YES;
}

- (BOOL)updateCategory:(NSString *)categoryName withCategory:(IRCategory *)category
{
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"CategoryGroup" inManagedObjectContext:[self managedObjectContext]];
    [fetchRequest setEntity:entity];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"categoryName == %@ && isExpense == %i",categoryName,category.isExpense];
    [fetchRequest setPredicate:predicate];
    NSError *error = nil;
    NSArray *fetchedObjects = [[self managedObjectContext] executeFetchRequest:fetchRequest error:&error];
    CategoryGroup *categoryGroup = [fetchedObjects lastObject];
    categoryGroup.categoryName = category.categoryName;
    categoryGroup.colorCode = [NSNumber numberWithInt:category.colorCode];
    categoryGroup.isExpense = [NSNumber numberWithBool:category.isExpense];
    if (category.categoryID != -1) {
        categoryGroup.categoryID = [NSNumber numberWithInt:category.categoryID];
    }
    
    if (![[self managedObjectContext] save:&error]) {
        return NO;
    }
    return YES;
}

- (NSArray *)fetchCategoriesForExpense:(BOOL)isExpense
{
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"CategoryGroup" inManagedObjectContext:[self managedObjectContext]];
    [fetchRequest setEntity:entity];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"isExpense == %@",[NSNumber numberWithBool:isExpense]];
    [fetchRequest setPredicate:predicate];
    NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"categoryID" ascending:YES];
    [fetchRequest setSortDescriptors:@[sortDescriptor]];
    NSError *error = nil;
    NSArray *fetchedObjects = [[self managedObjectContext] executeFetchRequest:fetchRequest error:&error];
    NSMutableArray *expenseModalArray = [[NSMutableArray alloc]init];
    for (CategoryGroup *category in fetchedObjects) {
        IRCategory *categoryModel = [[IRCategory alloc]init];
        [expenseModalArray addObject:[categoryModel readFromEntity:category]];
    }
    return expenseModalArray;
}

- (BOOL)deleteCategoryWithName:(NSString *)category
{
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"CategoryGroup" inManagedObjectContext:[self managedObjectContext]];
    [fetchRequest setEntity:entity];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"categoryName == %@",category];
    [fetchRequest setPredicate:predicate];
    NSError *error = nil;
    NSArray *fetchedObjects = [[self managedObjectContext] executeFetchRequest:fetchRequest error:&error];
    CategoryGroup *categoryGroup = [fetchedObjects lastObject];
    [[self managedObjectContext]deleteObject:categoryGroup];
    if (![[self managedObjectContext] save:&error]) {
        return NO;
    }
    return YES;
}

- (BOOL)updateExpenseForCategory:(NSString *)oldCategory with:(NSString *)newCategory
{
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Expense" inManagedObjectContext:[self managedObjectContext]];
    [fetchRequest setEntity:entity];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"category == %@",oldCategory];
    [fetchRequest setPredicate:predicate];
    NSError *error = nil;
    NSArray *fetchedObjects = [[self managedObjectContext] executeFetchRequest:fetchRequest error:&error];
    for (Expense *expense in fetchedObjects) {
        expense.category = newCategory;
    }
    if (![[self managedObjectContext] save:&error]) {
        return NO;
    }
    return YES;
}

- (NSArray *)getExpensesForCurrentMonthForCategory:(NSString *)category
{
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Expense" inManagedObjectContext:[self managedObjectContext]];
    [fetchRequest setEntity:entity];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"category == %@",category];
    [fetchRequest setPredicate:predicate];
    NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"date" ascending:YES];
    [fetchRequest setSortDescriptors:@[sortDescriptor]];
    NSError *error = nil;
    NSArray *fetchedObjects = [[self managedObjectContext] executeFetchRequest:fetchRequest error:&error];
    NSMutableArray *expenseModalArray = [[NSMutableArray alloc]init];
    for (Expense *expense in fetchedObjects) {
        IRExpense *expenseModel = [[IRExpense alloc]init];
        [expenseModalArray addObject:[expenseModel readFromEntity:expense]];
    }
    return expenseModalArray;
}

- (BOOL)deleteExpenseWithExpenseId:(NSString *)expenseId
{
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Expense" inManagedObjectContext:[self managedObjectContext]];
    [fetchRequest setEntity:entity];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"expenseId == %@",expenseId];
    [fetchRequest setPredicate:predicate];
    NSError *error = nil;
    NSArray *fetchedObjects = [[self managedObjectContext] executeFetchRequest:fetchRequest error:&error];
    Expense *expense = [fetchedObjects lastObject];
    [[self managedObjectContext]deleteObject:expense];
    if (![[self managedObjectContext] save:&error]) {
        return NO;
    }
    return YES;
}

- (BOOL)deleteAllExpenseData
{
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Expense" inManagedObjectContext:[self managedObjectContext]];
    [fetchRequest setEntity:entity];
    NSError *error = nil;
    NSArray *fetchedObjects = [[self managedObjectContext] executeFetchRequest:fetchRequest error:&error];
    for (Expense *expense in fetchedObjects) {
        [[self managedObjectContext]deleteObject:expense];
    }
    if (![[self managedObjectContext] save:&error]) {
        return NO;
    }
    return YES;
}

- (BOOL)deleteAllCategories
{
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"CategoryGroup" inManagedObjectContext:[self managedObjectContext]];
    [fetchRequest setEntity:entity];
    NSError *error = nil;
    NSArray *fetchedObjects = [[self managedObjectContext] executeFetchRequest:fetchRequest error:&error];
    for (CategoryGroup *category in fetchedObjects) {
        [[self managedObjectContext]deleteObject:category];
    }
    if (![[self managedObjectContext] save:&error]) {
        return NO;
    }
    return YES;
}

@end
