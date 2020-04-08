//
//  UIImage+ZHExtension.m
//  ZHCategoty
//
//  Created by 李保征 on 2017/6/28.
//  Copyright © 2017年 李保征. All rights reserved.
//

#import "UIImage+ZHExtension.h"

@implementation UIImage (ZHExtension)

+ (UIImage *)zh_imageWithColor:(UIColor *)color size:(CGSize)size{
    
    if (!color || size.width == 0 || size.height == 0) {
        return nil;
    }
    
    CGFloat imageW = size.width;
    CGFloat imageH = size.height;
    
    // 1.开启基于位图的图形上下文   NO表示透明
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(imageW, imageH), NO, 0.0);
    
    // 2.画一个color颜色的矩形框
    [color set];
    
    UIRectFill(CGRectMake(0, 0, imageW, imageH));
    
    // 3.拿到图片
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    
    // 4.关闭上下文
    UIGraphicsEndImageContext();
    
    return image;
}

+ (UIImage *)zh_captureImageWithViewAndSubViews:(UIView *)view{
    if (!view) return nil;
    //处理subViews
    NSMutableArray *addImageViews = [NSMutableArray array];
    [self zh_handleSubViewsWhenCapture:view addImageViews:addImageViews];
    //截图
    UIImage *resImage = [self zhIn_captureImageWithView:view];
    
    for (UIImageView *imageView in addImageViews) {
        [imageView removeFromSuperview];
    }
    
    return resImage;
}
+ (void)zh_handleSubViewsWhenCapture:(UIView *)view addImageViews:(NSMutableArray *)addImageViews{
    if (!view || view.subviews.count == 0) return;
    NSArray *subviews = view.subviews;
    for (UIView *temp in subviews) {
        if (temp.subviews.count > 0) {
            [self zh_handleSubViewsWhenCapture:temp addImageViews:addImageViews];
            continue;
        }
        if (![temp isKindOfClass:[WKWebView class]]) continue;
        
        __block UIImage *res = nil;
        [self zh_captureImageWithWKWebView:(WKWebView *)temp isAll:NO completion:^(UIImage *image) {
            res = image;
        }];
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:temp.bounds];
        imageView.backgroundColor = [UIColor whiteColor];
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        imageView.image = res;
        [temp addSubview:imageView];
        [temp sendSubviewToBack:imageView];
        [addImageViews addObject:imageView];
    }
}

+ (UIImage *)zh_captureImageWithView:(UIView *)view{
    if (!view) return nil;
    if ([view isKindOfClass:[UIScrollView class]]) {
        return [self zh_captureImageWithUIScrollView:(UIScrollView *)view isAll:NO];
    }
    if ([view isKindOfClass:[UIWebView class]]) {
        return [self zh_captureImageWithUIWebView:(UIWebView *)view isAll:NO];
    }
    if ([view isKindOfClass:[WKWebView class]]) {
        __block UIImage *res = nil;
        [self zh_captureImageWithWKWebView:(WKWebView *)view isAll:NO completion:^(UIImage *image) {
            res = image;
        }];
        return res;
    }
    return [self zhIn_captureImageWithView:view];
}

+ (UIImage *)zh_captureImageWithUIScrollView:(UIScrollView *)scrollView isAll:(BOOL)isAll{
    if (!isAll) {
        return [self zhIn_captureImageWithView:scrollView];
    }
    
    CGPoint originOffset = scrollView.contentOffset;
    CGRect originFrame = scrollView.frame;

    scrollView.contentOffset = CGPointZero;
    scrollView.frame = CGRectMake(0, 0, scrollView.contentSize.width, scrollView.contentSize.height);

    UIGraphicsBeginImageContextWithOptions(scrollView.contentSize, NO, UIScreen.mainScreen.scale);
    [scrollView.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *snapshotImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();

    scrollView.contentOffset = originOffset;
    scrollView.frame = originFrame;
    
    return snapshotImage;
}
+ (UIImage *)zh_captureImageWithUIWebView:(UIWebView *)webView isAll:(BOOL)isAll{
    return [self zh_captureImageWithUIScrollView:webView.scrollView isAll:isAll];
}
+ (void)zh_captureImageWithWKWebView:(WKWebView *)webView isAll:(BOOL)isAll completion:(void (^) (UIImage *image))completion{
    if (!isAll) {
        UIGraphicsBeginImageContextWithOptions(webView.bounds.size, NO, UIScreen.mainScreen.scale);
        [webView drawViewHierarchyInRect:webView.bounds afterScreenUpdates:YES];
        UIImage *snapshotImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        if (completion) completion(snapshotImage);
        return;
    }
    
    //获取快照【防止截图时对 frame 进行操作 出现的闪屏等现象】
    UIView *snapshotView = [webView snapshotViewAfterScreenUpdates:YES];
    snapshotView.frame = webView.frame;
    //添加快照
    [webView.superview addSubview:snapshotView];
    
    //保留WebView原始位置
    CGPoint originOffset = webView.scrollView.contentOffset;
    CGRect originFrame = webView.frame;
    UIView *originSuperView = webView.superview;
    NSUInteger originIndex = [webView.superview.subviews indexOfObject:webView];
    
    //创建临时视图 用于截图
    UIView *containerView = [[UIView alloc] initWithFrame:webView.bounds];
    [webView removeFromSuperview];
    [containerView addSubview:webView];
    
    //获取WebView内容大小，分页数
    CGSize totalSize = webView.scrollView.contentSize;
    NSInteger page = ceil(totalSize.height / containerView.bounds.size.height);
    
    //设置从0位置开始截图
    webView.scrollView.contentOffset = CGPointZero;
    webView.frame = CGRectMake(0, 0, containerView.bounds.size.width, webView.scrollView.contentSize.height);
    
    //开始截图
    UIGraphicsBeginImageContextWithOptions(totalSize, NO, UIScreen.mainScreen.scale);
    
    [self zhIn_captureImageWithWKWebView:webView containerView:containerView index:0 maxIndex:page completion:^{
        //截图
        UIImage *snapshotImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        
        //还原webview位置
        [webView removeFromSuperview];
        [originSuperView insertSubview:webView atIndex:originIndex];
        webView.frame = originFrame;
        webView.scrollView.contentOffset = originOffset;
        
        //移除快照
        [snapshotView removeFromSuperview];
        
        if (completion) completion(snapshotImage);
    }];
}

- (UIImage *)zh_imageScaledToSize:(CGSize)scaledToSize{
    // Create a graphics image context
//    UIGraphicsBeginImageContext(scaledToSize);
    UIGraphicsBeginImageContextWithOptions(scaledToSize, NO, 0.0);
    
    // Tell the old image to draw in this new context, with the desired
    // new size
    [self drawInRect:CGRectMake(0,0,scaledToSize.width,scaledToSize.height)];
    
    // Get the new image from the context
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    
    // End the context
    UIGraphicsEndImageContext();
    
    // Return the new image.
    return newImage;
}

+ (UIImage *)zh_iconFontImageWithText:(NSString *)text iconsize:(CGFloat)iconsize color:(UIColor *)color{
    UIFont *font = [UIFont fontWithName:@"iconfont" size:iconsize];
    
    if (font == nil || text == nil || color == nil || iconsize == 0) {
        return nil;
    }
    
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(iconsize, iconsize), NO, 0.0);
    CGContextRef context = UIGraphicsGetCurrentContext();
    if ([text respondsToSelector:@selector(drawAtPoint:withAttributes:)]) {
        /**
         * 如果这里抛出异常，请打开断点列表，右击All Exceptions -> Edit Breakpoint -> All修改为Objective-C
         * See: http://stackoverflow.com/questions/1163981/how-to-add-a-breakpoint-to-objc-exception-throw/14767076#14767076
         */
        [text drawAtPoint:CGPointZero withAttributes:@{NSFontAttributeName:font, NSForegroundColorAttributeName: color}];
    } else {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
        CGContextSetFillColorWithColor(context, color.CGColor);
        [text drawAtPoint:CGPointZero withFont:font];
#pragma clang pop
    }
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    //下面这种方法 当realSize较大时  不清晰
    //    UIImage *image = [UIImage imageWithCGImage:UIGraphicsGetImageFromCurrentImageContext().CGImage scale:scale orientation:UIImageOrientationUp];
    
    UIGraphicsEndImageContext();
    return image;
}

- (UIImage *)zh_imageFromImageInRect:(CGRect)inRect{
    //将UIImage转换成CGImageRef
    CGImageRef sourceImageRef = [self CGImage];
    
    //按照给定的矩形区域进行剪裁
    CGImageRef newImageRef = CGImageCreateWithImageInRect(sourceImageRef, inRect);
    
    //将CGImageRef转换成UIImage
    UIImage *newImage = [UIImage imageWithCGImage:newImageRef];
    
    //返回剪裁后的图片
    return newImage;
}

- (UIImage *)zh_resizedImageCenter{
    return [self stretchableImageWithLeftCapWidth:self.size.width * 0.5 topCapHeight:self.size.height * 0.5];
}

#pragma mark - private

+ (UIImage *)zhIn_captureImageWithView:(UIView *)view{
    //  可截取任何UIView的视图  即使没有显示在屏幕上也可截取
    
    // 1.创建bitmap上下文
    //    UIGraphicsBeginImageContext(view.frame.size);//这种方式的截图不清晰
    //  YES:透明   NO：不透明
    UIGraphicsBeginImageContextWithOptions(view.bounds.size, NO, 0.0);//这种方式的截图清晰
    // 2.将要保存的view的layer绘制到bitmap上下文中
    [view.layer renderInContext:UIGraphicsGetCurrentContext()];
    
    // 3.取出绘制号的图片
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

+ (void)zhIn_captureImageWithWKWebView:(WKWebView *)webView containerView:(UIView *)containerView index:(NSUInteger)index maxIndex:(NSUInteger)maxIndex completion:(void (^) (void))completion{
    CGFloat Y = index * containerView.frame.size.height;
    CGRect splitFrame = (CGRect){{0, Y}, containerView.bounds.size};
    webView.frame = (CGRect){{0, -Y}, webView.bounds.size};
    
    //屏幕刷新频率  60Hz  大概不到0.02秒
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.02 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [containerView drawViewHierarchyInRect:splitFrame afterScreenUpdates:YES];
        if (index < maxIndex) {
            [self zhIn_captureImageWithWKWebView:webView containerView:containerView index:index + 1 maxIndex:maxIndex completion:completion];
            return;
        }
        if (completion) completion();
    });
}
@end
