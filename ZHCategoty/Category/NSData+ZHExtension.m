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
    if ([self zh_isGifImage]) {
        return [self zh_gifImage];
    }else{
        return [UIImage imageWithData:self];
    }
}
/** 获得gif image */
- (UIImage *)zh_gifImage{
    CGImageSourceRef source = CGImageSourceCreateWithData((__bridge CFDataRef)self, NULL);
    size_t count = CGImageSourceGetCount(source);
    UIImage *animatedImage;
    if (count <= 1) {
        animatedImage = [[UIImage alloc] initWithData:self];
    }else{
        NSMutableArray *images = [NSMutableArray array];
        NSTimeInterval duration = 0.0f;
        for (size_t i = 0; i < count; i++) {
            CGImageRef image = CGImageSourceCreateImageAtIndex(source, i, NULL);
            duration += [self getFrameDurationAtIndex:i source:source];
            [images addObject:[UIImage imageWithCGImage:image scale:[UIScreen mainScreen].scale orientation:UIImageOrientationUp]];
            CGImageRelease(image);
        }
        if (!duration) {
            duration = (1.0f / 10.0f) * count;
        }
        animatedImage = [UIImage animatedImageWithImages:images duration:duration];
    }
    CFRelease(source);
    return animatedImage;
}
- (float)getFrameDurationAtIndex:(NSUInteger)index source:(CGImageSourceRef)source{
    float frameDuration = 0.1f;
    CFDictionaryRef cfFrameProperties = CGImageSourceCopyPropertiesAtIndex(source, index, nil);
    NSDictionary *frameProperties = (__bridge NSDictionary *)cfFrameProperties;
    NSDictionary *gifProperties = frameProperties[(NSString *)kCGImagePropertyGIFDictionary];
    
    NSNumber *delayTimeUnclampedProp = gifProperties[(NSString *)kCGImagePropertyGIFUnclampedDelayTime];
    if (delayTimeUnclampedProp) {
        frameDuration = [delayTimeUnclampedProp floatValue];
    } else {
        NSNumber *delayTimeProp = gifProperties[(NSString *)kCGImagePropertyGIFDelayTime];
        if (delayTimeProp) {
            frameDuration = [delayTimeProp floatValue];
        }
    }
    if (frameDuration < 0.011f) {
        frameDuration = 0.100f;
    }
    CFRelease(cfFrameProperties);
    return frameDuration;
}
/** gif图 */
- (BOOL)zh_isGifImage{
    return [[self zh_imageContentType] isEqualToString:@"image/gif"];
}
/** 图片类型*/
- (NSString *)zh_imageContentType{
    NSData *data = self;
    uint8_t c;
    [data getBytes:&c length:1];
    switch (c) {
        case 0xFF:
            return @"image/jpeg";
        case 0x89:
            return @"image/png";
        case 0x47:
            return @"image/gif";
        case 0x49:
        case 0x4D:
            return @"image/tiff";
        case 0x52:
            // R as RIFF for WEBP
            if ([data length] < 12) {
                return nil;
            }
            
            NSString *testString = [[NSString alloc] initWithData:[data subdataWithRange:NSMakeRange(0, 12)] encoding:NSASCIIStringEncoding];
            if ([testString hasPrefix:@"RIFF"] && [testString hasSuffix:@"WEBP"]) {
                return @"image/webp";
            }
            
            return nil;
    }
    return nil;
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
