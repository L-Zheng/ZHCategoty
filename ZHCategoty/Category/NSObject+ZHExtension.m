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

#ifdef DEBUG
@implementation NSObject (ZHLogExtension)
//可以使用系统的函数对json数据格式化  但这只适用于基本数据，如果json里面包含有原生的Object对象，会崩溃
- (NSString *)zh_descriptionWithLocale1:(nullable id)locale indent:(NSUInteger)level{
    NSError *jsonError = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:self options:NSJSONWritingPrettyPrinted error:&jsonError];
    if (jsonError || !jsonData) {
        return nil;
    }
    return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
}
__attribute__((unused)) static BOOL ZHLogConditionArr(id obj) {
    if (!obj) return NO;
    return [obj isKindOfClass:[NSArray class]];
}
__attribute__((unused)) static BOOL ZHLogConditionDic(id obj) {
    if (!obj) return NO;
    return [obj isKindOfClass:[NSDictionary class]];
}
//解析value to string
__attribute__((unused)) static NSString * ZHLogParseObj(id obj, id locale, NSUInteger level) {
    if ([obj isKindOfClass:[NSString class]]) {
        return [NSString stringWithFormat:@"\"%@\",\n", obj];
    }else if ([obj isKindOfClass:[NSNumber class]]){
//        __NSCFNumber __NSCFBoolean
        if ([obj isKindOfClass:NSClassFromString(@"__NSCFBoolean")]) {
            return [(NSNumber *)obj boolValue] ? @"true,\n" : @"false,\n";
        }else{
           return [NSString stringWithFormat:@"%@,\n", [(NSNumber *)obj description]];
        }
    }else if ([obj isEqual:[NSNull null]]) {
        return @"null,\n";
    }else if (ZHLogConditionDic(obj)){
        return [NSString stringWithFormat:@"%@,\n", [(NSDictionary *)obj descriptionWithLocale:locale indent:level]];
    }else if (ZHLogConditionArr(obj)) {
        return [NSString stringWithFormat:@"%@,\n", [(NSArray *)obj descriptionWithLocale:locale indent:level]];
    }else if ([obj isKindOfClass:[NSObject class]]) {
        return [NSString stringWithFormat:@"%@,\n", [(NSObject *)obj description]];
    }else {
        return [NSString stringWithFormat:@"%@,\n", obj];
    }
}
/**
 ❌DEBUG下：数据嵌套时：函数会递归调用 栈内存溢出
 DEBUG下：栈内存溢出情况：在打印JS的this对象时出现 -->  console.log(this);，其它情况暂时没有出现
 
 防止栈内存溢出： 1、函数内尽量避免定义变量  限制调用层级
              2、使用尾递归调用，编译器会进行优化处理，复用函数栈帧【该方式只在release下有效】
              3、使用while循环：函数运行所需的数据，均已函数参数形式传递，每次调用的结果传入下一参数【只适用于层层向里调用，不适用于调完又拐回来的情况】如：在遍历NSDictionary时，必须等待ZHLogParseObj函数执行完，再回来才能继续遍历下一个key
                 [(NSDictionary *)self enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
                     [strM appendString:space];
                     [strM appendFormat:@"\"%@\"", key];
                     [strM appendString:@" : "];
                     [strM appendString:ZHLogParseObj(locale, obj, level + 1)];
                 }];
 */
- (NSString *)zh_descriptionWithLocale:(nullable id)locale indent:(NSUInteger)level{
    if (!ZHLogConditionArr(self) && !ZHLogConditionDic(self)) {
        return nil;
    }
    
//    if (level > 50) {
//        return [NSString stringWithFormat:@"%@...(数据层级太深，不予显示)%@", startKey, endKey];
//    }
    
    //开始字符
    NSMutableString *strM = [@"" mutableCopy];
    [strM appendFormat:@"%@\n", ZHLogConditionArr(self) ? @"[" : @"{"];
    
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
    if (ZHLogConditionArr(self)) {
        [(NSArray *)self enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            [strM appendString:space];
            [strM appendString:ZHLogParseObj(obj, locale, level + 1)];
        }];
    }else{
        [(NSDictionary *)self enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
            [strM appendString:space];
            [strM appendFormat:@"\"%@\"", key];
            [strM appendString:@" : "];
            [strM appendString:ZHLogParseObj(obj, locale, level + 1)];
        }];
    }
    
    //结束字符
    [strM appendString:lastSpace];
    [strM appendString:ZHLogConditionArr(self) ? @"]" : @"}"];
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
#endif

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
