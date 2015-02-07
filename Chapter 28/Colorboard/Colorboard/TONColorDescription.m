//
//  TONColorDescription.m
//  Colorboard
//
//  Created by Tawatchai Sunarat on 2/7/15.
//  Copyright (c) 2015 pddk. All rights reserved.
//

#import "TONColorDescription.h"

@implementation TONColorDescription

-(id)init
{
    self = [super init];
    
    if (self) {
        
        _color = [UIColor colorWithRed:0 green:0 blue:1 alpha:1];
        _name = @"Blue";
    }
    
    return self;
}

@end
