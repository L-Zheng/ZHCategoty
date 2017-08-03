//
//  ZHDefineHeader.h
//  ZHCategoty
//
//  Created by 李保征 on 2017/6/28.
//  Copyright © 2017年 李保征. All rights reserved.
//

#ifndef ZHDefineHeader_h
#define ZHDefineHeader_h


#pragma mark - Version

//系统版本 (systemVersion >= 9.0)
#define kSystemVersion [[UIDevice currentDevice].systemVersion floatValue]

//App信息
#define kAppShortVersion [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"]
#define kAppBuildVersion [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"]


#pragma mark - Device
//屏幕尺寸
#define kScreen_Width [[UIScreen mainScreen]bounds].size.width
#define kScreen_Height [[UIScreen mainScreen]bounds].size.height

//设备类型
//(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
#define kIsIpad ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad)
#define kIsIphone ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
#define kIsSimulator TARGET_IPHONE_SIMULATOR

#define kIsiPhone4 (kScreen_Width == 320 && kScreen_Height == 480)
#define kIsiPhone5 (kScreen_Width == 320 && kScreen_Height == 568)
#define kIsiPhone6 (kScreen_Width == 375 && kScreen_Height == 667)
#define kIsiPhone7 kIsiPhone6
#define kIsiPhone6Plus (kScreen_Width == 414 && kScreen_Height == 736)
#define kIsiPhone7Plus kIsiPhone6Plus

#define kIsScreen2X (kIsiPhone4 || kIsiPhone5 || kIsiPhone6 || kIsiPhone7)
#define kIsScreen3X (kIsiPhone6Plus || kIsiPhone7Plus)

#pragma mark - Path
//沙盒路径
#define kAppDocumentPath ([NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0])
#define kAppCachePath ([NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0])
#define kTemporaryPath (NSTemporaryDirectory())

#endif /* ZHDefineHeader_h */
