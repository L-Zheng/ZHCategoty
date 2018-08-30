//
//  NSDate+ZHExtension.h
//  ZHCategoty
//
//  Created by 李保征 on 2017/7/3.
//  Copyright © 2017年 李保征. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (ZHExtension)

- (NSString *)stringFromDateFormat:(NSString *)dateFormat;

//世纪
- (NSInteger)era;

//年
- (NSInteger)year;

//月
- (NSInteger)month;

//日
- (NSInteger)day;

//时
- (NSInteger)hour;

//分
- (NSInteger)minute;

//秒
- (NSInteger)second;

//刻钟 （1~4）
- (NSInteger)quarter;

//当前天的起始时间  00：00：00
- (NSDate *)currentDayStartDate;

//当前天的结束时间  23：59：59
- (NSDate *)currentDayEndDate;

//今天的起始时间  00：00：00
+ (NSDate *)toDayStartDate;

//今天的结束时间  23：59：59
+ (NSDate *)toDayEndDate;

//前一天的起始时间  00：00：00
- (NSDate *)previousDayStartDate;

//前一天的结束时间  23：59：59
- (NSDate *)previousDayEndDate;

//后一天的起始时间  00：00：00
- (NSDate *)nextDayStartDate;

//后一天的结束时间  23：59：59
- (NSDate *)nextDayEndDate;

//前一天
- (NSDate *)previousDay;

//后一天
- (NSDate *)nextDay;

//上个月  07~31-->06~30
- (NSDate *)previousMonth;

//下个月  08~31-->09~30
- (NSDate *)nextMonth;

//上一年
- (NSDate *)previousYear;

//下一年
- (NSDate *)nextYear;

//本周的第几天（一周起始日：周日） 如 周三 ---> 返回4
- (NSInteger)weekday;

//本月的第几个7天 （1~7 第一个  8~14 第二个。。。）
- (NSInteger)weekdayOrdinal;

//本月月包含几周 (<=6)
- (NSInteger)weekOfMonth;

//本年包含几周 (<=53)
- (NSInteger)weekOfYear;

- (NSInteger)yearForWeekOfYear;

//本月天数
- (NSInteger)allDaysCountInThisMonth;

//本年天数
- (NSInteger)allDaysCountInThisYear;

//本月第一天
- (NSDate *)firstDateInThisMonth;

// startingDate 距离 self 多少小时
- (NSInteger)distanceHoursFromDate:(NSDate *)startingDate;

// startingDate 距离 self 多少分钟
- (NSInteger)distanceMinutesFromDate:(NSDate *)startingDate;

// self 距离 现在 多少小时
- (NSInteger)distanceHoursToNow;

// self 距离 现在 多少分钟
- (NSInteger)distanceMinutesToNow;

- (BOOL)isToday;

- (BOOL)isYesterday;

- (BOOL)isThisMonth;

- (BOOL)isThisYear;

//是否是周末
- (BOOL)isWeekendDay;

//是否是本月的第一天
- (BOOL)isFirstDayInThisMonth;

/** 小时前 分钟前*/
- (NSString *)referenceTimeText;


@end
