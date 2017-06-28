//
//  NSDictionary+ZHExtension.m
//  ZHCategoty
//
//  Created by 李保征 on 2017/6/28.
//  Copyright © 2017年 李保征. All rights reserved.
//

#import "NSDictionary+ZHExtension.h"
#import "NSObject+ZHExtension.h"

@implementation NSDictionary (ZHExtension)

@end

@implementation NSMutableDictionary (ZHRuntimeExtension)

+ (void)load{
    [self zh_swizzleInstanceMethod:NSClassFromString(@"__NSDictionaryM") originSelector:@selector(setValue:forKey:) otherSelector:@selector(zh_setValue:forKey:)];
    [self zh_swizzleInstanceMethod:NSClassFromString(@"__NSDictionaryM") originSelector:@selector(setObject:forKey:) otherSelector:@selector(zh_setObject:forKey:)];
}

- (void)zh_setValue:(nullable id)value forKey:(NSString *)key{
    if (value&&key) {
        [self zh_setValue:value forKey:key];
    }
}

- (void)zh_setObject:(nullable id)anObject forKey:(NSString *)aKey{
    //系统启动  内部会调用  很多次 setObject:forKey:  方法
    if (anObject&&aKey) {
        [self zh_setObject:anObject forKey:aKey];
    }
}

@end

@implementation NSDictionary (ZHLogExtension)

- (NSString *)descriptionWithLocale:(id)locale{
    NSMutableString *strM = [NSMutableString stringWithString:@"{\n"];
    
    [self enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        [strM appendFormat:@"\t%@ = %@;\n", key, obj];
    }];
    [strM appendString:@"}\n"];
    
    return strM;
}

@end

