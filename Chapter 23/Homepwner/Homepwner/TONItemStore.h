//
//  TONItemStore.h
//  Homepwner
//
//  Created by Tawatchai Sunarat on 1/24/15.
//  Copyright (c) 2015 pddk. All rights reserved.
//

#import <Foundation/Foundation.h>

@class TONItem;

@interface TONItemStore : NSObject

@property (nonatomic, readonly) NSArray *allItems;

+(instancetype)sharedStore;

-(TONItem *)createItem;
-(void)removeItem:(TONItem *)item;
-(void)moveItemAtIndex:(NSInteger)fromIndex toIndex:(NSInteger)toIndex;
-(BOOL)saveChanges;

@end
