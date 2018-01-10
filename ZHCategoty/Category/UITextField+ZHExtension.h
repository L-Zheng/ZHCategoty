//
//  UITextField+ZHExtension.h
//  ZHCategoty
//
//  Created by 李保征 on 2018/1/10.
//  Copyright © 2018年 李保征. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITextField (ZHExtension)

/**  手机空格格式化
 - (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
 return [self phoneNumberShouldChangeCharactersInRange:range replacementString:string];
 }
 //去掉空格后的实际数字
 NSString *realText = [textField zh_numberToNormalNum];
 */
/**
 *  手机号码格式化
 *  参数 range 文本范围
 *  参数 string 字符串
 */
- (BOOL)phoneNumberShouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string;

/** 格式化后的号码转正常数字 */
- (NSString *)zh_phoneNumberToNormalNum;

/**  限制输入位数
 - (void)textFieldDidChange:(NSNotification *)note{
 NSString *idCardText = self.idCardTextField.text;
 if (idCardText.length > 18) {
 self.idCardTextField.text = [idCardText substringToIndex:18];
 }
 }
 */

@end
