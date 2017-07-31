//
//  UINavigationBar+ZHExtension.h
//  ZHCategoty
//
//  Created by 李保征 on 2017/7/31.
//  Copyright © 2017年 李保征. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UINavigationBar (ZHExtension)

@end

@interface UINavigationBar (ZHUIExtension)

/** 导航条上返回按钮和图片的颜色 */
- (void)zh_setIconColor:(UIColor *)iconColor;

/** 导航条背景颜色 */
- (void)zh_setBackgroundColor:(UIColor *)backgroundColor;

/** 导航条背景图片 */
- (void)zh_setBackgroundImage:(UIImage *)backgroundImage;

/** 导航条阴影图片 */
- (void)zh_setShadowImage:(UIImage *)shadowImage;

/** 导航条上文字的颜色 */
- (void)zh_setTextColor:(UIColor *)textColor;

/** 导航条上文字的字体 */
- (void)zh_setTextFont:(UIFont *)textFont;

@end
