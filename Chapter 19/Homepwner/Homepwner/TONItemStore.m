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

@interface TONItemStore ()

@property (nonatomic) NSMutableArray *privateItems;

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
        
        NSString *path = [self itemArchivePath];
        self.privateItems = [NSKeyedUnarchiver unarchiveObjectWithFile:path];
        
        if (!self.privateItems) {
            self.privateItems = [[NSMutableArray alloc] init];
        }
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
    TONItem *item = [[TONItem alloc] init];
    [self.privateItems addObject:item];
    return item;
}

-(void)removeItem:(TONItem *)item
{
    [[TONImageStore sharedStroe] deleteImageForKey:item.imageKey];
    [self.privateItems removeObjectIdenticalTo:item];
}

-(void)moveItemAtIndex:(NSInteger)fromIndex toIndex:(NSInteger)toIndex
{
    TONItem *moveItem = [self.privateItems objectAtIndex:fromIndex];
    [self.privateItems removeObjectAtIndex:fromIndex];
    [self.privateItems insertObject:moveItem atIndex:toIndex];
}

#pragma mark - read-write file

-(NSString *)itemArchivePath
{
    NSArray *directories = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *directory = [directories firstObject];
    return [directory stringByAppendingPathComponent:@"items.archive"];
}

-(BOOL)saveChanges
{
    NSString *path = [self itemArchivePath];
    return [NSKeyedArchiver archiveRootObject:self.privateItems toFile:path];
}

@end
