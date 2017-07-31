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

@end

@interface NSString (ZHDate)

/** date --> string */
- (NSDate *)dateFromStringFormat:(NSString *)dateFormat;

@end

@interface NSString (ZHPinYin)

/** 中文转换成拼音 是否显示音调  你好--->ni hao 、 nǐ hǎo */
- (NSString *)zh_convertToPinYin:(BOOL)isShowTone;

@end
