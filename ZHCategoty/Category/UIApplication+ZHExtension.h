//
//  UIApplication+ZHExtension.h
//  ZHCategoty
//
//  Created by 李保征 on 2017/8/3.
//  Copyright © 2017年 李保征. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIApplication (ZHExtension)

- (NSString *)zh_AppShortVersion;

- (NSString *)zh_AppBuildVersion;

- (BOOL)zh_AppIsNewVersion;

- (NSString *)zh_AppBundleID;

- (BOOL)zh_skipAppStoreGrade:(NSString *)appID;

@end
