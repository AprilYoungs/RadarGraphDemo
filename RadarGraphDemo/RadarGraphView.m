//
//  RadarGraphView.m
//  RadarGraphDemo
//
//  Created by April Young on 2019/12/24.
//  Copyright © 2019 April Young. All rights reserved.
//

#import "RadarGraphView.h"
#import <CoreText/CoreText.h>

#define kMargin 10
#define kLayers 5
#define kTitleSpace 5

@interface RadarGraphView()
// 便签的字号
@property(nonatomic, assign) CGFloat titleFont;
@property(nonatomic, strong)NSMutableArray<CATextLayer *> *titleLayers;
@end

@implementation RadarGraphView

- (instancetype)initWithTitles:(NSArray<NSString *> * __nonnull)titles titleFont:(CGFloat)fontSize radius:(CGFloat)radius
{
    self = [super init];
    if (self) {
        
        self.radius = radius;
        self.lineColor = [UIColor yellowColor];
        self.pointColor = [UIColor purpleColor];
        self.patternBackgroupColor = [UIColor lightGrayColor];
        self.titleStrColor = [UIColor yellowColor];
        self.lineWidth = 4;
        self.graphColor = [[UIColor yellowColor] colorWithAlphaComponent:0.7];
        
        self.pointSize = 10;
        self.pointColor = [UIColor redColor];
        self.titleFont = fontSize;
        
        self.titles = titles;
        
        [self addTitleLayers];
    }
    return self;
}

- (instancetype)initWithTitles:(NSArray<NSString *> * __nonnull)titles titleFont:(CGFloat)fontSize
{
    self = [self initWithTitles:titles titleFont:fontSize radius:100];
    if (self)
    {
        
    }
    return self;
}


- (void)addTitleLayers
{
    NSMutableArray<CATextLayer *>* texts = [@[] mutableCopy];
    for (int i = 0; i < self.titles.count; i++)
    {
        CATextLayer *t = [CATextLayer layer];
        t.foregroundColor = self.titleStrColor.CGColor;
        t.fontSize = self.titleFont;
        [texts addObject:t];
        [self.layer addSublayer:t];
    }
    self.titleLayers = texts;
}

- (void)setTitleStrColor:(UIColor *)titleStrColor
{
    if (_titleStrColor != titleStrColor)
    {
        _titleStrColor = titleStrColor;
        for (CATextLayer *t in self.titleLayers)
        {
            t.foregroundColor = _titleStrColor.CGColor;
        }
    }
}

- (void)setValues:(NSArray<NSNumber *> *)values
{
    if (_values != values)
    {
        _values = values;
        [self setNeedsDisplay];
        [self updateTitles];
    }
}

- (void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    [self drawBackgroudWithContext:context rect:rect];
    [self drawGraphWithContext:context rect:rect];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    [self setNeedsDisplay];
    [self updateTitles];
}

// 更新标签
- (void)updateTitles
{
    CGSize size = self.bounds.size;
    CGPoint center = CGPointMake(size.width/2, size.height/2);
    CGFloat radius = self.radius;
    int points = (int)self.titles.count;
    CGFloat x,y;
    CGRect pointRect;
    CGSize textSize;
    
    // draw graph
    for (int i = 0; i < points; i++)
    {
        CGFloat score = self.values[i].floatValue;
        NSString *text = [NSString stringWithFormat:@"%@:%0.1lf", self.titles[i], score];
        self.titleLayers[i].string = text;
        
        CGFloat angle = M_PI*2/points*i;
        
        [self textSize:text size:&textSize];
        [self getPoint:center radius:radius angle:angle x:&x y:&y];
        
        int side = [self getSideWithAngle:angle];
        CGPoint textCenter;
        if (side == 0)
        {
            textCenter = CGPointMake(x, y - kTitleSpace - textSize.height/2);
        }
        else if (side == 1)
        {
            textCenter = CGPointMake(x, y + kTitleSpace + textSize.height/2);
        }
        else if (side == 2)
        {
            textCenter = CGPointMake(x - kTitleSpace - textSize.width/2, y);
        }
        else
        {
            textCenter = CGPointMake(x + kTitleSpace + textSize.width/2, y);
        }
        
        [self getRect:textCenter width:textSize.width height:textSize.height rect:&pointRect];
        
        self.titleLayers[i].frame = pointRect;
    }
}

/// draw the graph that indicate the score
- (void)drawGraphWithContext:(CGContextRef)context rect:(CGRect)rect
{
    CGMutablePathRef cgPath = CGPathCreateMutable();
    CGContextSetLineWidth(context, self.lineWidth);
    CGContextSetLineCap(context, kCGLineCapRound);
    
    CGSize size = rect.size;
    CGPoint center = CGPointMake(size.width/2, size.height/2);
    CGFloat radius = self.radius;
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
    CGFloat radius = self.radius;
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
    [self getRect:center width:width height:width rect:rect];
}

- (void)getRect:(CGPoint)center width:(CGFloat)width height:(CGFloat)height rect:(CGRect *)rect
{
    *rect = CGRectMake(center.x-width/2, center.y-height/2, width, height);
}


- (void)textSize:(NSString *)string size:(CGSize *)size
{
    *size = [string sizeWithAttributes:@{NSFontAttributeName: [UIFont systemFontOfSize:self.titleFont]}];
}

/// 根据角度判断是 上 0, 下 1, 左 2, 右 3
- (int)getSideWithAngle:(CGFloat)angle
{
    int side = 0;
    
    if (0 <= angle && angle < M_PI/4)
    {
        return 0;
    }else if (M_PI*0.25 <= angle &&  angle < M_PI*0.75)
    {
        return 2;
    }else if (M_PI*0.75 <=  angle && angle < M_PI*1.25)
    {
        return 1;
    }else if (M_PI*1.25 <=  angle && angle < M_PI*1.75)
    {
        return 3;
    }
    else if (M_PI*1.75 <= angle &&  angle < M_PI*2.25)
    {
        return 0;
    }
    
    return side;
}

@end
