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
#import "TONItemCell.h"
#import "TONImageStore.h"
#import "TONImageViewController.h"

@interface TONItemsViewController () <UIPopoverControllerDelegate, UIDataSourceModelAssociation>

@property (nonatomic, strong) IBOutlet UIView *headerView;
@property (nonatomic, strong) UIPopoverController* imagePopoverController;

@end

@implementation TONItemsViewController

#pragma mark - initail

-(instancetype)init
{
    self = [super initWithStyle:UITableViewStylePlain];
    self.navigationItem.title = NSLocalizedString(@"Homepwner", @"Name of application");
    UIBarButtonItem *rightBar = [[UIBarButtonItem alloc]
                                 initWithBarButtonSystemItem:UIBarButtonSystemItemAdd
                                 target:self
                                 action:@selector(addNewItem:)];
    self.navigationItem.rightBarButtonItem = rightBar;
    self.navigationItem.leftBarButtonItem = self.editButtonItem;
    
    NSNotificationCenter *defaultCenter = [NSNotificationCenter defaultCenter];
    [defaultCenter addObserver:self
                      selector:@selector(updateTableViewForDynamicTypeSize)
                          name:UIContentSizeCategoryDidChangeNotification
                        object:nil];
    
    [defaultCenter addObserver:self
                      selector:@selector(localeChanged:)
                          name:NSCurrentLocaleDidChangeNotification
                        object:nil];
    
    self.restorationIdentifier = NSStringFromClass([self class]);
    self.restorationClass = [self class];
    return self;
}

-(instancetype)initWithStyle:(UITableViewStyle)style
{
    return [self init];
}

#pragma mark - screen

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self updateTableViewForDynamicTypeSize];
}

-(void)viewDidLoad
{
    [super viewDidLoad];
    
    UINib *nib = [UINib nibWithNibName:@"TonItemCell" bundle:nil];
    [self.tableView registerNib:nib forCellReuseIdentifier:@"Cell"];
    
    UIView *header = self.headerView;
    [self.tableView setTableHeaderView:header];
    self.tableView.restorationIdentifier = @"TONItemsViewController";
}

-(void)dealloc
{
    NSNotificationCenter *def = [NSNotificationCenter defaultCenter];
    [def removeObserver:self];
}

#pragma mark - table

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[[TONItemStore sharedStore] allItems] count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView
        cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    TONItemCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    NSArray *items = [[TONItemStore sharedStore] allItems];
    TONItem *item = items[indexPath.row];
    
    static NSNumberFormatter *currencyFormatter = nil;
    
    if (!currencyFormatter) {
        
        currencyFormatter = [[NSNumberFormatter alloc] init];
        currencyFormatter.numberStyle = NSNumberFormatterCurrencyStyle;
    }
    
    cell.nameLabel.text = item.itemName;
    cell.serialNumberLabel.text = item.serialNumber;
    cell.valueLabel.text = [currencyFormatter stringFromNumber:@(item.valueInDollars)];
    cell.thumbnailView.image = item.thumbnail;
    
    __weak TONItemCell *weekcell = cell;
    
    cell.actionBlock = ^{
        NSLog(@"need display image:%@", item);
        
        if ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad) {
            
            NSString *imgKey = item.imageKey;
            UIImage *img = [[TONImageStore sharedStroe] imageForKey:imgKey];
            
            if (!img) {
                return;
            }
            
            TONItemCell *strongCell = weekcell;
            
            CGRect rect = [self.view convertRect:strongCell.thumbnailView.bounds fromView:strongCell.thumbnailView];
            TONImageViewController *ivc = [[TONImageViewController alloc] init];
            ivc.image = img;
            
            self.imagePopoverController = [[UIPopoverController alloc] initWithContentViewController:ivc];
            self.imagePopoverController.delegate = self;
            self.imagePopoverController.popoverContentSize = CGSizeMake(600, 600);
            [self.imagePopoverController presentPopoverFromRect:rect
                                                         inView:self.view
                                       permittedArrowDirections:UIPopoverArrowDirectionAny
                                                       animated:YES];
            
        }
    };
    
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

//when tapped row then ...
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    TONDetailViewController *detailViewController = [[TONDetailViewController alloc] initForNewItem:NO];
    NSArray *items = [[TONItemStore sharedStore] allItems];
    TONItem *selectedItem = items[indexPath.row];
    
    detailViewController.item = selectedItem;
    [self.navigationController pushViewController:detailViewController animated:YES];
}

#pragma mark - action

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
    
    navController.restorationIdentifier = NSStringFromClass([navController class]);
    
    [self presentViewController:navController animated:YES completion:nil];
    
}

#pragma mark - popover

-(void)popoverControllerDidDismissPopover:(UIPopoverController *)popoverController
{
    self.imagePopoverController = nil;
}

#pragma mark - dynamic type size

-(void)updateTableViewForDynamicTypeSize
{
    static NSDictionary *cellHeightDic = nil;
    
    if (!cellHeightDic) {
        
        cellHeightDic = @{
                          UIContentSizeCategoryExtraSmall : @44,
                          UIContentSizeCategorySmall : @44,
                          UIContentSizeCategoryMedium : @44,
                          UIContentSizeCategoryLarge : @44,
                          UIContentSizeCategoryExtraLarge : @55,
                          UIContentSizeCategoryExtraExtraLarge : @65,
                          UIContentSizeCategoryExtraExtraExtraLarge : @75
                          };
    }
    
    NSString *userSize = [[UIApplication sharedApplication] preferredContentSizeCategory];
    NSNumber *cellHeight = cellHeightDic[userSize];
    
    [self.tableView setRowHeight:cellHeight.floatValue];
    [self.tableView reloadData];
}

#pragma mark - restoration state

+(UIViewController *)viewControllerWithRestorationIdentifierPath:(NSArray *)identifierComponents coder:(NSCoder *)coder
{
    return [[self alloc] init];
}

-(void)encodeRestorableStateWithCoder:(NSCoder *)coder
{
    [coder encodeBool:[self isEditing] forKey:@"TableViewIsEditing"];
    [super encodeRestorableStateWithCoder:coder];
}

-(void)decodeRestorableStateWithCoder:(NSCoder *)coder
{
    self.editing = [coder decodeBoolForKey:@"TableViewIsEditing"];
    [super decodeRestorableStateWithCoder:coder];
}

-(NSString *)modelIdentifierForElementAtIndexPath:(NSIndexPath *)idx inView:(UIView *)view
{
    NSString *identifier = nil;
    
    if (idx && view) {
        
        TONItem *item = [[TONItemStore sharedStore] allItems][idx.row];
        identifier = item.imageKey;
    }
    
    return identifier;
}

-(NSIndexPath *)indexPathForElementWithModelIdentifier:(NSString *)identifier inView:(UIView *)view
{
    NSIndexPath *indexPath = nil;
    NSArray *items = [[TONItemStore sharedStore] allItems];
    
    if (identifier && view) {
        
        for (TONItem *item in items) {
            
            if ([identifier isEqualToString:item.imageKey]) {
                
                int row = [items indexOfObjectIdenticalTo:item];
                indexPath = [NSIndexPath indexPathForRow:row inSection:0];
                break;
            }
        }
    }
    
    return indexPath;
}

#pragma mark - locale

-(void)localeChanged:(NSNotification *)note
{
    [self.tableView reloadData];
}


@end
