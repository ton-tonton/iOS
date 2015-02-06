//
//  TONItem.h
//  Homepwner
//
//  Created by Tawatchai Sunarat on 2/5/15.
//  Copyright (c) 2015 pddk. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface TONItem : NSManagedObject

@property (nonatomic, strong) NSString * itemName;
@property (nonatomic, strong) NSString * serialNumber;
@property (nonatomic) int valueInDollars;
@property (nonatomic, strong) NSString * imageKey;
@property (nonatomic, strong) UIImage * thumbnail;
@property (nonatomic) double orderingValue;
@property (nonatomic, strong) NSManagedObject *assetType;
@property (nonatomic, strong) NSDate *dateCreated;

+(NSString *)randomSerialNumber;

-(void)setThumbnailFromImage:(UIImage *)img;

@end
