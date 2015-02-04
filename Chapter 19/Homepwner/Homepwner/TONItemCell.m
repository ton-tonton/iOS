//
//  TONItemCell.m
//  Homepwner
//
//  Created by Tawatchai Sunarat on 2/4/15.
//  Copyright (c) 2015 pddk. All rights reserved.
//

#import "TONItemCell.h"

@implementation TONItemCell

-(IBAction)showImage:(id)sender
{
    if (self.actionBlock) {
        
        self.actionBlock();
    }
}

@end
