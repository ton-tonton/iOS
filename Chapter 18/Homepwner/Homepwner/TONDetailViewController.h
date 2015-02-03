//
//  TONDetailViewController.h
//  Homepwner
//
//  Created by Tawatchai Sunarat on 1/28/15.
//  Copyright (c) 2015 pddk. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TONItem;

@interface TONDetailViewController : UIViewController

@property (nonatomic, strong) TONItem *item;
@property (nonatomic, copy) void (^dismissBlock)(void);

-(instancetype)initForNewItem:(BOOL)isNew;

@end
