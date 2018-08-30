//
//  NSDate+ZHExtension.m
//  ZHCategoty
//
//  Created by 李保征 on 2017/7/3.
//  Copyright © 2017年 李保征. All rights reserved.
//

#import "NSDate+ZHExtension.h"

@implementation NSDate (ZHExtension)

#pragma mark - public

- (NSString *)stringFromDateFormat:(NSString *)dateFormat{
    //设置区域  @"en_US" @"zh_CH"
    NSLocale *local =[[NSLocale alloc] initWithLocaleIdentifier:@"zh_CH"];
    //设置时区(如果设置时区 转换的字符串是零时区的时间字符串)
    //    NSTimeZone *timeZone = [NSTimeZone timeZoneForSecondsFromGMT:8];
    
    NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
    [fmt setLocale:local];
    //    [fmt setTimeZone:timeZone];
//    星期 月 日 小时  分钟  秒 时区  年  上下午
    //    fmt.dateFormat = @"EEE MMM dd HH:mm:ss Z yyyy aaa";
    fmt.dateFormat = dateFormat;
    return [fmt stringFromDate:self];
}

//世纪
- (NSInteger)era{
    return [Components(self) era];
}

//年
- (NSInteger)year{
    return [Components(self) year];
}

//月
- (NSInteger)month{
    return [Components(self) month];
}

//日
- (NSInteger)day{
    return [Components(self) day];
}

//时
- (NSInteger)hour{
    return [Components(self) hour];
}

//分
- (NSInteger)minute{
    return [Components(self) minute];
}

//秒
- (NSInteger)second{
    return [Components(self) second];
}

//刻钟 （1~4）
- (NSInteger)quarter{
    return [Components(self) quarter];
}

//当前天的起始时间  00：00：00
- (NSDate *)currentDayStartDate{
    NSDateComponents *cmps = Components(self);
    cmps.hour = 0;
    cmps.minute = 0;
    cmps.second = 0;
    return [Calendar() dateFromComponents:cmps];
}

//当前天的结束时间  23：59：59
- (NSDate *)currentDayEndDate{
    NSDateComponents *cmps = Components(self);
    cmps.hour = 23;
    cmps.minute = 59;
    cmps.second = 59;
    return [Calendar() dateFromComponents:cmps];
}

//今天的起始时间  00：00：00
+ (NSDate *)toDayStartDate{
    return [[NSDate date] currentDayStartDate];
}

//今天的结束时间  23：59：59
+ (NSDate *)toDayEndDate{
    return [[NSDate date] currentDayEndDate];
}

//前一天的起始时间  00：00：00
- (NSDate *)previousDayStartDate{
    return [NSDate dateWithTimeInterval:-24 * 60 * 60 sinceDate:[self currentDayStartDate]];
}

//前一天的结束时间  23：59：59
- (NSDate *)previousDayEndDate{
    return [NSDate dateWithTimeInterval:-1 sinceDate:[self currentDayStartDate]];
}

//后一天的起始时间  00：00：00
- (NSDate *)nextDayStartDate{
    return [NSDate dateWithTimeInterval:1 sinceDate:[self currentDayEndDate]];
}

//后一天的结束时间  23：59：59
- (NSDate *)nextDayEndDate{
    return [NSDate dateWithTimeInterval:24 * 60 * 60 sinceDate:[self currentDayEndDate]];
}

//前一天
- (NSDate *)previousDay{
    NSDateComponents *dateComponents = [[NSDateComponents alloc] init];
    dateComponents.day = -1;
    NSDate *newDate = [Calendar() dateByAddingComponents:dateComponents toDate:self options:0];
    return newDate;
}

//后一天
- (NSDate *)nextDay{
    NSDateComponents *dateComponents = [[NSDateComponents alloc] init];
    dateComponents.day = +1;
    NSDate *newDate = [Calendar() dateByAddingComponents:dateComponents toDate:self options:0];
    return newDate;
}

//上个月  07~31-->06~30
- (NSDate *)previousMonth{
    NSDateComponents *dateComponents = [[NSDateComponents alloc] init];
    dateComponents.month = -1;
    NSDate *newDate = [Calendar() dateByAddingComponents:dateComponents toDate:self options:0];
    return newDate;
}

//下个月  08~31-->09~30
- (NSDate *)nextMonth{
    NSDateComponents *dateComponents = [[NSDateComponents alloc] init];
    dateComponents.month = +1;
    NSDate *newDate = [Calendar() dateByAddingComponents:dateComponents toDate:self options:0];
    return newDate;
}

//上一年
- (NSDate *)previousYear{
    NSDateComponents *dateComponents = [[NSDateComponents alloc] init];
    dateComponents.year = -1;
    NSDate *newDate = [Calendar() dateByAddingComponents:dateComponents toDate:self options:0];
    return newDate;
}

//下一年
- (NSDate *)nextYear{
    NSDateComponents *dateComponents = [[NSDateComponents alloc] init];
    dateComponents.year = +1;
    NSDate *newDate = [Calendar() dateByAddingComponents:dateComponents toDate:self options:0];
    return newDate;
}

//本周的第几天（一周起始日：周日） 如 周三 ---> 返回4
- (NSInteger)weekday{
    return [Components(self) weekday];
}

//本月的第几个7天 （1~7 第一个  8~14 第二个。。。）
- (NSInteger)weekdayOrdinal{
    return [Components(self) weekdayOrdinal];
}

//本月月包含几周 (<=6)
- (NSInteger)weekOfMonth{
    return [Components(self) weekOfMonth];
}

//本年包含几周 (<=53)
- (NSInteger)weekOfYear{
    return [Components(self) weekOfYear];
}

- (NSInteger)yearForWeekOfYear{
    return [Components(self) yearForWeekOfYear];
}

//本月天数
- (NSInteger)allDaysCountInThisMonth{
    NSRange totaldaysInMonth = [Calendar() rangeOfUnit:NSCalendarUnitDay inUnit:NSCalendarUnitMonth forDate:self];
    return totaldaysInMonth.length;
}

//本年天数
- (NSInteger)allDaysCountInThisYear{
    NSRange totaldaysInYear = [Calendar() rangeOfUnit:NSCalendarUnitDay inUnit:NSCalendarUnitYear forDate:self];
    return totaldaysInYear.length;
}

//本月第一天
- (NSDate *)firstDateInThisMonth{
    NSDateComponents *components = [[NSDateComponents alloc] init];
    components.calendar = Calendar();
    components.timeZone = [NSTimeZone timeZoneForSecondsFromGMT:8];
    components.year = self.year;
    components.month = self.month;
    components.day = 1;
    
    return [Calendar() dateFromComponents:components];
}

// startingDate 距离 self 多少小时
- (NSInteger)distanceHoursFromDate:(NSDate *)startingDate{
    return DistanceComponents(startingDate, self).hour;
}

// startingDate 距离 self 多少分钟
- (NSInteger)distanceMinutesFromDate:(NSDate *)startingDate{
    return DistanceComponents(startingDate, self).minute;
}

// self 距离 现在 多少小时
- (NSInteger)distanceHoursToNow{
    return DistanceComponents(self, [NSDate date]).hour;
}

// self 距离 现在 多少分钟
- (NSInteger)distanceMinutesToNow{
    return DistanceComponents(self, [NSDate date]).minute;
}

- (BOOL)isToday{
    NSDateComponents *nowCmps = Components([NSDate date]);
    NSDateComponents *selfCmps = Components(self);
    return ((selfCmps.year == nowCmps.year) && (selfCmps.month == nowCmps.month) && (selfCmps.day == nowCmps.day));
}

- (BOOL)isYesterday{
    NSDateComponents *cmps = DistanceComponents(self, [[NSDate date] previousDayEndDate]);
    if ((cmps.second >= 0) && (cmps.day < 1)) {
        // cmps.second >= 0  代表  self < previousDayEndDate
        // cmps.day < 1      代表  self > previousDayStartDate
        return YES;
    }else{
        return NO;
    }
}

- (BOOL)isThisMonth{
    NSDateComponents *nowCmps = Components([NSDate date]);
    NSDateComponents *selfCmps = Components(self);
    return (nowCmps.year == selfCmps.year) && (nowCmps.month == selfCmps.month);
}

- (BOOL)isThisYear{
    NSDateComponents *nowCmps = Components([NSDate date]);
    NSDateComponents *selfCmps = Components(self);
    return nowCmps.year == selfCmps.year;
}

//是否是周末
- (BOOL)isWeekendDay{
    NSInteger weekDay = [self weekday];
    if (weekDay == 1 || weekDay == 7) {
        return YES;
    } else{
        return NO;
    }
}

//是否是本月的第一天
- (BOOL)isFirstDayInThisMonth{
    return (self.day == 1);
}

/** 小时前 分钟前*/
- (NSString *)referenceTimeText{
    if (self.isThisYear) {  //今年
        if (self.isToday) {  //今天
            NSDateComponents *cmps = DistanceComponents(self, [NSDate date]);
            if (cmps.hour >= 1) { // 至少是1小时前发的
                return [NSString stringWithFormat:@"%ld小时前", cmps.hour];
            } else if (cmps.minute >= 1) { // 1~59分钟之前发的
                return [NSString stringWithFormat:@"%ld分钟前", cmps.minute];
            } else { // 1分钟内发的
                return @"刚刚";
            }
        }else if (self.isYesterday){ //昨天
            return [self stringFromDateFormat:@"昨天 HH:mm"];
        }else{ //至少是前天
            return [self stringFromDateFormat:@"MM-dd HH:mm"];
        }
    } else {
        return [self stringFromDateFormat:@"yyyy-MM-dd"];
    }
}

#pragma mark - Private func

NSCalendar* Calendar(){
    if ([NSCalendar respondsToSelector:@selector(calendarWithIdentifier:)]) {
        //NSCalendarIdentifierGregorian  阳历
        // NSCalendarIdentifierChinese   阴历
        return [NSCalendar calendarWithIdentifier:NSCalendarIdentifierGregorian];
    }
    return [NSCalendar currentCalendar];
}

NSDateComponents* Components(NSDate *date) {
    int unit = NSCalendarUnitEra | NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond | NSCalendarUnitWeekday | NSCalendarUnitWeekdayOrdinal | NSCalendarUnitWeekOfMonth | NSCalendarUnitWeekOfYear | NSCalendarUnitQuarter | NSCalendarUnitYearForWeekOfYear;
    return [Calendar() components:unit fromDate:date];
}

NSDateComponents* DistanceComponents(NSDate *date1, NSDate *date2) {
    int unit = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
    return [Calendar() components:unit fromDate:date1 toDate:date2 options:0];
}


//other
- (NSString *)referenceTimeText1111{
    NSDate *todayDate = [NSDate date];

    NSDateComponents *diatanceCmps = DistanceComponents(self, todayDate);
    if (diatanceCmps.second > 0) {//过去的某个时间
        if (DistanceComponents(self,[todayDate currentDayStartDate]).second <= 0) {
            return [NSString stringWithFormat:@"今天--%@",[self stringFromDateFormat:@"yyyy-MM-dd HH:mm:ss"]];
        }else{//今天以前
            NSDateComponents *cmps = DistanceComponents(self, [todayDate previousDayEndDate]);
            if (cmps.day == 0) {
                return [NSString stringWithFormat:@"昨天--%@",[self stringFromDateFormat:@"yyyy-MM-dd HH:mm:ss"]];
            }else if (cmps.day == 1){
                return [NSString stringWithFormat:@"前天--%@",[self stringFromDateFormat:@"yyyy-MM-dd HH:mm:ss"]];
            }else{
                return [NSString stringWithFormat:@"%ld天前--%@",cmps.day,[self stringFromDateFormat:@"yyyy-MM-dd HH:mm:ss"]];
            }
        }
    }else if (diatanceCmps.second < 0){ //将来的某个时间
        if (DistanceComponents(self,[todayDate currentDayEndDate]).second >= 0) {
            return [NSString stringWithFormat:@"今天--%@",[self stringFromDateFormat:@"yyyy-MM-dd HH:mm:ss"]];
        }else{//今天以后
            NSDateComponents *cmps = DistanceComponents([todayDate nextDayStartDate], self);
            if (cmps.day == 0) {
                return [NSString stringWithFormat:@"明天--%@",[self stringFromDateFormat:@"yyyy-MM-dd HH:mm:ss"]];
            }else if (cmps.day == 1){
                return [NSString stringWithFormat:@"后天--%@",[self stringFromDateFormat:@"yyyy-MM-dd HH:mm:ss"]];
            }else{
                return [NSString stringWithFormat:@"%ld天后--%@",cmps.day,[self stringFromDateFormat:@"yyyy-MM-dd HH:mm:ss"]];
            }
        }
    }else{
        return [NSString stringWithFormat:@"今天--%@",[self stringFromDateFormat:@"yyyy-MM-dd HH:mm:ss"]];
    }
}

//按照时间天数进行分组 ---- 一天内的数据为一组
- (void)tese{
    NSDate *todayDate = [NSDate date];
    NSDate *todayStartDate = [todayDate currentDayStartDate];//今天起始时间
    NSDate *yesterDayEndDate = [todayDate previousDayEndDate];
    
    NSArray <NSDate *> *arr = @[[NSDate date],[NSDate dateWithTimeIntervalSinceNow:-60 * 60]];
    
    NSMutableArray <NSMutableArray *> *list = [NSMutableArray array];
    NSMutableArray <NSDate *> *subList = nil;
    NSInteger dayCount = 0;
    for (NSDate *date in arr) {
        //一天内的数据为一组
        if ([date timeIntervalSinceDate:todayStartDate] >= 0) {//今天
            if (list.count == 0) {
                subList = [NSMutableArray array];
                [list addObject:subList];
            }
        }else{//今天以前
            NSInteger distanceDayCount = DistanceComponents(date, yesterDayEndDate).day;
            if (distanceDayCount >= dayCount) {
                subList = [NSMutableArray array];
                [list addObject:subList];
                dayCount = distanceDayCount + 1;
            }
        }
    }
}


@end
