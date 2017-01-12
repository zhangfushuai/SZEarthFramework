//
//  My_App.m
//  nRF UART
//
//  Created by Earth on 15/7/19.
//  Copyright (c) 2015年 Nordic Semiconductor. All rights reserved.
//

#import "SZEarthResolveBluetooth.h"

@implementation SZEarthResolveBluetooth

+ (NSString*)tran_rec:(NSString*)inputstr
{
    #define REC_MAXLEN 128
    int i;
    
    const char *chars = [inputstr cStringUsingEncoding:NSUTF8StringEncoding];
    char outstr[REC_MAXLEN];

    for (i = 0; i < REC_MAXLEN; i++)
        outstr[i] = '\0';
    
    for (i = 0; i < strlen(chars); i++) {
        if(i>=REC_MAXLEN) break;
        outstr[i] = chars[i];
        if(i%2 && i>=1){
            char tem = chars[i-1];
            outstr[i-1] = chars[i];
            outstr[i] = tem;
        }
    }
    
//    printf("<%d>",(int)strlen(chars));

    NSString *str = [[NSString alloc] initWithCString:(const char*)outstr encoding:NSASCIIStringEncoding];
    
    return str;
}

-(int) tran_char:(NSString*)str_in {//NSNonLossyASCIIStringEncoding //NSASCIIStringEncoding
    int valueint;
    sscanf([str_in cStringUsingEncoding:NSASCIIStringEncoding],"%x",&valueint);
    char chartem = (valueint & 0xff);
    return (int)chartem;
}

-(void)getValue:(NSString*) tran_str{
    NSString *str_tem = @"";
    NSString *str_tem1 = @"";
//    NSLog(@"getValue:%@",tran_str);
//    speed = [[tran_str substringWithRange:NSMakeRange(0,2)] intValue]; ;
//    
//    str_tem = [tran_str substringWithRange:NSMakeRange(0,2)];
//    const char *color_char = [str_tem cStringUsingEncoding:NSASCIIStringEncoding];
//    sscanf(color_char,"%x",&cmd);
    
    cmd=banben=bao=0;
    if(tran_str.length>=6){
        str_tem = [tran_str substringWithRange:NSMakeRange(0,2)];
        sscanf([str_tem cStringUsingEncoding:NSASCIIStringEncoding],"%x",&cmd);
    
        str_tem = [tran_str substringWithRange:NSMakeRange(2,2)];
        sscanf([str_tem cStringUsingEncoding:NSASCIIStringEncoding],"%x",&banben);
    
        str_tem = [tran_str substringWithRange:NSMakeRange(4,2)];
        sscanf([str_tem cStringUsingEncoding:NSASCIIStringEncoding],"%x",&bao);
    } else {
        NSLog(@"!!!!RX:CMD is not my Value Or loss data~~~");
    }
    
//    NSLog(@"RX:Head %d %d %d",cmd,banben,bao);
    
    //命令：动作属性
    if(cmd==1){
        if(banben == 1)
        {
            NSString *str1;
            speed=power=hit_type=hand=zhuanpai=0;
            if(tran_str.length>=20){
                str_tem = [tran_str substringWithRange:NSMakeRange(6,2)];
                str_tem1 = [tran_str substringWithRange:NSMakeRange(8,2)];
                str1 = [NSString stringWithFormat:@"%@%@",str_tem1,str_tem];
//                NSLog(@"==========%@",str1);
                sscanf( [str1 cStringUsingEncoding:NSASCIIStringEncoding],"%x",&speed);
                speed = abs((short) speed);
            
                str_tem = [tran_str substringWithRange:NSMakeRange(10,2)];
                sscanf([str_tem cStringUsingEncoding:NSASCIIStringEncoding],"%x",&power);
                power = abs(power);
            
                str_tem = [tran_str substringWithRange:NSMakeRange(12,2)];
                sscanf([str_tem cStringUsingEncoding:NSASCIIStringEncoding],"%x",&hit_type);
            
                str_tem = [tran_str substringWithRange:NSMakeRange(14,2)];
                sscanf([str_tem cStringUsingEncoding:NSASCIIStringEncoding],"%x",&hand);
            
                str_tem = [tran_str substringWithRange:NSMakeRange(16,2)];
                str_tem1 = [tran_str substringWithRange:NSMakeRange(18,2)];
            
                str1 = [NSString stringWithFormat:@"%@%@",str_tem1,str_tem];
//                NSLog(@"==========%@",str1);

                sscanf( [str1 cStringUsingEncoding:NSASCIIStringEncoding],"%x",&zhuanpai);
                zhuanpai = (short) zhuanpai;

            } else  {
                NSLog(@"!!!!RX:DATA is loss data~~~");
            }
        }
    }
    
    if(cmd == 2)
    {
        if(banben == 1)
        {
            NSString *str1;
            baofali=falishiji=0;
            str_tem = [tran_str substringWithRange:NSMakeRange(6,2)];
            str_tem1 = [tran_str substringWithRange:NSMakeRange(8,2)];
            str1 = [NSString stringWithFormat:@"%@%@",str_tem1,str_tem];
//            NSLog(@"==========%@",str1);
            sscanf( [str1 cStringUsingEncoding:NSASCIIStringEncoding],"%x",&baofali);
            baofali = abs((short) baofali);
            
            str_tem = [tran_str substringWithRange:NSMakeRange(10,2)];
            sscanf([str_tem cStringUsingEncoding:NSASCIIStringEncoding],"%x",&falishiji);
            falishiji = abs(falishiji);
            
//        case RECV_DATA2:
//            {
//                int data =  ((Integer) msg.obj)/10;
//                Log.w("data baofali", ":"+ data );
//                if(data >= 4)
//                {
//                    m_ratingbar_new2.setRating(4);
//                }
//                else if(data >= 3)
//                {
//                    m_ratingbar_new2.setRating(3);
//                }
//                else if(data >= 2)
//                {
//                    m_ratingbar_new2.setRating(2);
//                }
//                else if(data >= 1)
//                {
//                    m_ratingbar_new2.setRating(1);
//                }
//                else
//                    m_ratingbar_new2.setRating(0);
//            }
//            break;
//        case RECV_DATA3:
//            {
//                int data = Math.abs((Integer) msg.obj);
//                Log.w("data falishiji", ":"+ data );
//                if(data >= 10)
//                {
//                    m_ratingbar_new3.setRating(0);
//                }
//                else if(data >= 8)
//                {
//                    m_ratingbar_new3.setRating(1);
//                }
//                else if(data >= 6)
//                {
//                    m_ratingbar_new3.setRating(2);
//                }
//                else if(data >= 3)
//                {
//                    m_ratingbar_new3.setRating(3);
//                }
//                else 
//                {
//                    m_ratingbar_new3.setRating(4);
//                }
//            }break;
//            
        }
    }
    
    if (cmd == 15) {
        str_tem = [tran_str substringWithRange:NSMakeRange(8,2)];
        sscanf([str_tem cStringUsingEncoding:NSASCIIStringEncoding],"%x",&lingmindu);
    }
    
}

//翻译击球类型
+(NSString*)Tran_Type:(int)type_num{
    
    switch (type_num) {
        case 1:
            return @"高位击球";
        case 2:
            return @"高位击球";
        case 3:
            return @"挑球";
        case 4:
            return @"搓球";
        case 5:
            return @"推球";
        case 6:
            return @"吊球";
        default:
            return @"空挥";
    }
    
}

@end