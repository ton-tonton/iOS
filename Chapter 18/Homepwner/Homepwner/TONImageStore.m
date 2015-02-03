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
    
    NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
    [nc addObserver:self selector:@selector(clearCache:) name:UIApplicationDidReceiveMemoryWarningNotification object:nil];
    
    return self;
}

#pragma mark - handle function

-(void)setImage:(UIImage *)image forKey:(NSString *)key
{
    _dictionary[key] = image;
    
    NSString *imgPath = [self imagePathForKey:key];
    NSData *data = UIImageJPEGRepresentation(image, 0.5);
    [data writeToFile:imgPath atomically:YES];
}

-(UIImage *)imageForKey:(NSString *)key
{
    UIImage *result = self.dictionary[key];
    
    if (!result) {
        NSString *imgPath = [self imagePathForKey:key];
        result = [UIImage imageWithContentsOfFile:imgPath];
        
        if (result) {
            [self.dictionary setObject:result forKey:key];
            
        } else {
            NSLog(@"Error: cant find this %@ file", key);
        }
    }
    
    return result;
}

-(void)deleteImageForKey:(NSString *)key
{
    if (!key) {
        return;
    }
    
    [_dictionary removeObjectForKey:key];
    
    NSString *imgPath = [self imagePathForKey:key];
    [[NSFileManager defaultManager] removeItemAtPath:imgPath error:nil];
}

#pragma mark - read-write function

-(NSString *)imagePathForKey:(NSString *)key
{
    NSArray *directories = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *directory = [directories firstObject];
    
    return  [directory stringByAppendingPathComponent:key];
}

-(void)clearCache:(NSNotificationCenter *)note
{
    [self.dictionary removeAllObjects];
    NSLog(@"flushing...");
}

@end
