//
//  IntroductionQiuPai.h
//  exampleSDK
//
//  Created by Earth on 16/3/3.
//  Copyright © 2016年 Earth. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SZEarthSearchBluetoothView.h"
#import "SZEarthUARTPeripheral.h"

@interface SZEarthIntroductionQiuPai : UIViewController<UITableViewDataSource, UITableViewDelegate>

@property (strong,nonatomic) UIView *topBackgroundView;
@property (strong,nonatomic) UIImageView *portraitImageView;
@property (strong,nonatomic) UILabel *IntroductionLabel;
@property (strong,nonatomic) UITextView *IntroductionTextView;
@property (strong,nonatomic) UIButton *searchButton;

@property (strong,nonatomic) UIActivityIndicatorView *indicatorView;

@property (strong,nonatomic) SZEarthSearchBluetoothView *searchView; //显示搜索列表结果视图

@property CBCentralManager *cm;
@property (strong,nonatomic) SZEarthUARTPeripheral *currentPeripheral;

@property (strong, nonatomic) NSMutableArray *BluetoothList;

@property NSIndexPath *selectedIndexPath;

@property NSTimer *timer;

@property NSMutableArray<NSString*> *tableTitle; //存储蓝牙名字

@end
