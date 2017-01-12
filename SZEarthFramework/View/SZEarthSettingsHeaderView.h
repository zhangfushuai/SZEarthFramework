//
//  SettingsHeaderView.h
//  exampleSDK
//
//  Created by Earth on 16/3/4.
//  Copyright © 2016年 Earth. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SZEarthSettingsHeaderView : UIView

@property (strong,nonatomic) UIView *chengSeBackgroundView;
@property (strong,nonatomic) UIImageView *portraitImageView;
@property (strong,nonatomic) UILabel *nameAndSexLabel;
@property (strong,nonatomic) UIButton *editButton;

@property(strong,nonatomic) UILabel *maxSpeedLabel;
@property(strong,nonatomic) UILabel *maxSpeedValue;
@property(strong,nonatomic) UILabel *maxLiDuLabel;
@property(strong,nonatomic) UILabel *maxLiDuValue;
@property(strong,nonatomic) UILabel *maxCaloriesLabel;
@property(strong,nonatomic) UILabel *maxCaloriesValue;

//-(instancetype)initWithFrame:(CGRect)frame;

@end
