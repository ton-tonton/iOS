//
//  TONReminderViewController.m
//  Hypnosis
//
//  Created by Tawatchai Sunarat on 1/13/15.
//  Copyright (c) 2015 pddk. All rights reserved.
//

#import "TONReminderViewController.h"

@interface TONReminderViewController ()

@property (nonatomic, weak) IBOutlet UIDatePicker *datePicker;

@end

@implementation TONReminderViewController

- (IBAction)addReminder:(id)sender
{
    NSDate *date = self.datePicker.date;
    NSLog(@"%@", date);
}

@end
