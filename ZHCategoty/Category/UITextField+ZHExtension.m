//
//  UITextField+ZHExtension.m
//  ZHCategoty
//
//  Created by 李保征 on 2018/1/10.
//  Copyright © 2018年 李保征. All rights reserved.
//

#import "UITextField+ZHExtension.h"

@implementation UITextField (ZHExtension)

/**
 *  手机号码格式化
 *  参数 range 文本范围
 *  参数 string 字符串
 */
- (BOOL)phoneNumberShouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    NSString *text = [self text];
    // 只能输入数字
    NSCharacterSet *characterSet = [NSCharacterSet characterSetWithCharactersInString:@"0123456789\b"];
    string = [string stringByReplacingOccurrencesOfString:@" " withString:@""];
    string = [string stringByReplacingOccurrencesOfString:@"-" withString:@""];
    if ([string rangeOfCharacterFromSet:[characterSet invertedSet]].location != NSNotFound)
    {
        return NO;
    }
    
    text = [text stringByReplacingCharactersInRange:range withString:string];
    text = [text stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    // 如果是电话号码格式化，需要添加这三行代码
    NSMutableString *temString = [NSMutableString stringWithString:text];
    [temString insertString:@" " atIndex:0];
    text = temString;
    
    NSString *newString = @"";
    
    while (text.length > 0){
        NSString *subString = [text substringToIndex:MIN(text.length, 4)];
        newString = [newString stringByAppendingString:subString];
        if (subString.length == 4)
        {
            newString = [newString stringByAppendingString:@" "];
        }
        text = [text substringFromIndex:MIN(text.length, 4)];
    }
    
    newString = [newString stringByTrimmingCharactersInSet:[characterSet invertedSet]];
    
    // 号码14 银行卡 24
    if (newString.length >= 14){
        return NO;
    }
    
    [self setText:newString];
    
    return NO;
}

- (NSString *)zh_phoneNumberToNormalNum{
    return [self.text stringByReplacingOccurrencesOfString:@" " withString:@""];
}

@end
