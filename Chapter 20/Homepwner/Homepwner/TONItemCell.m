//
//  TONItemCell.m
//  Homepwner
//
//  Created by Tawatchai Sunarat on 2/4/15.
//  Copyright (c) 2015 pddk. All rights reserved.
//

#import "TONItemCell.h"

@interface TONItemCell ()

@property (nonatomic, weak) IBOutlet NSLayoutConstraint *imageViewWidthConstraint;

@end

@implementation TONItemCell

-(IBAction)showImage:(id)sender
{
    if (self.actionBlock) {
        
        self.actionBlock();
    }
}

#pragma mark - dynamic type size

-(void)updateInterfaceForDynamicTypeSize
{
    UIFont *font = [UIFont preferredFontForTextStyle:UIFontTextStyleBody];
    
    self.nameLabel.font = font;
    self.serialNumberLabel.font = font;
    self.valueLabel.font = font;
    
    static NSDictionary *imgSize = nil;
    
    if (!imgSize) {
        imgSize = @{ UIContentSizeCategoryExtraSmall : @40,
                      UIContentSizeCategorySmall : @40,
                      UIContentSizeCategoryMedium : @40,
                      UIContentSizeCategoryLarge : @40,
                      UIContentSizeCategoryExtraLarge : @45,
                      UIContentSizeCategoryExtraExtraLarge : @55,
                      UIContentSizeCategoryExtraExtraExtraLarge : @65
                     };
    }
    
    NSString *userSize = [[UIApplication sharedApplication] preferredContentSizeCategory];
    
    NSNumber *imageSize = imgSize[userSize];
    self.imageViewHeightConstraint.constant = imageSize.floatValue;
    self.imageViewWidthConstraint.constant = imageSize.floatValue;
}

-(void)awakeFromNib
{
    [self updateInterfaceForDynamicTypeSize];
    
    NSNotificationCenter *defaultCenter = [NSNotificationCenter defaultCenter];
    [defaultCenter addObserver:self
                      selector:@selector(updateInterfaceForDynamicTypeSize)
                          name:UIContentSizeCategoryDidChangeNotification
                        object:nil];
}

-(void)dealloc
{
    NSNotificationCenter *def = [NSNotificationCenter defaultCenter];
    [def removeObserver:self];
}

@end
