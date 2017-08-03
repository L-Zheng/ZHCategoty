//
//  UIView+ZHExtension.h
//  ZHCategoty
//
//  Created by 李保征 on 2017/6/22.
//  Copyright © 2017年 李保征. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (ZHExtension)

@property (assign, nonatomic) CGFloat x;
@property (assign, nonatomic) CGFloat y;
@property (assign, nonatomic) CGFloat width;
@property (assign, nonatomic) CGFloat height;
@property (assign, nonatomic) CGSize size;
@property (assign, nonatomic) CGPoint origin;
@property (assign, nonatomic) CGFloat centerX;
@property (assign, nonatomic) CGFloat centerY;

@end

@interface UIView (ZHCornerExtension)

/** 设置单个角的圆角 */
- (void)zh_setSingleCornerRadius:(CGFloat)radius rectCorner:(UIRectCorner)rectCorner;

/** 设置圆角 */
- (void)zh_setViewCornerRadius:(CGFloat)radius;

/** 设置边框 */
- (void)zh_setViewBorder:(CGFloat)width borderColor:(UIColor *)borderColor;

@end
