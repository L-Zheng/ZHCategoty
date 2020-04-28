//
//  UIImage+ZHExtension.h
//  ZHCategoty
//
//  Created by 李保征 on 2017/6/28.
//  Copyright © 2017年 李保征. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <WebKit/WebKit.h>

@interface UIImage (ZHExtension)

/** 创建纯色图片 */
+ (UIImage *)zh_imageWithColor:(UIColor *)color size:(CGSize)size;

/** 截图View */
+ (UIImage *)zh_captureImageWithView:(UIView *)view;
+ (UIImage *)zh_captureImageWithUIScrollView:(UIScrollView *)scrollView isAll:(BOOL)isAll;
+ (UIImage *)zh_captureImageWithUIWebView:(UIWebView *)webView isAll:(BOOL)isAll;
+ (void)zh_captureImageWithWKWebView:(WKWebView *)webView isAll:(BOOL)isAll completion:(void (^) (UIImage *image))completion;

/** 压缩到制定尺寸 */
- (UIImage *)zh_imageScaledToSize:(CGSize)scaledToSize;

/** iconfont图标 */
+ (UIImage *)zh_iconFontImageWithText:(NSString *)text iconsize:(CGFloat)iconsize color:(UIColor *)color;

/** 从图片中按指定的位置大小截取图片的一部分 */
- (UIImage *)zh_imageFromImageInRect:(CGRect)inRect;

/** 拉伸图片中间区域 */
- (UIImage *)zh_resizedImageCenter;
@end
