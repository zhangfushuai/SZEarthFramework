//
//  SettingsViewController.h
//  exampleSDK
//
//  Created by Earth on 16/3/4.
//  Copyright © 2016年 Earth. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SZEarthSettingsHeaderView.h"
#import "SZEarthSelectMenuView.h"
#import "SZEarthEditInformationViewController.h"
#import "SZEarthCalendarViewController.h"
#import "SZEarthIntroductionQiuPai.h"

@interface SZEarthSettingsViewController : UIViewController<UITableViewDataSource, UITableViewDelegate, SZEarthSelectMenuViewDelegate, UIAlertViewDelegate>

@property (strong,nonatomic) UITableView *tableView;

@property (strong,nonatomic) UITableView *menuTableView; //导航条选择列表
@property (strong,nonatomic) UIButton *backgroundViewButton;
@property (strong,nonatomic) NSArray *dataListNavigation;

@property (strong,nonatomic) NSMutableArray *dataList;
@property (strong,nonatomic) SZEarthSettingsHeaderView *tableHeaderView;

@property (strong, nonatomic) UIButton *soundButton; //声音开关按钮
@property (strong, nonatomic) UIView *accessoryView; //自定义表格附件
//设置滑动条
@property (strong, nonatomic) UISlider *sensitivitySlider;

@property (strong, nonatomic) UISwitch *speciallyEffectSwitch;
@property (strong, nonatomic) UISwitch *EmptyEffectSwitch;

@property (strong, nonatomic) SZEarthSelectMenuView *selectMenuView; //选择语音播报选项
@property (strong,nonatomic) NSArray *dataListOfSound;

@property (strong,nonatomic) SZEarthEditInformationViewController *editVC2;
@property (strong,nonatomic) SZEarthIntroductionQiuPai *IntroductionVC2;
@property (strong,nonatomic) SZEarthCalendarViewController *calendarVC2;

@property (strong, nonatomic) SZEarthUARTPeripheral *currentPeripheral;

@property int isBoBaoSpeed; //1不播报，0播报;以下同理
@property int isBoBaoLiDu;
@property int isBoBaoJiQiuType;

@end
