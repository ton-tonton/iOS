//
//  TONItemStore.m
//  Homepwner
//
//  Created by Tawatchai Sunarat on 1/24/15.
//  Copyright (c) 2015 pddk. All rights reserved.
//

#import "TONItemStore.h"
#import "TONItem.h"

@interface TONItemStore ()

@property (nonatomic) NSMutableArray *privateOver50;
@property (nonatomic) NSMutableArray *privateOther;

@end

@implementation TONItemStore

+(instancetype)sharedStore
{
    static TONItemStore *sharedStore = nil;
    if (!sharedStore) {
        sharedStore = [[self alloc] initPrivate];
    }
    
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
        _privateOver50 = [[NSMutableArray alloc] init];
        _privateOther = [[NSMutableArray alloc] init];
    }
    
    return self;
}

-(NSArray *)over50
{
    return self.privateOver50;
}

-(NSArray *)other
{
    return self.privateOther;
}

-(TONItem *)createItem
{
    TONItem *item = [TONItem randomItem];
    
    if (item.valueInDollars > 50)
    {
        [self.privateOver50 addObject:item];
    }
    else
    {
        [self.privateOther addObject:item];
    }

    return item;
}

@end
