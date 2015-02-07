//
//  TONHypnosisViewController.m
//  HypnoMe
//
//  Created by Tawatchai Sunarat on 1/15/15.
//  Copyright (c) 2015 pddk. All rights reserved.
//

#import "TONHypnosisViewController.h"
#import "TONHypnosisView.h"

@interface TONHypnosisViewController () <UITextFieldDelegate>

@property (nonatomic) TONHypnosisView *hypnosis;
@property (nonatomic, weak) UITextField *textField;

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
    CGRect textFieldRect = CGRectMake(40, 0, 240, 30);
    UITextField *textField = [[UITextField alloc] initWithFrame:textFieldRect];
    
    textField.borderStyle = UITextBorderStyleRoundedRect;
    textField.placeholder = @"Hypnotize me";
    textField.returnKeyType = UIReturnKeyDone;
    textField.delegate = self;
    
    [self.hypnosis addSubview:textField];
    
    self.textField = textField;
    self.view = self.hypnosis;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    NSLog(@"TONHypnosisViewController loaded its view.");
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [UIView animateWithDuration:2.0
                          delay:0.0
         usingSpringWithDamping:0.25
          initialSpringVelocity:0.0
                        options:0
                     animations:^{
                         
                         CGRect frame = CGRectMake(40, 70, 240, 30);
                         self.textField.frame = frame;
                     }
                     completion:NULL];
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self drawHypnoticMessage:textField.text];
    textField.text = @"";
    [textField resignFirstResponder];
    
    return YES;
}

-(void)drawHypnoticMessage:(NSString *)message
{
    for (int i = 0; i < 20; i++) {
        UILabel *messageLabel = [[UILabel alloc] init];
        
        //text properties
        messageLabel.backgroundColor = [UIColor clearColor];
        messageLabel.textColor = [UIColor whiteColor];
        messageLabel.text = message;
        
        //label size relative to text size
        [messageLabel sizeToFit];
        
        //random x, y within hypnosis view
        int width = (int)(self.view.bounds.size.width - messageLabel.bounds.size.width);
        int x = arc4random() % width;
        
        int height = (int)(self.view.bounds.size.height - messageLabel.bounds.size.height);
        int y = arc4random() % height;
        
        CGRect frame = messageLabel.frame;
        frame.origin = CGPointMake(x, y);
        messageLabel.frame = frame;
        
        [self.view addSubview:messageLabel];
        
        //animation
        messageLabel.alpha = 0.0;
        [UIView animateWithDuration:0.5
                              delay:0.0
                            options:UIViewAnimationOptionCurveEaseIn
                         animations:^{
                             messageLabel.alpha = 1.0;
                         }
                         completion:nil];
        
        [UIView animateKeyframesWithDuration:1.0
                                       delay:0.0
                                     options:0
                                  animations:^{
                                      
                                      [UIView addKeyframeWithRelativeStartTime:0
                                                              relativeDuration:0.8
                                                                    animations:^{
                                                                        
                                                                        messageLabel.center = self.view.center;
                                                                    }];
                                      [UIView addKeyframeWithRelativeStartTime:0.8
                                                              relativeDuration:0.2
                                                                    animations:^{
                                                                        
                                                                        int x = arc4random() % width;
                                                                        int y = arc4random() % height;
                                                                        messageLabel.center = CGPointMake(x, y);
                                                                    }];
                                  }
                                  completion:Nil];
        
        //motion effect
        UIInterpolatingMotionEffect *motionEffect = [[UIInterpolatingMotionEffect alloc]
                                                     initWithKeyPath:@"center.x"
                                                     type:UIInterpolatingMotionEffectTypeTiltAlongHorizontalAxis];
        motionEffect.minimumRelativeValue = @(-25);
        motionEffect.maximumRelativeValue = @(25);
        [messageLabel addMotionEffect:motionEffect];
        
        motionEffect = [[UIInterpolatingMotionEffect alloc]
                        initWithKeyPath:@"center.y"
                        type:UIInterpolatingMotionEffectTypeTiltAlongVerticalAxis];
        motionEffect.minimumRelativeValue = @(-25);
        motionEffect.maximumRelativeValue = @(25);
        [messageLabel addMotionEffect:motionEffect];
    }
}


@end
