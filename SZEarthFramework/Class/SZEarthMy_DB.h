//
//  Header.h
//  smartbadminton
//
//  Created by Earth on 15/7/25.
//  Copyright (c) 2015年 Earth. All rights reserved.
//

#ifndef smartbadminton_My_DB_h
#define smartbadminton_My_DB_h

#import <Foundation/Foundation.h>
#import <sqlite3.h>
#import "SZEarthClass_Game.h"
#import "SZEarthClass_Ball.h"

//struct ball_property{
//    int ball_id;
//    char* ball_email;					//#注册号
//    int ball_stye;			//#击球类型
//    float ball_maxspeed;			//#最大速度
//    float ball_maxstrength;				//#最大力度
//    int ball_hitmoment;					//#击球时刻
//    float ball_angle_face;					//#拍面角
//    float ball_angle_stick;				//#拍杆角
//    int ball_back_hand;					//#正反手（1）表示正手，（2）表示反手
//    int ball_data_length;					//#动作长度
//    int ball_play_time;				//#打球时间点
//    float ball_kaluli;					//#消耗卡路里
//    float ball_score;					//#比分
//    float ball_extend1;
//    float ball_extend2;
//    float ball_extend3;
//                           
//};

//struct games_property{
//    int games_id;//                     #标识号
//    char* games_email;//                #注册号
//    int games_start_time;//				#开始时间
//    int games_end_time;//				#结束时间
//    float games_max_speed;//			#最大速度
//    float games_max_strength;//			#最大力度
//    float games_score;//				#评分
//    float games_kaluli;//				#一场球的卡路里
//    float games_extend1;//
//    float games_extend2;//
//    float games_extend3;//
//                            
//};

struct user_information{
    char* name;
    char* email;
    char* password;
    char* birthday;
    int sex;
    int hand;
    char* brands;
    
};
//extern struct user_information public_user;
extern char my_char_email[];
extern int my_end_time;

@interface SZEarthMy_DB : NSObject
{
@public
    sqlite3 *db;
    struct ball_property ball_in,ball_out;
    struct games_property game_in,game_out;
    NSMutableArray *array_game;//= [NSMutableArray arrayWithCapacity:10];
    NSMutableArray *chatMessage;
    
}

@property (nonatomic,retain)NSString *dbFilePath;

-(void)BtnCreateTable;

//
-(BOOL)OPenDB;

-(void)closeDB;

-(BOOL)CreateTableWithString:(NSString*)sqlString;
-(BOOL)insertDataWithString:(NSString*)sqlString;
-(BOOL)selectDataWithString:(NSString*)sqlString ;
-(BOOL)deleteDataWithString:(NSString*)sqlString ;

//插入数据
-(void)Insert_ball:(NSString*)ball_email ball_stye:(int)ball_stye ball_maxspeed:(float)ball_maxspeed ball_maxstrength:(float)ball_maxstrength ball_back_hand:(int)ball_back_hand ball_hitmoment:(int)ball_hitmoment ball_play_time:(int)ball_play_time;
-(void)Insert_game:(struct games_property)StuGame;//插入表2

-(void)Insert_ball_2:(NSString*)ball_email ball_stye:(int)ball_stye ball_maxspeed:(float)ball_maxspeed ball_maxstrength:(float)ball_maxstrength ball_back_hand:(int)ball_back_hand ball_hitmoment:(int)ball_hitmoment ball_play_time:(int)ball_play_time;
//查询
-(void)Select_ball;
-(void)Select_games:(NSString*)querySql;

-(int)Select_value:(NSString*)querySql;

-(int)selectCaloriesSum:(NSString*)querySql;

-(int)Select_ball_int:(NSString*)querySql;

-(NSArray*)Select_Sum:(NSString*)querySql;

-(NSMutableArray*)Select_qiuchangMode ;


+(int)getTime;//获取时间
+(int)NSDate2Int:(NSDate *)date;//时间转换数值


@end


#endif
