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
#import "TONDetailViewController.h"

@interface TONItemsViewController ()

@property (nonatomic, strong) IBOutlet UIView *headerView;

@end

@implementation TONItemsViewController

-(instancetype)init
{
    self = [super initWithStyle:UITableViewStylePlain];
    self.navigationItem.title = @"Homepwner";
    UIBarButtonItem *rightBar = [[UIBarButtonItem alloc]
                                 initWithBarButtonSystemItem:UIBarButtonSystemItemAdd
                                 target:self
                                 action:@selector(addNewItem:)];
    self.navigationItem.rightBarButtonItem = rightBar;
    self.navigationItem.leftBarButtonItem = self.editButtonItem;
    return self;
}

-(instancetype)initWithStyle:(UITableViewStyle)style
{
    return [self init];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.tableView reloadData];
}

-(void)viewDidLoad
{
    [super viewDidLoad];
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"UITableViewCell"];
    
    UIView *header = self.headerView;
    [self.tableView setTableHeaderView:header];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[[TONItemStore sharedStore] allItems] count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView
        cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell" forIndexPath:indexPath];
    NSArray *items = [[TONItemStore sharedStore] allItems];
    TONItem *item = items[indexPath.row];
    cell.textLabel.text = [item description];
    
    return cell;
}

//title for delete btn when in editing mode
-(NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return @"Remove";
}

//when editing mode, what to do
-(void)tableView:(UITableView *)tableView
        commitEditingStyle:(UITableViewCellEditingStyle)editingStyle
        forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        NSArray *items = [[TONItemStore sharedStore] allItems];
        TONItem *item = items[indexPath.row];
        [[TONItemStore sharedStore] removeItem:item];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
}

//move row when in editing mode
-(void)tableView:(UITableView *)tableView
        moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath
        toIndexPath:(NSIndexPath *)destinationIndexPath
{
    [[TONItemStore sharedStore] moveItemAtIndex:sourceIndexPath.row toIndex:destinationIndexPath.row];
    
}

-(IBAction)addNewItem:(id)sender
{
    TONItem *newItem = [[TONItemStore sharedStore] createItem];
    TONDetailViewController *detailViewController = [[TONDetailViewController alloc] initForNewItem:YES];
    
    detailViewController.item = newItem;
    detailViewController.dismissBlock = ^{
        [self.tableView reloadData];
    };
    
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:detailViewController];
    navController.modalPresentationStyle = UIModalPresentationFormSheet;
    
    [self presentViewController:navController animated:YES completion:nil];
    
}

//when tapped row then ...
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    TONDetailViewController *detailViewController = [[TONDetailViewController alloc] initForNewItem:NO];
    NSArray *items = [[TONItemStore sharedStore] allItems];
    TONItem *selectedItem = items[indexPath.row];
    
    detailViewController.item = selectedItem;
    [self.navigationController pushViewController:detailViewController animated:YES];
}

@end
