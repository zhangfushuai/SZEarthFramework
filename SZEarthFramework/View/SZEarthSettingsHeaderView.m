//
//  SettingsHeaderView.m
//  exampleSDK
//
//  Created by Earth on 16/3/4.
//  Copyright © 2016年 Earth. All rights reserved.
//

#import "SZEarthSettingsHeaderView.h"

@implementation SZEarthSettingsHeaderView

-(instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    
    CGFloat margin = frame.size.width/3.0;
    
    _chengSeBackgroundView = [[UIView alloc]initWithFrame:CGRectMake(frame.origin.x, frame.origin.y-20, frame.size.width, frame.size.height*0.84)];
    _chengSeBackgroundView.backgroundColor = [UIColor colorWithRed:249/255.0 green:94/255.0 blue:0 alpha:1.0];
    
    if ([UIScreen mainScreen].bounds.size.height < 568) {
        _portraitImageView = [[UIImageView alloc]initWithFrame:CGRectMake(self.center.x-frame.size.width*0.16, frame.size.height*0.15, frame.size.width*0.28, frame.size.width*0.28)];
    } else {
        _portraitImageView = [[UIImageView alloc]initWithFrame:CGRectMake(self.center.x-frame.size.width*0.16, frame.size.height*0.15, frame.size.width*0.32, frame.size.width*0.32)];
    }
    
    _portraitImageView.backgroundColor = [UIColor greenColor];
    _portraitImageView.layer.cornerRadius = _portraitImageView.frame.size.height/2.0;
    _portraitImageView.layer.masksToBounds = YES;
    
    _nameAndSexLabel = [[UILabel alloc]initWithFrame:CGRectMake(frame.origin.x, frame.size.height*0.54, frame.size.width, frame.size.height*0.1)];
    _nameAndSexLabel.text = @"张先生 男|右";
    _nameAndSexLabel.font = [UIFont systemFontOfSize:20];
    _nameAndSexLabel.textColor = [UIColor whiteColor];
    _nameAndSexLabel.textAlignment =NSTextAlignmentCenter;
    
    _nameAndSexLabel.adjustsFontSizeToFitWidth = YES;
    
    _editButton = [[UIButton alloc]initWithFrame:CGRectMake(self.center.x-frame.size.width*0.14, frame.size.height*0.66, frame.size.width*0.28, frame.size.height*0.08)];
    [_editButton setTitle:@"编辑资料" forState:UIControlStateNormal];
    _editButton.titleLabel.font = [UIFont systemFontOfSize:14];
    _editButton.layer.cornerRadius = _editButton.frame.size.height/2.0;
    _editButton.layer.masksToBounds = YES;
    _editButton.layer.borderWidth = 1;
    _editButton.layer.borderColor = [UIColor whiteColor].CGColor;
    
    _maxSpeedLabel = [[UILabel alloc]initWithFrame:CGRectMake(frame.origin.x, frame.size.height*0.8, margin, frame.size.width*0.08)];
    _maxSpeedValue = [[UILabel alloc]initWithFrame:CGRectMake(frame.origin.x, frame.size.height*0.9, margin, frame.size.width*0.08)];
    _maxLiDuLabel = [[UILabel alloc]initWithFrame:CGRectMake(frame.origin.x+margin, frame.size.height*0.8, margin, frame.size.width*0.08)];
    _maxLiDuValue = [[UILabel alloc]initWithFrame:CGRectMake(frame.origin.x+margin, frame.size.height*0.9, margin, frame.size.width*0.08)];
    _maxCaloriesLabel = [[UILabel alloc]initWithFrame:CGRectMake(frame.origin.x+margin*2, frame.size.height*0.8, margin, frame.size.width*0.08)];
    _maxCaloriesValue = [[UILabel alloc]initWithFrame:CGRectMake(frame.origin.x+margin*2, frame.size.height*0.9, margin, frame.size.width*0.08)];
    
    _maxCaloriesLabel.textAlignment =NSTextAlignmentCenter;
    _maxCaloriesValue.textAlignment =NSTextAlignmentCenter;
    _maxLiDuLabel.textAlignment =NSTextAlignmentCenter;
    _maxLiDuValue.textAlignment =NSTextAlignmentCenter;
    _maxSpeedLabel.textAlignment =NSTextAlignmentCenter;
    _maxSpeedValue.textAlignment =NSTextAlignmentCenter;
    _maxCaloriesLabel.adjustsFontSizeToFitWidth = YES;
    _maxCaloriesValue.adjustsFontSizeToFitWidth = YES;
    _maxLiDuLabel.adjustsFontSizeToFitWidth = YES;
    _maxLiDuValue.adjustsFontSizeToFitWidth = YES;
    _maxSpeedLabel.adjustsFontSizeToFitWidth = YES;
    _maxSpeedValue.adjustsFontSizeToFitWidth = YES;
    
    _maxSpeedValue.text = @"0km/h";
    _maxSpeedLabel.text = @"最大拍球速度";
    _maxLiDuValue.text = @"0N";
    _maxLiDuLabel.text = @"最大力度";
    _maxCaloriesValue.text = @"0大卡";
    _maxCaloriesLabel.text = @"总消耗";
    
    _maxSpeedLabel.textColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.7];
    _maxLiDuLabel.textColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.7];
    _maxCaloriesLabel.textColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.7];
    
    
    [self addSubview:_chengSeBackgroundView];
    [self addSubview:_portraitImageView];
    [self addSubview:_nameAndSexLabel];
    [self addSubview:_editButton];
    [self addSubview:_maxSpeedLabel];
    [self addSubview:_maxSpeedValue];
    [self addSubview:_maxLiDuLabel];
    [self addSubview:_maxLiDuValue];
    [self addSubview:_maxCaloriesLabel];
    [self addSubview:_maxCaloriesValue];
    
    return self;
}

@end
