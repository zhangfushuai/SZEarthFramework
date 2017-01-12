//
//  ViewController.m
//  RiLiTest
//
//  Created by quan on 16/3/4.
//  Copyright © 2016年 quan. All rights reserved.
//

#import "SZEarthCalendarViewController.h"

#import "UIImage+SZEarth_UIImage.h"

#import "SZEarthMy_DB.h"

@interface SZEarthCalendarViewController ()

@property NSArray *historyDataArray;

@end

@implementation SZEarthCalendarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    [self.collectionView registerClass:[SZEarthMyCollectionViewCell class]
            forCellWithReuseIdentifier:@"Cell"];
    
    self.collectionView.backgroundColor = [UIColor whiteColor];
    
    _one = 0;
    
    NSDate *now = [NSDate date];
    
    _currentDay = [self day:now];
    
    _currentDate = now;
    
    _dayCounts = [self totaldaysInMonth:now];
    
    _weeksOfFirstDay = [self firstWeekdayInThisMotnth:now];
    
    _lastMonthDays = [self totaldaysInMonth:[self lastMonth:now]];
    
    _nextMonthDays = [self totaldaysInMonth:[self nextMonth:now]];
    
    _firstDayRowOfMonth = _weeksOfFirstDay - 1;
    _lastDayRowOfMonth = _firstDayRowOfMonth + _dayCounts;
    
     _titleView= [self createTitleView];
    self.navigationItem.titleView = _titleView;
    
    NSString *userEmail = [[NSUserDefaults standardUserDefaults] objectForKey:@"SZEarthUserEmail"];
    NSString *selectedString = [NSString stringWithFormat:@"select * from games_property where games_email='%@' " , userEmail];;
    SZEarthMy_DB *mydb = [[SZEarthMy_DB alloc]init];
    [mydb Select_games: selectedString];
    
    
    _historyDataArray = [[NSArray alloc]init];
    _historyDataArray = mydb->array_game;
    
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamedFromCustomBundle:@"导航条"] forBarMetrics:UIBarMetricsDefault];
    
    _titleLabel.text = [self toLocalStringOfDate:_currentDate];
}

-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    UISwipeGestureRecognizer *recognizer;
    recognizer = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(handleSwipeFrom:)];
    
    [recognizer setDirection:(UISwipeGestureRecognizerDirectionRight)];
    [self.collectionView addGestureRecognizer:recognizer];
    recognizer = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(handleSwipeFrom:)];
    
    [recognizer setDirection:(UISwipeGestureRecognizerDirectionLeft)];
    [self.collectionView addGestureRecognizer:recognizer];
}

-(void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.navigationItem.title = @"";
}

-(void)handleSwipeFrom:(UISwipeGestureRecognizer *)recognizer{
    
    if(recognizer.direction==UISwipeGestureRecognizerDirectionLeft) {
        [self touchDownForwardButton];
    }
    
    if(recognizer.direction==UISwipeGestureRecognizerDirectionRight) {
        [self touchDownBackwardButton];
    }
    
}

//转换为当前时区的时间
- (NSDate *)getNowDateFromatAnDate:(NSDate *)anyDate
{
    //设置源日期时区
    NSTimeZone* sourceTimeZone = [NSTimeZone timeZoneWithAbbreviation:@"UTC"];//或GMT
    //设置转换后的目标日期时区
    NSTimeZone* destinationTimeZone = [NSTimeZone localTimeZone];
    //得到源日期与世界标准时间的偏移量
    NSInteger sourceGMTOffset = [sourceTimeZone secondsFromGMTForDate:anyDate];
    //目标日期与本地时区的偏移量
    NSInteger destinationGMTOffset = [destinationTimeZone secondsFromGMTForDate:anyDate];
    //得到时间偏移量的差值
    NSTimeInterval interval = destinationGMTOffset - sourceGMTOffset;
    //转为现在时间
    NSDate* destinationDateNow = [[NSDate alloc] initWithTimeInterval:interval sinceDate:anyDate];
    return destinationDateNow;
}

-(NSDate*)toLocalDate:(NSDate*)date {
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    NSTimeZone *GTMZone = [NSTimeZone timeZoneForSecondsFromGMT:0];
    [formatter setTimeZone:GTMZone];
    NSString *dateStr = [formatter stringFromDate:date];
    return [formatter dateFromString:dateStr];
}

-(NSString*)toLocalStringOfDate:(NSDate*)date {
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyyy年 MM月"];
    NSTimeZone *GTMZone = [NSTimeZone timeZoneForSecondsFromGMT:0];
//    NSTimeZone *GTMZone = [NSTimeZone localTimeZone];
    [formatter setTimeZone:GTMZone];
    
    NSString *dateStr = [formatter stringFromDate:date];
    return dateStr;
}

//给定一个日期，计算出这个月的第一天是星期几;
- (NSInteger)firstWeekdayInThisMotnth:(NSDate *)date{
    NSCalendar *calendar = [NSCalendar currentCalendar]; // 取得当前用户的逻辑日历(logical calendar)
    
    [calendar setFirstWeekday:1]; //  设定每周的第一天从星期几开始，比如:. 如需设定从星期日开始，则value传入1 ，如需设定从星期一开始，则value传入2 ，以此类推
    NSDateComponents *comp = [calendar components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay fromDate:date];
    [comp setDay:1]; // 设置为这个月的第一天
    NSDate *firstDayOfMonthDate = [calendar dateFromComponents:comp];
    NSUInteger firstWeekday = [calendar ordinalityOfUnit:NSCalendarUnitWeekday inUnit:NSCalendarUnitWeekOfMonth forDate:firstDayOfMonthDate]; // 这个月第一天在当前日历的顺序
    // 返回某个特定时间(date)其对应的小的时间单元(smaller)在大的时间单元(larger)中的顺序
    return firstWeekday - 1;
}

//给我一个日期，我就能显示出这个月的长度了
- (NSInteger)totaldaysInMonth:(NSDate *)date{
    NSRange daysInOfMonth = [[NSCalendar currentCalendar] rangeOfUnit:NSCalendarUnitDay inUnit:NSCalendarUnitMonth forDate:date]; // 返回某个特定时间(date)其对应的小的时间单元(smaller)在大的时间单元(larger)中的范围
    
    return daysInOfMonth.length;
}

//其它可能用到的
// /*

// 日历的上一个月
- (NSDate *)lastMonth:(NSDate *)date{
    NSDateComponents *comp = [[NSDateComponents alloc]init];
    comp.timeZone = [NSTimeZone localTimeZone];
    comp.month = -1;
    NSDate *newDate = [[NSCalendar currentCalendar] dateByAddingComponents:comp toDate:date options:0];
    return newDate;
}

// 日历的下一个月
- (NSDate *)nextMonth:(NSDate *)date{
    NSDateComponents *comp = [[NSDateComponents alloc]init];
    comp.timeZone = [NSTimeZone localTimeZone];
    comp.month = 1;
    NSDate *newDate = [[NSCalendar currentCalendar] dateByAddingComponents:comp toDate:date options:0];
    return newDate;
}

//字符窜转nsdate
- (NSDate *)dateFromString:(NSString *)dateString{
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    
    [dateFormatter setDateFormat: @"yyyy年 MM月 dd日 HH:mm:ss"];
    
    
    NSDate *destDate= [dateFormatter dateFromString:dateString];
    
    return destDate;
    
}

// 获取日历的年份
- (NSInteger)year:(NSDate *)date{
    NSDateComponents *components = [[NSCalendar currentCalendar] components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay) fromDate:date];
    components.timeZone = [NSTimeZone localTimeZone];
    return [components year];
}

// 获取日历的月份
- (NSInteger)month:(NSDate *)date{
    NSDateComponents *components = [[NSCalendar currentCalendar] components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay) fromDate:date];
    components.timeZone = [NSTimeZone localTimeZone];
    return [components month];
}

// 获取日历的第几天
- (NSInteger)day:(NSDate *)date{
    NSDateComponents *components = [[NSCalendar currentCalendar] components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay) fromDate:date];
    components.timeZone = [NSTimeZone localTimeZone];
    return [components day];
}

//创建导航栏标题控件
-(UIView*)createTitleView {
    UIView *titleView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.navigationController.navigationBar.frame.size.width*0.5, self.navigationController.navigationBar.frame.size.height*0.6)];
    _backwardButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, titleView.frame.size.width*0.15, titleView.frame.size.height)];
    _forwardButton = [[UIButton alloc]initWithFrame:CGRectMake(titleView.frame.size.width - titleView.frame.size.width*0.15, 0, titleView.frame.size.width*0.15, titleView.frame.size.height)];
    _titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(titleView.frame.size.width*0.15, 0, titleView.frame.size.width*0.7, titleView.frame.size.height)];
    
    _titleLabel.text = [self toLocalStringOfDate:_currentDate];
    _titleLabel.textAlignment = NSTextAlignmentCenter;
    _titleLabel.textColor = [UIColor whiteColor];
    
    [_forwardButton addTarget:self action:@selector(touchDownForwardButton) forControlEvents:UIControlEventTouchDown];
    [_backwardButton addTarget:self action:@selector(touchDownBackwardButton) forControlEvents:UIControlEventTouchDown];
    [_backwardButton setImage:[UIImage imageNamedFromCustomBundle:@"后退"] forState:UIControlStateNormal];
    [_forwardButton setImage:[UIImage imageNamedFromCustomBundle:@"前进"] forState:UIControlStateNormal];
    
    [titleView addSubview:_backwardButton];
    [titleView addSubview:_forwardButton];
    [titleView addSubview:_titleLabel];
    
    return titleView;
}


-(void)touchDownForwardButton {
    
    _currentDate = [self nextMonth:_currentDate];
    
    _dayCounts = [self totaldaysInMonth:_currentDate];
    
    if ([[self toLocalStringOfDate:_currentDate] isEqualToString:[self toLocalStringOfDate:[NSDate date]]]) {
        _currentDay = [self day:[NSDate date]];
        
    } else {
        _currentDay = -1;
        _currentRow = -1;
    }
    
    _one = 0;
    
    _weeksOfFirstDay = [self firstWeekdayInThisMotnth:_currentDate];
    
    _lastMonthDays = [self totaldaysInMonth:[self lastMonth:_currentDate]];
    
    _nextMonthDays = [self totaldaysInMonth:[self nextMonth:_currentDate]];
    
    _firstDayRowOfMonth = _weeksOfFirstDay - 1;
    _lastDayRowOfMonth = _firstDayRowOfMonth + _dayCounts;
    
    _titleLabel.text = [self toLocalStringOfDate:_currentDate];
    
    [self.collectionView reloadItemsAtIndexPaths:[self.collectionView indexPathsForVisibleItems]];
    
}
-(void)touchDownBackwardButton {
    
    _currentDate = [self lastMonth:_currentDate];
    
    _dayCounts = [self totaldaysInMonth:_currentDate];
    
    if ([[self toLocalStringOfDate:_currentDate] isEqualToString:[self toLocalStringOfDate:[NSDate date]]]) {
        _currentDay = [self day:[NSDate date]];
    } else {
        _currentDay = -1;
        _currentRow = -1;
    }
    
    _one = 0;
    
    _weeksOfFirstDay = [self firstWeekdayInThisMotnth:_currentDate];
    
    _lastMonthDays = [self totaldaysInMonth:[self lastMonth:_currentDate]];
    
    _nextMonthDays = [self totaldaysInMonth:[self nextMonth:_currentDate]];
    
    _firstDayRowOfMonth = _weeksOfFirstDay - 1;
    _lastDayRowOfMonth = _firstDayRowOfMonth + _dayCounts;
    
    _titleLabel.text = [self toLocalStringOfDate:_currentDate];
    
    [self.collectionView reloadItemsAtIndexPaths:[self.collectionView indexPathsForVisibleItems]];
}

// */

//定义展示的UICollectionViewCell的个数
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 42;
}
//定义展示的Section的个数
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}
//每个UICollectionView展示的内容
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *reuseID = @"Cell";
    SZEarthMyCollectionViewCell *cell = (SZEarthMyCollectionViewCell*)[collectionView dequeueReusableCellWithReuseIdentifier:reuseID forIndexPath:indexPath];
    cell.backgroundColor = [UIColor clearColor];
    if (_weeksOfFirstDay - 1 <= indexPath.row) {
        _one +=1;
        if (_one<=_dayCounts) {
            if (_one == 1) {
                _firstDayRowOfMonth = indexPath.row;
            }
            if (_one==_dayCounts) {
                _lastDayRowOfMonth = indexPath.row;
            }
            cell.botlabel.text = [NSString stringWithFormat:@"%ld",(long)_one];  //本月的
            cell.botlabel.textColor = [UIColor blueColor];
            if (_currentDay == _one) {
                _currentRow = indexPath.row;
                cell.botlabel.backgroundColor = [UIColor redColor];
                
            } else {
                cell.botlabel.backgroundColor = [UIColor clearColor];
            }
        } else { //下个月的
            cell.botlabel.text = [NSString stringWithFormat:@"%d",(int)(_one - _dayCounts)];
            cell.botlabel.textColor = [UIColor grayColor];
            cell.botlabel.backgroundColor = [UIColor clearColor];
        }
        
        
    } else { //上个月的
        cell.botlabel.text = [NSString stringWithFormat:@"%d",(int)(_lastMonthDays - _weeksOfFirstDay+indexPath.row+2)];
        cell.botlabel.textColor = [UIColor grayColor];
        
    }
    cell.dotImageView.hidden = YES;
    cell.layer.cornerRadius = cell.frame.size.height/2.0;
    cell.layer.masksToBounds = YES;

    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath {
    SZEarthMyCollectionViewCell * cell2 = (SZEarthMyCollectionViewCell *)cell;
    NSString *selectedDayString = cell2.botlabel.text;
    if ([selectedDayString intValue] < 10) {
        selectedDayString = [@"0" stringByAppendingString:selectedDayString];
    }
 
    if (indexPath.row >= _firstDayRowOfMonth && indexPath.row <= _lastDayRowOfMonth ) {
        selectedDayString = [NSString stringWithFormat:@"%@ %@日", _titleLabel.text, selectedDayString];
    }
    if (indexPath.row < _firstDayRowOfMonth) {
        selectedDayString =[NSString stringWithFormat:@"%@ %@日",[self toLocalStringOfDate:[self lastMonth:_currentDate]], selectedDayString] ;
        
    }
    if (indexPath.row > _lastDayRowOfMonth) {
        selectedDayString =[NSString stringWithFormat:@"%@ %@日",[self toLocalStringOfDate:[self nextMonth:_currentDate]], selectedDayString];
    }
    
    //是否隐藏圆点
    for (NSObject * object in _historyDataArray)
    {
        
        SZEarthClass_Game *cla_game1=(SZEarthClass_Game *)object;
        
        NSDate *aDate = [NSDate dateWithTimeIntervalSinceReferenceDate:cla_game1->stu_game.games_end_time-8*3600 ];
        NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
        [formatter setDateFormat:@"yyyy年 MM月 dd日"];
        NSTimeZone *GTMZone = [NSTimeZone timeZoneForSecondsFromGMT:0];
        [formatter setTimeZone:GTMZone];
        
        NSString *endTimeStr = [formatter stringFromDate:aDate];
        
        if ([endTimeStr isEqualToString: selectedDayString]) {
            cell2.dotImageView.hidden = NO;
            break;
        }
        
    }
    
}


#pragma mark --UICollectionViewDelegateFlowLayout
//定义每个UICollectionView 的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(self.view.frame.size.width/9.0, self.view.frame.size.width/9.0);
}
//定义每个UICollectionView 的 margin
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(0, 0, 0, 0);
}
#pragma mark --UICollectionViewDelegate
//UICollectionView被选中时调用的方法
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    SZEarthMyCollectionViewCell * cell = (SZEarthMyCollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
    NSString *selectedDayString = cell.botlabel.text;
    if (indexPath.row >= _firstDayRowOfMonth && indexPath.row <= _lastDayRowOfMonth ) {
        selectedDayString = [NSString stringWithFormat:@"%@ %@日", _titleLabel.text, selectedDayString];
    }
    if (indexPath.row < _firstDayRowOfMonth) {
        selectedDayString =[NSString stringWithFormat:@"%@ %@日",[self toLocalStringOfDate:[self lastMonth:_currentDate]], selectedDayString] ;
        
    }
    if (indexPath.row > _lastDayRowOfMonth) {
        selectedDayString =[NSString stringWithFormat:@"%@ %@日",[self toLocalStringOfDate:[self nextMonth:_currentDate]], selectedDayString];
    }
    
    NSDate *startDate = [self dateFromString:[NSString stringWithFormat:@"%@ 00:00:00",selectedDayString]];
    SZEarthHistoryViewController *historyVC = [[SZEarthHistoryViewController alloc]init];
    historyVC.startDate = [SZEarthMy_DB NSDate2Int:startDate];
    
    NSDate *endDate = [self dateFromString:[NSString stringWithFormat:@"%@ 23:59:59",selectedDayString]];
    historyVC.endDate = [SZEarthMy_DB NSDate2Int:endDate];
    
    historyVC.selectedDateString = [NSString stringWithFormat:@"%ld月 %ld日",(long)[self month:endDate],(long)[self day:endDate]];
    [self showViewController:historyVC sender:self];
    
}
- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    
}
//返回这个UICollectionView是否可以被选择
-(BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
