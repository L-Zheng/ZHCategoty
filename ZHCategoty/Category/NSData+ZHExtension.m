//
//  NSData+ZHExtension.m
//  ZHCategoty
//
//  Created by 李保征 on 2017/8/11.
//  Copyright © 2017年 李保征. All rights reserved.
//

#import "NSData+ZHExtension.h"

@implementation NSData (ZHExtension)

@end

@implementation NSData (ZHConvertExtension)

- (id)zh_utf_8_DicOrArray{
    //NSJSONReadingMutableContainers = (1UL << 0), // 返回的是一个可变数组或者字典
    //NSJSONReadingMutableLeaves = (1UL << 1), // 不仅返回的最外层是可变的, 内部的子数值或字典也是可变对象
    //NSJSONReadingAllowFragments = (1UL << 2) // 返回的最外侧可不是字典或者数组 可以是如 "10"
    //如果你不想返回一个可变的对象, 那么可以传入kNilOptions参数
    NSError *error = nil;
    id result = [NSJSONSerialization JSONObjectWithData:self options:NSJSONReadingAllowFragments error:&error];
    
    return error ? nil : result;
}

- (UIImage *)zh_image{
    return [UIImage imageWithData:self];
}

- (NSString *)zh_utf_8_String{
    return [[NSString alloc] initWithData:self encoding:NSUTF8StringEncoding];
}

- (NSString *)zh_Base64_String{
    return [self base64EncodedStringWithOptions:0];
}

@end

@implementation NSData (ZHFileExtension)

- (BOOL)writeToFileWithPath:(NSString *)filePath{
    return [self writeToFile:filePath atomically:YES];
}

@end
