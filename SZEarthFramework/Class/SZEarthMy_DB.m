//
//  My_DB.m
//  smartbadminton
//
//  Created by Earth on 15/7/25.
//  Copyright (c) 2015年 Earth. All rights reserved.
//

#define DBName  @"badminton.db"
#define DBVersion   2

#import <Foundation/Foundation.h>
#import "SZEarthMy_DB.h"


//struct user_information public_user;
char my_char_email[50];
int my_end_time=0;


@implementation SZEarthMy_DB

-(id)init
{
    if(self=[super init])
    {
//        NSLog(@"DB--init");
        //管理数据库
        NSUserDefaults *defaults =[NSUserDefaults standardUserDefaults];
        //读取整型int类型的数据
        NSInteger myVersion = [defaults integerForKey:@"badminton_version"];
        if(DBVersion!=myVersion){//数据库版本更新
//            NSLog(@"数据库版本更新!!");
            [self DropTables];
            if(true==[self CreateTable]){
                [defaults setInteger:DBVersion forKey:@"badminton_version"];
                [defaults synchronize];//这里建议同步存储到磁盘中，但是不是必须的
            }
        }
        
    }
    return self;
}


-(BOOL)OPenDB{
    NSArray *array =NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentpath = [array objectAtIndex:0];
    NSString *destpath =[documentpath stringByAppendingPathComponent:DBName];
    
    if(sqlite3_open([destpath UTF8String], &db) == SQLITE_OK){
        
        return YES;
    }else{
//        NSLog(@"~~~打开数据库失败");
//        sqlite3_close(db);
        return NO;
    }
}

-(void)closeDB{
    sqlite3_close(db);
}

-(void)ExecuteSql:(NSString *)sql{
    if([self OPenDB]){
        char *errMsg = nil;
        if(sqlite3_exec(db, [sql UTF8String],nil, nil, &errMsg)==SQLITE_OK){
//            NSLog(@"数据库操作成功");
        }else{
//            NSLog(@"~~~数据库操作失败:%s",errMsg);
        }
    }
    sqlite3_close(db);
}


//删除表
-(void)DropTables{
//    NSLog(@"执行删除表");
    NSString *sql1 = @"drop table ball_property;";
    [self ExecuteSql:sql1];
    NSString *sql2 = @"drop table games_property;";
    [self ExecuteSql:sql2];
    NSString *sql3 = @"drop table messageHistory;";
    [self ExecuteSql:sql3];
    NSString *sql4 = @"drop table friendsList;";
    [self ExecuteSql:sql4];
}

-(BOOL)CreateTableWithString:(NSString*)sqlString {
    BOOL rusult=false;
//    NSString  *sqlString = @"CREATE TABLE [messageHistory] ([message_id] INTEGER PRIMARY KEY AUTOINCREMENT,[friendEmail] VARCHAR(50),[userEmail] VARCHAR(50),[time] DATETIME,[type] INT,[text] TEXT);";
    if([self OPenDB]){
        char *err;
        //表1
        if(sqlite3_exec(db, [sqlString UTF8String], NULL, NULL, &err) == SQLITE_OK){
//            NSLog(@"创建表1成功:%@",sqlString);
            rusult = true;
        }else{
//                        NSLog(@"~~~创建表1失败");
//                        NSLog(@"Error Create Table:%s",err);
        }
    }
    return rusult;
}

-(BOOL)insertDataWithString:(NSString*)sqlString {
//    NSString *insertSql = [NSString stringWithFormat:@"INSERT INTO ball_property('ball_email','ball_stye','ball_maxspeed','ball_maxstrength','ball_back_hand','ball_hitmoment','ball_play_time') values('%@',%d,%f,%f,%d,%d,%d)",ball_email,ball_stye,ball_maxspeed,ball_maxstrength,ball_back_hand,ball_hitmoment,ball_play_time];
    if([self OPenDB]){
        char *errMsg = nil;
        if(sqlite3_exec(db, [sqlString UTF8String],nil, nil, &errMsg)==SQLITE_OK){
            sqlite3_close(db);
            return YES;
        }
    }
    sqlite3_close(db);
    return NO;
}

-(BOOL)selectDataWithString:(NSString*)sqlString {
    [self OPenDB];
//    NSString *querySql = @"select ball_id,ball_email,ball_stye,ball_maxspeed,ball_maxstrength,ball_back_hand,ball_hitmoment from ball_property";
    sqlite3_stmt *statement;
    chatMessage = [[NSMutableArray alloc]init];
    if(sqlite3_prepare_v2(db, [sqlString UTF8String], -1, &statement, nil) == SQLITE_OK){
        while (sqlite3_step(statement) == SQLITE_ROW) {
            NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"%s",(char *)sqlite3_column_text(statement, 0)],@"message_id",[NSString stringWithFormat:@"%s",(char *)sqlite3_column_text(statement, 1)],@"friendEmail", [NSString stringWithFormat:@"%s",(char *)sqlite3_column_text(statement, 2)],@"userEmail", [[NSString alloc] initWithCString:(char *)sqlite3_column_text(statement, 3) encoding:NSUTF8StringEncoding],@"time", [NSNumber numberWithInt:sqlite3_column_int(statement, 4)],@"type",[[NSString alloc] initWithCString:(char *)sqlite3_column_text(statement, 5) encoding:NSUTF8StringEncoding],@"text",[[NSString alloc] initWithCString:(char *)sqlite3_column_text(statement, 6) encoding:NSUTF8StringEncoding],@"userName", [[NSString alloc] initWithCString:(char *)sqlite3_column_text(statement, 7) encoding:NSUTF8StringEncoding], @"currentCity", [[NSString alloc] initWithCString:(char *)sqlite3_column_text(statement, 8) encoding:NSUTF8StringEncoding], @"addFriend", nil];
            [chatMessage addObject:dic];
            
        }
        sqlite3_close(db);
        return YES;
    }
    sqlite3_close(db);
    return YES;
}

-(BOOL)deleteDataWithString:(NSString*)sqlString {
    [self OPenDB];
    if (sqlite3_exec (db, [sqlString UTF8String], NULL, NULL, nil) != SQLITE_OK) {
        sqlite3_close(db);
        return NO;
    }
    sqlite3_close(db);
    return YES;
}

//创建表
-(BOOL)CreateTable{
    BOOL rusult=false;
    
    NSString  *createTableSql1 = @"CREATE TABLE IF NOT EXISTS [ball_property] ([ball_id] INTEGER PRIMARY KEY AUTOINCREMENT,[ball_email] VARCHAR(50),[ball_stye] INT,[ball_maxspeed] FLOAT,[ball_maxstrength] FLOAT,[ball_hitmoment] INT,[ball_angle_face] FLOAT,[ball_angle_stick] FLOAT,[ball_back_hand] INT,[ball_data_length] INT,[ball_play_time] DATETIME,[ball_kaluli] FLOAT,[ball_score] FLOAT,[ball_extend1] FLOAT,[ball_extend2] FLOAT,[ball_extend3] FLOAT);";
    
    NSString *createTableSql2 = @"CREATE TABLE IF NOT EXISTS [games_property] ([games_id] INTEGER PRIMARY KEY AUTOINCREMENT,[games_email] CHAR(50),[games_start_time] INT,[games_end_time] INT,[games_max_speed] FLOAT,[games_max_strength] FLOAT,[games_score] FLOAT, [games_kaluli] FLOAT,[games_extend1] FLOAT,[games_extend2] FLOAT,[games_extend3] FLOAT);";
    
    if([self OPenDB]){
        char *err;
        //表1
        if(sqlite3_exec(db, [createTableSql1 UTF8String], NULL, NULL, &err) == SQLITE_OK){
//            NSLog(@"创建表1成功:%@",createTableSql1);
            rusult = true;
        }else{
//            NSLog(@"~~~创建表1失败");
//            NSLog(@"Error Create Table:%s",err);
        }
        //表2
        if(sqlite3_exec(db, [createTableSql2 UTF8String], NULL, NULL, &err) == SQLITE_OK){
//            NSLog(@"创建表2成功:%@",createTableSql2);
            rusult = true;
        }else{
//            NSLog(@"~~~创建表2失败");
//            NSLog(@"Error Create Table:%s",err);
        }
    }
    return rusult;
}





//插入数据
-(void)Insert_ball:(NSString*)ball_email ball_stye:(int)ball_stye ball_maxspeed:(float)ball_maxspeed ball_maxstrength:(float)ball_maxstrength ball_back_hand:(int)ball_back_hand ball_hitmoment:(int)ball_hitmoment ball_play_time:(int)ball_play_time {
    
    NSString *insertSql = [NSString stringWithFormat:@"INSERT INTO ball_property('ball_email','ball_stye','ball_maxspeed','ball_maxstrength','ball_back_hand','ball_hitmoment','ball_play_time') values('%@',%d,%f,%f,%d,%d,%d)",ball_email,ball_stye,ball_maxspeed,ball_maxstrength,ball_back_hand,ball_hitmoment,ball_play_time];

    [self ExecuteSql:insertSql];
    
}

-(void)Insert_ball_2:(NSString*)ball_email ball_stye:(int)ball_stye ball_maxspeed:(float)ball_maxspeed ball_maxstrength:(float)ball_maxstrength ball_back_hand:(int)ball_back_hand ball_hitmoment:(int)ball_hitmoment ball_play_time:(int)ball_play_time {
    NSString *insertSql = [NSString stringWithFormat:@"INSERT INTO ball_property('ball_email','ball_stye','ball_maxspeed','ball_maxstrength','ball_back_hand','ball_hitmoment','ball_play_time') values('%@',%d,%f,%f,%d,%d,%d)",ball_email,ball_stye,ball_maxspeed,ball_maxstrength,ball_back_hand,ball_hitmoment,ball_play_time];
    char *errMsg = nil;
    if(sqlite3_exec(db, [insertSql UTF8String],nil, nil, &errMsg)==SQLITE_OK){
        //            NSLog(@"数据库操作成功");
    }
}
//-(void)Insert_ball:(struct ball_property)StuBall{
//    
//    NSString *insertSql = [NSString stringWithFormat:@"INSERT INTO ball_property('ball_email','ball_stye','ball_maxspeed','ball_maxstrength','ball_back_hand','ball_hitmoment','ball_play_time') values('%s',%d,%f,%f,%d,%d,%d)",StuBall.ball_email,StuBall.ball_stye,StuBall.ball_maxspeed,StuBall.ball_maxstrength,StuBall.ball_back_hand,StuBall.ball_hitmoment,StuBall.ball_play_time];
//    
//    [self ExecuteSql:insertSql];
//    
//    sqlite3_close(db);
//}

//插入数据2
//-(void)Insert_game:(NSString*)games_email :(int)games_start_time :(int)games_end_time :(float)games_max_speed :(float)games_max_strength :(float)games_score :(float)games_kaluli{


-(void)Insert_game:(struct games_property)StuGame{
    NSString *insertSql = [NSString stringWithFormat:@"INSERT INTO games_property('games_email','games_start_time','games_end_time','games_max_speed','games_max_strength','games_score','games_kaluli', 'games_extend1', 'games_extend2', 'games_extend3') values('%s',%d,%d,%f,%f,%f,%f,%f,%f,%f)",StuGame.games_email,StuGame.games_start_time,StuGame.games_end_time,StuGame.games_max_speed,StuGame.games_max_strength,StuGame.games_score,StuGame.games_kaluli,StuGame.games_extend1,StuGame.games_extend2,StuGame.games_extend3];
    
    [self ExecuteSql:insertSql];
    
}


-(void)Select_ball{
    [self OPenDB];
    NSString *querySql = @"select ball_id,ball_email,ball_stye,ball_maxspeed,ball_maxstrength,ball_back_hand,ball_hitmoment from ball_property";
    sqlite3_stmt *statement;
    
    if(sqlite3_prepare_v2(db, [querySql UTF8String], -1, &statement, nil) == SQLITE_OK){
        while (sqlite3_step(statement) == SQLITE_ROW) {
            //tempchar = (char *)sqlite3_column_text(statement, 1);
            //NSString *ball_email =[[NSString alloc] initWithUTF8String:tempchar];
            ball_out.ball_id = sqlite3_column_int(statement, 0);
            ball_out.ball_email = (char *)sqlite3_column_text(statement, 1);
            ball_out.ball_stye = sqlite3_column_int(statement, 2);
            ball_out.ball_maxspeed = sqlite3_column_double(statement, 3);
            ball_out.ball_maxstrength = sqlite3_column_double(statement, 4);
            ball_out.ball_back_hand = sqlite3_column_int(statement, 5);
            ball_out.ball_hitmoment = sqlite3_column_int(statement, 6);
            
        }
    }else{
//        NSLog(@"查询数据库失败");
    }
    sqlite3_close(db);
    
}

-(void)Select_games:(NSString*)querySql{
    
    [array_game removeAllObjects];
    array_game = [NSMutableArray arrayWithCapacity:10];
    
    [self OPenDB];
//    NSString *def_sql = @"select games_id,games_email,games_start_time,games_end_time,games_max_speed,games_max_strength,games_score,games_kaluli from games_property";
//    if([querySql isEqualToString:@""]) querySql = def_sql;
    sqlite3_stmt *statement;
    
    if(sqlite3_prepare_v2(db, [querySql UTF8String], -1, &statement, nil) == SQLITE_OK){
        while (sqlite3_step(statement) == SQLITE_ROW) {
            game_out.games_id = sqlite3_column_int(statement, 0);
            game_out.games_email = (char *)sqlite3_column_text(statement, 1);
            game_out.games_start_time = sqlite3_column_int(statement, 2);
            game_out.games_end_time = sqlite3_column_int(statement, 3);
            game_out.games_max_speed = sqlite3_column_double(statement, 4);
            game_out.games_max_strength = sqlite3_column_double(statement, 5);
            game_out.games_score = sqlite3_column_double(statement, 6);
            game_out.games_kaluli = sqlite3_column_double(statement, 7);
            
//            NSDate *aDate = [NSDate dateWithTimeIntervalSinceReferenceDate:game_out.games_end_time];
//            NSLog(@"end time:%@",aDate);
            
//            NSNumber *num = [NSNumber numberWithInt:game_out.games_end_time];
//            [array_list addObject:num];//数组
            SZEarthClass_Game *cla_game=[SZEarthClass_Game alloc];
            cla_game->stu_game=game_out;
            [array_game addObject:cla_game];//数组
        }
    }else{
        NSLog(@"查询数据库失败...");
    }
    sqlite3_close(db);
    
}

-(int)Select_value:(NSString*)querySql{
    int rulvalue=0;
    [self OPenDB];
    sqlite3_stmt *statement;
    
    if(sqlite3_prepare_v2(db, [querySql UTF8String], -1, &statement, nil) == SQLITE_OK){
        while (sqlite3_step(statement) == SQLITE_ROW) {
            rulvalue = sqlite3_column_int(statement, 0);
        }
    }else{
        //        NSLog(@"查询数据库失败");
    }
    sqlite3_close(db);
    
    return rulvalue;
}

//查找速度或力度值，并添加到数组
-(int)selectCaloriesSum:(NSString*)querySql{
    int rulvalue=0;
    [self OPenDB];
    sqlite3_stmt *statement;
    
    if(sqlite3_prepare_v2(db, [querySql UTF8String], -1, &statement, nil) == SQLITE_OK){
        while (sqlite3_step(statement) == SQLITE_ROW) {
            rulvalue = sqlite3_column_int(statement, 0);
        }
    }else{
        //        NSLog(@"查询数据库失败");
    }
    sqlite3_close(db);
    
    return rulvalue;
}

//我定义的
-(NSMutableArray*)Select_qiuchangMode {
    NSMutableArray *array = [[NSMutableArray alloc]init];
    [self OPenDB];
//    NSString *Login_User = [NSString stringWithFormat:@"%s",my_char_email];
    NSString *def_sql = [NSString stringWithFormat: @"select * from ball_property"];
//                         WHERE (games_end_time=%d) AND games_email='%@'",my_end_time,Login_User];
    sqlite3_stmt *statement;
    
    if(sqlite3_prepare_v2(db, [def_sql UTF8String], -1, &statement, nil) == SQLITE_OK){
        while (sqlite3_step(statement) == SQLITE_ROW) {
            
            ball_out.ball_id = sqlite3_column_int(statement, 0);
            ball_out.ball_email = (char *)sqlite3_column_text(statement, 1);
            ball_out.ball_stye = sqlite3_column_int(statement, 2);
            ball_out.ball_maxspeed = sqlite3_column_double(statement, 3);
            ball_out.ball_maxstrength = sqlite3_column_double(statement, 4);
            ball_out.ball_back_hand = sqlite3_column_int(statement, 5);
            ball_out.ball_hitmoment = sqlite3_column_int(statement, 6);
            SZEarthClass_Ball *cla_ball=[SZEarthClass_Ball alloc];
            cla_ball->stu_ball= ball_out;
            [array addObject:cla_ball];//数组
        }
    }else{
//        NSLog(@"查询数据库失败");
    }
    sqlite3_close(db);
    
    return array;
}

-(int)Select_ball_int:(NSString*)querySql{
    int rulvalue=0;
    [self OPenDB];
    //NSString *def_sql = @"select ball_id,ball_email,ball_stye,ball_maxspeed,ball_maxstrength,ball_back_hand,ball_hitmoment from ball_property";
    sqlite3_stmt *statement;
    
    if(sqlite3_prepare_v2(db, [querySql UTF8String], -1, &statement, nil) == SQLITE_OK){
        while (sqlite3_step(statement) == SQLITE_ROW) {
            rulvalue = sqlite3_column_int(statement, 0);
        }
    }else{
//        NSLog(@"查询数据库失败");
    }
    sqlite3_close(db);
    
    return rulvalue;
}

//查找速度或力度值，并添加到数组
-(NSArray*)Select_Sum:(NSString*)querySql{
    int rulvalue=0;
    NSMutableArray *tempArray =[[NSMutableArray alloc]init];
    [self OPenDB];
    sqlite3_stmt *statement;
    
    if(sqlite3_prepare_v2(db, [querySql UTF8String], -1, &statement, nil) == SQLITE_OK){
        while (sqlite3_step(statement) == SQLITE_ROW) {
            rulvalue = sqlite3_column_int(statement, 0);
            [tempArray addObject: [[NSNumber alloc] initWithFloat: rulvalue]];
        }
    }else{
//        NSLog(@"查询数据库失败");
    }
    sqlite3_close(db);
    
    return tempArray;
}

-(void)BtnCreateTable{
    
    //[self Select_ball];
    [self Select_games:@""];
    
}


+(int)getTime{//获取时间
    
    NSDate *date = [NSDate date];
    
    NSTimeZone *zone = [NSTimeZone systemTimeZone];
    
    NSInteger interval = [zone secondsFromGMTForDate: date];
    
    NSDate *localeDate = [date  dateByAddingTimeInterval: interval];
    
//    NSLog(@"%@", localeDate);
    
    //NSDate *aDate = [NSDate date];
    NSNumber *secondsSinceRefDate = [NSNumber numberWithDouble:[localeDate timeIntervalSinceReferenceDate]];
    return [secondsSinceRefDate intValue];
}

+(int)NSDate2Int:(NSDate *)date{//时间转换数值
    
    //NSDate *date = [NSDate date];
    
    NSTimeZone *zone = [NSTimeZone systemTimeZone];
    
    NSInteger interval = [zone secondsFromGMTForDate: date];
    
    NSDate *localeDate = [date  dateByAddingTimeInterval: interval];
    
//    NSLog(@"%@", localeDate);
    
    //NSDate *aDate = [NSDate date];
    NSNumber *secondsSinceRefDate = [NSNumber numberWithDouble:[localeDate timeIntervalSinceReferenceDate]];
    return [secondsSinceRefDate intValue];
}

@end