//
//  UIDevice+ZHExtension.h
//  ZHCategoty
//
//  Created by 李保征 on 2017/8/3.
//  Copyright © 2017年 李保征. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIDevice (ZHExtension)

@end


typedef NS_ENUM(NSInteger, ZHDeviceLanguage) {
    ZHDeviceLanguageEn_US     = 0,  //英文
    ZHDeviceLanguageZh_Hans_US      = 1,  //简体中文
    ZHDeviceLanguageZh_Hant_US      = 2,   //繁体中文
    ZHDeviceLanguageUnknown      = 3,
};
@interface UIDevice (ZHLanguageExtension)

- (ZHDeviceLanguage)zh_currentDeviceLanguage;

@end
