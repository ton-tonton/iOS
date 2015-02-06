//
//  TONItem.m
//  Homepwner
//
//  Created by Tawatchai Sunarat on 2/5/15.
//  Copyright (c) 2015 pddk. All rights reserved.
//

#import "TONItem.h"


@implementation TONItem

@dynamic itemName;
@dynamic serialNumber;
@dynamic valueInDollars;
@dynamic imageKey;
@dynamic thumbnail;
@dynamic orderingValue;
@dynamic assetType;
@dynamic dateCreated;

#pragma mark - function

+(NSString *)randomSerialNumber
{

    NSString *randomSerialNumber = [NSString stringWithFormat:@"%c%c%c%c%c",
                                        '0' + arc4random() % 10,
                                        'A' + arc4random() % 26,
                                        '0' + arc4random() % 10,
                                        'A' + arc4random() % 26,
                                        '0' + arc4random() % 10];
        
    return randomSerialNumber;

}

-(void)setThumbnailFromImage:(UIImage *)img
{
    CGSize origiSize = img.size;
    CGRect newRect = CGRectMake(0, 0, 40, 40);
    
    CGFloat ratio = MAX(newRect.size.width / origiSize.width, newRect.size.height / origiSize.height);
    
    UIGraphicsBeginImageContextWithOptions(newRect.size, NO, 0.0);
    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:newRect cornerRadius:5.0];
    [path addClip];
    
    CGRect projectRect;
    projectRect.size.width = ratio * origiSize.width;
    projectRect.size.height = ratio * origiSize.height;
    projectRect.origin.x = (newRect.size.width - projectRect.size.width) / 2.0;
    projectRect.origin.y = (newRect.size.height - projectRect.size.height) / 2.0;
    
    [img drawInRect:projectRect];
    
    UIImage *smallImg = UIGraphicsGetImageFromCurrentImageContext();
    self.thumbnail = smallImg;
    
    UIGraphicsEndImageContext();
}

#pragma mark - core data

-(void)awakeFromInsert
{
    [super awakeFromInsert];
    
    NSUUID *uuid = [[NSUUID alloc] init];
    
    self.dateCreated = [NSDate date];
    self.imageKey = [uuid UUIDString];
}

@end
