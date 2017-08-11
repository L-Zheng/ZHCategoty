//
//  NSArray+ZHExtension.m
//  ZHCategoty
//
//  Created by 李保征 on 2017/6/28.
//  Copyright © 2017年 李保征. All rights reserved.
//

#import "NSArray+ZHExtension.h"
#import "NSObject+ZHExtension.h"
#import "NSData+ZHExtension.h"

@implementation NSArray (ZHExtension)

@end

@implementation NSArray (ZHRuntimeExtension)

+ (void)load{
    [self zh_swizzleInstanceMethod:NSClassFromString(@"__NSArrayI") originSelector:@selector(objectAtIndex:) otherSelector:@selector(zh_objectAtIndex:)];
}

- (id)zh_objectAtIndex:(NSUInteger)index{
    if (index < self.count) {
        return [self zh_objectAtIndex:index];
    } else {
        return nil;
    }
}
@end

@implementation NSMutableArray (ZHRuntimeExtension)

+ (void)load{
    [self zh_swizzleInstanceMethod:NSClassFromString(@"__NSArrayM") originSelector:@selector(addObject:) otherSelector:@selector(zh_addObject:)];
    [self zh_swizzleInstanceMethod:NSClassFromString(@"__NSArrayM") originSelector:@selector(objectAtIndex:) otherSelector:@selector(zh_objectAtIndex:)];
}

- (void)zh_addObject:(id)object{
    if (object != nil) {
        [self zh_addObject:object];
    }
}

- (id)zh_objectAtIndex:(NSUInteger)index{
    if (index < self.count) {
        return [self zh_objectAtIndex:index];
    } else {
        return nil;
    }
}

@end

@implementation NSArray (ZHLogExtension)

- (NSString *)descriptionWithLocale:(id)locale{
    NSMutableString *strM = [NSMutableString stringWithString:@"(\n"];
    
    [self enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        [strM appendFormat:@"\t%@,\n", obj];
    }];
    [strM appendString:@")"];
    return strM;
}
@end

@implementation NSArray (ZHConvertExtension)

- (NSData *)zh_Data{
    
    //如果你不想返回一个可变的对象, 那么可以传入kNilOptions参数
    //NSJSONWritingPrettyPrinted
    NSError *error = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:self options:NSJSONWritingPrettyPrinted error:&error];
    return error ? nil : jsonData;
}

- (NSString *)zh_utf_8_String{
    return self.zh_Data.zh_utf_8_String;
}

@end
