//
//  TONItemStore.m
//  Homepwner
//
//  Created by Tawatchai Sunarat on 1/24/15.
//  Copyright (c) 2015 pddk. All rights reserved.
//

#import "TONItemStore.h"
#import "TONItem.h"
#import "TONImageStore.h"
#import "TONAppDelegate.h"

@import CoreData;

@interface TONItemStore ()

@property (nonatomic) NSMutableArray *privateItems;
@property (nonatomic, strong) NSMutableArray *allAssetTypes;
@property (nonatomic, strong) NSManagedObjectContext *context;
@property (nonatomic, strong) NSManagedObjectModel *model;

@end

@implementation TONItemStore

#pragma mark - initail

+(instancetype)sharedStore
{
    static TONItemStore *sharedStore = nil;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        sharedStore = [[self alloc] initPrivate];
    });
    
    return sharedStore;
}

-(instancetype)init
{
    @throw [NSException exceptionWithName:@"Singleton"
                                   reason:@"Use +[TONItemstore sharedStore]"
                                 userInfo:nil];
    return nil;
}

-(instancetype)initPrivate
{
    self = [super init];
    if (self) {
        
        _model = [NSManagedObjectModel mergedModelFromBundles:nil];
        NSPersistentStoreCoordinator *psc = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:_model];
        NSString *path = [self itemArchivePath];
        NSURL *storeUrl = [NSURL fileURLWithPath:path];
        NSError *err = nil;
        
        if (
            ![psc addPersistentStoreWithType:NSSQLiteStoreType
                               configuration:nil
                                         URL:storeUrl
                                     options:nil
                                       error:&err]
            ) {
            @throw [NSException exceptionWithName:@"OpenFailure" reason:@"error localizedDescription" userInfo:nil];
        }
        
        _context = [[NSManagedObjectContext alloc] init];
        _context.persistentStoreCoordinator = psc;
        [self loadAllItems];
        
    }
    
    return self;
}

#pragma mark - handle function

-(NSArray *)allItems
{
    return self.privateItems;
}

-(TONItem *)createItem
{
    double order;
    
    if ([self.allItems count] == 0) {
        
        order = 1.0;
    } else {
        
        order = [[self.privateItems lastObject] orderingValue] + 1.0;
    }
    
    NSLog(@"Adding after %d items, order = %.2f", [self.privateItems count], order);
    
    TONItem *item = [NSEntityDescription insertNewObjectForEntityForName:@"TONItem"
                                                  inManagedObjectContext:self.context];
    
    item.serialNumber = [TONItem randomSerialNumber];
    item.orderingValue = order;
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    item.valueInDollars = [defaults integerForKey:TONNextItemValuePrefsKey];
    item.itemName = [defaults objectForKey:TONNextItemNamePrefsKey];
    
    NSLog(@"defaults: %@", [defaults dictionaryRepresentation]);
    
    [self.privateItems addObject:item];
    return item;
}

-(NSArray *)allAssetTypes
{
    if (!_allAssetTypes) {
        
        NSFetchRequest *req = [[NSFetchRequest alloc] init];
        NSEntityDescription *e = [NSEntityDescription entityForName:@"TONAssetType"
                                             inManagedObjectContext:self.context];
        req.entity = e;
        
        NSError *err;
        NSArray *result = [self.context executeFetchRequest:req error:&err];
        
        if (!result) {
            [NSException raise:@"FetchFailed" format:@"%@",[err localizedDescription]];
        }
        
        _allAssetTypes = [result mutableCopy];
    }
    
    if ([_allAssetTypes count] == 0) {
        
        NSManagedObject *type = [NSEntityDescription insertNewObjectForEntityForName:@"TONAssetType"
                                                              inManagedObjectContext:self.context];
        [type setValue:@"Animal" forKey:@"label"];
        [_allAssetTypes addObject:type];
        
        type =  [NSEntityDescription insertNewObjectForEntityForName:@"TONAssetType"
                                              inManagedObjectContext:self.context];
        [type setValue:@"Natural" forKey:@"label"];
        [_allAssetTypes addObject:type];
        
        type =  [NSEntityDescription insertNewObjectForEntityForName:@"TONAssetType"
                                              inManagedObjectContext:self.context];
        [type setValue:@"Town" forKey:@"label"];
        [_allAssetTypes addObject:type];
    }
    
    return _allAssetTypes;
}

-(void)removeItem:(TONItem *)item
{
    [[TONImageStore sharedStroe] deleteImageForKey:item.imageKey];
    [self.context deleteObject:item];
    [self.privateItems removeObjectIdenticalTo:item];
}

-(void)moveItemAtIndex:(NSInteger)fromIndex toIndex:(NSInteger)toIndex
{
    TONItem *moveItem = [self.privateItems objectAtIndex:fromIndex];
    [self.privateItems removeObjectAtIndex:fromIndex];
    [self.privateItems insertObject:moveItem atIndex:toIndex];
    
    double lowerBound = 0.0;
    double upperBound = 0.0;
    
    if (toIndex > 0) {
        lowerBound = [self.privateItems[(toIndex - 1)] orderingValue];
    } else {
        lowerBound = [self.privateItems[1] orderingValue] - 2.0;
    }
    
    if (toIndex < [self.privateItems count] - 1) {
        upperBound = [self.privateItems[(toIndex + 1)] orderingValue];
    } else {
        upperBound = [self.privateItems[(toIndex - 1)] orderingValue] + 2.0;
    }
    
    double nowOrderValue = (lowerBound + upperBound) / 2.0;
    NSLog(@"moving to order %f", nowOrderValue);
    moveItem.orderingValue = nowOrderValue;
}

#pragma mark - read-write file

-(NSString *)itemArchivePath
{
    NSArray *directories = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *directory = [directories firstObject];
    return [directory stringByAppendingPathComponent:@"store.data"];
}

-(void)loadAllItems
{
    if (!_privateItems) {
        
        NSFetchRequest *req = [[NSFetchRequest alloc] init];
        NSEntityDescription *e = [NSEntityDescription entityForName:@"TONItem"
                                             inManagedObjectContext:self.context];
        req.entity = e;
        
        NSSortDescriptor *sortdes = [NSSortDescriptor sortDescriptorWithKey:@"orderingValue"
                                                                  ascending:YES];
        req.sortDescriptors = @[sortdes];
        
        NSError *err;
        NSArray *result = [self.context executeFetchRequest:req error:&err];
        
        if (!result) {
            [NSException raise:@"Fetch failed" format:@"Reason: %@", [err localizedDescription]];
        }
        
        self.privateItems = [[NSMutableArray alloc] initWithArray:result];
    }
}

-(BOOL)saveChanges
{
    NSError *err;
    BOOL successful = [_context save:&err];
    
    if (!successful) {
        NSLog(@"Error saving:%@", [err localizedDescription]);
    }
    
    return successful;
}

@end
