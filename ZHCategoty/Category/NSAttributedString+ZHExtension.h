//
//  NSAttributedString+ZHExtension.h
//  ZHCategoty
//
//  Created by 李保征 on 2017/6/28.
//  Copyright © 2017年 李保征. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface NSAttributedString (ZHExtension)

/** 获取每行文本 */
- (NSMutableArray *)zh_getLinesArrayWithLimitWidth:(CGFloat)limitWidth;

@end
