//
//  RZGraphView.m
//  VideoProc
//
//  Created by RM on 6/24/14.
//  Copyright (c) 2014 Ruimin Zhang. All rights reserved.
//

#import "RZGraphView.h"
#import "RZGraphViewController.h"

@implementation RZGraphView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

-(void)drawPointGraphWithContext:(CGContextRef)ctx{
    CGContextSetFillColorWithColor(ctx, [[UIColor colorWithRed:1.0 green:0.5 blue:0 alpha:1.0] CGColor]);
    
    // Draw dot for happy emotions
    for(int i=0;i<[self.happies count];i++){
        if ([[self.happies objectAtIndex:i] intValue] == 1){
           float x = kOffsetX + i * kStepX; 
           float y = 50;
           CGRect rect = CGRectMake(x - kCircleRadius, y - kCircleRadius, 2 * kCircleRadius, 2 * kCircleRadius);
           CGContextAddEllipseInRect(ctx, rect);
        }    
        
    }
    // Draw dot for surprise emotions
    for(int i=0;i<[self.surprises count];i++){
        if ([[self.surprises objectAtIndex:i] intValue] == 1){
            float x = kOffsetX + i * kStepX; 
            float y = 100;
            CGRect rect = CGRectMake(x - kCircleRadius, y - kCircleRadius, 2 * kCircleRadius, 2 * kCircleRadius);
            CGContextAddEllipseInRect(ctx, rect);
        }    
        
    }
    // Commit the drawing
    CGContextDrawPath(ctx, kCGPathFillStroke);
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    
    // just for test
    NSLog(@"graph view:%@", self.surprises);
    // Drawing code
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetLineWidth(context, 0.6);
    CGContextSetStrokeColorWithColor(context, [[UIColor lightGrayColor] CGColor]);
    CGFloat dash[] = {2.0, 2.0};
    CGContextSetLineDash(context, 0.0, dash, 2);
    
    // How many lines?
    int howMany = (kDefaultGraphWidth - kOffsetX) / kStepX;
    printf("%d # of lines are drawn.\n", howMany);
    for(int i=0;i<howMany; i++){
        CGContextMoveToPoint(context, kOffsetX + i * kStepX, kGraphTop);
        CGContextAddLineToPoint(context, kOffsetX + i * kStepX, kGraphBottom);
    }
    
    int howManyHorizontal = (kGraphBottom - kGraphTop - kOffsetY) / kStepY;
    for(int i=0;i<=howManyHorizontal;i++){
        CGContextMoveToPoint(context, kOffsetX, kGraphBottom - kOffsetY - i*kStepY);
        CGContextAddLineToPoint(context, kDefaultGraphWidth, kGraphBottom - kOffsetY - i*kStepY);
    }
    CGContextStrokePath(context);
    CGContextSetLineDash(context, 0, NULL, 0); // Remove the dash
    
    [self drawPointGraphWithContext:context];
}


@end
