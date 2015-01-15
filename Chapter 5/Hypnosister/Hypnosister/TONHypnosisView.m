//
//  tonHypnosisterView.m
//  Hypnosister
//
//  Created by Tawatchai Sunarat on 1/9/15.
//  Copyright (c) 2015 pddk. All rights reserved.
//

#import "TONHypnosisView.h"

@implementation TONHypnosisView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.circleColor = [UIColor lightGrayColor];
    }
    return self;
}

-(void)setCircleColor:(UIColor *)circleColor
{
    _circleColor = circleColor;
    [self setNeedsDisplay];
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.

- (void)drawRect:(CGRect)rect
{
    CGRect bounds = self.bounds;
    CGContextRef currentContext = UIGraphicsGetCurrentContext();
    
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
    [self.circleColor setStroke];
    
    //draw hypnosister
    [path stroke];
    CGContextSaveGState(currentContext);
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    NSLog(@"%@, was touched", self);
    //get 3 random number between 0 and 1
    float red = arc4random() % 100 / 100.0;
    float green = arc4random() % 100 / 100.0;
    float blue = arc4random() % 100 / 100.0;
    //NSLog(@"red: %.2f, green: %.2f, blue: %.2f", red, green, blue);
    
    UIColor *randomColor = [UIColor colorWithRed:red
                                           green:green
                                            blue:blue
                                           alpha:1];
    
    self.circleColor = randomColor;
    
}

@end
