//
//  DailyCalendarView.h
//  Deputy
//
//  Created by Caesar on 30/10/2014.
//  Copyright (c) 2014 Caesar Li. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol DailyCalendarViewDelegate <NSObject>
-(void)dailyCalendarViewDidSelect: (NSDate *)date;


@end
@interface DailyCalendarView : UIView
@property (nonatomic, weak) id<DailyCalendarViewDelegate> delegate;
@property (nonatomic, strong) NSDate *date;
@property (nonatomic) BOOL blnSelected;
@property (nonatomic,strong)NSString * lunarDateString;

-(void)markSelected:(BOOL)blnSelected;
-(void)markSelected:(BOOL)blnSelected andWithWeekOrMonth:(BOOL)weekOrMonth andWithDate:(NSDate *)date;

@end

// 版权属于原作者
// http://code4app.com (cn) http://code4app.net (en)
// 发布代码于最专业的源码分享网站: Code4App.com 
