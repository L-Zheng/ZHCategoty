//
//  NSString+ZHExtension.h
//  ZHCategoty
//
//  Created by 李保征 on 2017/6/28.
//  Copyright © 2017年 李保征. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface NSString (ZHExtension)

/** 是否有值 */
- (BOOL)zh_isValue;

/** 获取每行文本 */
- (NSMutableArray *)zh_getLinesArrayWithFont:(UIFont *)calculateFont limitWidth:(CGFloat)limitWidth;

/** 字符串真实长度  去掉空格 包括中英文混合情况 */
- (NSUInteger)zh_realLength;

@end

@interface NSString (ZHDateExtension)

/** date --> string */
- (NSDate *)zh_dateFromStringFormat:(NSString *)dateFormat;

@end

@interface NSString (ZHPinYinExtension)

/** 中文转换成拼音 是否显示音调  你好--->ni hao 、 nǐ hǎo */
- (NSString *)zh_convertToPinYin:(BOOL)isShowTone;

@end


//正则匹配
@interface NSString (ZHRegularExtension)

/** 邮箱 */
- (BOOL)zh_isEmail;

/** url */
- (BOOL)zh_isUrl;

/** 手机号 */
- (BOOL)zh_isTelephone;

/** 是否全是数字 */
- (BOOL)zh_isAllNumberStr;

/** 转换为数字 */
- (NSNumber *)zh_asNumber;


@end


//转换
@interface NSString (ZHConvertExtension)

/** 字符串  -   UTF-8 */
- (NSString *)zh_utf_8_String;

/** 字符串  -   UTF-8 Data */
- (NSData *)zh_utf_8_Data;

/** 字符串  -   Base64 Data */
- (NSData *)zh_Base64_Data;

/** UTF-8  -   字符串 */
- (NSString *)zh_utf_8_StringToString;

/** 字符串---->UTF-8 Dic字典 or Array数组 */
- (id)zh_utf_8_DicOrArray;

/** 字符串---->Base64 Image图像 */
- (UIImage *)zh_Base64_StringToImage;

/**
 字符串---->UTF-8 Dic字典   :   字符串---->UTF-8 Data---->UTF-8 Dic
 字符串---->UTF-8 Array数组   :   字符串---->UTF-8 Data---->UTF-8 Array
 字符串---->Base64 Image图像   :   字符串---->Base64_Data---->Image
 */


@end
