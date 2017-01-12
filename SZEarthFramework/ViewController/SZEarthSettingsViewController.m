//
//  SettingsViewController.m
//  exampleSDK
//
//  Created by Earth on 16/3/4.
//  Copyright © 2016年 Earth. All rights reserved.
//

#import "SZEarthSettingsViewController.h"
#import "UIImage+SZEarth_UIImage.h"

@implementation SZEarthSettingsViewController


-(void)viewDidLoad {
    [super viewDidLoad];
    
    _dataListOfSound = [NSArray arrayWithObjects:@"选择提示语音", @"速度", @"力度", @"击球类型", nil];
    
    self.view.backgroundColor =[UIColor whiteColor];
    
    _tableHeaderView = [[SZEarthSettingsHeaderView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height*0.5)];
    [_tableHeaderView.editButton addTarget:self action:@selector(touchEditButton) forControlEvents:UIControlEventTouchDown];
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, -self.navigationController.navigationBar.frame.size.height, self.view.frame.size.width, self.view.frame.size.height+self.navigationController.navigationBar.frame.size.height) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    self.tableView.tableHeaderView = _tableHeaderView;
    _tableView.rowHeight = self.view.frame.size.height*0.08;
    [self.view addSubview:_tableView];
    
    NSString *userEmail = [[NSUserDefaults standardUserDefaults] objectForKey:@"SZEarthUserEmail"];
    
    //
    SZEarthMy_DB *myDB = [[SZEarthMy_DB alloc]init];
    NSString *sqlstr = [NSString stringWithFormat:@"select max(games_max_speed) from games_property WHERE (games_email='%@')" ,userEmail];
    int maxSpeed = [myDB Select_value:sqlstr];
    if (maxSpeed > [[NSUserDefaults standardUserDefaults] integerForKey:[NSString stringWithFormat:@"SZEarthMaxSpeed%@",userEmail]]) {
        _tableHeaderView.maxSpeedValue.text = [NSString stringWithFormat:@"%dkm/h",maxSpeed];
        [[NSUserDefaults standardUserDefaults] setInteger:maxSpeed forKey:[NSString stringWithFormat:@"SZEarthMaxSpeed%@",userEmail]];
    } else {
        _tableHeaderView.maxSpeedValue.text = [NSString stringWithFormat:@"%dkm/h",(int)[[NSUserDefaults standardUserDefaults] integerForKey:[NSString stringWithFormat:@"SZEarthMaxSpeed%@",userEmail]]];
    }
    
    
    sqlstr = [NSString stringWithFormat:@"select max(games_max_strength) from games_property WHERE (games_email='%@')" ,userEmail];
    int maxLiDu = [myDB Select_value:sqlstr];
    if (maxLiDu > [[NSUserDefaults standardUserDefaults] integerForKey:[NSString stringWithFormat:@"SZEarthMaxLiDu%@",userEmail]]) {
        _tableHeaderView.maxLiDuValue.text = [NSString stringWithFormat:@"%dN",maxLiDu];
        [[NSUserDefaults standardUserDefaults] setInteger:maxLiDu forKey:[NSString stringWithFormat:@"SZEarthMaxLiDu%@",userEmail]];
    } else {
        _tableHeaderView.maxLiDuValue.text = [NSString stringWithFormat:@"%dN",(int)[[NSUserDefaults standardUserDefaults] integerForKey:[NSString stringWithFormat:@"SZEarthMaxLiDu%@",userEmail]]];
    }
    
    sqlstr = [NSString stringWithFormat:@"select SUM(games_kaluli) from games_property WHERE (games_email='%@')" ,userEmail];
    int calories = [myDB selectCaloriesSum:sqlstr];
    if (calories > [[NSUserDefaults standardUserDefaults] integerForKey:[NSString stringWithFormat:@"SZEarthCalories%@",userEmail]]) {
        _tableHeaderView.maxCaloriesValue.text = [NSString stringWithFormat:@"%d大卡",calories];
        [[NSUserDefaults standardUserDefaults] setInteger:calories forKey:[NSString stringWithFormat:@"SZEarthCalories%@",userEmail]];
    } else {
        _tableHeaderView.maxCaloriesValue.text = [NSString stringWithFormat:@"%d大卡",(int)[[NSUserDefaults standardUserDefaults] integerForKey:[NSString stringWithFormat:@"SZEarthCalories%@",userEmail]]];
    }
    
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@", _tableHeaderView.maxSpeedValue.text]];
    [str addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:249/255.0 green:94/255.0 blue:0 alpha:1.0] range:NSMakeRange(0,str.length)];
    [str addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.3] range:NSMakeRange(str.length-4,4)];
    _tableHeaderView.maxSpeedValue.attributedText = str;
    
    str = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@", _tableHeaderView.maxLiDuValue.text]];
    [str addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:249/255.0 green:94/255.0 blue:0 alpha:1.0] range:NSMakeRange(0,str.length)];
    [str addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.3] range:NSMakeRange(str.length-1,1)];
    _tableHeaderView.maxLiDuValue.attributedText = str;
    
    str = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@", _tableHeaderView.maxCaloriesValue.text]];
    [str addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:249/255.0 green:94/255.0 blue:0 alpha:1.0] range:NSMakeRange(0,str.length)];
    [str addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.3] range:NSMakeRange(str.length-2,2)];
    _tableHeaderView.maxCaloriesValue.attributedText = str;
    
    _tableHeaderView.portraitImageView.image = [UIImage imageNamed:@"test"];
    
    //导航条右边更多的初始化
    _dataListNavigation = [NSArray arrayWithObjects:@"更换设备", @"历史数据", nil];
    _menuTableView = [[UITableView alloc]initWithFrame:CGRectMake(self.view.frame.size.width - 5 - self.view.frame.size.width * 0.48, self.navigationController.navigationBar.frame.size.height+20, self.view.frame.size.width * 0.48, self.view.frame.size.width * 0.25) style:UITableViewStylePlain];
    _menuTableView.separatorColor = [UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:0.2];
    _menuTableView.separatorInset = UIEdgeInsetsMake(0, -15, 0, 0);
    _menuTableView.scrollEnabled = NO;
    _menuTableView.dataSource = self;
    _menuTableView.delegate = self;
    _menuTableView.hidden = YES;
    _menuTableView.alpha = 0.8;
    if ([_menuTableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [_menuTableView setSeparatorInset:UIEdgeInsetsZero];
    }
    
    if ([_menuTableView respondsToSelector:@selector(setLayoutMargins:)]) {
        [_menuTableView setLayoutMargins:UIEdgeInsetsZero];
    }
    _backgroundViewButton = [[UIButton alloc]initWithFrame:self.view.frame];
    [_backgroundViewButton addTarget:self action:@selector(tapBackgroundView) forControlEvents:UIControlEventTouchDown];
    _backgroundViewButton.hidden = YES;
    
    [self initView];
    
    [self.view addSubview:_backgroundViewButton];
    [self.view addSubview:_menuTableView];
    
    _selectMenuView = [[SZEarthSelectMenuView alloc]initWithFrame:self.view.frame withRowCounts:4];
    [self.view addSubview:_selectMenuView];
    _selectMenuView.delegate = self;
    _selectMenuView.hidden= YES;
    
    _editVC2 =[[SZEarthEditInformationViewController alloc]init];
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
    layout.headerReferenceSize = CGSizeMake(self.view.frame.size.width, 40);
    _calendarVC2 = [[SZEarthCalendarViewController alloc]initWithCollectionViewLayout:layout];
    
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    //读取灵敏度
    [self readData];
    
    self.navigationItem.title = @"设置";
    
    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamedFromCustomBundle:@"更多"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal ] style:UIBarButtonItemStylePlain target:self action:@selector(touchRightButton)];
    self.navigationItem.rightBarButtonItem = rightButton;
    
    
    _dataList = [[NSMutableArray alloc]initWithObjects:@"语音播报", nil];
    
    if ([_tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [_tableView setSeparatorInset:UIEdgeInsetsZero];
    }
    
    if ([_tableView respondsToSelector:@selector(setLayoutMargins:)]) {
        [_tableView setLayoutMargins:UIEdgeInsetsZero];
    }
    _tableView.backgroundColor = [UIColor colorWithWhite:0.95 alpha:0.9];
    
    if ([[NSUserDefaults standardUserDefaults] integerForKey:@"SZEarthhand"]==0) {
        if ([[NSUserDefaults standardUserDefaults] integerForKey:@"SZEarthUserSex"]==0) {
            _tableHeaderView.nameAndSexLabel.text = [NSString stringWithFormat:@"%@ 男|左",[[NSUserDefaults standardUserDefaults] objectForKey:@"SZEarthUserName"]];
        } else {
            _tableHeaderView.nameAndSexLabel.text = [NSString stringWithFormat:@"%@ 女|左", [[NSUserDefaults standardUserDefaults] objectForKey:@"SZEarthUserName"]];
        }
        
    } else {
        if ([[NSUserDefaults standardUserDefaults] integerForKey:@"SZEarthUserSex"]==0) {
            _tableHeaderView.nameAndSexLabel.text = [NSString stringWithFormat:@"%@ 男|右",[[NSUserDefaults standardUserDefaults] objectForKey:@"SZEarthUserName"]];
        } else {
            _tableHeaderView.nameAndSexLabel.text = [NSString stringWithFormat:@"%@ 女|右",[[NSUserDefaults standardUserDefaults] objectForKey:@"SZEarthUserName"]];
        }
    }
    
    _tableHeaderView.portraitImageView.image = [UIImage imageWithData:[[NSUserDefaults standardUserDefaults] objectForKey:@"SZEarthUserImageData"]];
    
}

-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
}

-(void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.navigationItem.title = @"";
    [self.navigationController.view viewWithTag:888].hidden = YES;
    
    _menuTableView.hidden = YES;
    _backgroundViewButton.hidden = YES;
    
}


-(void)readData {
    if (_currentPeripheral.peripheral.state == CBPeripheralStateConnected) {
        //读取灵敏度
        Byte byte1[] = {15, 1, 1, 1};
        [self.currentPeripheral writeString: [NSData dataWithBytes:byte1 length: 4]];
    }
    
}

-(void)initView {
    
    //声音按键
    self.soundButton = [[UIButton alloc]initWithFrame:CGRectMake(self.view.frame.size.width - 40, _tableView.rowHeight/2.0-_tableView.rowHeight*0.3, _tableView.rowHeight*0.6, _tableView.rowHeight*0.6)];
    if ([[NSUserDefaults standardUserDefaults] integerForKey:@"set_sound"] == 1) {
        [self.soundButton setImage:[UIImage imageNamedFromCustomBundle:@"sounds_off"] forState:UIControlStateNormal];
    } else {
        [self.soundButton setImage:[UIImage imageNamedFromCustomBundle:@"sounds_on"] forState:UIControlStateNormal];
    }
    [self.soundButton addTarget:self action:@selector(touchSoundBt:) forControlEvents:UIControlEventTouchDown];
    
    
    
    //    设置滑动条
    self.sensitivitySlider = [[UISlider alloc]initWithFrame:CGRectMake(self.view.frame.size.width *0.33, _tableView.rowHeight/2.0-_tableView.rowHeight*0.2, self.view.frame.size.width *0.66, _tableView.rowHeight*0.4)];
    
    self.sensitivitySlider.backgroundColor = [UIColor clearColor];
    self.sensitivitySlider.tintColor = [UIColor colorWithRed:249/255.0 green:94/255.0 blue:0 alpha:1.0];
    
    self.sensitivitySlider.value=110.0;
    self.sensitivitySlider.minimumValue=0;
    self.sensitivitySlider.maximumValue=180;
    
    self.sensitivitySlider.continuous = YES;
    
    //灵敏度相关
    NSString *data = [[NSUserDefaults standardUserDefaults] objectForKey:@"lingmindu"];
    if (data) {
        self.sensitivitySlider.value = 200 - [data intValue];
        
    }
    
    //滑动拖动后的事件
    [self.sensitivitySlider addTarget:self action:@selector(sliderValueChanged:) forControlEvents:UIControlEventTouchUpInside];
}

-(void)tapBackgroundView {
    if (_menuTableView.hidden == NO) {
        _menuTableView.hidden = YES;
        [self.navigationController.view viewWithTag:888].hidden = YES;
        _backgroundViewButton.hidden = YES;
    }
}

-(void)touchSoundBt: (UIButton*)button {
    NSUserDefaults *defualts = [NSUserDefaults standardUserDefaults];
    if ([defualts integerForKey:@"set_sound"]==0) {
        [defualts setInteger:1 forKey:@"set_sound"];
        [defualts setInteger:1 forKey:@"isBoBaoSpeed"];
        [defualts setInteger:1 forKey:@"isBoBaoLiDu"];
        [defualts setInteger:1 forKey:@"isBoBaoJiQiuType"];
        [self.soundButton setImage:[UIImage imageNamedFromCustomBundle:@"sounds_off"] forState:UIControlStateNormal];
    } else {
        [defualts setInteger:0 forKey:@"set_sound"];
        [defualts setInteger:0 forKey:@"isBoBaoSpeed"];
        [defualts setInteger:0 forKey:@"isBoBaoLiDu"];
        [defualts setInteger:0 forKey:@"isBoBaoJiQiuType"];
        [self.soundButton setImage:[UIImage imageNamedFromCustomBundle:@"sounds_on"] forState:UIControlStateNormal];
    }
    [_selectMenuView.tableView reloadData];
}


//绑定控件的事件
-(void) sliderValueChanged:(UISlider*) slider{
//    [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%d",200-(int)slider.value] forKey:@"lingmindu"];
    if (_currentPeripheral && _currentPeripheral.peripheral.state == CBPeripheralStateConnected) {
        Byte byte[] = {15, 1, 1, 2,(Byte)(200-(int)slider.value),(Byte)(200-(int)slider.value)>>8,(Byte)(200-(int)slider.value)>>16,(Byte)(200-(int)slider.value)>>24};
        [_currentPeripheral writeString:[NSData dataWithBytes:byte length: 8]];
        
        dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5.0 * NSEC_PER_SEC));
        dispatch_after(delayTime, dispatch_get_main_queue(), ^{
            [self readData]; //读取蓝牙灵敏度
        });
    } else {
        double version = [[UIDevice currentDevice].systemVersion doubleValue];//判定系统版本。
        if(version<8.0f){
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"修改灵敏度失败" message:@"未连接球拍设备" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
            alertView.delegate = self;
            [alertView show];
        } else {
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"修改灵敏度失败" message:@"未连接球拍设备" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                //灵敏度相关
                NSString *data = [[NSUserDefaults standardUserDefaults] objectForKey:@"lingmindu"];
                if (data) {
                    self.sensitivitySlider.value = 200 - [data intValue];
                    
                }
            } ];
            [alertController addAction:okAction];
            [self showDetailViewController:alertController sender:self];
        }
    }
    
}

//uialertview delegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex==0) {
        //灵敏度相关
        NSString *data = [[NSUserDefaults standardUserDefaults] objectForKey:@"lingmindu"];
        if (data) {
            self.sensitivitySlider.value = 200 - [data intValue];
            
        }
    }
}

-(void)touchRightButton {
    if (_menuTableView.hidden == NO) {
        _menuTableView.hidden = YES;
        _backgroundViewButton.hidden = YES;
        [self.navigationController.view viewWithTag:888].hidden = YES;
    } else {
        _menuTableView.hidden = NO;
        _backgroundViewButton.hidden = NO;
        [self.navigationController.view viewWithTag:888].hidden = NO;
    }
    
}

-(void)touchEditButton {
    [self showViewController:_editVC2 sender:self];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (tableView == _menuTableView) {
        return 1;
    }
    return 2;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (tableView == _menuTableView) {
        return _dataListNavigation.count;
    }
    if (section == 0) {
        return _dataList.count;
    }
    if (section == 1) {
        return 1;
    }
    return 0;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (tableView == _menuTableView) {
        return 0;
    }
    return 15;
}

- (CGFloat) tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (section == tableView.numberOfSections-1) {
        return 0.1;
    }
    
    return 0;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView==_menuTableView) {
        return self.view.frame.size.width * 0.25/2;
    }
    return self.view.frame.size.height*0.08;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath

{
    // 设置需要的偏移量,这个UIEdgeInsets左右偏移量不要太大，不然会titleLabel也会便宜的。
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) { // iOS8的方法
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
    
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell==nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    if (tableView == _menuTableView) {
        cell.textLabel.text = _dataListNavigation[indexPath.row];
        cell.textLabel.textAlignment = NSTextAlignmentCenter;
        cell.backgroundColor = [UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:0.8];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.textLabel.textColor = [UIColor whiteColor];
    } else {
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        if (indexPath.section == 0) {
            cell.textLabel.text = _dataList[indexPath.row];
            if (indexPath.row==0) {
                [cell.contentView addSubview:_soundButton];
            }
        }
        if (indexPath.section == 1) {
            cell.textLabel.text = @"球拍灵敏度";
            [cell.contentView addSubview:_sensitivitySlider];
        }
        cell.textLabel.textColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.7];
    }
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView == _menuTableView) {
        switch (indexPath.row) {
            case 0:
                [self showViewController:_IntroductionVC2 sender:self];
                break;
            case 1:
                [self showViewController:_calendarVC2 sender:self];
                break;
            default:
                break;
        }
    }
    if (tableView==_tableView) {
        if (indexPath.section==0) {
            if (indexPath.row==0) {
                if (_selectMenuView.hidden) {
                    _isBoBaoSpeed = (int)[[NSUserDefaults standardUserDefaults] integerForKey:@"isBoBaoSpeed"];
                    _isBoBaoLiDu = (int)[[NSUserDefaults standardUserDefaults] integerForKey:@"isBoBaoLiDu"];
                    _isBoBaoJiQiuType = (int)[[NSUserDefaults standardUserDefaults] integerForKey:@"isBoBaoJiQiuType"];
                    _selectMenuView.hidden = NO;
                } else {
                    _selectMenuView.hidden = YES;
                }
            }
        }
    }
    
}

// -- SelectMenuViewDelegate
//取消修改语音播报选项
-(void)hideSelectMenuView{ //点击取消时
    [[NSUserDefaults standardUserDefaults] setInteger:_isBoBaoSpeed forKey:@"isBoBaoSpeed"];
    [[NSUserDefaults standardUserDefaults] setInteger:_isBoBaoLiDu forKey:@"isBoBaoLiDu"];
    [[NSUserDefaults standardUserDefaults] setInteger:_isBoBaoJiQiuType forKey:@"isBoBaoJiQiuType"];
    [_selectMenuView.tableView reloadData];
}

//确定修改语音播报选项
-(void)tapOkButton {
    NSUserDefaults *defualts = [NSUserDefaults standardUserDefaults];
    NSInteger isBoBaoSpeed = [[NSUserDefaults standardUserDefaults] integerForKey:@"isBoBaoSpeed"];
    NSInteger isBoBaoLiDu = [[NSUserDefaults standardUserDefaults] integerForKey:@"isBoBaoLiDu"];
    NSInteger isBoBaoJiQiuType = [[NSUserDefaults standardUserDefaults] integerForKey:@"isBoBaoJiQiuType"];
    if ((isBoBaoSpeed == 1) && (isBoBaoLiDu == 1) && (isBoBaoJiQiuType == 1)) {
        [defualts setInteger:1 forKey:@"set_sound"] ;
        [self.soundButton setImage:[UIImage imageNamedFromCustomBundle:@"sounds_off"] forState:UIControlStateNormal];
    } else {
        [defualts setInteger:0 forKey:@"set_sound"] ;
        [self.soundButton setImage:[UIImage imageNamedFromCustomBundle:@"sounds_on"] forState:UIControlStateNormal];
    }
    _selectMenuView.hidden = YES;
    [_selectMenuView.tableView reloadData];
}


-(NSInteger)numberOfSectionsInSelectMenuView {
    return 1;
}

-(NSInteger)numberOfRowsInSectionOfSelectMenuView:(NSInteger)section{
    return _dataListOfSound.count;
}

- (NSString*)textOfCellForRowOfSelectMenuViewAtIndexPath:(NSIndexPath *)indexPath{
    return _dataListOfSound[indexPath.row];
}

-(void)selectMenuView:(UITableViewCell*)cell WillDisplayCellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row==1) {
        if ([[NSUserDefaults standardUserDefaults] integerForKey:@"isBoBaoSpeed"] == 0) {
            ((UIImageView*)cell.accessoryView).image = [UIImage imageNamedFromCustomBundle:@"YES"];
        } else {
            ((UIImageView*)cell.accessoryView).image = [UIImage imageNamedFromCustomBundle:@"NO"];
        }
    }
    if (indexPath.row == 2) {
        if ([[NSUserDefaults standardUserDefaults] integerForKey:@"isBoBaoLiDu"] == 0) {
            ((UIImageView*)cell.accessoryView).image = [UIImage imageNamedFromCustomBundle:@"YES"];
        } else {
            ((UIImageView*)cell.accessoryView).image = [UIImage imageNamedFromCustomBundle:@"NO"];
        }
    }
    if (indexPath.row == 3) {
        if ([[NSUserDefaults standardUserDefaults] integerForKey:@"isBoBaoJiQiuType"] == 0) {
            ((UIImageView*)cell.accessoryView).image = [UIImage imageNamedFromCustomBundle:@"YES"];
        } else {
            ((UIImageView*)cell.accessoryView).image = [UIImage imageNamedFromCustomBundle:@"NO"];
        }
    }
}

-(void)didSelectRowOfSelectMenuViewAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell = [_selectMenuView.tableView cellForRowAtIndexPath:indexPath];
    NSUserDefaults *defualts = [NSUserDefaults standardUserDefaults];
    NSInteger isBoBaoSpeed = [[NSUserDefaults standardUserDefaults] integerForKey:@"isBoBaoSpeed"];
    NSInteger isBoBaoLiDu = [[NSUserDefaults standardUserDefaults] integerForKey:@"isBoBaoLiDu"];
    NSInteger isBoBaoJiQiuType = [[NSUserDefaults standardUserDefaults] integerForKey:@"isBoBaoJiQiuType"];
    if (indexPath.row==1) {
        
        if (isBoBaoSpeed == 0) {
            [defualts setInteger:1 forKey:@"isBoBaoSpeed"];
            ((UIImageView*)cell.accessoryView).image = [UIImage imageNamedFromCustomBundle:@"NO"];
        } else {
            [defualts setInteger:0 forKey:@"isBoBaoSpeed"];
            ((UIImageView*)cell.accessoryView).image = [UIImage imageNamedFromCustomBundle:@"YES"];
        }
    }
    if (indexPath.row == 2) {
        if (isBoBaoLiDu == 0) {
            [defualts setInteger:1 forKey:@"isBoBaoLiDu"];
            ((UIImageView*)cell.accessoryView).image = [UIImage imageNamedFromCustomBundle:@"NO"];
        } else {
            [defualts setInteger:0 forKey:@"isBoBaoLiDu"];
            ((UIImageView*)cell.accessoryView).image = [UIImage imageNamedFromCustomBundle:@"YES"];
        }
    }
    if (indexPath.row == 3) {
        if (isBoBaoJiQiuType == 0) {
            [defualts setInteger:1 forKey:@"isBoBaoJiQiuType"];
            ((UIImageView*)cell.accessoryView).image = [UIImage imageNamedFromCustomBundle:@"NO"];
        } else {
            [defualts setInteger:0 forKey:@"isBoBaoJiQiuType"];
            ((UIImageView*)cell.accessoryView).image = [UIImage imageNamedFromCustomBundle:@"YES"];
        }
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
