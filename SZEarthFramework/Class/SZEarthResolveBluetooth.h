//
//  My_App.h
//  nRF UART
//
//  Created by Earth on 15/7/19.
//  Copyright (c) 2015年 Nordic Semiconductor. All rights reserved.
//

#ifndef nRF_UART_My_App_h
#define nRF_UART_My_App_h

#import <Foundation/Foundation.h>

@interface
SZEarthResolveBluetooth : NSObject {
    @public
    NSString* recstr;
    int cmd;
    int banben;
    int bao;
    int speed;
    int power;
    int hit_type;
    int hand;
    int zhuanpai;
    
    int baofali;
    int falishiji;
    
    int lingmindu;
    
}

+(NSString*)tran_rec:(NSString*) inputstr;
-(void)getValue:(NSString*) tran_str;
+(NSString*)Tran_Type:(int)type_num;//翻译击球类型
@end

#endif
