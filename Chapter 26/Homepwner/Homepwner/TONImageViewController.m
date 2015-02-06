//
//  TONImageViewController.m
//  Homepwner
//
//  Created by Tawatchai Sunarat on 2/4/15.
//  Copyright (c) 2015 pddk. All rights reserved.
//

#import "TONImageViewController.h"

@interface TONImageViewController ()

@end

@implementation TONImageViewController

#pragma mark - initail

-(void)loadView
{
    UIImageView *imgView = [[UIImageView alloc] init];
    imgView.contentMode = UIViewContentModeScaleAspectFit;
    self.view = imgView;
}

#pragma mark - screen

-(void)viewWillAppear:(BOOL)animated
{
    UIImageView *imageView = (UIImageView *)self.view;
    imageView.image = self.image;
}

@end
