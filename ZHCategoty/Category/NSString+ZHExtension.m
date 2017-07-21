//
//  NSString+ZHExtension.m
//  ZHCategoty
//
//  Created by 李保征 on 2017/6/28.
//  Copyright © 2017年 李保征. All rights reserved.
//

#import "NSString+ZHExtension.h"
#import "NSAttributedString+ZHExtension.h"
#import <CoreText/CoreText.h>

@implementation NSString (ZHExtension)

- (BOOL)zh_isValue {
    if ((self == nil || [self isEqual:[NSNull null]] || [self isEqualToString:@""])) {
        return NO;
    } else {
        return YES;
    }
}

/*
 {
 
 NSString *text = self;
 UIFont   *font = calculateFont;
 CGFloat width = limitWidth;
 
 NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc] initWithString:text];
 
 //设置字体
 CTFontRef myFont = CTFontCreateWithName((__bridge CFStringRef)([font fontName]), [font pointSize], NULL);
 [attStr addAttribute:(NSString *)kCTFontAttributeName value:(__bridge id)myFont range:NSMakeRange(0, attStr.length)];
 
 //设置行间距
 
 //     CGFloat lineSpace = 0;
 //     id lineSpaceObject = calculateDic[calculateLineSpace];
 //     if (lineSpaceObject) {
 //     lineSpace = [calculateDic[calculateLineSpace] floatValue];
 //     }
 //    if (lineSpaceObject) {
 //        const CFIndex num = 1;
 //        CTParagraphStyleSetting theSettings[num] = {
 //            {kCTParagraphStyleSpecifierLineSpacingAdjustment,sizeof(CGFloat),&lineSpace},
 //        };
 //        CTParagraphStyleRef myParagraphStyle = CTParagraphStyleCreate(theSettings, num);
 //        [attStr addAttribute:(NSString *)kCTParagraphStyleAttributeName value:(__bridge id)myParagraphStyle range:NSMakeRange(0, attStr.length)];
 //    }
 
 
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
 
 CFRelease(myFont);
 CFRelease(frameSetter);
 CFRelease(path);
 CFRelease(frame);
 return linesArray;
 }
 */
- (NSMutableArray *)zh_getLinesArrayWithFont:(UIFont *)calculateFont limitWidth:(CGFloat)limitWidth{
    
    NSString *text = self;
    UIFont   *font = calculateFont;
    CGFloat width = limitWidth;
    
    NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc] initWithString:text];
    
    //设置字体
    CTFontRef myFont = CTFontCreateWithName((__bridge CFStringRef)([font fontName]), [font pointSize], NULL);
    [attStr addAttribute:(NSString *)kCTFontAttributeName value:(__bridge id)myFont range:NSMakeRange(0, attStr.length)];
    
    //开始计算
    CFRelease(myFont);
    return [attStr zh_getLinesArrayWithLimitWidth:width];
}

@end

@implementation NSString (ZHDate)

- (NSDate *)dateFromStringFormat:(NSString *)dateFormat{
    //    @"Tue Dec 13 06:44:07 +0800 2016"
    //    周二 12月 13 15:52:29 +0800 2016
    //设置区域  @"en_US" @"zh_CH"
    NSLocale *local =[[NSLocale alloc] initWithLocaleIdentifier:@"en_US"];
    //设置时区
    //    NSTimeZone *timeZone = [NSTimeZone timeZoneForSecondsFromGMT:8];
    
    NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
    [fmt setLocale:local];
    //    [fmt setTimeZone:timeZone];
    //    fmt.dateFormat = @"EEE MMM dd HH:mm:ss Z yyyy";
    fmt.dateFormat = dateFormat;
    return [fmt dateFromString:self];
}

@end

@implementation NSString (ZHPinYin)

/** 中文转换成拼音 是否显示音调  你好--->ni hao 、 nǐ hǎo */
- (NSString *)convertToPinYin:(BOOL)isShowTone{
    /*
     let kCFStringTransformStripCombiningMarks: CFString! //删除重音符号
     let kCFStringTransformToLatin: CFString! //中文的拉丁字母
     let kCFStringTransformFullwidthHalfwidth: CFString!//全角半宽
     let kCFStringTransformLatinKatakana: CFString!//片假名拉丁字母
     let kCFStringTransformLatinHiragana: CFString!//平假名拉丁字母
     let kCFStringTransformHiraganaKatakana: CFString!//平假名片假名
     let kCFStringTransformMandarinLatin: CFString!//普通话拉丁字母
     let kCFStringTransformLatinHangul: CFString!//韩文的拉丁字母
     let kCFStringTransformLatinArabic: CFString!//阿拉伯语拉丁字母
     let kCFStringTransformLatinHebrew: CFString!//希伯来语拉丁字母
     let kCFStringTransformLatinThai: CFString!//泰国拉丁字母
     let kCFStringTransformLatinCyrillic: CFString!//西里尔拉丁字母
     let kCFStringTransformLatinGreek: CFString!//希腊拉丁字母
     let kCFStringTransformToXMLHex: CFString!//转换为XML十六进制字符
     let kCFStringTransformToUnicodeName: CFString!//转换为Unicode的名称
     let kCFStringTransformStripDiacritics: CFString!//转换成不带音标的符号
     */
    NSMutableString *source = [self mutableCopy];
//    kCFStringTransformMandarinLatin 等价于 kCFStringTransformToLatin
    CFStringTransform((__bridge CFMutableStringRef)source, NULL, kCFStringTransformMandarinLatin, NO);
    CFStringTransform((__bridge CFMutableStringRef)source, NULL, kCFStringTransformStripDiacritics, isShowTone);
    return source;
}

@end
