//
//  TONItemsViewController.m
//  Homepwner
//
//  Created by Tawatchai Sunarat on 1/24/15.
//  Copyright (c) 2015 pddk. All rights reserved.
//

#import "TONItemsViewController.h"
#import "TONItem.h"
#import "TONItemStore.h"

@implementation TONItemsViewController

-(instancetype)init
{
    self = [super initWithStyle:UITableViewStylePlain];
    if (self) {
        for (int i = 0; i < 10; i++) {
            [[TONItemStore sharedStore] createItem];
        }
    }
    return self;
}

-(instancetype)initWithStyle:(UITableViewStyle)style
{
    return [self init];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    NSArray *mySection = @[@"More than $50", @"other"];
    return mySection[section];
}



-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    int count;
    if (section == 0)
    {
        count = [[[TONItemStore sharedStore] over50] count];
    }
    else
    {
        count = [[[TONItemStore sharedStore] other] count];
    }

    return count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView
        cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell" forIndexPath:indexPath];
    
    NSArray *allItems = [NSArray alloc];
    if (indexPath.section == 0)
    {
        allItems = [[TONItemStore sharedStore] over50];
    }
    else
    {
        allItems = [[TONItemStore sharedStore] other];
    }
    
    TONItem *item = allItems[indexPath.row];
    cell.textLabel.text = [item description];
    return cell;
}

-(void)viewDidLoad
{
    [super viewDidLoad];
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"UITableViewCell"];
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    CGRect frame = [[UIScreen mainScreen] bounds];
    frame.origin.y += 20;
    frame.size.height -= 20;
    
    self.tableView.frame = frame;
}

@end
