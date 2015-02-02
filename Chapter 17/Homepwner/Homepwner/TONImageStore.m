//
//  TONImageStore.m
//  Homepwner
//
//  Created by Tawatchai Sunarat on 1/29/15.
//  Copyright (c) 2015 pddk. All rights reserved.
//

#import "TONImageStore.h"

@interface TONImageStore ()

@property(nonatomic, strong)NSMutableDictionary *dictionary;

@end

@implementation TONImageStore

+(instancetype)sharedStroe
{
    static TONImageStore *sharedStore = nil;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        sharedStore = [[self alloc] initPrivate];
    });
    return sharedStore;
}

-(instancetype)init
{
    @throw [NSException exceptionWithName:@"im a singleton"
                                   reason:@"use +[TONImageStore sharedStore]"
                                 userInfo:nil];
    return nil;
}

-(instancetype)initPrivate
{
    self = [super init];
    _dictionary = [[NSMutableDictionary alloc] init];
    
    return self;
}

-(void)setImage:(UIImage *)image forKey:(NSString *)key
{
    _dictionary[key] = image;
}

-(UIImage *)imageForKey:(NSString *)key
{
    return _dictionary[key];
}

-(void)deleteImageForKey:(NSString *)key
{
    if (!key) {
        return;
    }
    
    [_dictionary removeObjectForKey:key];
}

@end
