//
//  UIFont+ZHExtension.m
//  ZHCategoty
//
//  Created by EM on 2019/8/31.
//  Copyright © 2019 李保征. All rights reserved.
//

#import "UIFont+ZHExtension.h"
#import <CoreText/CoreText.h>

@implementation UIFont (ZHExtension)
//iconfont字体    @"\ue660"   (普通的文字也可设置iconfont字体)
/** 加载指定路径的ttf字体 */
+ (UIFont *)zh_customFontWithSrc:(NSString *)fontSrc size:(CGFloat)fontSize{
    if (fontSrc.length == 0) {
        return [UIFont systemFontOfSize:fontSize];
    }
    NSString *fontName = [UIFont fw_registerFont:fontSrc];
    if (!fontName) {
        return [UIFont systemFontOfSize:fontSize];
    }
    return [UIFont fontWithName:fontName size:fontSize];
}

/** 注册字体 */
+ (NSString *)fw_registerFont:(NSString *)fontSrc{
    if (fontSrc.length == 0) return nil;
    NSURL *fontFileUrl = [NSURL fileURLWithPath:fontSrc];
    if (!fontFileUrl) return nil;
    //字体源数据
    CGDataProviderRef fontDataProvider = CGDataProviderCreateWithURL((__bridge CFURLRef)fontFileUrl);
    //获取字体
    CGFontRef font = CGFontCreateWithDataProvider(fontDataProvider);
    //字体Name
    CFStringRef fontNameRef = CGFontCopyFullName(font);
    NSString *fontName = (__bridge NSString *)fontNameRef;
    //该字体是否注册过
    CGFontRef originFont = CGFontCreateWithFontName(fontNameRef);
    if (originFont) {//取消注册
        CTFontManagerUnregisterGraphicsFont(originFont, nil);
        CGFontRelease(originFont);
    }
    //注册新字体
    CTFontManagerRegisterGraphicsFont(font, nil);
    //release
    CGDataProviderRelease(fontDataProvider);
    CGFontRelease(font);
    CFRelease(fontNameRef);
    return fontName;
}
@end
