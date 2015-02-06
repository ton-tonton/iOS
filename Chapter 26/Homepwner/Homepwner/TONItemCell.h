//
//  TONItemCell.h
//  Homepwner
//
//  Created by Tawatchai Sunarat on 2/4/15.
//  Copyright (c) 2015 pddk. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TONItemCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *thumbnailView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *serialNumberLabel;
@property (weak, nonatomic) IBOutlet UILabel *valueLabel;

@property (copy, nonatomic) void (^actionBlock)(void);

@end
