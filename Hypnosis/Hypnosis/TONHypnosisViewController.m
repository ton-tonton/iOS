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

- (instancetype)initWithNibName:(NSString *)nibNameOrNil
                         bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil
                           bundle:nibBundleOrNil];
    if (self) {
        // Set the tab bar item's title
        self.tabBarItem.title = @"Hypnotize";
        
        // Create a UIImage from a file
        // This will use Hypno@2x.png on retina display devices
        UIImage *i = [UIImage imageNamed:@"Hypno.png"];
        
        // Put that image on the tab bar item
        self.tabBarItem.image = i;
    }
    return self;
}

- (void)loadView
{
    // Create a view
    TONHypnosisView *backgroundView = [[TONHypnosisView alloc] init];
    
    // Set it as *the* view of this view controller
    self.view = backgroundView;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    NSLog(@"TONHypnosisViewController laoded its view.");
}

@end
