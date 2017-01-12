//
//  historyViewController.m
//  RiLiTest
//
//  Created by quan on 16/3/5.
//  Copyright © 2016年 quan. All rights reserved.
//

#import "SZEarthHistoryViewController.h"


@implementation SZEarthHistoryViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.tableView.rowHeight = self.view.frame.size.height*0.23;
    
    _dataList = [[NSMutableArray alloc] init];
    
    _titleList = [[NSMutableArray alloc]init];
    
    _myDB = [[SZEarthMy_DB alloc] init];
    
    NSString *userEmail = [[NSUserDefaults standardUserDefaults] objectForKey:@"SZEarthUserEmail"];
    
    NSString *sqlstr = [NSString stringWithFormat:@"select * from games_property WHERE (games_end_time BETWEEN %d and %d) and (games_email='%@')" ,_startDate, _endDate ,userEmail];
    [_myDB Select_games:sqlstr];
    
    for (NSObject * object in _myDB->array_game)
    {
        
        SZEarthClass_Game *cla_game1=(SZEarthClass_Game *)object;
        
        NSDate *aDate = [NSDate dateWithTimeIntervalSinceReferenceDate:cla_game1->stu_game.games_start_time-8*3600 ];
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"HH:mm:ss"];//@"yyyy-MM-dd HH:mm:ss"
        NSString *startTimeStr = [dateFormatter stringFromDate:aDate];
        
        aDate = [NSDate dateWithTimeIntervalSinceReferenceDate:cla_game1->stu_game.games_end_time-8*3600 ];
        [dateFormatter setDateFormat:@"HH:mm:ss"];//@"yyyy-MM-dd HH:mm:ss"
        NSString *endTimeStr = [dateFormatter stringFromDate:aDate];
        
        [_titleList addObject:[NSString stringWithFormat:@"%@ - %@", startTimeStr, endTimeStr]];
        
        //速度数组
        NSString *sqlstr = [NSString stringWithFormat:@"select ball_maxspeed from ball_property WHERE (ball_play_time BETWEEN %d AND %d) AND (ball_stye != 7) AND (ball_stye != 0) AND ball_email='%@'",cla_game1->stu_game.games_start_time,cla_game1->stu_game.games_end_time ,userEmail];
        NSArray *temp_1 = [_myDB Select_Sum:sqlstr];
        
        //力度数组
        sqlstr = [NSString stringWithFormat:@"select ball_maxstrength from ball_property WHERE (ball_play_time BETWEEN %d AND %d) AND (ball_stye != 7) AND (ball_stye != 0) AND ball_email='%@'",cla_game1->stu_game.games_start_time,cla_game1->stu_game.games_end_time, userEmail];
        NSArray *temp_2 = [_myDB Select_Sum:sqlstr];
        
        float speedTotal = 0;
        float liDuTotal = 0;
        for (int i = 0; i< temp_1.count; i++) {
            speedTotal += [temp_1[i] floatValue];
            liDuTotal += [temp_2[i] floatValue];
        }
        
        NSDictionary *dictionary = [NSDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"%dkm/h",(int)(speedTotal/temp_1.count)], @"averageSpeedValue", [NSString stringWithFormat:@"%dN",(int)(liDuTotal/temp_2.count)], @"averageLiDUValue", @"平均值", @"averageValueLabel", [NSString stringWithFormat:@"%dkm/h",(int)cla_game1->stu_game.games_max_speed], @"maxSpeedValue", [NSString stringWithFormat:@"%dN",(int)cla_game1->stu_game.games_max_strength], @"maxLiDUValue", @"最大值", @"maxValueLabel", [NSString stringWithFormat:@"%d",(int)cla_game1->stu_game.games_kaluli], @"caloriesValue",  @"卡路里", @"caloriesDanWei", @"消耗", @"caloriesLabel", [NSString stringWithFormat:@"%d",(int)cla_game1->stu_game.games_score], @"scoreValue", @"评分", @"scoreLabel", [NSString stringWithFormat:@"%d",cla_game1->stu_game.games_start_time], @"startTime", [NSString stringWithFormat:@"%d",cla_game1->stu_game.games_end_time], @"endTime", nil];
        
        [_dataList addObject:dictionary];
        
    }
    
    
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationItem.title = _selectedDateString;
    
    self.navigationController.navigationBar.translucent = NO;
    
}

-(void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.navigationItem.title = @"";
    self.navigationController.navigationBar.translucent = YES;
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (_dataList.count>0) {
        return _dataList.count;
    }
    return 1;
//    return _dataList.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (_dataList.count>0) {
        return 1;
    }
    return 0;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (_dataList.count==0) {
        return 0;
    }
    return self.view.frame.size.height*0.08;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    
    return 0.1;
}

-(NSString*)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return _titleList[section];
//    return nil;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *reuseID = @"CellID";
    
    SZEarthHistoryTableViewCell *cell = [[SZEarthHistoryTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseID frame:self.view.frame];
    if (_dataList.count>0) {
        cell.averageSpeedValue.text = [((NSDictionary*)_dataList[indexPath.section]) objectForKey:@"averageSpeedValue"] ;
        cell.averageLiDUValue.text = [((NSDictionary*)_dataList[indexPath.section]) objectForKey:@"averageLiDUValue"];
        cell.averageValueLabel.text = [((NSDictionary*)_dataList[indexPath.section]) objectForKey:@"averageValueLabel"];
        
        cell.maxSpeedValue.text = [((NSDictionary*)_dataList[indexPath.section]) objectForKey:@"maxSpeedValue"];
        cell.maxLiDUValue.text = [((NSDictionary*)_dataList[indexPath.section]) objectForKey:@"maxLiDUValue"];
        cell.maxValueLabel.text = [((NSDictionary*)_dataList[indexPath.section]) objectForKey:@"maxValueLabel"];
        
        cell.caloriesValue.text = [((NSDictionary*)_dataList[indexPath.section]) objectForKey:@"caloriesValue"];
        cell.caloriesDanWei.text = [((NSDictionary*)_dataList[indexPath.section]) objectForKey:@"caloriesDanWei"];
        cell.caloriesLabel.text = [((NSDictionary*)_dataList[indexPath.section]) objectForKey:@"caloriesLabel"];
        
        cell.scoreValue.text = [((NSDictionary*)_dataList[indexPath.section]) objectForKey:@"scoreValue"];
        cell.scoreLabel.text = [((NSDictionary*)_dataList[indexPath.section]) objectForKey:@"scoreLabel"];
        tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    } else {
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    SZEarthResultViewController *resultCV = [[SZEarthResultViewController alloc]init];
    resultCV.bottonDictionary = [[NSMutableDictionary alloc]init];
    resultCV.bottonDictionary = (NSMutableDictionary*)_dataList[indexPath.section];
    [self showViewController:resultCV sender:self];
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}

// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
        if (editingStyle == UITableViewCellEditingStyleDelete) {
            NSString *userEmail = [[NSUserDefaults standardUserDefaults] objectForKey:@"SZEarthUserEmail"];
            NSString *deleteballProperty = [NSString stringWithFormat:@"DELETE FROM ball_property WHERE ((ball_email = '%@') and (ball_play_time BETWEEN %@ and %@))", userEmail, [((NSDictionary*)_dataList[indexPath.section]) objectForKey:@"startTime"], [((NSDictionary*)_dataList[indexPath.section]) objectForKey:@"endTime"]];
            NSString *deleteQiuChangMode = [NSString stringWithFormat:@"DELETE FROM games_property WHERE ((games_email = '%@') and (games_end_time = %@))", userEmail, [((NSDictionary*)_dataList[indexPath.section]) objectForKey:@"endTime"]];
            
            [_dataList removeObjectAtIndex:indexPath.section];
            [_titleList removeObjectAtIndex:indexPath.section];
            [tableView beginUpdates];
            if (_dataList.count == 0) {
                [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
                [tableView reloadData];
            } else {
                [tableView deleteSections:[NSIndexSet indexSetWithIndex:indexPath.section] withRowAnimation:UITableViewRowAnimationAutomatic];
            }
            [tableView endUpdates];
            [_myDB deleteDataWithString:deleteballProperty];
            [_myDB deleteDataWithString:deleteQiuChangMode];
            
            
        } else if (editingStyle == UITableViewCellEditingStyleInsert) {
            
    }
    //     [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
