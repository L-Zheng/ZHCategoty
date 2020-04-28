//
//  NSArray+ZHExtension.h
//  ZHCategoty
//
//  Created by 李保征 on 2017/6/28.
//  Copyright © 2017年 李保征. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSArray (ZHExtension)

@end

@interface NSArray (ZHRuntimeExtension)

@end

@interface NSMutableArray (ZHRuntimeExtension)

@end

#ifdef DEBUG
@interface NSArray (ZHLogExtension)
@end
#endif

@interface NSArray (ZHConvertExtension)

- (NSData *)zh_Data;
/** UTF-8 Array数组---->字符串   :   UTF-8 Array---->UTF-8 Data---->字符串 */
- (NSString *)zh_utf_8_String;

@end
