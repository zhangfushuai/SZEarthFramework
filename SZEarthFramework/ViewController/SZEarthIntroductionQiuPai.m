//
//  IntroductionQiuPai.m
//  exampleSDK
//
//  Created by Earth on 16/3/3.
//  Copyright © 2016年 Earth. All rights reserved.
//

#import "SZEarthIntroductionQiuPai.h"
#import "UIImage+SZEarth_UIImage.h"
#import "SZEarthViewController.h"
@implementation SZEarthIntroductionQiuPai

-(void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"智能羽毛球拍";
    self.view.backgroundColor = [UIColor colorWithRed:245/255.0 green:245/255.0 blue:245/255.0 alpha:1.0];
    
    _BluetoothList = [[NSMutableArray alloc]init];
    
    _topBackgroundView = [[UIView alloc] initWithFrame:CGRectMake(0, -20, self.view.frame.size.width, self.view.frame.size.height*0.56)];
    _portraitImageView = [[UIImageView alloc]initWithFrame:CGRectMake(self.view.center.x-self.view.frame.size.width*0.4/2, self.view.frame.size.height*0.2, self.view.frame.size.width*0.4, self.view.frame.size.width*0.4)];
    _portraitImageView.image = [UIImage imageNamedFromCustomBundle:@"qiupai"];
    
    _IntroductionLabel = [[UILabel alloc]initWithFrame:CGRectMake(self.view.center.x-self.view.frame.size.width/2, self.view.frame.size.height*0.54, self.view.frame.size.width, self.view.frame.size.height*0.05)];
    _IntroductionTextView = [[UITextView alloc]initWithFrame:CGRectMake(self.view.center.x-self.view.frame.size.width/2, self.view.frame.size.height*0.6, self.view.frame.size.width, self.view.frame.size.height*0.28)];
    _searchButton = [[UIButton alloc]initWithFrame:CGRectMake(self.view.center.x-self.view.frame.size.width*0.5/2, self.view.frame.size.height*0.88, self.view.frame.size.width*0.5, self.view.frame.size.height*0.08)];
    _indicatorView = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(_searchButton.frame.size.width - _searchButton.frame.size.height*0.85, _searchButton.frame.size.height*0.5 -_searchButton.frame.size.height*0.8*0.5, _searchButton.frame.size.height*0.8, _searchButton.frame.size.height*0.8)];
    _indicatorView.hidesWhenStopped = YES;
    _indicatorView.color = [UIColor colorWithRed:249/255.0 green:94/255.0 blue:0 alpha:1.0];
    [_searchButton addSubview:_indicatorView];
    
    _searchView = [[SZEarthSearchBluetoothView alloc]initWithFrame:CGRectMake(self.view.center.x-self.view.frame.size.width*0.86/2, self.view.frame.size.height*0.2, self.view.frame.size.width*0.86, self.view.frame.size.height*0.6)];
    _searchView.tableView.delegate = self;
    _searchView.tableView.dataSource = self;
    
    _searchView.hidden = YES;
    
    [_searchView.okButtonView addTarget:self action:@selector(tapOkButton) forControlEvents:UIControlEventTouchDown];
    [_searchView.cancelButtonView addTarget:self action:@selector(tapCancelButton) forControlEvents:UIControlEventTouchDown];
    
    
    [self.view addSubview:_topBackgroundView];
    [self.view addSubview:_portraitImageView];
    [self.view addSubview:_IntroductionLabel];
    [self.view addSubview:_IntroductionTextView];
    [self.view addSubview:_searchButton];
    
    [self.view addSubview:_searchView];
    
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
    
    _topBackgroundView.backgroundColor = [UIColor colorWithRed:249/255.0 green:94/255.0 blue:0 alpha:1.0];
    _portraitImageView.backgroundColor = [UIColor blueColor];
    _portraitImageView.layer.cornerRadius = _portraitImageView.frame.size.height/2.0;
    _portraitImageView.layer.masksToBounds = YES;
    
    _IntroductionLabel.text = @"简介";
    _IntroductionLabel.textColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.7];
    _IntroductionLabel.textAlignment = NSTextAlignmentCenter;
    _IntroductionLabel.font = [UIFont systemFontOfSize:22];
    _IntroductionLabel.backgroundColor = [UIColor clearColor];
    
    _IntroductionTextView.text = @"通过芯片采集运动轨迹进行科学的数据分析，进行针对性的改进和训练；通过分析数据，形成战力值排行榜，一较高下，隔空比武，乐在其中。";
    _IntroductionTextView.backgroundColor = [UIColor clearColor];
//    _IntroductionTextView.textColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.4];
//    _IntroductionTextView.font = [UIFont systemFontOfSize:20];
    _IntroductionTextView.userInteractionEnabled = NO;
    
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineSpacing = 10;// 字体的行间距
    
    NSDictionary *attributes = @{
                                 NSParagraphStyleAttributeName:paragraphStyle,
                                 NSForegroundColorAttributeName: [UIColor colorWithRed:0 green:0 blue:0 alpha:0.4],
                                 NSFontAttributeName: [UIFont systemFontOfSize:18],
                                 
                                 };
    _IntroductionTextView.attributedText = [[NSAttributedString alloc] initWithString:_IntroductionTextView.text attributes:attributes];
    
    [_searchButton setTitle:@"搜索设备" forState:UIControlStateNormal];
    [_searchButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    _searchButton.backgroundColor = [UIColor whiteColor];
    _searchButton.layer.borderColor = [UIColor colorWithWhite:0.94 alpha:0.9].CGColor;
    _searchButton.layer.borderWidth = 1;
    _searchButton.layer.cornerRadius = _searchButton.frame.size.height/2.0;
    _searchButton.layer.masksToBounds = YES;
    [_searchButton addTarget:self action:@selector(startSearchBluetooth) forControlEvents:UIControlEventTouchDown];
    
    if (_currentPeripheral && _currentPeripheral.peripheral.state == CBPeripheralStateConnected) {
        _searchView.backgroundImageView.image = [UIImage imageNamedFromCustomBundle:@"连接设备"];
    } else {
        _searchView.backgroundImageView.image = [UIImage imageNamedFromCustomBundle:@"连接失败"];
    }
}

-(void)tapOkButton {
    if ([_searchView.okButtonView.titleLabel.text isEqualToString:@"立即绑定"]) {
        if (_selectedIndexPath) {
            [_cm connectPeripheral:((SZEarthUARTPeripheral*)_BluetoothList[_selectedIndexPath.row]).peripheral options:@{CBConnectPeripheralOptionNotifyOnNotificationKey: [NSNumber numberWithBool:YES]}];
            _currentPeripheral = (SZEarthUARTPeripheral*)_BluetoothList[_selectedIndexPath.row];
            [_currentPeripheral didConnect];
            [[NSUserDefaults standardUserDefaults] setObject:_currentPeripheral.peripheral.identifier.UUIDString forKey:@"perihperalUUIDString"];
            
            
        }
        _searchView.hidden = YES;
        [_BluetoothList removeAllObjects];
        [_indicatorView stopAnimating];
        [_searchView.tableView reloadData];
        
        dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC));
        
        dispatch_after(delayTime, dispatch_get_main_queue(), ^{
            if (_currentPeripheral && _currentPeripheral.peripheral.state == CBPeripheralStateConnected) {
                _searchView.backgroundImageView.image = [UIImage imageNamedFromCustomBundle:@"连接设备"];
                NSInteger i = self.navigationController.viewControllers.count-1;
                while (i>=0) {
                    if ([[self.navigationController.viewControllers objectAtIndex:i] isKindOfClass:[SZEarthViewController class]]) {
                        [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:i] animated:YES];
                    }
                    i--;
                }
            } else {
                _searchView.backgroundImageView.image = [UIImage imageNamedFromCustomBundle:@"连接失败"];
            }
        });
        
    } else {
        [_indicatorView startAnimating];
        [_cm scanForPeripheralsWithServices:@[[SZEarthUARTPeripheral uartServiceUUID]] options:@{CBCentralManagerScanOptionAllowDuplicatesKey: [NSNumber numberWithBool:NO]}];
    }
    
}

-(void)showSearchView {
    if (_BluetoothList.count==0 && _searchView.hidden) {
        _searchView.hidden = NO;
        [_indicatorView stopAnimating];
        _searchView.backgroundImageView.image = [UIImage imageNamedFromCustomBundle:@"连接失败"];
        [_searchView.okButtonView setTitle:@"重新搜索" forState:UIControlStateNormal];
        [_cm stopScan];
    }
    [_timer setFireDate:[NSDate distantFuture]];
}

-(void)tapCancelButton {
    [_indicatorView stopAnimating];
    _searchView.hidden = YES;
    [_BluetoothList removeAllObjects];
    [_searchView.tableView reloadData];
}

-(void)startSearchBluetooth {
    
    if (_searchView.hidden) {
        [_indicatorView startAnimating];
        [_BluetoothList removeAllObjects];
        [_cm scanForPeripheralsWithServices:@[[SZEarthUARTPeripheral uartServiceUUID]] options:@{CBCentralManagerScanOptionAllowDuplicatesKey: [NSNumber numberWithBool:NO]}];
        
    }
    //定时器
    _timer = [NSTimer scheduledTimerWithTimeInterval:15 target:self selector:@selector(showSearchView) userInfo:nil repeats:YES];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (_BluetoothList.count==0) {
        return 2;
    }
    return _BluetoothList.count+1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

//-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
//    return 20;
//}

//-(NSString*)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
//    NSString *title = @"";
//    if (section == 0) {
//        title = @"";
//    } else {
//        title = _tableTitle[section-1];
//    }
//    return title;
//}


-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.1;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *reuseID = @"CellID";
    UITableViewCell *cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseID];
    if (indexPath.section == 0) {
        if (_BluetoothList.count==0) {
            cell.textLabel.text = @"羽毛球拍可能没电或不在附近";
        } else {
            cell.textLabel.text = @"选择设备";
            
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    } else if (indexPath.section == 1) {
        if (_BluetoothList.count==0) {
            cell.textLabel.text = @"无法找到羽毛球拍";
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        } else {
            NSString *name = ((SZEarthUARTPeripheral*)_BluetoothList[indexPath.section-1]).peripheral.name;
            if (name) {
                cell.textLabel.text = name;
            } else {
                cell.textLabel.text = ((SZEarthUARTPeripheral*)_BluetoothList[indexPath.section-1]).peripheral.identifier.UUIDString;
            }
        }
    } else {
        NSString *name = ((SZEarthUARTPeripheral*)_BluetoothList[indexPath.section-1]).peripheral.name;
        if (name) {
            cell.textLabel.text = name;
        } else {
            cell.textLabel.text = ((SZEarthUARTPeripheral*)_BluetoothList[indexPath.section-1]).peripheral.identifier.UUIDString;
        }
    }
    cell.textLabel.adjustsFontSizeToFitWidth = YES;
    cell.textLabel.textAlignment = NSTextAlignmentCenter;
    cell.backgroundColor = [UIColor clearColor];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section!=0) {
        if (_BluetoothList.count!=0) {
            _selectedIndexPath = indexPath;
        }
    }
    
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
