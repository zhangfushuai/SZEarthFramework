//
//  SZEarthResultViewController.m
//  exampleSDK
//
//  Created by Earth on 16/3/10.
//  Copyright © 2016年 Earth. All rights reserved.
//

#import "SZEarthResultViewController.h"

@implementation SZEarthResultViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    SZEarthMy_DB *myDB = [[SZEarthMy_DB alloc]init];
    
    NSString *Login_User = [[NSUserDefaults standardUserDefaults] objectForKey:@"SZEarthUserEmail"];
    
    _startTime = [[_bottonDictionary objectForKey:@"startTime"] intValue];
    _endTime = [[_bottonDictionary objectForKey:@"endTime"] intValue];
    
    
    NSString *sqlstr;
    //统计:
    sqlstr = [NSString stringWithFormat:@"select COUNT(ball_email) from ball_property WHERE ((ball_stye=1) OR (ball_stye=2)) AND (ball_back_hand=3) AND (ball_play_time BETWEEN %d AND %d) AND ball_email='%@'",_startTime,_endTime ,Login_User ];
    _zsGaoWeicount = [myDB Select_ball_int:sqlstr];
    
    sqlstr = [NSString stringWithFormat:@"select COUNT(ball_email) from ball_property WHERE ((ball_stye=1) OR (ball_stye=2)) AND (ball_back_hand=2) AND (ball_play_time BETWEEN %d AND %d) AND ball_email='%@'",_startTime,_endTime ,Login_User ];
    _fsGaoWeicount = [myDB Select_ball_int:sqlstr];
    
    sqlstr = [NSString stringWithFormat:@"select COUNT(ball_email) from ball_property WHERE (ball_stye=3) AND (ball_back_hand=3) AND (ball_play_time BETWEEN %d AND %d) AND ball_email='%@'",_startTime,_endTime ,Login_User ];
    _zsTiaoQiucount = [myDB Select_ball_int:sqlstr];
    
    sqlstr = [NSString stringWithFormat:@"select COUNT(ball_email) from ball_property WHERE (ball_stye=3) AND (ball_back_hand=2) AND (ball_play_time BETWEEN %d AND %d) AND ball_email='%@'",_startTime,_endTime,Login_User ];
    _fsTiaoQiucount = [myDB Select_ball_int:sqlstr];
    
    sqlstr = [NSString stringWithFormat:@"select COUNT(ball_email) from ball_property WHERE (ball_stye=4) AND (ball_back_hand=3) AND (ball_play_time BETWEEN %d AND %d) AND ball_email='%@'", _startTime, _endTime, Login_User ];
    _zsCuoQiucount = [myDB Select_ball_int:sqlstr];
    
    sqlstr = [NSString stringWithFormat:@"select COUNT(ball_email) from ball_property WHERE (ball_stye=4) AND (ball_back_hand=2) AND (ball_play_time BETWEEN %d AND %d) AND ball_email='%@'", _startTime,_endTime, Login_User ];
    _fsCuoQiucount = [myDB Select_ball_int:sqlstr];
    
    sqlstr = [NSString stringWithFormat:@"select COUNT(ball_email) from ball_property WHERE (ball_stye=5) AND (ball_back_hand=3) AND (ball_play_time BETWEEN %d AND %d) AND ball_email='%@'",_startTime, _endTime, Login_User ];
    _zsTuiQiucount = [myDB Select_ball_int:sqlstr];
    
    sqlstr = [NSString stringWithFormat:@"select COUNT(ball_email) from ball_property WHERE (ball_stye=5) AND (ball_back_hand=2) AND (ball_play_time BETWEEN %d AND %d) AND ball_email='%@'",_startTime,_endTime,Login_User ];
    _fsTuiQiucount = [myDB Select_ball_int:sqlstr];
    
    sqlstr = [NSString stringWithFormat:@"select COUNT(ball_email) from ball_property WHERE (ball_stye=6) AND (ball_back_hand=3) AND (ball_play_time BETWEEN %d AND %d) AND ball_email='%@'",_startTime,_endTime,Login_User ];
    _zsDiaoQiucount = [myDB Select_ball_int:sqlstr];
    
    sqlstr = [NSString stringWithFormat:@"select COUNT(ball_email) from ball_property WHERE (ball_stye=6) AND (ball_back_hand=2) AND (ball_play_time BETWEEN %d AND %d) AND ball_email='%@'",_startTime,_endTime,Login_User ];
    _fsDiaoQiucount = [myDB Select_ball_int:sqlstr];
    
    NSArray *allValues = @[ [NSNumber numberWithInteger:_zsGaoWeicount],
                            [NSNumber numberWithInteger:_fsGaoWeicount],
                            [NSNumber numberWithInteger:_zsCuoQiucount],
                            [NSNumber numberWithInteger:_fsCuoQiucount],
                            [NSNumber numberWithInteger:_zsDiaoQiucount],
                            [NSNumber numberWithInteger:_fsDiaoQiucount],
                            [NSNumber numberWithInteger:_zsTiaoQiucount],
                            [NSNumber numberWithInteger:_fsTiaoQiucount],
                            [NSNumber numberWithInteger:_zsTuiQiucount],
                            [NSNumber numberWithInteger:_fsTuiQiucount]];
    _maxCount = [[allValues valueForKeyPath:@"@max.intValue"] intValue];
    if (_maxCount%2 != 0) {
        _maxCount += 1;
    }
    if (_maxCount == 0) {
        _maxCount = 40;
    }
//    int min = [[allValues valueForKeyPath:@"@min.intValue"] intValue];
    
    if ([UIScreen mainScreen].bounds.size.height < 568) {
        _resultChartView = [[ResultChartView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.width*0.8) maxSings:_maxCount];
    } else {
        _resultChartView = [[ResultChartView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.width) maxSings:_maxCount];
    }
    
    [self.view addSubview:_resultChartView];
    
    _bottonView = [[ResultBottonView alloc]initWithFrame:CGRectMake(10, _resultChartView.frame.size.height, self.view.frame.size.width-20, self.view.frame.size.height - _resultChartView.frame.size.height-5)];
    
    [self.view addSubview:_bottonView];
    
    _resultChartView.totalSwingsLabel.text = [NSString stringWithFormat:@"%d次(正手%d次 反手%d次)",(int)(_zsGaoWeicount+_fsGaoWeicount+_zsCuoQiucount+_fsCuoQiucount+_zsDiaoQiucount+_fsDiaoQiucount+_zsTiaoQiucount+_fsTiaoQiucount+_zsTuiQiucount+_fsTuiQiucount), (int)(_zsGaoWeicount+_zsCuoQiucount+_zsDiaoQiucount+_zsTiaoQiucount+_zsTuiQiucount), (int)(_fsGaoWeicount+_fsCuoQiucount+_fsDiaoQiucount+_fsTiaoQiucount+_fsTuiQiucount)];
    
    NSRange range;
    range = [_resultChartView.totalSwingsLabel.text rangeOfString:@"次"];
    if (range.location != NSNotFound) {
        NSMutableAttributedString *totalstr = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@", _resultChartView.totalSwingsLabel.text]];
        [totalstr addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:249/255.0 green:94/255.0 blue:0 alpha:1.0] range:NSMakeRange(0,totalstr.length)];
        [totalstr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:26] range:NSMakeRange(0,totalstr.length)];
        [totalstr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:16] range:NSMakeRange(range.location,totalstr.length-range.location)];
        _resultChartView.totalSwingsLabel.attributedText = totalstr;
    }else{
    }
    
    _bottonView.averageSpeedValue.text = [_bottonDictionary objectForKey:@"averageSpeedValue"];
    _bottonView.averageLiDUValue.text = [_bottonDictionary objectForKey:@"averageLiDUValue"];
    _bottonView.maxSpeedValue.text = [_bottonDictionary objectForKey:@"maxSpeedValue"];
    _bottonView.maxLiDUValue.text = [_bottonDictionary objectForKey:@"maxLiDUValue"];
    _bottonView.CaloriesLabel.text = [NSString stringWithFormat:@"%@大卡",[_bottonDictionary objectForKey:@"caloriesValue"]];
    
    NSMutableAttributedString *attributeString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@", _bottonView.averageSpeedValue.text]];
    [attributeString addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:249/255.0 green:94/255.0 blue:0 alpha:1.0] range:NSMakeRange(0,attributeString.length)];
    [attributeString addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.3] range:NSMakeRange(attributeString.length-4,4)];
    _bottonView.averageSpeedValue.attributedText = attributeString;
    
    attributeString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@", _bottonView.averageLiDUValue.text]];
    [attributeString addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:249/255.0 green:94/255.0 blue:0 alpha:1.0] range:NSMakeRange(0,attributeString.length)];
    [attributeString addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.3] range:NSMakeRange(attributeString.length-1,1)];
    _bottonView.averageLiDUValue.attributedText = attributeString;
    
    attributeString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@", _bottonView.maxSpeedValue.text]];
    [attributeString addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:249/255.0 green:94/255.0 blue:0 alpha:1.0] range:NSMakeRange(0,attributeString.length)];
    [attributeString addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.3] range:NSMakeRange(attributeString.length-4,4)];
    _bottonView.maxSpeedValue.attributedText = attributeString;
    
    attributeString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@", _bottonView.maxLiDUValue.text]];
    [attributeString addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:249/255.0 green:94/255.0 blue:0 alpha:1.0] range:NSMakeRange(0,attributeString.length)];
    [attributeString addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.3] range:NSMakeRange(attributeString.length-1,1)];
    _bottonView.maxLiDUValue.attributedText = attributeString;
    
    //球场模式打球时间
    NSDate *timeIntervalDate = [NSDate dateWithTimeIntervalSinceReferenceDate:_endTime - _startTime - 8*3600 ];
    NSDateFormatter *dateFormtter=[[NSDateFormatter alloc] init];
    [dateFormtter setDateFormat:@"HH:mm:ss"];
    NSString *dateString = [dateFormtter stringFromDate:timeIntervalDate];
    _bottonView.shijianLabel.text = [dateString stringByAppendingString:@"h"];
    
    [self setLabelFrame]; //计算柱形高度
    
    
}

-(void) setLabelFrame {
    CGFloat chartImageHeight;
    CGFloat chartyOfBotton;
    CGFloat widthOfZhuXing;
    if ([UIScreen mainScreen].bounds.size.height < 568) {
        chartImageHeight = self.view.frame.size.width*0.4; //表格高度
        
        chartyOfBotton = _resultChartView.center.y*1.1+chartImageHeight*0.5; //表格底部y坐标
        
        widthOfZhuXing = self.view.frame.size.width*0.05;
    } else {
        chartImageHeight = self.view.frame.size.width*0.5; //表格高度
        
        chartyOfBotton = _resultChartView.center.y*1.1+chartImageHeight*0.5; //表格底部y坐标
        
        widthOfZhuXing = self.view.frame.size.width*0.05;
    }
    
//    CGFloat originy = chartyOfBotton - chartImageHeight * _zsGaoWeicount / _maxCount; //计算正手高位数label的y坐标
    
    
    _resultChartView.zsGaoWeiLabelOfZhuXing.frame = CGRectMake(self.view.frame.size.width*0.146, chartyOfBotton - chartImageHeight * _zsGaoWeicount / _maxCount, widthOfZhuXing, chartImageHeight * _zsGaoWeicount / _maxCount);
    _resultChartView.fsGaoWeiLabelOfZhuXing.frame = CGRectMake(self.view.frame.size.width*0.204, chartyOfBotton - chartImageHeight * _fsGaoWeicount / _maxCount, widthOfZhuXing, chartImageHeight * _fsGaoWeicount / _maxCount);
    _resultChartView.zsGaoWeiLabelOfZhuXing.backgroundColor = [UIColor colorWithRed:19/255.0 green:141/255.0 blue:208/255.0 alpha:1.0];
    _resultChartView.fsGaoWeiLabelOfZhuXing.backgroundColor = [UIColor colorWithRed:179/255.0 green:217/255.0 blue:41/255.0 alpha:1.0];
    
    _resultChartView.zsTiaoQiuLabelOfZhuXing.frame = CGRectMake(self.view.frame.size.width*0.298, chartyOfBotton - chartImageHeight * _zsTiaoQiucount / _maxCount, widthOfZhuXing, chartImageHeight * _zsTiaoQiucount / _maxCount);
    _resultChartView.fsTiaoQiuLabelOfZhuXing.frame = CGRectMake(self.view.frame.size.width*0.356, chartyOfBotton - chartImageHeight * _fsTiaoQiucount / _maxCount, widthOfZhuXing, chartImageHeight * _fsTiaoQiucount / _maxCount);
    _resultChartView.zsTiaoQiuLabelOfZhuXing.backgroundColor = [UIColor colorWithRed:19/255.0 green:141/255.0 blue:208/255.0 alpha:1.0];
    _resultChartView.fsTiaoQiuLabelOfZhuXing.backgroundColor = [UIColor colorWithRed:179/255.0 green:217/255.0 blue:41/255.0 alpha:1.0];
    
    _resultChartView.zsCuoQiuLabelOfZhuXing.frame = CGRectMake(self.view.frame.size.width*0.448, chartyOfBotton - chartImageHeight * _zsCuoQiucount / _maxCount, widthOfZhuXing, chartImageHeight * _zsCuoQiucount / _maxCount);
    _resultChartView.fsCuoQiuLabelOfZhuXing.frame = CGRectMake(self.view.frame.size.width*0.506, chartyOfBotton - chartImageHeight * _fsCuoQiucount / _maxCount, widthOfZhuXing, chartImageHeight * _fsCuoQiucount / _maxCount);
    _resultChartView.zsCuoQiuLabelOfZhuXing.backgroundColor = [UIColor colorWithRed:19/255.0 green:141/255.0 blue:208/255.0 alpha:1.0];
    _resultChartView.fsCuoQiuLabelOfZhuXing.backgroundColor = [UIColor colorWithRed:179/255.0 green:217/255.0 blue:41/255.0 alpha:1.0];

    _resultChartView.zsDiaoQiuLabelOfZhuXing.frame = CGRectMake(self.view.frame.size.width*0.592, chartyOfBotton - chartImageHeight * _zsDiaoQiucount / _maxCount, widthOfZhuXing, chartImageHeight * _zsDiaoQiucount / _maxCount);
    _resultChartView.fsDiaoQiuLabelOfZhuXing.frame = CGRectMake(self.view.frame.size.width*0.65, chartyOfBotton - chartImageHeight * _fsDiaoQiucount / _maxCount, widthOfZhuXing, chartImageHeight * _fsDiaoQiucount / _maxCount);
    _resultChartView.zsDiaoQiuLabelOfZhuXing.backgroundColor = [UIColor colorWithRed:19/255.0 green:141/255.0 blue:208/255.0 alpha:1.0];
    _resultChartView.fsDiaoQiuLabelOfZhuXing.backgroundColor = [UIColor colorWithRed:179/255.0 green:217/255.0 blue:41/255.0 alpha:1.0];
    
    _resultChartView.zsTuiQiuLabelOfZhuXing.frame = CGRectMake(self.view.frame.size.width*0.748, chartyOfBotton - chartImageHeight * _zsTuiQiucount / _maxCount, widthOfZhuXing, chartImageHeight * _zsTuiQiucount / _maxCount);
    _resultChartView.fsTuiQiuLabelOfZhuXing.frame = CGRectMake(self.view.frame.size.width*0.806, chartyOfBotton - chartImageHeight * _fsTuiQiucount / _maxCount, widthOfZhuXing, chartImageHeight * _fsTuiQiucount / _maxCount);
    _resultChartView.zsTuiQiuLabelOfZhuXing.backgroundColor = [UIColor colorWithRed:19/255.0 green:141/255.0 blue:208/255.0 alpha:1.0];
    _resultChartView.fsTuiQiuLabelOfZhuXing.backgroundColor = [UIColor colorWithRed:179/255.0 green:217/255.0 blue:41/255.0 alpha:1.0];
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationItem.title = @"统计结果";
    
}

@end
