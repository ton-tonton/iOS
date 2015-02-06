//
//  TONDetailViewController.m
//  Homepwner
//
//  Created by Tawatchai Sunarat on 1/28/15.
//  Copyright (c) 2015 pddk. All rights reserved.
//

#import "TONDetailViewController.h"
#import "TONItem.h"
#import "TONImageStore.h"
#import "TONItemStore.h"
#import "TONAssetTypeViewController.h"

@interface TONDetailViewController () <UITextFieldDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate, UIPopoverControllerDelegate>

@property (weak, nonatomic) IBOutlet UILabel *itemNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *serialLabel;
@property (weak, nonatomic) IBOutlet UILabel *valueLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;

@property (weak, nonatomic) IBOutlet UITextField *nameField;
@property (weak, nonatomic) IBOutlet UITextField *serialNumberField;
@property (weak, nonatomic) IBOutlet UITextField *valueField;

@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@property (weak, nonatomic) IBOutlet UIToolbar *toolbar;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *cameraButton;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *assetTypeButton;


@property (strong, nonatomic) UIPopoverController *imagePickerPopover;


@end

@implementation TONDetailViewController

#pragma mark - restoration state

+(UIViewController *)viewControllerWithRestorationIdentifierPath:(NSArray *)identifierComponents coder:(NSCoder *)coder
{
    BOOL isNew = NO;
    
    if ([identifierComponents count] == 3) {
        isNew = YES;
    }
    
    return [[self alloc] initForNewItem:isNew];
}

-(void)encodeRestorableStateWithCoder:(NSCoder *)coder
{
    [coder encodeObject:self.item.imageKey forKey:@"item.imageKey"];
    
    self.item.itemName = self.nameField.text;
    self.item.serialNumber = self.serialNumberField.text;
    self.item.valueInDollars = [self.valueField.text intValue];
    
    [[TONItemStore sharedStore] saveChanges];
    
    [super encodeRestorableStateWithCoder:coder];
}

-(void)decodeRestorableStateWithCoder:(NSCoder *)coder
{
    NSString *imageKey = [coder decodeObjectForKey:@"item.imageKey"];
    
    for (TONItem *item in [[TONItemStore sharedStore] allItems]) {
        
        if ([item.imageKey isEqualToString:imageKey]) {
            
            self.item = item;
            break;
        }
    }
    [super decodeRestorableStateWithCoder:coder];
}

#pragma mark - initail

-(instancetype)initForNewItem:(BOOL)isNew
{
    self = [super initWithNibName:nil bundle:nil];
    
    NSNotificationCenter *defaultCenter = [NSNotificationCenter defaultCenter];
    [defaultCenter addObserver:self
                      selector:@selector(updateFont)
                          name:UIContentSizeCategoryDidChangeNotification
                        object:nil];
    
    
    if (self && isNew) {
        
        UIBarButtonItem *doneItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone
                                                                                 target:self action:@selector(save:)];
        UIBarButtonItem *cancelItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel
                                                                                    target:self action:@selector(cancel:)];
        self.navigationItem.rightBarButtonItem = doneItem;
        self.navigationItem.leftBarButtonItem = cancelItem;
        
    }
    
    self.restorationIdentifier = NSStringFromClass([self class]);
    self.restorationClass = [self class];
    return self;
}

-(instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    @throw [NSException exceptionWithName:@"wrong initailizer" reason:@"Use initForNewItem" userInfo:nil];
    return nil;
}

-(void)viewDidLoad
{
    [super viewDidLoad];
    
    UIImageView *iv = [[UIImageView alloc] initWithImage:nil];
    iv.contentMode = UIViewContentModeScaleAspectFit;
    iv.translatesAutoresizingMaskIntoConstraints = NO;
    
    [self.view addSubview:iv];
    self.imageView = iv;
    
    [self.imageView setContentHuggingPriority:200 forAxis:UILayoutConstraintAxisVertical];
    [self.imageView setContentCompressionResistancePriority:700 forAxis:UILayoutConstraintAxisVertical];
    
    NSDictionary *nameMap = @{@"imageView":self.imageView, @"dateLabel":self.dateLabel, @"toolbar":self.toolbar};
    NSArray *horizontalConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[imageView]-0-|"
                                                                            options:0
                                                                            metrics:nil
                                                                              views:nameMap];
    
    NSArray *verticalConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"V:[dateLabel]-[imageView]-[toolbar]"
                                                                           options:0
                                                                           metrics:nil
                                                                             views:nameMap];
    [self.view addConstraints:horizontalConstraints];
    [self.view addConstraints:verticalConstraints];
}

-(void)updateFont
{
    UIFont *font = [UIFont preferredFontForTextStyle:UIFontTextStyleBody];
    
    _itemNameLabel.font = font;
    _serialLabel.font = font;
    _valueLabel.font = font;
    _dateLabel.font = font;
    
    _nameField.font  = font;
    _serialNumberField.font  = font;
    _valueField.font  = font;
}

-(void)dealloc
{
    NSNotificationCenter *defaultCenter = [NSNotificationCenter defaultCenter];
    [defaultCenter removeObserver:self];
}

#pragma mark - screen

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    UIInterfaceOrientation io = [[UIApplication sharedApplication] statusBarOrientation];
    [self prepareViewsForOrientation:io];
    
    TONItem *item = self.item;
    static NSDateFormatter *dateFormatter = nil;
    
    if (!dateFormatter) {
        dateFormatter = [[NSDateFormatter alloc] init];
        dateFormatter.dateStyle = NSDateFormatterMediumStyle;
        dateFormatter.timeStyle = NSDateFormatterNoStyle;
    }
    
    self.nameField.text = item.itemName;
    self.serialNumberField.text = item.serialNumber;
    self.valueField.text = [NSString stringWithFormat:@"%d", item.valueInDollars];
    self.dateLabel.text = [dateFormatter stringFromDate:item.dateCreated];
    self.imageView.image =  [[TONImageStore sharedStroe] imageForKey:self.item.imageKey];
    
    NSString *typeLabel = [self.item.assetType valueForKey:@"label"];
    
    if (!typeLabel) {
        typeLabel = NSLocalizedString(@"None", @"Type label None");
    }
    
    self.assetTypeButton.title = [NSString stringWithFormat:NSLocalizedString(@"Type: %@", @"Asset type button"), typeLabel];
    [self updateFont];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [self.view endEditing:YES];
    self.item.itemName = self.nameField.text;
    self.item.serialNumber = self.serialNumberField.text;
    self.item.valueInDollars = [self.valueField.text intValue];
    
}

#pragma mark - function

-(void)setItem:(TONItem *)item
{
    _item = item;
    self.navigationItem.title = item.itemName;
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

-(void)save:(id)sender
{
    [self.presentingViewController dismissViewControllerAnimated:YES completion:self.dismissBlock];
}

-(void)cancel:(id)sender
{
    [[TONItemStore sharedStore] removeItem:self.item];
    [self.presentingViewController dismissViewControllerAnimated:YES completion:self.dismissBlock];
}

#pragma mark - image picker

-(void)imagePickerController:(UIImagePickerController *)picker
    didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *image = info[UIImagePickerControllerOriginalImage];
    [[TONImageStore sharedStroe] setImage:image forKey:self.item.imageKey];
    
    [self.item setThumbnailFromImage:image];
    
    self.imageView.image = image;
    
    if (self.imagePickerPopover) {
        
        [self.imagePickerPopover dismissPopoverAnimated:YES];
        
    } else {
        
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

#pragma mark - action

- (IBAction)backgroundTapped:(id)sender
{
    [self.view endEditing:YES];
}

- (IBAction)takePicture:(id)sender
{
    if ([self.imagePickerPopover isPopoverVisible]) {
        [self.imagePickerPopover dismissPopoverAnimated:YES];
        self.imagePickerPopover = nil;
        return;
    }
    
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
    
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
        
    } else {
        imagePicker.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
    }
    
    imagePicker.delegate = self;
    
    if ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad) {
        
        self.imagePickerPopover = [[UIPopoverController alloc] initWithContentViewController:imagePicker];
        self.imagePickerPopover.delegate = self;
        [self.imagePickerPopover presentPopoverFromBarButtonItem:sender
                                        permittedArrowDirections:UIPopoverArrowDirectionAny
                                                        animated:YES];
    } else {
        
        [self presentViewController:imagePicker animated:YES completion:nil];
    }
}

- (IBAction)removePicture:(id)sender
{
    if (self.imageView.image) {
        self.imageView.image = nil;
        [[TONImageStore sharedStroe] deleteImageForKey:self.item.imageKey];
        
    }
}

-(IBAction)showAssetTypePicker:(id)sender
{
    [self.view endEditing:YES];
    
    TONAssetTypeViewController *avc = [[TONAssetTypeViewController alloc] init];
    avc.item = self.item;
    
    [self.navigationController pushViewController:avc animated:YES];
}

#pragma mark - rotation

-(void)prepareViewsForOrientation:(UIInterfaceOrientation)orientation
{
    if ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad) {
        return;
    }
    
    if (UIInterfaceOrientationIsLandscape(orientation)) {
        
        self.imageView.hidden = YES;
        self.cameraButton.enabled = NO;
        
    } else {
        
        self.imageView.hidden = NO;
        self.cameraButton.enabled = YES;
    }
}

-(void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
                                        duration:(NSTimeInterval)duration
{
    [self prepareViewsForOrientation:toInterfaceOrientation];
}

#pragma mark - Popover

-(void)popoverControllerDidDismissPopover:(UIPopoverController *)popoverController
{
    self.imagePickerPopover = nil;
}

@end
