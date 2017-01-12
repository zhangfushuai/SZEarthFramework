//
//  ViewController.h
//  RiLiTest
//
//  Created by quan on 16/3/4.
//  Copyright © 2016年 quan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SZEarthMyCollectionViewCell.h"
#import "SZEarthHistoryViewController.h"

@interface SZEarthCalendarViewController : UICollectionViewController

@property NSInteger dayCounts; //这个月有几天;
@property NSInteger currentDay; //今天是几号

@property NSInteger weeksOfFirstDay; //这个月的第一天是星期几
@property NSInteger currentRow; //今天的日期所在的项的位置;

@property NSInteger firstDayRowOfMonth; //第一天的日期所在的项的位置;
@property NSInteger lastDayRowOfMonth; //最后一天的日期所在的项的位置;

@property NSInteger one; //设置集合视图中本月的项的量

@property NSInteger lastMonthDays;
@property NSInteger nextMonthDays;

@property NSDate *currentDate; //当前显示的date

@property (strong,nonatomic) UIButton *backwardButton;
@property (strong,nonatomic) UIButton *forwardButton;
@property (strong,nonatomic) UILabel *titleLabel;
@property (strong, nonatomic) UIView *titleView;


@end

