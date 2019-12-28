//
//  RadarGraphView.h
//  RadarGraphDemo
//
//  Created by April Young on 2019/12/24.
//  Copyright © 2019 April Young. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface RadarGraphView : UIView

// 雷达图的标签
@property(nonatomic, strong) NSArray<NSString*> *titles;
// 雷达图的值 0 ~ 100
@property(nonatomic, strong) NSArray<NSNumber*> *values;
// 便签的颜色
@property(nonatomic, strong) UIColor *titleStrColor;

// 多边形的半径
@property(nonatomic, assign) CGFloat radius;
// 正多边形背景色
@property(nonatomic, strong) UIColor *patternBackgroupColor;
// 多边形的颜色,中心雷达图
@property(nonatomic, strong) UIColor *graphColor;
// 背景线条的颜色
@property(nonatomic, strong) UIColor *lineColor;
// 背景线条的粗细
@property(nonatomic, assign) CGFloat lineWidth;
// 图边上点的颜色
@property(nonatomic, strong) UIColor *pointColor;
// 图边上点的大小
@property(nonatomic, assign) CGFloat pointSize;

- (instancetype)initWithTitles:(NSArray<NSString *> * __nonnull)titles titleFont:(CGFloat)fontSize;

- (instancetype)initWithTitles:(NSArray<NSString *> * __nonnull)titles titleFont:(CGFloat)fontSize radius:(CGFloat)radius;

@end

NS_ASSUME_NONNULL_END
