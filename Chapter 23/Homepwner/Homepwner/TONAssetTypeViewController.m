//
//  TONAssetTypeViewController.m
//  Homepwner
//
//  Created by Tawatchai Sunarat on 2/5/2558.
//  Copyright (c) 2015 pddk. All rights reserved.
//

#import "TONAssetTypeViewController.h"
#import "TONItemStore.h"
#import "TONItem.h"

@interface TONAssetTypeViewController ()

@end

@implementation TONAssetTypeViewController

#pragma mark - initail

-(id)init
{
    return [super initWithStyle:UITableViewStylePlain];
}

-(id)initWithStyle:(UITableViewStyle)style
{
    return [self init];
}

-(void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"Cell"];
}

#pragma mark - table view

-(NSInteger)tableView:(UITableView *)tableView
numberOfRowsInSection:(NSInteger)section
{
    return [[[TONItemStore sharedStore] allAssetTypes] count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView
        cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"
                                                        forIndexPath:indexPath];
    
    NSArray *allAssets = [[TONItemStore sharedStore] allAssetTypes];
    NSManagedObject *type = allAssets[indexPath.row];
    NSString *label = [type valueForKey:@"label"];
    
    cell.textLabel.text = label;
    
    if (type == self.item.assetType) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    } else {
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    
    return cell;
}

-(void)tableView:(UITableView *)tableView
didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    cell.accessoryType = UITableViewCellAccessoryCheckmark;
    
    NSArray *allAssets = [[TONItemStore sharedStore] allAssetTypes];
    NSManagedObject *type = allAssets[indexPath.row];
    
    self.item.assetType = type;
    [self.navigationController popViewControllerAnimated:YES];
}

@end
