//
//  TONPaletteViewController.m
//  Colorboard
//
//  Created by Tawatchai Sunarat on 2/7/15.
//  Copyright (c) 2015 pddk. All rights reserved.
//

#import "TONPaletteViewController.h"
#import "TONColorViewController.h"
#import "TONColorDescription.h"

@interface TONPaletteViewController ()

@property (nonatomic) NSMutableArray *colors;

@end

@implementation TONPaletteViewController

#pragma mark - screen

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.tableView reloadData];
}

#pragma mark - accessor

-(NSMutableArray *)colors
{
    if (!_colors) {
        
        _colors = [NSMutableArray array];
        
        TONColorDescription *cd = [[TONColorDescription alloc] init];
        
        [_colors addObject:cd];
    }
    
    return _colors;
}

#pragma mark - segue

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"NewColor"]) {
        
        TONColorDescription *color = [[TONColorDescription alloc] init];
        [self.colors addObject:color];
        
        UINavigationController *nv = segue.destinationViewController;
        TONColorViewController *cv = (TONColorViewController *)[nv topViewController];
        
        cv.colorDesc = color;
        
    } else if ([segue.identifier isEqualToString:@"ExistingColor"]) {
        
        NSIndexPath *ip = [self.tableView indexPathForCell:sender];
        TONColorDescription *color = self.colors[ip.row];
        
        TONColorViewController *cv = (TONColorViewController *)segue.destinationViewController;
        cv.colorDesc = color;
        cv.existingColor = YES;
    }
}

#pragma mark - table view

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.colors count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell" forIndexPath:indexPath];
    TONColorDescription *color = _colors[indexPath.row];
    
    cell.textLabel.text = color.name;
    
    return cell;
}

@end
