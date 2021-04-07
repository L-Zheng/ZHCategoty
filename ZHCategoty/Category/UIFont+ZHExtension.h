//
//  UIFont+ZHExtension.h
//  ZHCategoty
//
//  Created by EM on 2019/8/31.
//  Copyright © 2019 李保征. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIFont (ZHExtension)

//[UIFont familyNames] 所有字体库
//[UIFont fontNamesForFamilyName:@""]

/** 加载指定路径的ttf字体 */
+ (UIFont *)zh_coreText_customFontWithSrc:(NSString *)fontSrc size:(CGFloat)fontSize;

+ (UIFont *)zh_descriptor_customFontWithSrc:(NSString *)fontSrc size:(CGFloat)fontSize;

@end

NS_ASSUME_NONNULL_END
