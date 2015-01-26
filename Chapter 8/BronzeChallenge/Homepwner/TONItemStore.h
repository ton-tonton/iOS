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

@property (nonatomic, readonly) NSArray *over50;
@property (nonatomic, readonly) NSArray *other;

+(instancetype)sharedStore;
-(TONItem *)createItem;

@end
