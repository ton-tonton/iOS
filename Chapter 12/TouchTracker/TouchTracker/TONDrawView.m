//
//  TONDrawView.m
//  TouchTracker
//
//  Created by Tawatchai Sunarat on 1/30/15.
//  Copyright (c) 2015 pddk. All rights reserved.
//

#import "TONDrawView.h"
#import "TONLine.h"

@interface TONDrawView ()

@property (nonatomic, strong) NSMutableDictionary *linesInProgress;
@property (nonatomic, strong) NSMutableArray *finishedLine;

@end

@implementation TONDrawView

#pragma mark - Initailization

-(id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self) {
        self.linesInProgress = [[NSMutableDictionary alloc] init];
        self.finishedLine = [[NSMutableArray alloc] init];
        self.backgroundColor = [UIColor grayColor];
        self.multipleTouchEnabled = YES;
    }
    
    return self;
}

#pragma mark - Draw line

-(void)strokeLine:(TONLine *)line
{
    UIBezierPath *bp = [UIBezierPath bezierPath];
    bp.lineWidth = 10;
    bp.lineCapStyle = kCGLineCapRound;
    [bp moveToPoint:line.begin];
    [bp addLineToPoint:line.end];
    
    [bp stroke];
}

-(void)drawRect:(CGRect)rect
{
    //draw finished line color in black
    [[UIColor blackColor] set];
    
    for (TONLine *line in self.finishedLine) {
        [self strokeLine:line];
    }
    
    //draw current line color in red
    for (NSValue *key in self.linesInProgress) {
        
        [[UIColor redColor] set];
        
        [self strokeLine:self.linesInProgress[key]];
    }
}

#pragma mark - Touch event

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    NSLog(@"%@", NSStringFromSelector(_cmd));
    
    for (UITouch *t in touches) {
        
        CGPoint location = [t locationInView:self];
        TONLine *line = [[TONLine alloc] init];
        line.begin = location;
        line.end = location;
        
        NSValue *key = [NSValue valueWithNonretainedObject:t];
        self.linesInProgress[key] = line;
    }
   
    
    [self setNeedsDisplay];
}

-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    NSLog(@"%@", NSStringFromSelector(_cmd));
    
    for (UITouch *t in touches) {
        
        NSValue *key = [NSValue valueWithNonretainedObject:t];
        TONLine *line = self.linesInProgress[key];
        line.end = [t locationInView:self];
    }
    
    [self setNeedsDisplay];
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    NSLog(@"%@", NSStringFromSelector(_cmd));
    
    for (UITouch *t in touches) {
        NSValue *key = [NSValue valueWithNonretainedObject:t];
        [self.finishedLine addObject:self.linesInProgress[key]];
        [self.linesInProgress removeObjectForKey:key];
    }

    [self setNeedsDisplay];
}

-(void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    NSLog(@"%@", NSStringFromSelector(_cmd));
    
    for (UITouch *t in touches) {
        NSValue *key = [NSValue valueWithNonretainedObject:t];
        [self.linesInProgress removeObjectForKey:key];
    }
    
    [self setNeedsDisplay];
}

@end
