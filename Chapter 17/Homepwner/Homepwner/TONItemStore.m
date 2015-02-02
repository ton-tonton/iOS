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
        _privateItems = [[NSMutableArray alloc] init];
    }
    
    return self;
}

-(NSArray *)allItems
{
    return self.privateItems;
}

-(TONItem *)createItem
{
    TONItem *item = [TONItem randomItem];
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

@end
