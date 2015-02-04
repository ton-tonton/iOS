//
//  BNRItem.m
//  RandomItems
//
//  Created by Rahim Sonawalla on 3/20/14.
//  Copyright (c) 2014 Hi Rahim. All rights reserved.
//

#import "TONItem.h"

@implementation TONItem

+ (instancetype)randomItem
{
    NSArray *randomAdjectiveList = @[@"Fluffy", @"Rusty", @"Shiny"];
    NSArray *randomNounList = @[@"Bear", @"Spork", @"Mac"];

    NSInteger adjectiveIndex = arc4random() % [randomAdjectiveList count];
    NSInteger nounIndex = arc4random() % [randomNounList count];
    
    NSString *randomName = [NSString stringWithFormat:@"%@ %@",
                            randomAdjectiveList[adjectiveIndex],
                            randomNounList[nounIndex]];
    
    int randomValue = arc4random() % 100;
    
    NSString *randomSerialNumber = [NSString stringWithFormat:@"%c%c%c%c%c",
                                    '0' + arc4random() % 10,
                                    'A' + arc4random() % 26,
                                    '0' + arc4random() % 10,
                                    'A' + arc4random() % 26,
                                    '0' + arc4random() % 10];
    
    TONItem *newItem = [[self alloc] initWithItemName:randomName
                                       valueInDollars:randomValue
                                         serialNumber:randomSerialNumber];
    
    return newItem;
}

- (instancetype)initWithItemName:(NSString *)name
                  valueInDollars:(int)value
                    serialNumber:(NSString *)sNumber
{
    self = [super init];
    
    if (self) {
        _itemName = name;
        _serialNumber = sNumber;
        _valueInDollars = value;
        _dateCreated = [[NSDate alloc] init];
        _imageKey = [[[NSUUID alloc] init] UUIDString];
    }
    
    return self;
}

- (instancetype)initWithItemName:(NSString *)name
{
    return [self initWithItemName:name
                   valueInDollars:0
                     serialNumber:[self randomSerialNumber]];
}

- (instancetype)init
{
    return [self initWithItemName:@"Item"];
}

- (NSString *)description
{
    NSString *descriptionString = [[NSString alloc] initWithFormat:@"%@ (%@): Worth %d, recorded on %@",
                                   self.itemName, self.serialNumber, self.valueInDollars, self.dateCreated];
    
    return descriptionString;
}

-(NSString *)randomSerialNumber
{
    NSString *randomSerialNumber = [NSString stringWithFormat:@"%c%c%c%c%c",
                                    '0' + arc4random() % 10,
                                    'A' + arc4random() % 26,
                                    '0' + arc4random() % 10,
                                    'A' + arc4random() % 26,
                                    '0' + arc4random() % 10];
    
    return randomSerialNumber;
}

#pragma mark - NSCoding

-(void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.itemName forKey:@"itemName"];
    [aCoder encodeObject:self.serialNumber forKey:@"serialNumber"];
    [aCoder encodeObject:self.dateCreated forKey:@"dateCreated"];
    [aCoder encodeObject:self.imageKey forKey:@"imageKey"];
    [aCoder encodeObject:self.thumbnail forKey:@"thumbnail"];
    
    [aCoder encodeInt:self.valueInDollars forKey:@"valueInDollars"];
}

-(id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    
    if (self) {
        _itemName = [aDecoder decodeObjectForKey:@"itemName"];
        _serialNumber = [aDecoder decodeObjectForKey:@"serialNumber"];
        _dateCreated = [aDecoder decodeObjectForKey:@"dateCreated"];
        _imageKey = [aDecoder decodeObjectForKey:@"imageKey"];
        _thumbnail = [aDecoder decodeObjectForKey:@"thumbnail"];
        
        _valueInDollars = [aDecoder decodeIntForKey:@"valueInDollars"];
    }
    
    return self;
}

#pragma mark - Thumbnail

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

@end
