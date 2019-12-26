//
//  RadarGraphView.m
//  RadarGraphDemo
//
//  Created by April Young on 2019/12/24.
//  Copyright © 2019 April Young. All rights reserved.
//

#import "RadarGraphView.h"

#define kMargin 10
#define kLayers 5

@interface RadarGraphView()

@end

@implementation RadarGraphView

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.lineColor = [UIColor yellowColor];
        self.pointColor = [UIColor purpleColor];
        self.patternBackgroupColor = [UIColor lightGrayColor];
        self.titleStrColor = [UIColor yellowColor];
        self.lineWidth = 4;
        self.graphColor = [[UIColor yellowColor] colorWithAlphaComponent:0.7];
        
        self.pointSize = 10;
        self.pointColor = [UIColor redColor];
        self.titleFont = [UIFont systemFontOfSize:15];
        
        self.titles = @[@"abb", @"bbb", @"ccc", @"dddd", @"eeee"];
        self.values = @[@0, @0, @0, @0, @0];
    }
    return self;
}

- (void)setValues:(NSArray<NSNumber *> *)values
{
    if (_values != values)
    {
        _values = values;
       [self setNeedsDisplay];
    }
}

- (void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    [self drawBackgroudWithContext:context rect:rect];
    [self drawGraphWithContext:context rect:rect];
    [self drawTitlesWithContext:context rect:rect];
}

- (void)drawTitlesWithContext:(CGContextRef)context rect:(CGRect)rect
{
    
    
//    [@"d" drawWithRect:<#(CGRect)#> options:<#(NSStringDrawingOptions)#> attributes:<#(nullable NSDictionary<NSAttributedStringKey,id> *)#> context:<#(nullable NSStringDrawingContext *)#>]
}

/// draw the graph that indicate the score
- (void)drawGraphWithContext:(CGContextRef)context rect:(CGRect)rect
{
    CGMutablePathRef cgPath = CGPathCreateMutable();
    CGContextSetLineWidth(context, self.lineWidth);
    CGContextSetLineCap(context, kCGLineCapRound);
    
    CGSize size = rect.size;
    CGPoint center = CGPointMake(size.width/2, size.height/2);
    CGFloat shortSize = MIN(size.width, size.height);
    CGFloat radius = shortSize/2 - kMargin;
    CGFloat currentRadius = radius;
    int points = (int)self.values.count;
    CGFloat x,y;
    CGRect pointRect;
    
    // draw graph
    for (int i = 0; i < points; i++)
    {
        CGFloat percent = self.values[i].floatValue/100.0;
        currentRadius = radius * percent;
        CGFloat angle = M_PI*2/points*i;
        [self getPoint:center radius:currentRadius angle:angle x:&x y:&y];
        
        if (i == 0)
        {
            CGPathMoveToPoint(cgPath, nil, x, y);
        }
        else
        {
             CGPathAddLineToPoint(cgPath, nil, x, y);
        }
    }
    CGPathCloseSubpath(cgPath);
    CGContextAddPath(context, cgPath);
    CGContextSetFillColorWithColor(context,self.graphColor.CGColor);
    CGContextFillPath(context);
    CGPathRelease(cgPath);
   
   
    // draw graph points
    CGContextSetFillColorWithColor(context,self.pointColor.CGColor);
    for (int i = 0; i < points; i++)
    {
        CGFloat percent = self.values[i].floatValue/100.0;
        currentRadius = radius * percent;
        CGFloat angle = M_PI*2/points*i;
        [self getPoint:center radius:currentRadius angle:angle x:&x y:&y];
        [self getRect:CGPointMake(x, y) width:self.pointSize rect:&pointRect];
        
        CGPathRef pointPath =CGPathCreateWithRoundedRect(pointRect,self.pointSize/2, self.pointSize/2, nil);
        CGContextAddPath(context, pointPath);
        CGContextFillPath(context);
        CGPathRelease(pointPath);
    }
}

- (void)drawBackgroudWithContext:(CGContextRef)context rect:(CGRect)rect
{
    CGMutablePathRef cgPath = CGPathCreateMutable();
    CGContextSetLineWidth(context, self.lineWidth);
    CGContextSetLineCap(context, kCGLineCapRound);
    CGContextSetFillColorWithColor(context,self.patternBackgroupColor.CGColor);
    CGContextSetStrokeColorWithColor(context, self.lineColor.CGColor);
    //    CGFloat lengths[] = {10, 15};
    //    CGContextSetLineDash(context, 0, lengths, 2);
    
    CGSize size = rect.size;
    CGPoint center = CGPointMake(size.width/2, size.height/2);
    CGFloat shortSize = MIN(size.width, size.height);
    CGFloat radius = shortSize/2 - kMargin;
    CGFloat currentRadius = radius;
    CGFloat unitLegenth = radius/kLayers;
    int points = (int)self.titles.count;
    
    CGFloat x,y;
    for (int i = 0; i < kLayers; i++)
    {
        [self getPoint:center radius:currentRadius angle:0 x:&x y:&y];
        CGPathMoveToPoint(cgPath, nil, x, y);
        
        for (int j = 1; j <= points; j++)
        {
            CGFloat angle = M_PI*2/points*j;
            [self getPoint:center radius:currentRadius angle:angle x:&x y:&y];
            CGPathAddLineToPoint(cgPath, nil, x, y);
        }
        currentRadius -= unitLegenth;
    }
        
        
    CGContextAddPath(context, cgPath);
    CGContextFillPath(context);
    CGContextAddPath(context, cgPath);
    CGContextStrokePath(context);
    
    //    CGContextSaveGState(context);
    //    CGContextRestoreGState(context);
    
    CGPathRelease(cgPath);
}


/// caculate location
- (void)getPoint:(CGPoint)center radius:(CGFloat)radius angle:(CGFloat)angle x:(CGFloat *)x y:(CGFloat *)y
{
    *x = center.x - sin(angle)*radius;
    *y = center.y - cos(angle)*radius;
}

/// get a rect from a center and width(size)
- (void)getRect:(CGPoint)center width:(CGFloat)width rect:(CGRect *)rect
{
    *rect = CGRectMake(center.x-width/2, center.y-width/2, width, width);
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    [self setNeedsDisplay];
}

@end
