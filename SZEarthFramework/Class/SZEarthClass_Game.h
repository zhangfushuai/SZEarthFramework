//
//  Class_Game.h
//  smartbadminton
//
//  Created by Earth on 15/9/14.
//  Copyright (c) 2015年 Earth. All rights reserved.
//

//#ifndef smartbadminton_Class_Game_h
//#define smartbadminton_Class_Game_h

#import <Foundation/Foundation.h>
//#import "SZEarthMy_DB.h"

struct games_property{
    int games_id;//                     #标识号
    char* games_email;//                #注册号
    int games_start_time;//				#开始时间
    int games_end_time;//				#结束时间
    float games_max_speed;//			#最大速度
    float games_max_strength;//			#最大力度
    float games_score;//				#评分
    float games_kaluli;//				#一场球的卡路里
    float games_extend1;//
    float games_extend2;//
    float games_extend3;//
    
};

@interface
SZEarthClass_Game : NSObject
{
@public
    int aaa;
    struct games_property stu_game;
}

@end

//#endif
