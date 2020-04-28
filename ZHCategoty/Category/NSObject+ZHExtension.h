//
//  NSObject+ZHExtension.h
//  ZHCategoty
//
//  Created by 李保征 on 2017/6/28.
//  Copyright © 2017年 李保征. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (ZHExtension)

@end

#ifdef DEBUG
@interface NSObject (ZHLogExtension)
- (NSString *)zh_descriptionWithLocale:(nullable id)locale indent:(NSUInteger)level;
@end
#endif

@interface NSObject (ZHRuntimeExtension)

/** 交换类方法 */
+ (void)zh_swizzleClassMethod:(Class)class originSelector:(SEL)originSelector otherSelector:(SEL)otherSelector;

/** 交换实例方法 */
+ (void)zh_swizzleInstanceMethod:(Class)class originSelector:(SEL)originSelector otherSelector:(SEL)otherSelector;
@end
