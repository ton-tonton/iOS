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
        // Set the tabbar item
        self.tabBarItem.title = @"Hypnotize";
        self.tabBarItem.image = [UIImage imageNamed:@"Hypno.png"];
        
        TONHypnosisView *bg = [[TONHypnosisView alloc] init];
        [self.view addSubview:bg];
    }
    
    return self;
}

/*- (void)loadView
{
    // Create a view
    TONHypnosisView *backgroundView = [[TONHypnosisView alloc] init];
    
    // Set it as *the* view of this view controller
    //self.view = backgroundView;
    [self.view addSubview:backgroundView];
}*/

- (void)viewDidLoad
{
    [super viewDidLoad];
    NSLog(@"TONHypnosisViewController laoded its view.");

}

- (void)changeColor:(id)sender
{
    TONHypnosisView *hypnosisView = (TONHypnosisView *)self.view;
    UISegmentedControl *s = sender;
    
    int index = [s selectedSegmentIndex];
    NSLog(@"%d", index);
    
    if (index == 0) {
        hypnosisView.circleColor = [UIColor redColor];
    }
    else if (index == 1) {
        hypnosisView.circleColor = [UIColor greenColor];
    }
    else if (index == 2) {
        hypnosisView.circleColor = [UIColor blueColor];
    }
}

@end
