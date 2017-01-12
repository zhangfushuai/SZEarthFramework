//
//  Header.h
//  nRF UART
//
//  Created by Earth on 15/7/20.
//  Copyright (c) 2015年 Nordic Semiconductor. All rights reserved.
//

#ifndef nRF_UART_Header_h
#define nRF_UART_Header_h

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <AudioToolbox/AudioToolbox.h>

@interface SZEarthMySound : NSObject

+ (void)playSound:(int)isHit;
+ (NSArray*) playArrayURL: (float)powerOrSpeed isPower: (BOOL)isPower actionType: (int)actionType;
+(void)playSoundOfPowerOrSpeed:(BOOL)isPower;

+(void)playsoundsWithArray:(NSArray*)array  atIndex:(int)index;

@end

#endif
