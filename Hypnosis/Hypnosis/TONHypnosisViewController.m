//
//  TONHypnosisViewController.m
//  Hypnosis
//
//  Created by Tawatchai Sunarat on 1/12/15.
//  Copyright (c) 2015 pddk. All rights reserved.
//

#import "TONHypnosisViewController.h"
#import "TONHypnosisView.h"

@implementation TONHypnosisViewController

- (void)loadView
{
    // Create a view
    TONHypnosisView *backgroundView = [[TONHypnosisView alloc] init];
    
    // Set it as *the* view of this view controller
    self.view = backgroundView;
}

@end
