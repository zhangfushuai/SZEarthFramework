//
//  ResultChartView.h
//  exampleSDK
//
//  Created by Earth on 16/3/10.
//  Copyright © 2016年 Earth. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ResultChartView : UIView

@property (strong,nonatomic) UIImageView *chartImageview;

@property (strong,nonatomic) UILabel *maxValueLabel;
@property (strong,nonatomic) UILabel *averageValueLabel;
@property (strong,nonatomic) UILabel *minValueLabel;

@property (strong,nonatomic) UILabel *gaoWeiLabel;
@property (strong,nonatomic) UILabel *tiaoQiuLabel;
@property (strong,nonatomic) UILabel *cuoQiuLabel;
@property (strong,nonatomic) UILabel *diaoQiuLabel;
@property (strong,nonatomic) UILabel *tuiQiuLabel;
@property (strong,nonatomic) UILabel *zhengShouImage;
@property (strong,nonatomic) UILabel *zhengShouLabel;
@property (strong,nonatomic) UILabel *fanShouImage;
@property (strong,nonatomic) UILabel *fanShouLabel;

@property (strong,nonatomic) UILabel *totalSwingsLabel;


//柱形label
@property (strong,nonatomic) UILabel *zsGaoWeiLabelOfZhuXing;
@property (strong,nonatomic) UILabel *fsGaoWeiLabelOfZhuXing;
@property (strong,nonatomic) UILabel *zsTiaoQiuLabelOfZhuXing;
@property (strong,nonatomic) UILabel *fsTiaoQiuLabelOfZhuXing;
@property (strong,nonatomic) UILabel *zsCuoQiuLabelOfZhuXing;
@property (strong,nonatomic) UILabel *fsCuoQiuLabelOfZhuXing;
@property (strong,nonatomic) UILabel *zsDiaoQiuLabelOfZhuXing;
@property (strong,nonatomic) UILabel *fsDiaoQiuLabelOfZhuXing;
@property (strong,nonatomic) UILabel *zsTuiQiuLabelOfZhuXing;
@property (strong,nonatomic) UILabel *fsTuiQiuLabelOfZhuXing;


-(instancetype)initWithFrame:(CGRect)frame maxSings:(NSInteger)count;

-(void)setLabel:(UILabel*)label;

@end
