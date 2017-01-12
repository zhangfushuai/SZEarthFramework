//
//  ResultChartView.m
//  exampleSDK
//
//  Created by Earth on 16/3/10.
//  Copyright © 2016年 Earth. All rights reserved.
//

#import "ResultChartView.h"
#import "UIImage+SZEarth_UIImage.h"
@implementation ResultChartView

-(instancetype)initWithFrame:(CGRect)frame maxSings:(NSInteger)count {
    self = [super initWithFrame:frame];
    _chartImageview = [[UIImageView alloc]init];
    _maxValueLabel = [[UILabel alloc]init];
    _averageValueLabel = [[UILabel alloc]init];
    _minValueLabel = [[UILabel alloc]init];
    _gaoWeiLabel = [[UILabel alloc]init];
    _tiaoQiuLabel = [[UILabel alloc]init];
    _cuoQiuLabel = [[UILabel alloc]init];
    _diaoQiuLabel = [[UILabel alloc]init];
    _tuiQiuLabel = [[UILabel alloc]init];
    _zhengShouImage = [[UILabel alloc]init];
    _zhengShouLabel = [[UILabel alloc]init];
    _fanShouImage = [[UILabel alloc]init];
    _fanShouLabel = [[UILabel alloc]init];
    _totalSwingsLabel = [[UILabel alloc]init];
    
    //柱形
    _zsGaoWeiLabelOfZhuXing = [[UILabel alloc]init];
    _fsGaoWeiLabelOfZhuXing = [[UILabel alloc]init];
    _zsTiaoQiuLabelOfZhuXing = [[UILabel alloc]init];
    _fsTiaoQiuLabelOfZhuXing = [[UILabel alloc]init];
    _zsCuoQiuLabelOfZhuXing = [[UILabel alloc]init];
    _fsCuoQiuLabelOfZhuXing = [[UILabel alloc]init];
    _zsDiaoQiuLabelOfZhuXing = [[UILabel alloc]init];
    _fsDiaoQiuLabelOfZhuXing = [[UILabel alloc]init];
    _zsTuiQiuLabelOfZhuXing = [[UILabel alloc]init];
    _fsTuiQiuLabelOfZhuXing = [[UILabel alloc]init];
    
    [self addSubview:_chartImageview];
    [self addSubview:_maxValueLabel];
    [self addSubview:_averageValueLabel];
    [self addSubview:_minValueLabel];
    [self addSubview:_gaoWeiLabel];
    [self addSubview:_tiaoQiuLabel];
    [self addSubview:_cuoQiuLabel];
    [self addSubview:_diaoQiuLabel];
    [self addSubview:_tuiQiuLabel];
    [self addSubview:_zhengShouImage];
    [self addSubview:_zhengShouLabel];
    [self addSubview:_fanShouImage];
    [self addSubview:_fanShouLabel];
    [self addSubview:_totalSwingsLabel];
    
    
    [self addSubview:_zsGaoWeiLabelOfZhuXing];
    [self addSubview:_fsGaoWeiLabelOfZhuXing];
    [self addSubview:_zsTiaoQiuLabelOfZhuXing];
    [self addSubview:_fsTiaoQiuLabelOfZhuXing];
    [self addSubview:_zsCuoQiuLabelOfZhuXing];
    [self addSubview:_fsCuoQiuLabelOfZhuXing];
    [self addSubview:_zsDiaoQiuLabelOfZhuXing];
    [self addSubview:_fsDiaoQiuLabelOfZhuXing];
    [self addSubview:_zsTuiQiuLabelOfZhuXing];
    [self addSubview:_fsTuiQiuLabelOfZhuXing];
    
    _chartImageview.image = [UIImage imageNamedFromCustomBundle:@"柱形图"];
    
    _maxValueLabel.text = [NSString stringWithFormat:@"%d",(int)count];
    _averageValueLabel.text = [NSString stringWithFormat:@"%d",(int)count/2];
    _minValueLabel.text = @"0";
    
    _gaoWeiLabel.text = @"高位";
    _tiaoQiuLabel.text = @"挑球";
    _cuoQiuLabel.text = @"搓球";
    _diaoQiuLabel.text = @"吊球";
    _tuiQiuLabel.text = @"推球";
    _zhengShouLabel.text = @"正手";
    _fanShouLabel.text = @"反手";
    _totalSwingsLabel.text = @"76次";
    
    _zhengShouLabel.textColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.3];
    _fanShouLabel.textColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.3];
    _zhengShouImage.backgroundColor = [UIColor colorWithRed:19/255.0 green:141/255.0 blue:208/255.0 alpha:1.0];
    _fanShouImage.backgroundColor = [UIColor colorWithRed:179/255.0 green:217/255.0 blue:41/255.0 alpha:1.0];
    
    if ([UIScreen mainScreen].bounds.size.height < 568) {
        [self layoutView:_chartImageview multiplierX:1.0 multiplierY:1.1 multiplierWidth:0.8 multiplierHeight:0.4];
        [self layoutView:_maxValueLabel multiplierX:0.1 multiplierY:0.6 multiplierWidth:0.1 multiplierHeight:0.06];
        [self layoutView:_averageValueLabel multiplierX:0.1 multiplierY:1.1 multiplierWidth:0.1 multiplierHeight:0.06];
        [self layoutView:_minValueLabel multiplierX:0.1 multiplierY:1.6 multiplierWidth:0.12 multiplierHeight:0.06];
        [self layoutView:_gaoWeiLabel multiplierX:0.4 multiplierY:1.66 multiplierWidth:0.12 multiplierHeight:0.04];
        [self layoutView:_tiaoQiuLabel multiplierX:0.7 multiplierY:1.66 multiplierWidth:0.12 multiplierHeight:0.04];
        [self layoutView:_cuoQiuLabel multiplierX:1.0 multiplierY:1.66 multiplierWidth:0.12 multiplierHeight:0.04];
        [self layoutView:_diaoQiuLabel multiplierX:1.3 multiplierY:1.66 multiplierWidth:0.12 multiplierHeight:0.04];
        [self layoutView:_tuiQiuLabel multiplierX:1.6 multiplierY:1.66 multiplierWidth:0.12 multiplierHeight:0.04];
        
        [self layoutView:_zhengShouImage multiplierX:1.25 multiplierY:1.8 multiplierWidth:0.05 multiplierHeight:0.05];
        [self layoutView:_zhengShouLabel multiplierX:1.4 multiplierY:1.8 multiplierWidth:0.08 multiplierHeight:0.05];
        [self layoutView:_fanShouImage multiplierX:1.6 multiplierY:1.8 multiplierWidth:0.05 multiplierHeight:0.05];
        [self layoutView:_fanShouLabel multiplierX:1.75 multiplierY:1.8 multiplierWidth:0.08 multiplierHeight:0.05];
        [self layoutView:_totalSwingsLabel multiplierX:0.6 multiplierY:1.8 multiplierWidth:0.4 multiplierHeight:0.08];
    } else {
        [self layoutView:_chartImageview multiplierX:1.0 multiplierY:1.1 multiplierWidth:0.8 multiplierHeight:0.5];
        [self layoutView:_maxValueLabel multiplierX:0.1 multiplierY:0.6 multiplierWidth:0.1 multiplierHeight:0.08];
        [self layoutView:_averageValueLabel multiplierX:0.1 multiplierY:1.1 multiplierWidth:0.1 multiplierHeight:0.08];
        [self layoutView:_minValueLabel multiplierX:0.1 multiplierY:1.6 multiplierWidth:0.12 multiplierHeight:0.08];
        [self layoutView:_gaoWeiLabel multiplierX:0.4 multiplierY:1.66 multiplierWidth:0.12 multiplierHeight:0.05];
        [self layoutView:_tiaoQiuLabel multiplierX:0.7 multiplierY:1.66 multiplierWidth:0.12 multiplierHeight:0.05];
        [self layoutView:_cuoQiuLabel multiplierX:1.0 multiplierY:1.66 multiplierWidth:0.12 multiplierHeight:0.05];
        [self layoutView:_diaoQiuLabel multiplierX:1.3 multiplierY:1.66 multiplierWidth:0.12 multiplierHeight:0.05];
        [self layoutView:_tuiQiuLabel multiplierX:1.6 multiplierY:1.66 multiplierWidth:0.12 multiplierHeight:0.05];
        
        [self layoutView:_zhengShouImage multiplierX:1.25 multiplierY:1.8 multiplierWidth:0.05 multiplierHeight:0.05];
        [self layoutView:_zhengShouLabel multiplierX:1.4 multiplierY:1.8 multiplierWidth:0.08 multiplierHeight:0.05];
        [self layoutView:_fanShouImage multiplierX:1.6 multiplierY:1.8 multiplierWidth:0.05 multiplierHeight:0.05];
        [self layoutView:_fanShouLabel multiplierX:1.75 multiplierY:1.8 multiplierWidth:0.08 multiplierHeight:0.05];
        [self layoutView:_totalSwingsLabel multiplierX:0.6 multiplierY:1.8 multiplierWidth:0.4 multiplierHeight:0.08];
        
    }
    
    return self;
}

//添加布局约束
-(void) layoutView: (UIView*)view multiplierX: (CGFloat)multiplierX multiplierY: (CGFloat)multiplierY multiplierWidth: (CGFloat)multiplierWidth multiplierHeight: (CGFloat)multiplierHeight{
    if ([view isKindOfClass:[UILabel class]]) {
        ((UILabel*)view).adjustsFontSizeToFitWidth = YES;
        if (view != _totalSwingsLabel) {
            ((UILabel*)view).textAlignment = NSTextAlignmentCenter;
        }
    }
    view.translatesAutoresizingMaskIntoConstraints = NO;
//    view.backgroundColor = [UIColor brownColor];
    NSLayoutConstraint *centerXContraint=[NSLayoutConstraint
                                          constraintWithItem: view
                                          attribute:NSLayoutAttributeCenterX
                                          relatedBy:NSLayoutRelationEqual
                                          toItem: view.superview
                                          attribute:NSLayoutAttributeCenterX
                                          multiplier: multiplierX
                                          constant:0];
    NSLayoutConstraint *centerYContraint=[NSLayoutConstraint
                                          constraintWithItem: view
                                          attribute:NSLayoutAttributeCenterY
                                          relatedBy:NSLayoutRelationEqual
                                          toItem: view.superview
                                          attribute:NSLayoutAttributeCenterY
                                          multiplier:multiplierY
                                          constant:0];
    NSLayoutConstraint *widthContraint=[NSLayoutConstraint
                                        constraintWithItem: view
                                        attribute:NSLayoutAttributeWidth
                                        relatedBy:NSLayoutRelationEqual
                                        toItem: view.superview
                                        attribute:NSLayoutAttributeWidth
                                        multiplier:multiplierWidth
                                        constant:0];
    NSLayoutConstraint *heightContraint=[NSLayoutConstraint
                                         constraintWithItem: view
                                         attribute:NSLayoutAttributeHeight
                                         relatedBy:NSLayoutRelationEqual
                                         toItem: view.superview
                                         attribute:NSLayoutAttributeWidth
                                         multiplier:multiplierHeight
                                         constant: 0];
    
    [self addConstraints:@[centerXContraint,centerYContraint,widthContraint,heightContraint]];
    
}

-(void)setLabel:(UILabel*)label {
    
}


@end
