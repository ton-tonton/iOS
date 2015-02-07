//
//  TONColorViewController.m
//  Colorboard
//
//  Created by Tawatchai Sunarat on 2/7/15.
//  Copyright (c) 2015 pddk. All rights reserved.
//

#import "TONColorViewController.h"

@interface TONColorViewController ()

@property (weak, nonatomic) IBOutlet UITextField *textField;
@property (weak, nonatomic) IBOutlet UISlider *redSlider;
@property (weak, nonatomic) IBOutlet UISlider *greenSlider;
@property (weak, nonatomic) IBOutlet UISlider *blueSlider;


@end

@implementation TONColorViewController

#pragma mark - initail

-(void)viewDidLoad
{
    [super viewDidLoad];
    
    UIColor *color = self.colorDesc.color;
    float red, green, blue;
    
    [color getRed:&red green:&green blue:&blue alpha:nil];
    self.redSlider.value = red;
    self.greenSlider.value = green;
    self.blueSlider.value = blue;
    
    self.textField.text = self.colorDesc.name;
    self.view.backgroundColor = color;
}

#pragma mark - screen

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if (self.existingColor) {
        
        self.navigationItem.rightBarButtonItem = nil;
    }
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    self.colorDesc.name = self.textField.text;
    self.colorDesc.color = self.view.backgroundColor;
}

#pragma mark - action

-(IBAction)dismiss:(id)sender
{
    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}

-(IBAction)changeColor:(id)sender
{
    float red = self.redSlider.value;
    float green = self.greenSlider.value;
    float blue = self.blueSlider.value;
    
    UIColor *newColor = [UIColor colorWithRed:red green:green blue:blue alpha:1.0];
    self.view.backgroundColor = newColor;
}

@end
