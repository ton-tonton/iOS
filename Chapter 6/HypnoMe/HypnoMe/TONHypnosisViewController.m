//
//  TONHypnosisViewController.m
//  HypnoMe
//
//  Created by Tawatchai Sunarat on 1/15/15.
//  Copyright (c) 2015 pddk. All rights reserved.
//

#import "TONHypnosisViewController.h"
#import "TONHypnosisView.h"

@interface TONHypnosisViewController ()

@property (nonatomic) TONHypnosisView *hypnosis;

@end

@implementation TONHypnosisViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.hypnosis = [[TONHypnosisView alloc] init];
        self.tabBarItem.title = @"Hypnotize";
        self.tabBarItem.image = [UIImage imageNamed:@"Hypno.png"];
    }
    
    return self;
}

- (void)loadView
{
    self.view = self.hypnosis;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    NSLog(@"TONHypnosisViewController loaded its view.");
    
    //screen size
    CGRect screenFrame = [[UIScreen mainScreen] applicationFrame];
    //NSLog(@"bounds = %@", NSStringFromCGRect(screenFrame));
    
    //Creating segment control in navigation bar
    UISegmentedControl *mainSegment = [[UISegmentedControl alloc] initWithItems:@[@"Red", @"Green", @"Blue"]];
    mainSegment.frame = CGRectMake(0, 20, screenFrame.size.width, 40);
    
    [mainSegment addTarget:self action:@selector(mainSegmentControl:) forControlEvents: UIControlEventValueChanged];
    [self.view addSubview:mainSegment];
}

- (void)mainSegmentControl:(UISegmentedControl *)segment
{
    NSLog(@"%d", segment.selectedSegmentIndex);
    if (segment.selectedSegmentIndex == 0)
    {
        self.hypnosis.circleColor = [UIColor redColor];
    }
    else if (segment.selectedSegmentIndex == 1)
    {
        self.hypnosis.circleColor = [UIColor greenColor];
    }
    else if (segment.selectedSegmentIndex == 2)
    {
        self.hypnosis.circleColor = [UIColor blueColor];
    }
}

@end
