//
//  NSString+ZHExtension.m
//  ZHCategoty
//
//  Created by 李保征 on 2017/6/28.
//  Copyright © 2017年 李保征. All rights reserved.
//

#import "NSString+ZHExtension.h"
#import "NSAttributedString+ZHExtension.h"
#import "NSData+ZHExtension.h"
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

- (NSUInteger)zh_realLength{
    //过滤字符串前后的空格
    NSString *st = [self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    //去掉所有空格
//    [self stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    char *p = (char *)[st cStringUsingEncoding:NSUnicodeStringEncoding];
    NSUInteger lengthOfBytes = [st lengthOfBytesUsingEncoding:NSUnicodeStringEncoding];
    NSUInteger strlength = 0;
    for (int i = 0 ; i < lengthOfBytes ;i++) {
        if (*p) {
            p++;
            strlength++;
        }
        else {
            p++;
        }
    }
    return strlength;
}

- (BOOL)zh_isAllWhitespaceAndNewline{
//    whitespaceAndNewlineCharacterSet   空格和换行
//    whitespaceCharacterSet   空格
    NSString *str = [self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    return !str.length;
}

- (NSString *)zh_hiddenMiddleStr{
    if (self.length > 2) {
        //身份证号
        NSUInteger targetReplaceLocation = 1;
        NSUInteger targetReplaceLength = self.length - 2;
        
        NSMutableString *showText = [NSMutableString stringWithString:self];
        
        NSMutableString *replaceString = [NSMutableString stringWithString:@""];
        for (NSInteger i = 0; i < targetReplaceLength; i ++) {
            [replaceString appendString:@"*"];
        }
        [showText replaceCharactersInRange:NSMakeRange(targetReplaceLocation, targetReplaceLength) withString:replaceString];
        
        return showText;
    }else{
        return self;
    }
}

@end

@implementation NSString (ZHDateExtension)

- (NSDate *)zh_dateFromStringFormat:(NSString *)dateFormat{
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

@implementation NSString (ZHPinYinExtension)

/** 中文转换成拼音 是否显示音调  你好--->ni hao 、 nǐ hǎo */
- (NSString *)zh_convertToPinYin:(BOOL)isShowTone{
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

//正则匹配
@implementation NSString (ZHRegularExtension)

- (BOOL)zh_isEmail{
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailPredicate evaluateWithObject:self];
}

/** 身份账号 */
- (BOOL)zh_isIDCard{
    
    if (self.length != 18) return NO;
    // 正则表达式判断基本 身份证号是否满足格式
    NSString *regex = @"^[1-9]\\d{5}[1-9]\\d{3}((0\\d)|(1[0-2]))(([0|1|2]\\d)|3[0-1])\\d{3}([0-9]|X)$";
    //  NSString *regex = @"^(^[1-9]\\d{7}((0\\d)|(1[0-2]))(([0|1|2]\\d)|3[0-1])\\d{3}$)|(^[1-9]\\d{5}[1-9]\\d{3}((0\\d)|(1[0-2]))(([0|1|2]\\d)|3[0-1])((\\d{4})|\\d{3}[Xx])$)$";
    NSPredicate *identityStringPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex];
    //如果通过该验证，说明身份证格式正确，但准确性还需计算
    if(![identityStringPredicate evaluateWithObject:self]) return NO;
    
    //** 开始进行校验 *//
    
    //将前17位加权因子保存在数组里
    NSArray *idCardWiArray = @[@"7", @"9", @"10", @"5", @"8", @"4", @"2", @"1", @"6", @"3", @"7", @"9", @"10", @"5", @"8", @"4", @"2"];
    
    //这是除以11后，可能产生的11位余数、验证码，也保存成数组
    NSArray *idCardYArray = @[@"1", @"0", @"10", @"9", @"8", @"7", @"6", @"5", @"4", @"3", @"2"];
    
    //用来保存前17位各自乖以加权因子后的总和
    NSInteger idCardWiSum = 0;
    for(int i = 0;i < 17;i++) {
        NSInteger subStrIndex = [[self substringWithRange:NSMakeRange(i, 1)] integerValue];
        NSInteger idCardWiIndex = [[idCardWiArray objectAtIndex:i] integerValue];
        idCardWiSum+= subStrIndex * idCardWiIndex;
    }
    
    //计算出校验码所在数组的位置
    NSInteger idCardMod = idCardWiSum%11;
    //得到最后一位身份证号码
    NSString *idCardLast= [self substringWithRange:NSMakeRange(17, 1)];
    //如果等于2，则说明校验码是10，身份证号码最后一位应该是X
    if(idCardMod==2) {
        if(![idCardLast isEqualToString:@"X"]||[idCardLast isEqualToString:@"x"]) {
            return NO;
        }
    }
    else{
        //用计算出的验证码与最后一位身份证号码匹配，如果一致，说明通过，否则是无效的身份证号码
        if(![idCardLast isEqualToString: [idCardYArray objectAtIndex:idCardMod]]) {
            return NO;
        }
    }
    return YES;
}

- (BOOL)zh_isUrl{
    NSString *regex = @"http(s)?:\\/\\/([\\w-]+\\.)+[\\w-]+(\\/[\\w- .\\/?%&=]*)?";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    return [pred evaluateWithObject:self];
}

- (BOOL)zh_isTelephone{
    /**
     * 手机号码
     * 移动：134[0-8],135,136,137,138,139,150,151,157,158,159,182,187,188
     * 联通：130,131,132,152,155,156,185,186
     * 电信：133,1349,153,180,189
     */
    NSString * MOBILE = @"^1(3[0-9]|5[0-35-9]|8[025-9])\\d{8}$";
    /**
     10         * 中国移动：China Mobile
     11         * 134[0-8],135,136,137,138,139,150,151,157,158,159,182,187,188
     12         */
    NSString * CM = @"^1(34[0-8]|(3[5-9]|5[017-9]|8[278])\\d)\\d{7}$";
    /**
     15         * 中国联通：China Unicom
     16         * 130,131,132,152,155,156,185,186
     17         */
    NSString * CU = @"^1(3[0-2]|5[256]|8[56])\\d{8}$";
    /**
     20         * 中国电信：China Telecom
     21         * 133,1349,153,180,189
     22         */
    NSString * CT = @"^1((33|53|8[09])[0-9]|349)\\d{7}$";
    /**
     25         * 大陆地区固话及小灵通
     26         * 区号：010,020,021,022,023,024,025,027,028,029
     27         * 号码：七位或八位
     28         */
    NSString * PHS = @"^0(10|2[0-5789]|\\d{3})\\d{7,8}$";
    NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", MOBILE];
    NSPredicate *regextestcm = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CM];
    NSPredicate *regextestcu = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CU];
    NSPredicate *regextestct = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CT];
    NSPredicate *regextestphs = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", PHS];

    if ([regextestmobile evaluateWithObject:self]
        || [regextestcm evaluateWithObject:self]
        || [regextestct evaluateWithObject:self]
        || [regextestcu evaluateWithObject:self]
        || [regextestphs evaluateWithObject:self]){
        
        if([regextestcm evaluateWithObject:self] == YES) {
            NSLog(@"China Mobile");
        } else if([regextestct evaluateWithObject:self] == YES) {
            NSLog(@"China Telecom");
        } else if ([regextestcu evaluateWithObject:self] == YES) {
            NSLog(@"China Unicom");
        } else {
            NSLog(@"Unknow");
        }
        return YES;
    } else{
        return NO;
    }
}

- (BOOL)zh_isAllNumberStr{
    NSString *number =@"0123456789";
    NSCharacterSet * cs =[[NSCharacterSet characterSetWithCharactersInString:number]invertedSet];
    NSString * comparStr = [[self componentsSeparatedByCharactersInSet:cs]componentsJoinedByString:@""];
    return [self isEqualToString:comparStr];
}

- (NSNumber *)zh_asNumber{
    NSString *regEx = @"^-?\\d+.?\\d?";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regEx];
    BOOL isMatch = [pred evaluateWithObject:self];
    if (isMatch) {
        return [NSNumber numberWithDouble:[self doubleValue]];
    }
    return nil;
}

/** 匹配帐号是否合法(字母开头，允许4-21字节，允许字母数字下划线) */
- (BOOL)isUserName{
    NSString *regex = @"(^[a-zA-Z][A-Za-z0-9_]{3,20}$)";
    
    /*
     ^[a-zA-Z][A-Za-z0-9_]{3,20}$  (字母开头，允许4-21字节，允许字母数字下划线)
     ^[A-Za-z0-9_]{6,20}$  (允许6-20字节，允许字母数字下划线)
     ^[A-Za-z]+$　　       //匹配由26个英文字母组成的字符串
     ^[A-Z]+$　　          //匹配由26个英文字母的大写组成的字符串
     ^[a-z]+$　　          //匹配由26个英文字母的小写组成的字符串
     ^[A-Za-z0-9]+$　　    //匹配由数字和26个英文字母组成的字符串
     ^\w+$　　             //匹配由数字、26个英文字母或者下划线组成的字符串
     [\u4e00-\u9fa5]         匹配中文:
     ^[\u4E00-\u9FA5]{2,4}$  2~4个汉字

     */
    
    
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    return [pred evaluateWithObject:self];
}

@end


//转换
@implementation NSString (ZHConvertExtension)

- (NSString *)zh_utf_8_String{
//    return [self stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    return [self stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
}

- (NSData *)zh_utf_8_Data{
    return [self dataUsingEncoding:NSUTF8StringEncoding];
}

- (NSData *)zh_Base64_Data{
    return [[NSData alloc] initWithBase64EncodedString:self options:0];
}

- (NSString *)zh_utf_8_StringToString{
//    @"\u5982\u4f55\u8054\u7cfb\u5ba2\u670d\u4eba\u5458\uff1f"
//    return [self stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    return [self stringByRemovingPercentEncoding];
}

- (id)zh_utf_8_DicOrArray{
    return self.zh_utf_8_Data.zh_utf_8_DicOrArray;
}

- (UIImage *)zh_Base64_StringToImage{
    return self.zh_Base64_Data.zh_image;
}

@end
