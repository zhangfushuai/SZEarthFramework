//
//  ResultBottonView.m
//  exampleSDK
//
//  Created by Earth on 16/3/10.
//  Copyright © 2016年 Earth. All rights reserved.
//

#import "ResultBottonView.h"
#import "UIImage+SZEarth_UIImage.h"

@implementation ResultBottonView

-(instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    
    self.image = [UIImage imageNamedFromCustomBundle:@"统计结果"];
    
    _shijianLabel = [[UILabel alloc]initWithFrame:CGRectMake(frame.size.width*0.17, frame.size.height*0.05, frame.size.width*0.25, frame.size.height*0.08)];
    _CaloriesLabel = [[UILabel alloc]initWithFrame:CGRectMake(frame.size.width*0.75, frame.size.height*0.05, frame.size.width*0.25, frame.size.height*0.08)];
    
     _averageSpeedValue = [[UILabel alloc]initWithFrame:CGRectMake(frame.size.width*0.45, frame.size.height*0.3, frame.size.width*0.25, frame.size.height*0.08)];
    _averageSpeedLabel = [[UILabel alloc]initWithFrame:CGRectMake(frame.size.width*0.45, frame.size.height*0.45, frame.size.width*0.25, frame.size.height*0.08)];
   
    _averageLiDUValue = [[UILabel alloc]initWithFrame:CGRectMake(frame.size.width*0.75, frame.size.height*0.3, frame.size.width*0.25, frame.size.height*0.08)];
    _averageLiDULabel = [[UILabel alloc]initWithFrame:CGRectMake(frame.size.width*0.75, frame.size.height*0.45, frame.size.width*0.25, frame.size.height*0.08)];
    
    _maxSpeedValue = [[UILabel alloc]initWithFrame:CGRectMake(frame.size.width*0.45, frame.size.height*0.7, frame.size.width*0.25, frame.size.height*0.08)];
    _maxSpeedLabel = [[UILabel alloc]initWithFrame:CGRectMake(frame.size.width*0.45, frame.size.height*0.85, frame.size.width*0.25, frame.size.height*0.08)];
    
    _maxLiDUValue = [[UILabel alloc]initWithFrame:CGRectMake(frame.size.width*0.75, frame.size.height*0.7, frame.size.width*0.25, frame.size.height*0.08)];
    _maxLiDULabel = [[UILabel alloc]initWithFrame:CGRectMake(frame.size.width*0.75, frame.size.height*0.85, frame.size.width*0.25, frame.size.height*0.08)];
    
    _shijianLabel.text = @"00:00:00h";
    _CaloriesLabel.text = @"100大卡";
    _averageSpeedLabel.text = @"平均速度";
    _averageSpeedValue.text = @"86km/h";
    _averageLiDUValue.text = @"6N";
    _averageLiDULabel.text = @"平均力度";
    _maxSpeedValue.text = @"230km/h";
    _maxSpeedLabel.text = @"最大速度";
    _maxLiDUValue.text = @"13N";
    _maxLiDULabel.text = @"最大力度";
    
    _shijianLabel.textColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.3];
    _CaloriesLabel.textColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.3];
    
    _averageSpeedLabel.textColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.6];
    _averageLiDULabel.textColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.6];
    _maxSpeedLabel.textColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.6];
    _maxLiDULabel.textColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.6];
    
    _shijianLabel.textAlignment = NSTextAlignmentCenter;
    _CaloriesLabel.textAlignment = NSTextAlignmentCenter;
    _averageSpeedLabel.textAlignment = NSTextAlignmentCenter;
    _averageSpeedValue.textAlignment = NSTextAlignmentCenter;
    _averageLiDUValue.textAlignment = NSTextAlignmentCenter;
    _averageLiDULabel.textAlignment = NSTextAlignmentCenter;
    _maxSpeedValue.textAlignment = NSTextAlignmentCenter;
    _maxSpeedLabel.textAlignment = NSTextAlignmentCenter;
    _maxLiDUValue.textAlignment = NSTextAlignmentCenter;
    _maxLiDULabel.textAlignment = NSTextAlignmentCenter;
    
    _shijianLabel.adjustsFontSizeToFitWidth = YES;
    _CaloriesLabel.adjustsFontSizeToFitWidth = YES;
    _averageSpeedLabel.adjustsFontSizeToFitWidth = YES;
    _averageSpeedValue.adjustsFontSizeToFitWidth = YES;
    _averageLiDUValue.adjustsFontSizeToFitWidth = YES;
    _averageLiDULabel.adjustsFontSizeToFitWidth = YES;
    _maxSpeedValue.adjustsFontSizeToFitWidth = YES;
    _maxSpeedLabel.adjustsFontSizeToFitWidth = YES;
    _maxLiDUValue.adjustsFontSizeToFitWidth = YES;
    _maxLiDULabel.adjustsFontSizeToFitWidth = YES;
    
    [self addSubview:_shijianLabel];
    [self addSubview:_CaloriesLabel];
    [self addSubview:_averageSpeedValue];
    [self addSubview:_averageSpeedLabel];
    [self addSubview:_averageLiDUValue];
    [self addSubview:_averageLiDULabel];
    [self addSubview:_maxSpeedValue];
    [self addSubview:_maxSpeedLabel];
    [self addSubview:_maxLiDUValue];
    [self addSubview:_maxLiDULabel];
    
    return self;
}

@end
