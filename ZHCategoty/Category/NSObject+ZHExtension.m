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
