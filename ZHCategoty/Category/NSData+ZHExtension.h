//
//  NSData+ZHExtension.h
//  ZHCategoty
//
//  Created by 李保征 on 2017/8/11.
//  Copyright © 2017年 李保征. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface NSData (ZHExtension)

@end

@interface NSData (ZHConvertExtension)

/** UTF-8 Data   -    UTF-8 Dic Or Array */
- (id)zh_utf_8_DicOrArray;

- (UIImage *)zh_image;

- (NSString *)zh_utf_8_String;

- (NSString *)zh_Base64_String;

@end

@interface NSData (ZHFileExtension)

- (BOOL)writeToFileWithPath:(NSString *)filePath;

@end
