//
//  TONDrawView.m
//  TouchTracker
//
//  Created by Tawatchai Sunarat on 1/30/15.
//  Copyright (c) 2015 pddk. All rights reserved.
//

#import "TONDrawView.h"
#import "TONLine.h"

@interface TONDrawView () <UIGestureRecognizerDelegate>

@property (nonatomic, strong) NSMutableDictionary *linesInProgress;
@property (nonatomic, strong) NSMutableArray *finishedLine;
@property (nonatomic, strong) UIPanGestureRecognizer *moveRecognizer;

@property (nonatomic, weak) TONLine *selectedLine;

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
        
        //double tap recognize
        UITapGestureRecognizer *doubleTapRecognizer = [[UITapGestureRecognizer alloc]
                                                    initWithTarget:self
                                                    action:@selector(doubleTap:)];
        doubleTapRecognizer.numberOfTapsRequired = 2;
        doubleTapRecognizer.delaysTouchesBegan = YES;
        [self addGestureRecognizer:doubleTapRecognizer];
        
        //tab recognize
        UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc]
                                                initWithTarget:self
                                                action:@selector(tap:)];
        tapRecognizer.delaysTouchesBegan = YES;
        [tapRecognizer requireGestureRecognizerToFail:doubleTapRecognizer];
        [self addGestureRecognizer:tapRecognizer];
        
        //long press recognize
        UILongPressGestureRecognizer *pressRecognizer = [[UILongPressGestureRecognizer alloc]
                                                         initWithTarget:self
                                                         action:@selector(longPress:)];
        [self addGestureRecognizer:pressRecognizer];
        
        //panning line
        self.moveRecognizer = [[UIPanGestureRecognizer alloc]
                               initWithTarget:self
                               action:@selector(moveLine:)];
        self.moveRecognizer.delegate = self;
        self.moveRecognizer.cancelsTouchesInView = NO;
        [self addGestureRecognizer:self.moveRecognizer];
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
    
    //draw selected line in green
    if (self.selectedLine) {
        [[UIColor greenColor] set];
        [self strokeLine:self.selectedLine];
    }
}

-(TONLine *)lineAtPoint:(CGPoint)point
{
    for (TONLine *line in self.finishedLine) {
        CGPoint start = line.begin;
        CGPoint end = line.end;
        
        for (float t = 0.0; t < 1.0; t+= 0.05) {
            float x = start.x + t * (end.x - start.x);
            float y = start.y + t * (end.y - start.y);
            
            // If the tapped point is within 20 points, let's return this line
            if (hypot(x - point.x, y - point.y) < 20.0) {
                return line;
            }
        }
    }
        
    return nil;
}

-(void)deleteLine:(id *)sender
{
    [self.finishedLine removeObject:self.selectedLine];
    [self setNeedsDisplay];
}

#pragma mark - Touch event

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
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
    for (UITouch *t in touches) {
        
        NSValue *key = [NSValue valueWithNonretainedObject:t];
        TONLine *line = self.linesInProgress[key];
        line.end = [t locationInView:self];
    }
    
    [self setNeedsDisplay];
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    for (UITouch *t in touches) {
        NSValue *key = [NSValue valueWithNonretainedObject:t];
        [self.finishedLine addObject:self.linesInProgress[key]];
        [self.linesInProgress removeObjectForKey:key];
    }

    [self setNeedsDisplay];
}

-(void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    for (UITouch *t in touches) {
        NSValue *key = [NSValue valueWithNonretainedObject:t];
        [self.linesInProgress removeObjectForKey:key];
    }
    
    [self setNeedsDisplay];
}

#pragma mark - Gesture recognize protocol
-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    if (gestureRecognizer == self.moveRecognizer) {
        return YES;
    }
    
    return NO;
}

#pragma mark - Gesture recognize

-(void)doubleTap:(UIGestureRecognizer *)gr
{
    [self.linesInProgress removeAllObjects];
    [self.finishedLine removeAllObjects];
    [self setNeedsDisplay];
}

-(void)tap:(UIGestureRecognizer *)gr
{
    CGPoint point = [gr locationInView:self];
    self.selectedLine = [self lineAtPoint:point];
    
    if (self.selectedLine) {
        
        [self becomeFirstResponder];
        
        UIMenuController *menu = [UIMenuController sharedMenuController];
        UIMenuItem *deleteItem = [[UIMenuItem alloc]
                                  initWithTitle:@"Delete"
                                  action:@selector(deleteLine:)];
        menu.menuItems = @[deleteItem];
        [menu setTargetRect:CGRectMake(point.x, point.y, 2, 2) inView:self];
        [menu setMenuVisible:YES animated:YES];
        
    } else {
        
        [[UIMenuController sharedMenuController] setMenuVisible:NO animated:YES];
    }
    
    [self setNeedsDisplay];
}

-(void)longPress:(UIGestureRecognizer *)gr
{
    if (gr.state == UIGestureRecognizerStateBegan) {
        
        CGPoint point = [gr locationInView:self];
        self.selectedLine = [self lineAtPoint:point];
        
        if (self.selectedLine) {
            [self.linesInProgress removeAllObjects];
        }
        
    } else if (gr.state == UIGestureRecognizerStateEnded) {
        
        self.selectedLine = nil;
    }
    
    [self setNeedsDisplay];
}

-(void)moveLine:(UIPanGestureRecognizer *)gr
{
    if (!self.selectedLine) {
        return;
    }else if ([[UIMenuController  sharedMenuController] isMenuVisible])
    {
        self.selectedLine = nil;
        [[UIMenuController sharedMenuController] setMenuVisible:NO animated:YES];
        return;
    }
    
    if (gr.state == UIGestureRecognizerStateChanged) {
        
        CGPoint translation = [gr translationInView:self];
        CGPoint begin = self.selectedLine.begin;
        begin.x += translation.x;
        begin.y += translation.y;
        
        CGPoint end = self.selectedLine.end;
        end.x += translation.x;
        end.y += translation.y;
        
        self.selectedLine.begin = begin;
        self.selectedLine.end = end;
        [self setNeedsDisplay];
        [gr setTranslation:CGPointZero inView:self];
    }
}

#pragma mark - first responder

-(BOOL)canBecomeFirstResponder
{
    return YES;
}

@end
