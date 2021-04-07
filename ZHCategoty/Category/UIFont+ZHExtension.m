//
//  UIFont+ZHExtension.m
//  ZHCategoty
//
//  Created by EM on 2019/8/31.
//  Copyright © 2019 李保征. All rights reserved.
//

#import "UIFont+ZHExtension.h"
#import <CoreText/CoreText.h>

@interface ZHFontManager : NSObject {
    CFURLRef _originFontUrl;//注册字体Url
    CTFontDescriptorRef _descriptor;//注册字体Descriptor
}
@end
@implementation ZHFontManager
- (UIFont *)zh_descriptor_customFontWithSrc:(NSString *)fontSrc size:(CGFloat)fontSize{
    fontSize = (fontSize > 0 ? fontSize : 17);
    if (fontSrc.length == 0) {
        return [UIFont systemFontOfSize:fontSize];
    }
    NSURL *originFontURL = (__bridge NSURL *)_originFontUrl;
    BOOL isRegistered = (_originFontUrl && _descriptor);
    
    //已经注册同样的字体文件
    if (isRegistered && [originFontURL.path isEqualToString:fontSrc]) {
        return [UIFont fontWithDescriptor:(__bridge UIFontDescriptor *)_descriptor size:fontSize];
    }
    
    //取消注册先前的文件
    if (isRegistered) {
        CTFontManagerUnregisterFontsForURL(_originFontUrl, kCTFontManagerScopeNone, NULL);
        _originFontUrl = nil;
        _descriptor = nil;
    }
    
    //注册新字体文件
    CFURLRef newFontURL = CFURLCreateWithFileSystemPath(kCFAllocatorDefault, (__bridge CFStringRef)fontSrc, kCFURLPOSIXPathStyle, false);
    CTFontManagerRegisterFontsForURL(newFontURL, kCTFontManagerScopeNone, NULL);
    _originFontUrl = newFontURL;
    CFArrayRef descriptors = CTFontManagerCreateFontDescriptorsFromURL(newFontURL);
    NSInteger count = CFArrayGetCount(descriptors);
    _descriptor = (count >= 1 ? CFArrayGetValueAtIndex(descriptors, 0) : nil);
    if (_originFontUrl && _descriptor) {
        return [UIFont fontWithDescriptor:(__bridge UIFontDescriptor *)_descriptor size:fontSize];
    }else{
        return [UIFont systemFontOfSize:fontSize];
    }
}

- (instancetype)init{
    if (self = [super init]) {
    }
    return self;
}

static id _instance;

+ (instancetype)shareManager{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[self alloc] init];
    });
    return _instance;
}

+ (instancetype)allocWithZone:(struct _NSZone *)zone{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [super allocWithZone:zone];
    });
    return _instance;
}

@end


@implementation UIFont (ZHExtension)

+ (UIFont *)zh_descriptor_customFontWithSrc:(NSString *)fontSrc size:(CGFloat)fontSize{
    return [[ZHFontManager shareManager] zh_descriptor_customFontWithSrc:fontSrc size:fontSize];
}

//iconfont字体    @"\ue660"   (普通的文字也可设置iconfont字体)
/** 加载指定路径的ttf字体 */
+ (UIFont *)zh_coreText_customFontWithSrc:(NSString *)fontSrc size:(CGFloat)fontSize{
    if (fontSrc.length == 0) {
        return [UIFont systemFontOfSize:fontSize];
    }
    NSString *fontName = [UIFont zh_registerCoreTextFont:fontSrc];
    if (!fontName) {
        return [UIFont systemFontOfSize:fontSize];
    }
    return [UIFont fontWithName:fontName size:fontSize];
}

/** 注册字体
 CoreText问题：注册的字体不能取消注册 （可使用descriptor避免此问题）
 如：当注册了一个ttf后，使用某个图标1\ue660，显示字体后，
    再注册另一个ttf字体，使用其中的某个图标2，会导致显示问号
    因为第一个字体未能取消成功，系统会在第一个字体里面找图标2，找不着，导致显示问号
 */
+ (NSString *)zh_registerCoreTextFont:(NSString *)fontSrc{
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
