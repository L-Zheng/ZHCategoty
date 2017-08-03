//
//  UIApplication+ZHExtension.m
//  ZHCategoty
//
//  Created by 李保征 on 2017/8/3.
//  Copyright © 2017年 李保征. All rights reserved.
//

#import "UIApplication+ZHExtension.h"

#define ZHAppShortVersionUserDefaultsKey @"ZHAppShortVersionUserDefaultsKey"

@implementation UIApplication (ZHExtension)

- (NSString *)zh_AppShortVersion{
    return [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
}

- (NSString *)zh_AppBuildVersion{
    return [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"];
}

- (BOOL)zh_AppIsNewVersion{
    
    NSString *lastVersionStr = [[NSUserDefaults standardUserDefaults] valueForKey:ZHAppShortVersionUserDefaultsKey];
    
    BOOL isNewVersion = NO;
    
    NSComparisonResult compareResult = [self.zh_AppShortVersion compare:lastVersionStr];
    
    if (compareResult == NSOrderedAscending) { //升序
        
        isNewVersion = NO;
        
    } else if (compareResult == NSOrderedDescending){ //降序
        
        isNewVersion = YES;
        
    } else {
        
        isNewVersion = NO;
        
    }
    return isNewVersion;
}

- (NSString *)zh_AppBundleID{
    return [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleIdentifier"];
}

- (BOOL)zh_skipAppStoreGrade:(NSString *)appID{
//    NSString *appid = @"717804289";
    NSString *str = [NSString stringWithFormat:
                     @"itms-apps://itunes.apple.com/cn/app/id%@?mt=8", appID];
    return [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
}

@end
