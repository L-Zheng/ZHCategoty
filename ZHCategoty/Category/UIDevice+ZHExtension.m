//
//  UIDevice+ZHExtension.m
//  ZHCategoty
//
//  Created by 李保征 on 2017/8/3.
//  Copyright © 2017年 李保征. All rights reserved.
//

#import "UIDevice+ZHExtension.h"

@implementation UIDevice (ZHExtension)

@end

@implementation UIDevice (ZHLanguageExtension)

- (ZHDeviceLanguage)zh_currentDeviceLanguage{
    NSString *preferredLang = [[[NSUserDefaults standardUserDefaults] objectForKey:@"AppleLanguages"] objectAtIndex:0];
    
    ZHDeviceLanguage zhDeviceLanguage;
    
    if ([preferredLang isEqualToString:@"en-US"]) {
        
        zhDeviceLanguage = ZHDeviceLanguageEn_US;
        
    }else if ([preferredLang isEqualToString:@"zh-Hans-US"]){
        
        zhDeviceLanguage = ZHDeviceLanguageZh_Hans_US;
        
    }else if ([preferredLang isEqualToString:@"zh-Hant-US"]){
        
        zhDeviceLanguage = ZHDeviceLanguageZh_Hant_US;
        
    }else{
        
        zhDeviceLanguage = ZHDeviceLanguageUnknown;
        
    }
    return zhDeviceLanguage;
}

@end

