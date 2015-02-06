//
//  TONImageStore.h
//  Homepwner
//
//  Created by Tawatchai Sunarat on 1/29/15.
//  Copyright (c) 2015 pddk. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TONImageStore : NSObject

+(instancetype)sharedStroe;

-(void)setImage:(UIImage *)image forKey:(NSString *)key;
-(UIImage *)imageForKey:(NSString *)key;
-(void)deleteImageForKey:(NSString *)key;


@end
