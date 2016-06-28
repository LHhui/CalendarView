//
//  NSDate+CL.m
//  CLWeeklyCalendarView
//
//  Created by Caesar on 10/12/2014.
//  Copyright (c) 2014 Caesar. All rights reserved.
//

#import "NSDate+CL.h"
#import "NTMonthCalendar.h"

#define ChineseDayNameDictionary  @{@"Mon":@"一",@"Tue":@"二",@"Wed":@"三",@"Thu":@"四",@"Fri":@"五",@"Sat":@"六",@"Sun":@"七"}

@implementation NSDate (CL)


-(NSDate *)getWeekStartDate: (NSInteger)weekStartIndex
{
    int weekDay = [[self getWeekDay] intValue];
    
//    [self getMonthStartDate:1];
    NSInteger gap = (weekStartIndex <=  weekDay) ?  weekDay  : ( 7 + weekDay );
    NSInteger day = weekStartIndex - gap;
    
    return [self addDays:day];
}

-(NSDate *)getMonthStartDate: (NSInteger)weekStartIndex{
    
    //获取到月份
   int month = [[self getMonthDay] intValue];
    //获取到年份
    int year = [[self getYearDay] intValue];
    
    NSString * MonthDt =[NSString stringWithFormat:@"%d-%d-01",year,month];
    NSDateFormatter * formmart = [NSDateFormatter new];
    [formmart setDateFormat:@"yyyy-MM-dd"];
    
    NSDate * dateMonth = [formmart dateFromString:MonthDt];
    NSDate *  date = [dateMonth getWeekStartDate:1];
    return date;
}

- (NSNumber *)getMonthDay {
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *comps = [gregorian components:NSCalendarUnitMonth fromDate:self];
    return [NSNumber numberWithInteger:[comps month]];
}
- (NSNumber *)getYearDay {
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *comps = [gregorian components:NSCalendarUnitYear fromDate:self];
    return [NSNumber numberWithInteger:[comps year]];
}

-(NSNumber *)getWeekDay
{
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *comps = [gregorian components:NSWeekdayCalendarUnit fromDate:self];
    return [NSNumber numberWithInteger:([comps weekday] - 1)];
}

-(NSDate *)addDays:(NSInteger)day
{
    NSDateComponents *dayComponent = [[NSDateComponents alloc] init];
    dayComponent.day = day;
    
    NSCalendar *theCalendar = [NSCalendar currentCalendar];
    return [theCalendar dateByAddingComponents:dayComponent toDate:self options:0];
}

-(NSString *)getDayOfWeekShortString
{
    static NSDateFormatter *shortDayOfWeekFormatter;
    if(!shortDayOfWeekFormatter){
        shortDayOfWeekFormatter = [[NSDateFormatter alloc] init];
        NSLocale* en_AU_POSIX = [[NSLocale alloc] initWithLocaleIdentifier:@"en_AU_POSIX"];
        [shortDayOfWeekFormatter setLocale:en_AU_POSIX];
        [shortDayOfWeekFormatter setDateFormat:@"E"];
    }
    

    
//
    return [ChineseDayNameDictionary objectForKey:[shortDayOfWeekFormatter stringFromDate:self]];
}

/****************************************************
 *@Description:获得NSDate对应的中国日历（农历）的NSDate
 *@Params:nil
 *@Return:NSDate对应的中国日历（农历）的LunarCalendar
 ****************************************************/
- (NTMonthCalendar *)chineseCalendarDate
{
    NTMonthCalendar *lunarCalendar = [[NTMonthCalendar alloc] init];
    [lunarCalendar loadWithDate:self];
    [lunarCalendar InitializeValue];
    return lunarCalendar;
}

-(NSString *)getDateOfMonth
{
    static NSDateFormatter *dateFormaater;
    if(!dateFormaater){
        dateFormaater = [[NSDateFormatter alloc] init];
        NSLocale* en_AU_POSIX = [[NSLocale alloc] initWithLocaleIdentifier:@"en_AU_POSIX"];
        [dateFormaater setLocale:en_AU_POSIX];
        [dateFormaater setDateFormat:@"d"];
    }
    return [dateFormaater stringFromDate:self];
}

- (NSDate*)midnightDate {
    return [[NSCalendar currentCalendar] dateFromComponents:[[NSCalendar currentCalendar] components:(NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit) fromDate:self]];
}
-(BOOL) isSameDateWith: (NSDate *)dt{
    return  ([[self midnightDate] isEqualToDate: [dt midnightDate]])?YES:NO;
}
- (BOOL)isDateToday {
    return [[[NSDate date] midnightDate] isEqual:[self midnightDate]];
}
- (BOOL)isWithinDate: (NSDate *)earlierDate toDate:(NSDate *)laterDate
{
    NSTimeInterval timestamp = [[self midnightDate] timeIntervalSince1970];
    NSDate *fdt = [earlierDate midnightDate];
    NSDate *tdt = [laterDate midnightDate];
    
    BOOL isWithinDate = (timestamp >= [fdt timeIntervalSince1970] && timestamp <= [tdt timeIntervalSince1970]);
    
    return isWithinDate;
    
}
- (BOOL)isPastDate {
    NSDate* now = [NSDate date];
    if([[now earlierDate:self] isEqualToDate:self]) {
        return YES;
    } else {
        return NO;
    }
}
@end

// 版权属于原作者
// http://code4app.com (cn) http://code4app.net (en)
// 发布代码于最专业的源码分享网站: Code4App.com 
