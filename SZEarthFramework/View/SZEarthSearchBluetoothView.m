//
//  SZEarthSearchBluetoothViewController.m
//  exampleSDK
//
//  Created by Earth on 16/3/7.
//  Copyright © 2016年 Earth. All rights reserved.
//

#import "SZEarthSearchBluetoothView.h"

@implementation SZEarthSearchBluetoothView

-(instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, frame.size.width, self.frame.size.height*0.76) style:UITableViewStylePlain];
    
    UIView *backgroundViewOfTbaleView = [[UIView alloc]initWithFrame:_tableView.frame];
    _backgroundImageView = [[UIImageView alloc]initWithFrame:CGRectMake(_tableView.frame.size.width*0.5-_tableView.frame.size.width*0.4, _tableView.frame.size.height*0.6-_tableView.frame.size.height*0.1, _tableView.frame.size.width*0.8, _tableView.frame.size.height*0.4)];
    [backgroundViewOfTbaleView addSubview: _backgroundImageView];
    _tableView.backgroundView = backgroundViewOfTbaleView;
    
    _okButtonView = [[UIButton alloc]initWithFrame:CGRectMake(frame.size.width*0.1, frame.size.height*0.83, frame.size.width*0.3, frame.size.height*0.1)];
    _cancelButtonView = [[UIButton alloc]initWithFrame:CGRectMake(frame.size.width*0.6 , frame.size.height*0.83, frame.size.width*0.3, frame.size.height*0.1)];
    
    [_okButtonView setTitle:@"立即绑定" forState:UIControlStateNormal];
    _okButtonView.backgroundColor = [UIColor colorWithRed:249/255.0 green:94/255.0 blue:0 alpha:1.0];
    [_cancelButtonView setTitle:@"取消" forState:UIControlStateNormal];
    _cancelButtonView.backgroundColor = [UIColor colorWithRed:249/255.0 green:94/255.0 blue:0 alpha:1.0];
    [self addSubview:_tableView];
    [self addSubview:_okButtonView];
    [self addSubview:_cancelButtonView];
    
    self.backgroundColor = [UIColor whiteColor];
    
    return self;
}

@end
