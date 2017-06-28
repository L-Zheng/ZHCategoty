//
//  UIColor+ZHExtension.h
//  ZHCategoty
//
//  Created by 李保征 on 2017/6/28.
//  Copyright © 2017年 李保征. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (ZHExtension)

/** 十六进制颜色 0XFFFFFF 0xFFFFFF #FFFFFF FFFFFF */
+ (UIColor *)zh_colorWithHexString:(NSString *)hexString;
+ (UIColor *)zh_colorWithHexString:(NSString *)hexString alpha:(CGFloat)alpha;

/** 随机色 */
+ (UIColor *)zh_randomColor;

@end
