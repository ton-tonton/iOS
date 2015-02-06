//
//  TONImageTransformer.m
//  Homepwner
//
//  Created by Tawatchai Sunarat on 2/5/15.
//  Copyright (c) 2015 pddk. All rights reserved.
//

#import "TONImageTransformer.h"

@implementation TONImageTransformer

+(Class)transformedValueClass
{
    return [NSData class];
}

-(id)transformedValue:(id)value
{
    if (!value) {
        return nil;
    }
    
    if ([value isKindOfClass:[NSData class]]) {
        return value;
    }
    
    return UIImagePNGRepresentation(value);
}

-(id)reverseTransformedValue:(id)value
{
    return [UIImage imageWithData:value];
}

@end
