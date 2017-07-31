//
//  UINavigationBar+ZHExtension.m
//  ZHCategoty
//
//  Created by 李保征 on 2017/7/31.
//  Copyright © 2017年 李保征. All rights reserved.
//

#import "UINavigationBar+ZHExtension.h"

@implementation UINavigationBar (ZHExtension)

@end

@implementation UINavigationBar (ZHUIExtension)

/** 导航条上返回按钮和图片的颜色 */
- (void)zh_setIconColor:(UIColor *)iconColor{
    self.tintColor = iconColor;
}

/** 导航条背景颜色 */
- (void)zh_setBackgroundColor:(UIColor *)backgroundColor{
    self.barTintColor = backgroundColor;
}

/** 导航条背景图片 */
- (void)zh_setBackgroundImage:(UIImage *)backgroundImage{
    [self setBackgroundImage:backgroundImage forBarMetrics:UIBarMetricsDefault];
}

/** 导航条阴影图片 */
- (void)zh_setShadowImage:(UIImage *)shadowImage{
    self.shadowImage = shadowImage;
}

/** 导航条上文字的颜色 */
- (void)zh_setTextColor:(UIColor *)textColor{
    
    NSMutableDictionary *attDic = [NSMutableDictionary dictionaryWithDictionary:self.titleTextAttributes];
    
    attDic[NSForegroundColorAttributeName] = textColor;
    
    [self setTitleTextAttributes:attDic];
}

/** 导航条上文字的字体 */
- (void)zh_setTextFont:(UIFont *)textFont{
    
    NSMutableDictionary *attDic = [NSMutableDictionary dictionaryWithDictionary:self.titleTextAttributes];
    
    attDic[NSFontAttributeName] = textFont;
    
    [self setTitleTextAttributes:attDic];
}

@end
