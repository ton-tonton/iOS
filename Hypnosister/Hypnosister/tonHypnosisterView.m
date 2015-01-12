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
    CGContextRef currentContext = UIGraphicsGetCurrentContext();
    CGRect imageRect = CGRectMake(bounds.size.width / 4.0,
                                  bounds.size.height / 4.0,
                                  bounds.size.width / 2.0,
                                  bounds.size.height / 2.0);
    
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
    
    //draw hypnosister
    [path stroke];
    CGContextSaveGState(currentContext);
    
    //init triangle path
    UIBezierPath *trianglePath = [[UIBezierPath alloc] init];
    [trianglePath moveToPoint:CGPointMake(center.x, imageRect.origin.y)];
    [trianglePath addLineToPoint:CGPointMake(imageRect.origin.x,
                                             imageRect.origin.y + imageRect.size.height + 20)];
    [trianglePath addLineToPoint:CGPointMake(imageRect.origin.x + imageRect.size.width,
                                             imageRect.origin.y + imageRect.size.height + 20)];
    
    [trianglePath closePath];
    [trianglePath addClip];
    
    
    //make gradient
    CGFloat locations[2] = { 0.0, 1.0};
    CGFloat components[8] = { 0.0, 1.0, 0.0, 1.0, // start color is green
                            1.0, 1.0, 0.0, 1.0 }; // end color is yellow
    
    CGColorSpaceRef colorspace = CGColorSpaceCreateDeviceRGB();
    CGGradientRef gradient = CGGradientCreateWithColorComponents(colorspace, components, locations, 2);
    
    CGPoint startPoint = CGPointMake(center.x, imageRect.origin.y);
    CGPoint endPoint = CGPointMake(center.x, imageRect.origin.y + imageRect.size.height + 20);
    CGContextDrawLinearGradient(currentContext, gradient, startPoint, endPoint, 0);
    
    //fill gradient
    CGGradientRelease(gradient);
    CGColorSpaceRelease(colorspace);
    
    CGContextRestoreGState(currentContext);
    
    //save context state before set shadow
    CGContextSaveGState(currentContext);
    
    //set shadow
    CGContextSetShadow(currentContext, CGSizeMake(4, 7), 3);
    
    //draw blur image
    UIImage *logoImg = [UIImage imageNamed:@"logo.png"];
    [logoImg drawInRect: imageRect];
    
    //retore stage
    CGContextRestoreGState(currentContext);

}


@end
