//
//  Class_Ball.h
//  smartbadminton
//
//  Created by quan on 15/10/25.
//  Copyright © 2015年 Earth. All rights reserved.
//

#import <Foundation/Foundation.h>
//#import "SZEarthMy_DB.h"

struct ball_property{
    int ball_id;
    char* ball_email;					//#注册号
    int ball_stye;			//#击球类型
    float ball_maxspeed;			//#最大速度
    float ball_maxstrength;				//#最大力度
    int ball_hitmoment;					//#击球时刻
    float ball_angle_face;					//#拍面角
    float ball_angle_stick;				//#拍杆角
    int ball_back_hand;					//#正反手（1）表示正手，（2）表示反手
    int ball_data_length;					//#动作长度
    int ball_play_time;				//#打球时间点
    float ball_kaluli;					//#消耗卡路里
    float ball_score;					//#比分
    float ball_extend1;
    float ball_extend2;
    float ball_extend3;
    
};

@interface SZEarthClass_Ball : NSObject
{
    @public
    struct ball_property stu_ball;
}

@end
