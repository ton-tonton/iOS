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

- (instancetype)initWithNibName:(NSString *)nibNameOrNil
                         bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil
                           bundle:nibBundleOrNil];
    if (self) {
        // Set the tabbar item
        self.tabBarItem.title = @"Reminder";
        self.tabBarItem.image = [UIImage imageNamed:@"Time.png"];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    NSLog(@"TONReminderViewController laoded its view.");
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.datePicker.minimumDate = [NSDate dateWithTimeIntervalSinceNow:60];
}

- (IBAction)addReminder:(id)sender
{
    NSDate *date = self.datePicker.date;
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd 'at' HH:mm:ss"];
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSUInteger calendarUnit = (NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit |
                               NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit);
    NSDateComponents *dateComps = [calendar components:calendarUnit fromDate:date];
    [dateComps setSecond:0];
    
    date = [calendar dateFromComponents:dateComps];
    
    NSLog(@"%@", [dateFormatter stringFromDate:date]);
    
    UILocalNotification *note = [[UILocalNotification alloc] init];
    note.alertBody = @"Hypnotize me!";
    note.fireDate = date;
    
    [[UIApplication sharedApplication] scheduleLocalNotification:note];
}

@end
