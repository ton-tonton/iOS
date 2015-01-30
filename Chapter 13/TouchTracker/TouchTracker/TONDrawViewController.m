//
//  TONDrawViewController.m
//  TouchTracker
//
//  Created by Tawatchai Sunarat on 1/30/15.
//  Copyright (c) 2015 pddk. All rights reserved.
//

#import "TONDrawViewController.h"
#import "TONDrawView.h"

@interface TONDrawViewController ()

@end

@implementation TONDrawViewController

-(void)loadView
{
    self.view = [[TONDrawView alloc] initWithFrame:CGRectZero];
}

@end
