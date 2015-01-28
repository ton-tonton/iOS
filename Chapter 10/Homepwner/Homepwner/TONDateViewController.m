//
//  TONDateViewController.m
//  Homepwner
//
//  Created by Tawatchai Sunarat on 1/28/15.
//  Copyright (c) 2015 pddk. All rights reserved.
//

#import "TONDateViewController.h"
#import "TONItem.h"

@interface TONDateViewController ()

@property (weak, nonatomic) IBOutlet UIDatePicker *datePicker;

@end

@implementation TONDateViewController

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.datePicker setDate:self.item.dateCreated animated:YES];
}

-(void)setItem:(TONItem *)item
{
    _item = item;
    self.navigationItem.title = @"Change Date";
    
    UIBarButtonItem *saveBtn = [[UIBarButtonItem alloc] initWithTitle:@"Save" style:UIBarButtonItemStylePlain target:self action:@selector(saveDate:)];
    self.navigationItem.rightBarButtonItem = saveBtn;
}

-(IBAction)saveDate:(id)sender
{
    self.item.dateCreated = self.datePicker.date;
    [self.navigationController popViewControllerAnimated:YES];
}

@end
