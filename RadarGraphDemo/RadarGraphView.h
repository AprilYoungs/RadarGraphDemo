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
@property(nonatomic, strong) UIColor *lineColor;
@property(nonatomic, strong) UIColor *pointColor;
@property(nonatomic, strong) UIColor *patternBackgroupColor;
@property(nonatomic, strong) UIColor *graphColor;
@property(nonatomic, strong) UIColor *titleStrColor;
@property(nonatomic, strong) UIFont *titleFont;
@property(nonatomic, strong) NSArray<NSString*> *titles;
@property(nonatomic, strong) NSArray<NSNumber*> *values;
@property(nonatomic, assign) CGFloat lineWidth;
@property(nonatomic, assign) CGFloat pointSize;
@end

NS_ASSUME_NONNULL_END
