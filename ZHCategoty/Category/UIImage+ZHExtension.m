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

+ (UIImage *)zh_captureImageWithView:(UIView *)view{
    //  可截取任何UIView的视图  即使没有显示在屏幕上也可截取
    
    // 1.创建bitmap上下文
    //    UIGraphicsBeginImageContext(view.frame.size);//这种方式的截图不清晰
    UIGraphicsBeginImageContextWithOptions(view.bounds.size, NO, 0.0);//这种方式的截图清晰
    // 2.将要保存的view的layer绘制到bitmap上下文中
    [view.layer renderInContext:UIGraphicsGetCurrentContext()];
    
    // 3.取出绘制号的图片
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    /** 截取滚动区域
     UIGraphicsBeginImageContextWithOptions(scrollView.contentSize, NO, 0.0)
     CGPoint savedContentOffset = scrollView.contentOffset;
     CGRect savedFrame = scrollView.frame;
     scrollView.contentOffset = CGPointZero;
     scrollView.frame = (CGRect){CGPointZero,scrollView.contentSize};
     [scrollView.layer renderInContext:UIGraphicsGetCurrentContext()];
     UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
     scrollView.contentOffset = savedContentOffset;
     scrollView.frame = savedFrame;
     UIGraphicsEndImageContext();
     */
    
    return newImage;
}

- (UIImage *)zh_imageScaledToSize:(CGSize)scaledToSize{
    // Create a graphics image context
    UIGraphicsBeginImageContext(scaledToSize);
    
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

- (UIImage *)imageFromImageInRect:(CGRect)inRect{
    //将UIImage转换成CGImageRef
    CGImageRef sourceImageRef = [self CGImage];
    
    //按照给定的矩形区域进行剪裁
    CGImageRef newImageRef = CGImageCreateWithImageInRect(sourceImageRef, inRect);
    
    //将CGImageRef转换成UIImage
    UIImage *newImage = [UIImage imageWithCGImage:newImageRef];
    
    //返回剪裁后的图片
    return newImage;
}

- (UIImage *)resizedImageCenter{
    return [self stretchableImageWithLeftCapWidth:self.size.width * 0.5 topCapHeight:self.size.height * 0.5];
}

@end
