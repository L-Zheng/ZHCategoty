//
//  NSDictionary+ZHExtension.h
//  ZHCategoty
//
//  Created by 李保征 on 2017/6/28.
//  Copyright © 2017年 李保征. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDictionary (ZHExtension)

@end

@interface NSMutableDictionary (ZHRuntimeExtension)

@end

@interface NSDictionary (ZHLogExtension)

@end

@interface NSDictionary (ZHConvertExtension)

- (NSData *)zh_Data;
/** UTF-8 Dic数组---->字符串   :   UTF-8 Dic---->UTF-8 Data---->字符串 */
- (NSString *)zh_utf_8_String;

@end
