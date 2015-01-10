//
//  tonHypnosisterView.m
//  Hypnosister
//
//  Created by Tawatchai Sunarat on 1/9/15.
//  Copyright (c) 2015 pddk. All rights reserved.
//

#import "tonHypnosisterView.h"

@implementation tonHypnosisterView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.

- (void)drawRect:(CGRect)rect
{
    CGRect bounds = self.bounds;
    
    // Figure out the center of the bounds rectangle
    CGPoint center;
    center.x = bounds.origin.x + bounds.size.width / 2.0;
    center.y = bounds.origin.y + bounds.size.height / 2.0;
    
    // The circle will be the largest that will fit in the view
    float radius = (MIN(bounds.size.width, bounds.size.height) / 2.0);
    UIBezierPath *path = [[UIBezierPath alloc] init];
    // Add an arc to the path at center, with radius of radius,
    // from 0 to 2*PI radians (a circle)
    [path addArcWithCenter:center
                    radius:radius
                startAngle:0.0
                  endAngle:M_PI * 2.0
                 clockwise:YES];
    [path stroke];
}


@end
