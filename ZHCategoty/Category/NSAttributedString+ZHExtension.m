//
//  NSAttributedString+ZHExtension.m
//  ZHCategoty
//
//  Created by 李保征 on 2017/6/28.
//  Copyright © 2017年 李保征. All rights reserved.
//

#import "NSAttributedString+ZHExtension.h"
#import <CoreText/CoreText.h>

@implementation NSAttributedString (ZHExtension)

- (NSMutableArray *)zh_getLinesArrayWithLimitWidth:(CGFloat)limitWidth{
    
    NSString *text = [self.string copy];
//    UIFont   *font = calculateFont;
    CGFloat width = limitWidth;
    
    NSAttributedString *attStr = [self copy];
    
    //开始计算
    CTFramesetterRef frameSetter = CTFramesetterCreateWithAttributedString((__bridge CFAttributedStringRef)attStr);
    
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathAddRect(path, NULL, CGRectMake(0,0,width,100000));
    
    CTFrameRef frame = CTFramesetterCreateFrame(frameSetter, CFRangeMake(0, 0), path, NULL);
    
    NSArray *lines = (__bridge NSArray *)CTFrameGetLines(frame);
    NSMutableArray *linesArray = [[NSMutableArray alloc] init];
    
    for (id line in lines){
        CTLineRef lineRef = (__bridge CTLineRef )line;
        CFRange lineRange = CTLineGetStringRange(lineRef);
        NSRange range = NSMakeRange(lineRange.location, lineRange.length);
        
        NSString *lineString = [text substringWithRange:range];
        [linesArray addObject:lineString];
    }

    CFRelease(frameSetter);
    CFRelease(path);
    CFRelease(frame);
    return linesArray;
}

@end
