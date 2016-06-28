//
//  DailyCalendarView.m
//  Deputy
//
//  Created by Caesar on 30/10/2014.
//  Copyright (c) 2014 Caesar Li
//
#import "DailyCalendarView.h"
#import "NSDate+CL.h"
#import "UIColor+CL.h"

@interface DailyCalendarView()
@property (nonatomic, strong) UILabel *dateLabel;
@property (nonatomic, strong) UIView *dateLabelContainer;
@property (nonatomic,strong)UILabel * lunarDateLable;
@end


//#define DATE_LABEL_SIZE 28
#define DATE_LABEL_FONT_SIZE 16
#define LUNAR_LABLE_FONT_SIZE 14
#define DATE_LABEL_SIZE 50
#define DIS_DATE_LUNAR 3


@implementation DailyCalendarView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self addSubview:self.dateLabelContainer];
        
        UITapGestureRecognizer *singleFingerTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dailyViewDidClick:)];
        [self addGestureRecognizer:singleFingerTap];
    }
    return self;
}
-(UIView *)dateLabelContainer
{
    if(!_dateLabelContainer){
        float x = (self.bounds.size.width - DATE_LABEL_SIZE)/2;
        _dateLabelContainer = [[UIView alloc] initWithFrame:CGRectMake(x, 0, DATE_LABEL_SIZE, DATE_LABEL_SIZE)];
        _dateLabelContainer.backgroundColor = [UIColor clearColor];
        _dateLabelContainer.layer.cornerRadius = DATE_LABEL_SIZE/2;
        _dateLabelContainer.clipsToBounds = YES;
        [_dateLabelContainer addSubview:self.dateLabel];
        [_dateLabelContainer addSubview:self.lunarDateLable];
    }
    return _dateLabelContainer;
}
- (UILabel *)lunarDateLable {
    if (!_lunarDateLable) {
        _lunarDateLable = [[UILabel alloc] initWithFrame:CGRectMake(0, DATE_LABEL_SIZE/2 + DIS_DATE_LUNAR, DATE_LABEL_SIZE, DATE_LABEL_SIZE/2)];
        _lunarDateLable.backgroundColor = [UIColor clearColor];
        _lunarDateLable.textColor = [UIColor whiteColor];
        _lunarDateLable.textAlignment = NSTextAlignmentCenter;
        _lunarDateLable.font = [UIFont systemFontOfSize:LUNAR_LABLE_FONT_SIZE];
    }
    return _lunarDateLable;
}
-(UILabel *)dateLabel
{
    if(!_dateLabel){
        _dateLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, DATE_LABEL_SIZE, DATE_LABEL_SIZE/2)];
        _dateLabel.backgroundColor = [UIColor clearColor];
        _dateLabel.textColor = [UIColor whiteColor];
        _dateLabel.textAlignment = NSTextAlignmentCenter;
        _dateLabel.font = [UIFont systemFontOfSize:DATE_LABEL_FONT_SIZE];
    }
    
    return _dateLabel;
}

-(void)setDate:(NSDate *)date
{
    _date = date;
    
    [self setNeedsDisplay];
}
-(void)setBlnSelected: (BOOL)blnSelected
{
    _blnSelected = blnSelected;
    [self setNeedsDisplay];
}
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    self.dateLabel.text = [self.date getDateOfMonth];
    self.lunarDateLable.text = self.lunarDateString;
}

- (void)markSelected:(BOOL)blnSelected andWithWeekOrMonth:(BOOL)weekOrMonth andWithDate:(NSDate *)date{
/*
 

 */
    
    if([self.date isDateToday]){
        self.dateLabelContainer.backgroundColor = (blnSelected)?[UIColor whiteColor]: [UIColor colorWithHex:0x0081c1];
        
        self.dateLabel.textColor = (blnSelected)?[UIColor colorWithHex:0x0081c1]:[UIColor whiteColor];
        self.lunarDateLable.textColor = (blnSelected)?[UIColor colorWithHex:0x0081c1]:[UIColor whiteColor];
    }else{
        
        if (!weekOrMonth) {
            //获取到月份
            int month = [[[NSDate date] getMonthDay] intValue];
            //获取到年份
            int year = [[[NSDate date]  getYearDay] intValue];
            
            NSString * MonthDt =[NSString stringWithFormat:@"%d-%d-01",year,month];
            NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
            NSRange range = [calendar rangeOfUnit:NSDayCalendarUnit inUnit:NSMonthCalendarUnit forDate:[NSDate date]];
            NSUInteger numberOfDaysInMonth = range.length;
            NSString * MonthEnd = [NSString stringWithFormat:@"%d-%d-%lu",year,month,(unsigned long)numberOfDaysInMonth];
            NSDateFormatter * formmart = [NSDateFormatter new];
            [formmart setDateFormat:@"yyyy-MM-dd"];
            NSDate * dateMonthStart = [formmart dateFromString:MonthDt];
            NSDate * dateMonthEnd = [formmart dateFromString:MonthEnd];
            
            NSTimeInterval secondsIntervalStart= [dateMonthStart timeIntervalSinceDate:date];
            NSTimeInterval secondsIntervalEnd= [dateMonthEnd timeIntervalSinceDate:date];
            if (secondsIntervalStart > 0 || secondsIntervalEnd < 0) {
                self.dateLabel.alpha = 0.4;
                self.lunarDateLable.alpha = 0.4;
            }else {
                
                self.dateLabel.alpha = 1;
                self.lunarDateLable.alpha = 1;
            }
        }
        
        
        self.dateLabelContainer.backgroundColor = (blnSelected)?[UIColor whiteColor]: [UIColor clearColor];
        
        self.dateLabel.textColor = (blnSelected)?[UIColor colorWithRed:52.0/255.0 green:161.0/255.0 blue:255.0/255.0 alpha:1.0]:[self colorByDate];
        self.lunarDateLable.textColor = (blnSelected)?[UIColor colorWithRed:52.0/255.0 green:161.0/255.0 blue:255.0/255.0 alpha:1.0]:[self colorByDate];
        
    }
    
    
}
-(void)markSelected:(BOOL)blnSelected
{
    //    DLog(@"mark date selected %@ -- %d",self.date, blnSelected);
    if([self.date isDateToday]){
        self.dateLabelContainer.backgroundColor = (blnSelected)?[UIColor whiteColor]: [UIColor colorWithHex:0x0081c1];
        
        self.dateLabel.textColor = (blnSelected)?[UIColor colorWithHex:0x0081c1]:[UIColor whiteColor];
        self.lunarDateLable.textColor = (blnSelected)?[UIColor colorWithHex:0x0081c1]:[UIColor whiteColor];
    }else{
        self.dateLabelContainer.backgroundColor = (blnSelected)?[UIColor whiteColor]: [UIColor clearColor];
        
        self.dateLabel.textColor = (blnSelected)?[UIColor colorWithRed:52.0/255.0 green:161.0/255.0 blue:255.0/255.0 alpha:1.0]:[self colorByDate];
        self.lunarDateLable.textColor = (blnSelected)?[UIColor colorWithRed:52.0/255.0 green:161.0/255.0 blue:255.0/255.0 alpha:1.0]:[self colorByDate];
    }
    
    
    
    
}
-(UIColor *)colorByDate
{
    return [self.date isPastDate]?[UIColor colorWithHex:0x7BD1FF]:[UIColor whiteColor];
}

-(void)dailyViewDidClick: (UIGestureRecognizer *)tap
{
    [self.delegate dailyCalendarViewDidSelect: self.date];
}
@end


// 版权属于原作者
// http://code4app.com (cn) http://code4app.net (en)
// 发布代码于最专业的源码分享网站: Code4App.com 
