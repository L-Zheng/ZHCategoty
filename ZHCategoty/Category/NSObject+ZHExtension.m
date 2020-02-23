//
//  NSObject+ZHExtension.m
//  ZHCategoty
//
//  Created by 李保征 on 2017/6/28.
//  Copyright © 2017年 李保征. All rights reserved.
//

#import "NSObject+ZHExtension.h"
#import <objc/runtime.h>

@implementation NSObject (ZHExtension)
@end

@implementation NSObject (ZHLogExtension)
- (NSString *)zh_descriptionWithLocale:(nullable id)locale indent:(NSUInteger)level{
    
    BOOL (^conditionArr)(id) = ^(id obj){
        return [obj isKindOfClass:[NSArray class]];
    };
    BOOL (^conditionDic)(id) = ^(id obj){
        return [obj isKindOfClass:[NSDictionary class]];
    };
    
    BOOL isArr = conditionArr(self);
    BOOL isDic = conditionDic(self);
    
    if (!isArr && !isDic) {
        return nil;
    }
    
    //解析value to string
    NSString * (^parseObj)(NSObject *, NSUInteger) = ^(NSObject *obj, NSUInteger level){
        NSString *value = @"";
        if ([obj isKindOfClass:[NSString class]]) {
            value = [NSString stringWithFormat:@"\"%@\",\n", obj];
        }else if ([obj isEqual:[NSNull null]]) {
            value = @"null,\n";
        }else if (conditionDic(obj)){
            value = [NSString stringWithFormat:@"%@,\n", [(NSDictionary *)obj descriptionWithLocale:locale indent:level]];
        }else if (conditionArr(obj)) {
            value = [NSString stringWithFormat:@"%@,\n", [(NSArray *)obj descriptionWithLocale:locale indent:level]];
        }else if ([obj isKindOfClass:[NSObject class]]) {
            value = [NSString stringWithFormat:@"%@,\n", obj.description];
        }else {
            value = [NSString stringWithFormat:@"%@,\n", obj];
        }
        return value;
    };
    
    NSString *startKey = isArr ? @"[" : @"{";
    NSString *endKey = isArr ? @"]" : @"}";
    
    //开始字符
    NSMutableString *strM = [@"" mutableCopy];
    [strM appendFormat:@"%@\n", startKey];
    
    //空格
    NSMutableString *lastSpace = [@"" mutableCopy];
    NSMutableString *space = [@"" mutableCopy];
    if (level > 0) {
        for (int i = 0; i < level - 1; i++) {
            [lastSpace appendString:@"\t"];
        }
        [space appendString:lastSpace];
        [space appendString:@"\t"];
    }
    
    //遍历取值
    if (isArr) {
        [(NSArray *)self enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            [strM appendString:space];
            [strM appendString:parseObj(obj, level + 1)];
        }];
    }else{
        [(NSDictionary *)self enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
            [strM appendString:space];
            [strM appendFormat:@"\"%@\"", key];
            [strM appendString:@" : "];
            [strM appendString:parseObj(obj, level + 1)];
        }];
    }
    
    //结束字符
    [strM appendString:lastSpace];
    [strM appendString:endKey];
    if (level == 1) {
        [strM appendString:@"\n"];
    }
    
    // 删除最后一个逗号
    NSRange range = [strM rangeOfString:@"," options:NSBackwardsSearch];
    if (range.location != NSNotFound){
        [strM deleteCharactersInRange:range];
    }
    
    return strM;
}
@end

@implementation NSObject (ZHRuntimeExtension)

// 交换类方法的实现
+ (void)zh_swizzleClassMethod:(Class)class originSelector:(SEL)originSelector otherSelector:(SEL)otherSelector{
    //    class_getInstanceMethod(<#__unsafe_unretained Class cls#>, <#SEL name#>)
    Method otherMehtod = class_getClassMethod(class, otherSelector);
    Method originMehtod = class_getClassMethod(class, originSelector);
    method_exchangeImplementations(otherMehtod, originMehtod);
    //
    //    class_addIvar(<#__unsafe_unretained Class cls#>, <#const char *name#>, <#size_t size#>, <#uint8_t alignment#>, <#const char *types#>)
    //    class_addMethod(<#__unsafe_unretained Class cls#>, <#SEL name#>, <#IMP imp#>, <#const char *types#>)
    //    class_addProperty(<#__unsafe_unretained Class cls#>, <#const char *name#>, <#const objc_property_attribute_t *attributes#>, <#unsigned int attributeCount#>)
    //    class_addProtocol(<#__unsafe_unretained Class cls#>, <#Protocol *protocol#>)
}

// 交换实例方法的实现
+ (void)zh_swizzleInstanceMethod:(Class)class originSelector:(SEL)originSelector otherSelector:(SEL)otherSelector{
    Method otherMehtod = class_getInstanceMethod(class, otherSelector);
    Method originMehtod = class_getInstanceMethod(class, originSelector);
    
    method_exchangeImplementations(otherMehtod, originMehtod);
}

@end
