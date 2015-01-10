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
        self.backgroundColor = [UIColor clearColor];
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
    
    // The largest circle will circumscribe the view
    float maxRadius = hypot(bounds.size.width, bounds.size.height) / 2.0;
    UIBezierPath *path = [[UIBezierPath alloc] init];
    
    for (float currentRadius = maxRadius; currentRadius > 0; currentRadius -= 20) {
        [path moveToPoint:CGPointMake(center.x + currentRadius, center.y)];
        [path addArcWithCenter:center
                        radius:currentRadius
                    startAngle:0.0
                      endAngle:M_PI * 2.0
                     clockwise:YES];
    }
    
    //properties
    path.lineWidth = 10;
    [[UIColor lightGrayColor] setStroke];
    
    //draw
    [path stroke];
    
    //draw image
    UIImage *logoImg = [UIImage imageNamed:@"logo.png"];
    CGRect imageRect = CGRectMake(bounds.size.width / 4.0,
                                 bounds.size.height / 4.0,
                                 bounds.size.width / 2.0,
                                 bounds.size.height / 2.0);
    [logoImg drawInRect: imageRect];
    NSLog(@"imageRect");
    NSLog(@"origin.x = %.2f, origin.y = %.2f", imageRect.origin.x, imageRect.origin.y);
    NSLog(@"size.width = %.2f, size.height = %.2f", imageRect.size.width, imageRect.size.height);
    
    NSLog(@"framRect");
    NSLog(@"origin.x = %.2f, origin.y = %.2f", bounds.origin.x, bounds.origin.y);
    NSLog(@"size.width = %.2f, size.height = %.2f", bounds.size.width, bounds.size.height);

}


@end
