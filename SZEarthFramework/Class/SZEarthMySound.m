//
//  MySound.m
//  nRF UART
//
//  Created by Earth on 15/7/20.
//  Copyright (c) 2015年 Nordic Semiconductor. All rights reserved.
//

#import "SZEarthMySound.h"
#import <Foundation/Foundation.h>

static int i = 0;

static NSMutableArray *array_2;

@implementation SZEarthMySound

//BOOL isBobao;
//申明一个sound id对象
SystemSoundID system_sound_id;

+ (void)playSound:(int)isHit
{
    //第一步创建一个声音的路径
//    NSURL *system_sound_url=[NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"konghui" ofType:@"wav"]];
//    if(isHit==1) system_sound_url=[NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"gaoyuan" ofType:@"wav"]];
//    if(isHit==2) system_sound_url=[NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"gaoyuan" ofType:@"wav"]];
//    if(isHit==3) system_sound_url=[NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"tiaoqiu" ofType:@"wav"]];
//    if(isHit==4) system_sound_url=[NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"chuoqiu" ofType:@"wav"]];
//    if(isHit==5) system_sound_url=[NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"tuiqiu" ofType:@"wav"]];
//    if(isHit==6) system_sound_url=[NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"diaoqiu" ofType:@"wav"]];
//    if(isHit==7) system_sound_url=[NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"konghui" ofType:@"wav"]];
    
    NSURL *system_sound_url=[NSURL fileURLWithPath:[SZEarthMySound pathFromCustomBundle:@"konghui"]];
    if(isHit==1) system_sound_url=[NSURL fileURLWithPath:[SZEarthMySound pathFromCustomBundle:@"gaoyuan"]];
    if(isHit==2) system_sound_url=[NSURL fileURLWithPath:[SZEarthMySound pathFromCustomBundle:@"gaoyuan"]];
    if(isHit==3) system_sound_url=[NSURL fileURLWithPath:[SZEarthMySound pathFromCustomBundle:@"tiaoqiu"]];
    if(isHit==4) system_sound_url=[NSURL fileURLWithPath:[SZEarthMySound pathFromCustomBundle:@"cuoqiu"]];
    if(isHit==5) system_sound_url=[NSURL fileURLWithPath:[SZEarthMySound pathFromCustomBundle:@"tuiqiu"]];
    if(isHit==6) system_sound_url=[NSURL fileURLWithPath:[SZEarthMySound pathFromCustomBundle:@"diaoqiu"]];
    if(isHit==7) system_sound_url=[NSURL fileURLWithPath:[SZEarthMySound pathFromCustomBundle:@"konghui"]];
    
    //第二步：申明一个sound id对象
//    SystemSoundID system_sound_id;
    
    //第三步：通过AudioServicesCreateSystemSoundID方法注册一个声音对象
    AudioServicesCreateSystemSoundID((__bridge CFURLRef)system_sound_url, &system_sound_id);
    
    //第四步：播放声音
    AudioServicesPlaySystemSound(system_sound_id);
    [NSThread sleepForTimeInterval:0.6];
}

+(NSString*)pathFromCustomBundle:(NSString *)fileName
{
    NSBundle *mainbundle = [NSBundle mainBundle];
    NSString *bundle_path = [mainbundle.resourcePath stringByAppendingPathComponent:@"Frameworks/SZEarthFramework.framework/SZEarthFramework.bundle"];
    NSBundle *bundle = [NSBundle bundleWithPath: bundle_path];
    NSString *tempImgPath = [NSString stringWithFormat:@"sounds/raw/%@",fileName];
    NSString *wav_path = [bundle pathForResource:tempImgPath ofType:@"wav"];
    return wav_path;
}


+(void)playSoundOfPowerOrSpeed:(BOOL)isPower{
        //第一步创建一个声音的路径
        NSURL *system_sound_url;
        if (isPower) {
//            system_sound_url=[NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"power" ofType:@"wav"]];
            system_sound_url=[NSURL fileURLWithPath:[SZEarthMySound pathFromCustomBundle:@"power"]];
        } else {
//            system_sound_url=[NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"speed" ofType:@"wav"]];
            system_sound_url=[NSURL fileURLWithPath:[SZEarthMySound pathFromCustomBundle:@"speed"]];
        }
        
        //第二步：申明一个sound id对象
        SystemSoundID system_sound_id;
        
        //第三步：通过AudioServicesCreateSystemSoundID方法注册一个声音对象
        AudioServicesCreateSystemSoundID((__bridge CFURLRef)system_sound_url, &system_sound_id);
        
        //第三步：创建一个回调方法，用于完成声音播放后需要做的事情
        
        AudioServicesAddSystemSoundCompletion(
                                              system_sound_id,
                                              NULL, NULL,
                                              finishPalySoundCallBack,
                                              NULL
                                              );
        //第四步：播放声音
        AudioServicesPlaySystemSound(system_sound_id);
        [NSThread sleepForTimeInterval:0.6];
    
}

+(void)playsoundsWithArray:(NSArray*)array atIndex:(int)index {
    if (i == -1) {
        i++;
    }
    if (index < array.count) {
        NSURL *system_sound_url=[NSURL fileURLWithPath:[SZEarthMySound pathFromCustomBundle:[NSString stringWithFormat:@"%@", array[index]]]];
        //第二步：申明一个sound id对象
        //        SystemSoundID system_sound_id;
        
        //第三步：通过AudioServicesCreateSystemSoundID方法注册一个声音对象
        AudioServicesCreateSystemSoundID((__bridge CFURLRef)system_sound_url, &system_sound_id);
        
        //第三步：创建一个回调方法，用于完成声音播放后需要做的事情
        
        AudioServicesAddSystemSoundCompletion(
                                              system_sound_id,
                                              NULL, NULL,
                                              finishPalySoundCallBack,
                                              NULL
                                              );
        //第四步：播放声音
        AudioServicesPlaySystemSound(system_sound_id);
        
    } else {
        i = -1;
    }
}

+ (NSArray*) playArrayURL: (float)powerOrSpeed isPower: (BOOL)isPower actionType: (int)actionType {
    
    NSMutableArray *weiShuArray = [[NSMutableArray alloc]initWithObjects: @"num_10",@"bai",@"qian",@"wan", nil]; //记录十、百、千...;
    NSMutableArray *array = [[NSMutableArray alloc]init]; //记录各个位数；
    int i = 0;
    int j = 0;
    //判断是否为零再做下一步运算
    if (powerOrSpeed == 0) {
        [array insertObject:@"num_0" atIndex:0];
    }
    while (powerOrSpeed != 0) {
        j = (int)powerOrSpeed % 10;
        [array insertObject:[NSString stringWithFormat:@"num_%d",j] atIndex:0];
        powerOrSpeed = (int)powerOrSpeed/10;
    }
    
    i = (int)array.count - 1;
    for (int k = 0; k < i; k++) {
        if (!([array[i-k-1] isEqual: @"num_0"]))  {
            [array insertObject:weiShuArray[k] atIndex:i-k];
        }
    }
    i = (int)array.count - 1;
    for (int n = i; n >= 0; n--) { //去掉末尾的零
        if ([array[n] isEqual: @"num_0"] && array.count != 1) {
            [array removeObjectAtIndex:n];
        }else {
            break;
        }
    }
    
    if (array.count == 2) {
        if ([array[array.count - 1] isEqualToString: @"num_10"] && [array[array.count - 2] isEqualToString: @"num_1"]) {
            [array removeObjectAtIndex:array.count - 2];
        }
    }
    
    if (array.count == 3) {
        if ([array[array.count - 2] isEqualToString: @"num_10"] && [array[array.count - 3] isEqualToString: @"num_1"]) {
            [array removeObjectAtIndex:array.count - 3];
        }
    }
    
    
    for (int i = 0; i < array.count; i++) {
//        NSURL *system_sound_url=[NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:array[i] ofType:@"wav"]];
        NSURL *system_sound_url=[NSURL fileURLWithPath:[SZEarthMySound pathFromCustomBundle:[NSString stringWithFormat:@"%@", array[i]]]];
        //第二步：申明一个sound id对象
//        SystemSoundID system_sound_id;
        
        //第三步：通过AudioServicesCreateSystemSoundID方法注册一个声音对象
        AudioServicesCreateSystemSoundID((__bridge CFURLRef)system_sound_url, &system_sound_id);
        
        //第三步：创建一个回调方法，用于完成声音播放后需要做的事情
        
        AudioServicesAddSystemSoundCompletion(
                                              system_sound_id,
                                              NULL, NULL,
                                              finishPalySoundCallBack,
                                              NULL
                                              );
        //第四步：播放声音
        AudioServicesPlaySystemSound(system_sound_id);
        [NSThread sleepForTimeInterval:0.42];
    }
    
    if (isPower) {
        [array insertObject:@"power" atIndex:0];
        
    } else {
        [array insertObject:@"speed" atIndex:0];
    }
    
    if(actionType==1 || actionType==2)
    {
        [array insertObject:@"gaoyuan" atIndex:array.count - 1];
    }
    if(actionType==3) {
        [array insertObject:@"tiaoqiu" atIndex:array.count - 1];
    }
    if(actionType==4) {
        [array insertObject:@"chuoqiu" atIndex:array.count - 1];
    }
    if(actionType==5) {
        [array insertObject:@"tuiqiu" atIndex:array.count - 1];
    }
    if(actionType==6) {
        [array insertObject:@"diaoqiu" atIndex:array.count - 1];
    }
    if(actionType==7) {
        [array insertObject:@"konghui" atIndex:array.count - 1];
    }
    array_2 = array;
    return array;
}


//播放完毕调用：//
void finishPalySoundCallBack(SystemSoundID sound_id,void* user_data){
//    AudioServicesDisposeSystemSoundID(sound_id);
//    UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"title" message:@"helo" delegate:nil cancelButtonTitle:@"ok" otherButtonTitles:nil];
//    [alert show];
//    if (i != -1) {
//        i++;
//        [NSThread sleepForTimeInterval:0.43];
//        [MySound playsoundsWithArray:array_2 atIndex:i];
//    }
    
}

@end