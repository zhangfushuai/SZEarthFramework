//
//  CustomSegmentedView.m
//  smartbadminton
//
//  Created by Earth on 15/12/1.
//  Copyright © 2015年 Earth. All rights reserved.
//

#import "SZEarthCustomSegmentedView.h"

@implementation SZEarthCustomSegmentedView


-(instancetype)initWithFrame:(CGRect)initWithFrame andItems:(NSArray*)items {
    self = [super initWithItems:items];
    self.frame = initWithFrame;
    
    self.layer.borderColor = [UIColor colorWithRed:249/255.0 green:94/255.0 blue:0 alpha:1.0].CGColor;
    
    self.layer.borderWidth = 1;
    
    self.tintColor = [UIColor colorWithRed:249/255.0 green:94/255.0 blue:0 alpha:1.0];
    
    self.backgroundColor = [UIColor colorWithWhite:0.8 alpha:1.0];
    
    self.layer.cornerRadius = self.frame.size.height/2.0;
    self.layer.masksToBounds = YES;
    
    return self;
}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    CGFloat width = rect.size.width;
    
    CGFloat height = rect.size.height;
    
    // 简便起见，这里把圆角半径设置为长和宽平均值的1/10
    
    CGFloat radius = self.frame.size.height / 2.0;
    
    
    
    // 获取CGContext，注意UIKit里用的是一个专门的函数
    
    CGContextRef context =UIGraphicsGetCurrentContext();
    
    // 移动到初始点
    
    CGContextMoveToPoint(context, radius, 0);
    
    
    
    // 绘制第1条线和第1个1/4圆弧，右上圆弧
    
    CGContextAddLineToPoint(context, width - radius,0);
    
    CGContextAddArc(context, width - radius, radius, radius, -0.5 *M_PI,0.0,0);
    
    
    
    // 绘制第2条线和第2个1/4圆弧，右下圆弧
    
    CGContextAddLineToPoint(context, width, height - radius);
    
    CGContextAddArc(context, width - radius, height - radius, radius,0.0,0.5 *M_PI,0);
    
    
    
    // 绘制第3条线和第3个1/4圆弧，左下圆弧
    
    CGContextAddLineToPoint(context, radius, height);
    
    CGContextAddArc(context, radius, height - radius, radius,0.5 *M_PI,M_PI,0);
    
    
    
    // 绘制第4条线和第4个1/4圆弧，左上圆弧
    
    CGContextAddLineToPoint(context, 0, radius);
    
    CGContextAddArc(context, radius, radius, radius,M_PI,1.5 *M_PI,0);
    
    
    
    // 闭合路径
    
    CGContextClosePath(context);
    
}


@end
