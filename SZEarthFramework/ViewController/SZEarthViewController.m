//
//  SZEarthViewController.m
//  SZEarthSDK
//
//  Created by Earth on 16/3/2.
//  Copyright © 2016年 Earth. All rights reserved.
//

#import "SZEarthViewController.h"

#import "SZEarthCustomSegmentedView.h"
#import "SZEarthSettingsViewController.h"
#import "SZEarthScoreDetailTableViewController.h"
#import "SZEarthUARTPeripheral.h"
#import "SZEarthResolveBluetooth.h"
#import "SZEarthMy_DB.h"
#import "SZEarthMySound.h"
#import "SZEarthHttpHead.h"
#import "SZEarthCirclePercentView.h"
#import "SZEarthFillInTheInformation.h"
#import <CoreBluetooth/CoreBluetooth.h>
#import "UIImage+SZEarth_UIImage.h"


SZEarthResolveBluetooth *resolveBluetooth;

SZEarthMy_DB *mydb;

@interface SZEarthViewController ()<CBCentralManagerDelegate, SZEarthUARTPeripheralDelegate>

@property int ball_num; //挥拍次数

@property int started;//球场模式开始状态
@property int set_sound; //声音是否开启

@property BOOL isCurrentViewController;

@property BOOL is_bobao_end;

@property NSTimer *myTimer;
@property int miao_count;
@property int fen_count;
@property int shi_count;

@property CBCentralManager *cm;
@property SZEarthUARTPeripheral *currentPeripheral;
@property (strong,nonatomic) SZEarthIntroductionQiuPai *IntroductionVC;
@property (strong,nonatomic) SZEarthSettingsViewController *settingsVC;
@property (strong,nonatomic) SZEarthCalendarViewController *calendarVC;
@property (strong,nonatomic) SZEarthScoreDetailTableViewController *scoreDetailVC;
@property (strong, nonatomic) SZEarthHttpHead *httpHead;
@property (strong, nonatomic) SZEarthCirclePercentView *circlePercenViewOfSpeed;
@property (strong, nonatomic) SZEarthCirclePercentView *circlePercenViewOfLidu;

@property NSString *userEmail;

@property NSString *ConnectionStateString;


@end


typedef enum
{
    IDLE = 0,
    SCANNING,
    CONNECTED,
    SWITCHING,
} ConnectionState;

typedef enum
{
    LOGGING,  //版本号信息
    RX,     //读取蓝牙数据
    TX,     //向蓝牙写入数据
} ConsoleDataType;

@implementation SZEarthViewController

@synthesize cm = _cm;
@synthesize currentPeripheral = _currentPeripheral;
@synthesize httpHead = _httpHead;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _userEmail = [[NSUserDefaults standardUserDefaults]objectForKey:@"SZEarthUserEmail"];
    
    strcpy(my_char_email, [_userEmail UTF8String]);//存用户信息
    
    _started = 0;
    
    _is_bobao_end = YES;
    
    self.qiuChangDatas = [[NSMutableArray alloc]init];
    _unSendArray = [[NSMutableArray alloc]init];
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"unSendArray"]) {
        _unSendArray = (NSMutableArray*)[[NSUserDefaults standardUserDefaults] objectForKey:@"unSendArray"];
    }
    
    if (_unSendArray) {
        //
        NSString *currentDateStr = [self currentDate];
        _httpHead = [[SZEarthHttpHead alloc]initWithValid:[NSString stringWithFormat:@"%@%@%@",currentDateStr,_userEmail,[[NSUserDefaults standardUserDefaults] objectForKey:@"user_password"]] andID:[[NSNumber alloc]initWithInt:-1] Length:[[NSNumber alloc]initWithInteger:_unSendArray.count] error:[[NSNumber alloc]initWithInt:0]];
        
        NSURL *url = [[NSURL alloc]initWithString:[NSString stringWithFormat: @"%@SZearth/servlet/Updata", httpPort]];
        //加密
        NSData *ValidData = [_httpHead.valid dataUsingEncoding:NSUTF8StringEncoding];
        _httpHead.valid = [ValidData base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
        
        NSDictionary *headDictionary = @{@"valid":_httpHead.valid, @"length": _httpHead.length, @"error": _httpHead.error, @"id": _httpHead.ID};
        
        NSDictionary *dictionary = @{@"head": headDictionary, @"body" : _unSendArray};
        
        if ([NSJSONSerialization isValidJSONObject:dictionary]) {
            NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dictionary options:NSJSONWritingPrettyPrinted error:nil];
            NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url];
            [request setHTTPMethod:@"POST"];
            [[[NSURLSession sharedSession] uploadTaskWithRequest:request fromData:jsonData completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
                
                if (error) {
                    [[NSUserDefaults standardUserDefaults] setObject:_unSendArray forKey:@"unSendArray"];
                } else {
                    [_unSendArray removeAllObjects];
                }
                
            }] resume];
        }
    }
    
    _bluetoothList = [[NSMutableArray alloc]init];
    
    //定时器
    _myTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timeFireMethod) userInfo:nil repeats:YES];
    [_myTimer setFireDate:[NSDate distantFuture]];
    
    //蓝牙
    _cm = [[CBCentralManager alloc] initWithDelegate:self queue:dispatch_get_main_queue()];
    resolveBluetooth = [[SZEarthResolveBluetooth alloc] init];
    mydb = [[SZEarthMy_DB alloc] init];
    
    //设置导航条标题为白色字体
    [self.navigationController.navigationBar setTitleTextAttributes: [NSDictionary dictionaryWithObjectsAndKeys:[UIColor colorWithRed:245.0/255.0 green:245.0/255.0 blue:245.0/255.0 alpha:1.0], NSForegroundColorAttributeName, nil]];
    
    [self createView];
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    _isBackToLastVC = YES; //返回前一个界面
    
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamedFromCustomBundle:@"导航条"] forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.translucent = YES;
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    _isCurrentViewController = YES;
    
    if (_currentPeripheral && _currentPeripheral.peripheral.state == CBPeripheralStateConnected) {
        _ConnectionStateString =  @"已连接";
    } else {
        _ConnectionStateString =  @"未连接";
        
    }
    self.navigationItem.title = _ConnectionStateString;
    
    if (!_isExistUser) {
        
        SZEarthFillInTheInformation *fillInTheInformationVC = [[SZEarthFillInTheInformation alloc]initWithStyle:UITableViewStylePlain];
        
        [self showViewController:fillInTheInformationVC sender:self];
        _isExistUser = YES;
    }
    
}

-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    _IntroductionVC = [[SZEarthIntroductionQiuPai alloc]init];
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
    layout.headerReferenceSize = CGSizeMake(self.view.frame.size.width, 40);
    _calendarVC = [[SZEarthCalendarViewController alloc]initWithCollectionViewLayout:layout];
    
    _settingsVC = [[SZEarthSettingsViewController alloc]init];
    
    _scoreDetailVC = [[SZEarthScoreDetailTableViewController alloc]init];
    
    [_viewMoreBT addTarget:self action:@selector(tapViewMoreButton) forControlEvents:UIControlEventTouchDown];
    
}

-(void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self tapView];
    self.navigationItem.title = @"";
    
}

-(void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    _isCurrentViewController = NO;
    
    if (_isBackToLastVC) {
        if (_currentPeripheral && _currentPeripheral.peripheral.state == CBPeripheralStateConnected) {
            [_cm cancelPeripheralConnection:_currentPeripheral.peripheral];
        }
        _currentPeripheral = nil;
        [_cm stopScan];
    }
    
}

-(void)backToTopView {
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}

-(void)createView {
    
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    
    self.view.backgroundColor = [UIColor whiteColor];
    if (_hasNavigationBar) {
        
    } else {
        UIBarButtonItem *leftButton = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamedFromCustomBundle:@"向前"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(backToTopView)];
        self.navigationItem.leftBarButtonItem = leftButton;
    }
    
    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamedFromCustomBundle:@"更多"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal ] style:UIBarButtonItemStylePlain target:self action:@selector(touchRightButton)];
    self.navigationItem.rightBarButtonItem = rightButton;
    
    //圆弧
    if ([UIScreen mainScreen].bounds.size.height < 568) {
        
        _circlePercenViewOfSpeed = [[SZEarthCirclePercentView alloc]initWithFrame:CGRectMake(self.view.center.x-self.view.frame.size.width*0.4/2, self.view.center.y*0.5*0.635, self.view.frame.size.width*0.4, self.view.frame.size.width*0.4)];
        _circlePercenViewOfLidu = [[SZEarthCirclePercentView alloc]initWithFrame:CGRectMake(self.view.center.x-self.view.frame.size.width*0.4/2, self.view.center.y*0.5*0.63, self.view.frame.size.width*0.4, self.view.frame.size.width*0.4)];
    } else {
        
        _circlePercenViewOfSpeed = [[SZEarthCirclePercentView alloc]initWithFrame:CGRectMake(self.view.center.x*0.50, self.view.center.y*0.5*0.685, self.view.frame.size.width*0.5, self.view.frame.size.width*0.5)];
        _circlePercenViewOfLidu = [[SZEarthCirclePercentView alloc]initWithFrame:CGRectMake(self.view.center.x*0.50, self.view.center.y*0.5*0.68, self.view.frame.size.width*0.5, self.view.frame.size.width*0.5)];
    }
    
    _circleImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamedFromCustomBundle:@"单次圆"]];
    
    _dataList = [NSArray arrayWithObjects:@"更换设备", @"解除绑定", @"历史数据", @"设置", nil];
    _menuTableView = [[UITableView alloc]initWithFrame:CGRectMake(self.view.frame.size.width - 5 - self.view.frame.size.width * 0.48, self.navigationController.navigationBar.frame.size.height+20, self.view.frame.size.width * 0.48, self.view.frame.size.width * 0.5) style:UITableViewStylePlain];
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
    
    _indicatorImageView = [[UIImageView alloc]initWithFrame:CGRectMake(self.view.frame.size.width - 46, 47, 36, 26)];
    _indicatorImageView.image = [UIImage imageNamedFromCustomBundle:@"多边形"];
    _indicatorImageView.hidden = YES;
    _indicatorImageView.tag = 888;
    [self.navigationController.view insertSubview:_indicatorImageView aboveSubview:self.navigationController.navigationBar];
    
    _backgroundViewButton = [[UIButton alloc]initWithFrame:self.view.frame];
    [_backgroundViewButton addTarget:self action:@selector(tapView) forControlEvents:UIControlEventTouchDown];
    _backgroundViewButton.hidden = YES;
    
    
    
    _mainImageView = [[UIImageView alloc]initWithFrame:CGRectMake(self.view.center.x-70, 80, 140, 140)];
    _mainImageView.image = [UIImage imageNamedFromCustomBundle:@"LOGO"];
    
    _jiShiImageView = [[UIImageView alloc]initWithFrame:CGRectMake(self.view.center.x-70, 80, 140, 140)];
    _jiShiImageView.image = [UIImage imageNamedFromCustomBundle:@"计时器"];
    
    _speedImageView = [[UIImageView alloc]initWithFrame:CGRectMake(60, 440, 80, 20)];
    _speedImageView.image = [UIImage imageNamedFromCustomBundle:@"速度标注"];
    _speedLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 220, 100, 30)];
    _speedLabel.text = @"速度km/h";
    _speedLabel.textColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.7];
    _speedLabel.font = [UIFont systemFontOfSize:15];
    
    _liDuImageView = [[UIImageView alloc]initWithFrame:CGRectMake(60, 440, 80, 20)];
    _liDuImageView.image = [UIImage imageNamedFromCustomBundle:@"力度标注"];
    _liDuLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 250, 100, 30)];
    _liDuLabel.text = @"力度N";
    _liDuLabel.textColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.7];
    _liDuLabel.font = [UIFont systemFontOfSize:15];
    
    _wanYiBaLabel = [[UILabel alloc]init];
    _wanYiBaLabel.text = @"玩一把?";
    _wanYiBaLabel.textColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
    _startButtonTiShiLabel = [[UILabel alloc]init];
    _startButtonTiShiLabel.text = @"按橙色按钮启动打球模式";
    _startButtonTiShiLabel.textColor = [UIColor colorWithRed:249/255.0 green:94/255.0 blue:0 alpha:1.0];
    
    _currentSpeed = [[UILabel alloc]init];
    _currentSpeed.textAlignment = NSTextAlignmentCenter;
    _currentLiDu = [[UILabel alloc]init];
    _currentLiDu.textAlignment = NSTextAlignmentCenter;
    
    _qiuChangSegment = [[SZEarthCustomSegmentedView alloc]initWithFrame:CGRectMake(self.view.center.x - self.view.frame.size.width * 0.7 / 2, self.view.frame.origin.y+ 10, self.view.frame.size.width * 0.7, 30) andItems:[NSArray arrayWithObjects:@"单次模式",@"球场模式", nil]];
    [_qiuChangSegment addTarget:self action:@selector(tapQiuChangModeSegment:) forControlEvents:UIControlEventValueChanged];
    
    _bottomView = [[UIView alloc]init];
    _bottomView.backgroundColor = [UIColor colorWithWhite:0.94 alpha:0.8];
    
    _scoreLabel = [[UILabel alloc]init];
    _scoreLabel.textAlignment = NSTextAlignmentCenter;
    _scoreLabel.textColor = [UIColor colorWithRed:249/255.0 green:94/255.0 blue:0 alpha:1.0];
    
    _jiQiuLeiXingLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 250, 100, 30)];
    _jiQiuLeiXingLabel.text = @"击球类型";
    _jiQiuLeiXingLabel.textColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.7];
    _jiQiuLeiXingValue = [[UILabel alloc]initWithFrame:CGRectMake(60, 400, 80, 20)];
    _jiQiuLeiXingValue.text = @"空挥";
    _jiQiuLeiXingValue.textColor = [UIColor colorWithRed:249/255.0 green:94/255.0 blue:0 alpha:1.0];
    
    _huiPaiPingJiaLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 250, 100, 30)];
    _huiPaiPingJiaLabel.text = @"挥拍评价";
    _huiPaiPingJiaLabel.textColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.7];
    _huiPaiPingJiaImageView = [[UIImageView alloc]initWithFrame:CGRectMake(200, 400, 80, 20)];
    _huiPaiPingJiaImageView.image = [UIImage imageNamedFromCustomBundle:@"0"];
    
    _baoFaLiLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 250, 100, 30)];
    _baoFaLiLabel.text = @"爆发力";
    _baoFaLiLabel.textColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.7];
    _baoFaLiImageView = [[UIImageView alloc]initWithFrame:CGRectMake(60, 440, 80, 20)];
    _baoFaLiImageView.image = [UIImage imageNamedFromCustomBundle:@"0"];
    
    _faLiShiJiLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 250, 100, 30)];
    _faLiShiJiLabel.text = @"发力时机";
    _faLiShiJiLabel.textColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.7];
    _faLiShiJiImageView = [[UIImageView alloc]initWithFrame:CGRectMake(200, 440, 80, 20)];
    _faLiShiJiImageView.image = [UIImage imageNamedFromCustomBundle:@"0"];
    
    _jiShiLabel = [[UILabel alloc]init];
    _jiShiLabel.text = @"00:00:00";
    _jiShiLabel.adjustsFontSizeToFitWidth = YES;
    _jiShiLabel.textAlignment = NSTextAlignmentCenter;
    
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@", _jiShiLabel.text]];
    [str addAttribute:NSFontAttributeName value:[UIFont boldSystemFontOfSize:24] range:NSMakeRange(0,str.length)];
    [str addAttribute:NSFontAttributeName value:[UIFont boldSystemFontOfSize:14] range:NSMakeRange(2,str.length-2)];
    _jiShiLabel.attributedText = str;
    
    _jiShiDanWeiLabel = [[UILabel alloc]init];
    _jiShiDanWeiLabel.text = @"h";
    _jiShiDanWeiLabel.textColor = [UIColor greenColor];
    _jiShiDanWeiLabel.font = [UIFont systemFontOfSize:12];
    _jiShiDanWeiLabel.textAlignment = NSTextAlignmentCenter;
    
    _startPlayImageView = [[UIButton alloc]init];
//    [_startPlayImageView setImage:[UIImage imageNamedFromCustomBundle:@"开始"] forState:UIControlStateNormal] ;
    [_startPlayImageView setImage:[UIImage imageNamedFromCustomBundle:@"btn_start"] forState:UIControlStateNormal] ;
    _startPlayImageView.userInteractionEnabled = YES;
    [_startPlayImageView addTarget:self action:@selector(tapStartBt) forControlEvents:UIControlEventTouchDown];
    
    _bottomImageView = [[UIImageView alloc]init];
    _bottomImageView.image = [UIImage imageNamedFromCustomBundle:@"下栏"];
    
    _zhengShouLabel = [[UILabel alloc]init];
    _zhengShouLabel.text = @"正手";
    _zhengShouLabel.textColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.3];
    _zhengShouLabel.textAlignment = NSTextAlignmentCenter;
    _zhengShouValue = [[UILabel alloc]init];
    _zhengShouValue.text = @"0次";
    _zhengShouValue.textAlignment = NSTextAlignmentCenter;
    _zhengShouValue.textColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.6];
    
    _fanShouLabel = [[UILabel alloc]init];
    _fanShouLabel.text = @"反手";
    _fanShouLabel.textAlignment = NSTextAlignmentCenter;
    _fanShouLabel.textColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.3];
    _fanShouValue = [[UILabel alloc]init];
    _fanShouValue.text = @"0次";
    _fanShouValue.textAlignment = NSTextAlignmentCenter;
    _fanShouValue.textColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.6];
    
    _shiJianLabel = [[UILabel alloc]init];
    _shiJianLabel.text = @"时间";
    _shiJianLabel.textAlignment = NSTextAlignmentCenter;
    _shiJianLabel.textColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.3];
    _shiJianValue = [[UILabel alloc]init];
    _shiJianValue.text = @"00:00:00h";
    _shiJianValue.textAlignment = NSTextAlignmentCenter;
    _shiJianValue.textColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.6];
    
    _CaloriesLabel = [[UILabel alloc]init];
    _CaloriesLabel.text = @"大卡";
    _CaloriesLabel.textAlignment = NSTextAlignmentCenter;
    _CaloriesLabel.textColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.3];
    _CaloriesValue = [[UILabel alloc]init];
    _CaloriesValue.text = @"0";
    _CaloriesValue.textAlignment = NSTextAlignmentCenter;
    _CaloriesValue.textColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.6];
    
    _averageSpeedLabel = [[UILabel alloc]init];
    _averageSpeedLabel.text = @"平均速度";
    _averageSpeedLabel.textColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.7];
    _averageSpeedLabel.textAlignment = NSTextAlignmentCenter;
    _averageSpeedValue = [[UILabel alloc]init];
    _averageSpeedValue.text = @"0km/h";
    _averageSpeedValue.textAlignment = NSTextAlignmentCenter;
    NSMutableAttributedString *averageSpeedstr = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@", _averageSpeedValue.text]];
    [averageSpeedstr addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:249/255.0 green:94/255.0 blue:0 alpha:1.0] range:NSMakeRange(0,averageSpeedstr.length)];
    [averageSpeedstr addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.3] range:NSMakeRange(averageSpeedstr.length-4,4)];
    _averageSpeedValue.attributedText = averageSpeedstr;
    
    _averageLiDULabel = [[UILabel alloc]init];
    _averageLiDULabel.text = @"平均力度";
    _averageLiDULabel.textColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.7];
    _averageLiDULabel.textAlignment = NSTextAlignmentCenter;
    _averageLiDUValue = [[UILabel alloc]init];
    _averageLiDUValue.text = @"0N";
    _averageLiDUValue.textAlignment = NSTextAlignmentCenter;
    NSMutableAttributedString *averageLiDUstr = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@", _averageLiDUValue.text]];
    [averageLiDUstr addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:249/255.0 green:94/255.0 blue:0 alpha:1.0] range:NSMakeRange(0,averageLiDUstr.length)];
    [averageLiDUstr addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.3] range:NSMakeRange(averageLiDUstr.length-1,1)];
    _averageLiDUValue.attributedText = averageLiDUstr;
    
    _maxSpeedLabel = [[UILabel alloc]init];
    _maxSpeedLabel.text = @"最大速度";
    _maxSpeedLabel.textColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.7];
    _maxSpeedLabel.textAlignment = NSTextAlignmentCenter;
    _maxSpeedValue = [[UILabel alloc]init];
    _maxSpeedValue.text = @"0km/h";
    _maxSpeedValue.textAlignment = NSTextAlignmentCenter;
    NSMutableAttributedString *maxSpeedstr = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@", _maxSpeedValue.text]];
    [maxSpeedstr addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:249/255.0 green:94/255.0 blue:0 alpha:1.0] range:NSMakeRange(0,maxSpeedstr.length)];
    [maxSpeedstr addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.3] range:NSMakeRange(maxSpeedstr.length-4,4)];
    _maxSpeedValue.attributedText = maxSpeedstr;
    
    _maxLiDULabel = [[UILabel alloc]init];
    _maxLiDULabel.text = @"最大力度";
    _maxLiDULabel.textColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.7];
    _maxLiDULabel.textAlignment = NSTextAlignmentCenter;
    _maxLiDUValue = [[UILabel alloc]init];
    _maxLiDUValue.text = @"0N";
    _maxLiDUValue.textAlignment = NSTextAlignmentCenter;
    NSMutableAttributedString *maxLiDUstr = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@", _maxLiDUValue.text]];
    [maxLiDUstr addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:249/255.0 green:94/255.0 blue:0 alpha:1.0] range:NSMakeRange(0,maxLiDUstr.length)];
    [maxLiDUstr addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.3] range:NSMakeRange(maxLiDUstr.length-1,1)];
    _maxLiDUValue.attributedText = maxLiDUstr;
    
    _viewMoreBT = [[UIButton alloc]init];
    [_viewMoreBT setTitle:@"查看更多" forState:UIControlStateNormal];
    _viewMoreBT.titleLabel.adjustsFontSizeToFitWidth = YES;
    _viewMoreBT.backgroundColor = [UIColor colorWithRed:249/255.0 green:94/255.0 blue:0 alpha:1.0];
    
    [self.view addSubview:_mainImageView];
    [self.view addSubview:_jiShiImageView];
    [self.view addSubview:_circlePercenViewOfSpeed];
    [self.view addSubview:_circlePercenViewOfLidu];
    [self.view addSubview:_circleImageView];
    [self.view addSubview:_speedImageView];
    [self.view addSubview:_speedLabel];
    [self.view addSubview:_liDuImageView];
    [self.view addSubview:_liDuLabel];
    [self.view addSubview:_qiuChangSegment];
    [self.view addSubview:_bottomView];
    [self.view addSubview:_scoreLabel];
    [self.view addSubview:_jiQiuLeiXingLabel];
    [self.view addSubview:_jiQiuLeiXingValue];
    [self.view addSubview:_huiPaiPingJiaLabel];
    [self.view addSubview:_huiPaiPingJiaImageView];
    [self.view addSubview:_baoFaLiLabel];
    [self.view addSubview:_baoFaLiImageView];
    [self.view addSubview:_faLiShiJiLabel];
    [self.view addSubview:_faLiShiJiImageView];
    
    [self.view addSubview:_wanYiBaLabel];
    [self.view addSubview:_startButtonTiShiLabel];
    [self.view addSubview:_currentSpeed];
    [self.view addSubview:_currentLiDu];
    
    [self.view addSubview:_jiShiLabel];
    [self.view addSubview:_jiShiDanWeiLabel];
    [self.view addSubview:_startPlayImageView];
    [self.view addSubview:_bottomImageView];
    
    [self.view addSubview:_zhengShouLabel];
    [self.view addSubview:_zhengShouValue];
    [self.view addSubview:_fanShouLabel];
    [self.view addSubview:_fanShouValue];
    [self.view addSubview:_shiJianLabel];
    [self.view addSubview:_shiJianValue];
    [self.view addSubview:_CaloriesLabel];
    [self.view addSubview:_CaloriesValue];
    
    [self.view addSubview:_averageSpeedLabel];
    [self.view addSubview:_averageSpeedValue];
    [self.view addSubview:_averageLiDULabel];
    [self.view addSubview:_averageLiDUValue];
    [self.view addSubview:_maxSpeedLabel];
    [self.view addSubview:_maxSpeedValue];
    [self.view addSubview:_maxLiDULabel];
    [self.view addSubview:_maxLiDUValue];
    
    [self.view addSubview:_viewMoreBT];
    
    [self.view addSubview:_backgroundViewButton];
    [self.navigationController.view addSubview:_indicatorImageView];
    [self.view addSubview:_menuTableView];
    
    [self layoutView:_wanYiBaLabel multiplierX:0.26 multiplierY:0.63 multiplierWidth:0.22 multiplierHeight:0.06];
    [self layoutView:_startButtonTiShiLabel multiplierX:1.0 multiplierY:0.91 multiplierWidth:0.5 multiplierHeight:0.04];
    [self layoutView:_currentSpeed multiplierX:1.0 multiplierY:0.29 multiplierWidth:0.5 multiplierHeight:0.04];
    [self layoutView:_currentLiDu multiplierX:1.0 multiplierY:0.965 multiplierWidth:0.5 multiplierHeight:0.04];
    
    if ([UIScreen mainScreen].bounds.size.height < 568) {
        [self layoutView:_mainImageView multiplierX:1.0 multiplierY:0.64 multiplierWidth:0.4 multiplierHeight:0.4];
        [self layoutView:_jiShiImageView multiplierX:1.0 multiplierY:0.59 multiplierWidth:0.4 multiplierHeight:0.4];
        [self layoutView:_circleImageView multiplierX:0.635 multiplierY:0.64 multiplierWidth:0.06 multiplierHeight:0.06];
        [self layoutView:_bottomImageView multiplierX:1.0 multiplierY:1.60 multiplierWidth:0.94 multiplierHeight:0.65];
    } else {
        [self layoutView:_mainImageView multiplierX:1.0 multiplierY:0.63 multiplierWidth:0.5 multiplierHeight:0.5];
        [self layoutView:_jiShiImageView multiplierX:1.0 multiplierY:0.58 multiplierWidth:0.5 multiplierHeight:0.5];
        [self layoutView:_circleImageView multiplierX:0.55 multiplierY:0.63 multiplierWidth:0.066 multiplierHeight:0.066];
        [self layoutView:_bottomImageView multiplierX:1.0 multiplierY:1.60 multiplierWidth:0.94 multiplierHeight:0.78];
    }
    
    [self layoutView:_speedImageView multiplierX:0.1 multiplierY:0.88 multiplierWidth:0.06 multiplierHeight:0.06];
    [self layoutView:_speedLabel multiplierX:0.52 multiplierY:0.88 multiplierWidth:0.3 multiplierHeight:0.04];
    
    [self layoutView:_liDuImageView multiplierX:0.1 multiplierY:0.98 multiplierWidth:0.06 multiplierHeight:0.06];
    [self layoutView:_liDuLabel multiplierX:0.52 multiplierY:0.98 multiplierWidth:0.3 multiplierHeight:0.04];
    
    [self layoutView:_qiuChangSegment multiplierX:1.0 multiplierY:1.09 multiplierWidth:0.44 multiplierHeight:0.1];
    
    [self layoutView:_bottomView multiplierX:1.0 multiplierY:1.56 multiplierWidth:0.94 multiplierHeight:0.5];
    [self layoutView:_scoreLabel multiplierX:1.0 multiplierY:1.36 multiplierWidth:1.0 multiplierHeight:0.1];
    [self layoutView:_jiQiuLeiXingLabel multiplierX:0.3 multiplierY:1.46 multiplierWidth:0.2 multiplierHeight:0.1];
    [self layoutView:_jiQiuLeiXingValue multiplierX:0.74 multiplierY:1.46 multiplierWidth:0.2 multiplierHeight:0.1];
    
    [self layoutView:_huiPaiPingJiaLabel multiplierX:1.28 multiplierY:1.46 multiplierWidth:0.2 multiplierHeight:0.1];
    [self layoutView:_huiPaiPingJiaImageView multiplierX:1.7 multiplierY:1.46 multiplierWidth:0.2 multiplierHeight:0.05];
    
    [self layoutView:_baoFaLiLabel multiplierX:0.3 multiplierY:1.66 multiplierWidth:0.2 multiplierHeight:0.1];
    [self layoutView:_baoFaLiImageView multiplierX:0.74 multiplierY:1.66 multiplierWidth:0.2 multiplierHeight:0.05];
    
    [self layoutView:_faLiShiJiLabel multiplierX:1.28 multiplierY:1.66 multiplierWidth:0.2 multiplierHeight:0.1];
    [self layoutView:_faLiShiJiImageView multiplierX:1.7 multiplierY:1.66 multiplierWidth:0.2 multiplierHeight:0.05];
    
    
    [self layoutView:_jiShiLabel multiplierX:1.0 multiplierY:0.58 multiplierWidth:0.25 multiplierHeight:0.1];
    [self layoutView:_jiShiDanWeiLabel multiplierX:1.0 multiplierY:0.54 multiplierWidth:0.05 multiplierHeight:0.03];
    [self layoutView:_startPlayImageView multiplierX:1.60 multiplierY:0.82 multiplierWidth:0.15 multiplierHeight:0.15];
    
    
    [self layoutView:_zhengShouLabel multiplierX:0.3 multiplierY:1.22 multiplierWidth:0.2 multiplierHeight:0.05];
    [self layoutView:_zhengShouValue multiplierX:0.3 multiplierY:1.29 multiplierWidth:0.2 multiplierHeight:0.05];
    
    [self layoutView:_fanShouLabel multiplierX:0.76 multiplierY:1.22 multiplierWidth:0.2 multiplierHeight:0.05];
    [self layoutView:_fanShouValue multiplierX:0.76 multiplierY:1.29 multiplierWidth:0.2 multiplierHeight:0.05];
    
    [self layoutView:_shiJianLabel multiplierX:1.24 multiplierY:1.22 multiplierWidth:0.2 multiplierHeight:0.05];
    [self layoutView:_shiJianValue multiplierX:1.24 multiplierY:1.29 multiplierWidth:0.2 multiplierHeight:0.05];
    
    [self layoutView:_CaloriesLabel multiplierX:1.7 multiplierY:1.22 multiplierWidth:0.2 multiplierHeight:0.05];
    [self layoutView:_CaloriesValue multiplierX:1.7 multiplierY:1.29 multiplierWidth:0.2 multiplierHeight:0.05];
    
    [self layoutView:_averageSpeedLabel multiplierX:1.1 multiplierY:1.49 multiplierWidth:0.2 multiplierHeight:0.06];
    [self layoutView:_averageSpeedValue multiplierX:1.1 multiplierY:1.40 multiplierWidth:0.2 multiplierHeight:0.06];
    
    [self layoutView:_averageLiDULabel multiplierX:1.62 multiplierY:1.49 multiplierWidth:0.2 multiplierHeight:0.06];
    [self layoutView:_averageLiDUValue multiplierX:1.62 multiplierY:1.40 multiplierWidth:0.2 multiplierHeight:0.06];
    
    [self layoutView:_maxSpeedLabel multiplierX:1.1 multiplierY:1.77 multiplierWidth:0.2 multiplierHeight:0.06];
    [self layoutView:_maxSpeedValue multiplierX:1.1 multiplierY:1.68 multiplierWidth:0.2 multiplierHeight:0.06];
    
    [self layoutView:_maxLiDULabel multiplierX:1.62 multiplierY:1.77 multiplierWidth:0.2 multiplierHeight:0.06];
    [self layoutView:_maxLiDUValue multiplierX:1.62 multiplierY:1.68 multiplierWidth:0.2 multiplierHeight:0.06];
    
    [self layoutView:_viewMoreBT multiplierX:1.0 multiplierY:1.93 multiplierWidth:0.2 multiplierHeight:0.08];
    
    //初始时选中第一项
    _qiuChangSegment.selectedSegmentIndex = 0;
    [self showDanCiMdeViewOrNo:YES];
    
}

-(void)touchRightButton {
    if (_menuTableView.hidden == NO) {
        _menuTableView.hidden = YES;
        _indicatorImageView.hidden = YES;
        _backgroundViewButton.hidden = YES;
    } else {
        _menuTableView.hidden = NO;
        _indicatorImageView.hidden = NO;
        _backgroundViewButton.hidden = NO;
    }
    [_menuTableView reloadData];
}

//获取当前时间
-(NSString*)currentDate {
    NSDate *date = [NSDate date];
    NSDateFormatter *dateFormatterOfEnd = [[NSDateFormatter alloc] init];
    [dateFormatterOfEnd setDateFormat:@"yyyy-MM-dd HH:mm:ss"];//@"yyyy-MM-dd HH:mm:ss" 大小写不同
    NSString *currentDateStr = [dateFormatterOfEnd stringFromDate:date];
    return currentDateStr;
}

//开始球场模式
-(void)tapStartBt {
    if (_started != 1) {
        if ([_ConnectionStateString isEqualToString:@"已连接"]) {
            _started = 1; //已启动打球模式
            _startButtonTiShiLabel.text = @"按橙色按钮停止打球模式";
            
            [_startPlayImageView setImage:[UIImage imageNamedFromCustomBundle:@"btn_finsh"] forState:UIControlStateNormal] ;
            
            mydb->game_in.games_email=my_char_email;
            mydb->game_in.games_max_speed=0;
            mydb->game_in.games_max_strength=0;
            mydb->game_in.games_extend1=0;
            mydb->game_in.games_extend2=0;
            mydb->game_in.games_extend3=0;
            mydb->game_in.games_start_time=[SZEarthMy_DB getTime];
            _shi_count = _fen_count = _miao_count = 0;//60秒倒计时
            [_myTimer setFireDate:[NSDate distantPast]];
        }
    } else { //结束打球模式
        _startButtonTiShiLabel.text = @"按橙色按钮启动打球模式";
        [_startPlayImageView setImage:[UIImage imageNamedFromCustomBundle:@"btn_start"] forState:UIControlStateNormal] ;
        //结束时间
        mydb->game_in.games_end_time=[SZEarthMy_DB getTime];
        
        float calories = 0;
        int zhengShouCount=0;
        int fanShouCount=0;
        float lidu = 0;
        float speed = 0;
        for (int i = 0; i<_qiuChangDatas.count; i++) {
            if ([[_qiuChangDatas[i] objectForKey:@"ball_back_hand"] integerValue] ==3) {
                zhengShouCount++;
            }
            if ([[_qiuChangDatas[i] objectForKey:@"ball_back_hand"] integerValue] ==2) {
                fanShouCount++;
            }
            calories += [[_qiuChangDatas[i] objectForKey:@"ball_kaluli"] floatValue];
            speed += [[_qiuChangDatas[i] objectForKey:@"ball_maxspeed"] floatValue];
            lidu += [[_qiuChangDatas[i] objectForKey:@"ball_maxstrength"] floatValue];
        
        }
        
        int zsGaoWeiJiQiuCount=0;
        int fsGaoWeiJiQiuCount=0;
        int zsCuoQiuTotalCount=0;
        int fsCuoQiuTotalCount=0;
        int zsTuiQiuTotalCount=0;
        int fsTuiQiuTotalCount=0;
        int zsTiaoQiuTotalCount=0;
        int fsTiaoQiuTotalCount=0;
        int zsDiaoQiuTotalCount=0;
        int fsDiaoQiuTotalCount=0;
        
        _zsGaoWeiJiQiuScore=0;
        _fsGaoWeiJiQiuScore=0;
        _zsCuoQiuTotalScore=0;
        _fsCuoQiuTotalScore=0;
        _zsTuiQiuTotalScore=0;
        _fsTuiQiuTotalScore=0;
        _zsTiaoQiuTotalScore=0;
        _fsTiaoQiuTotalScore=0;
        _zsDiaoQiuTotalScore=0;

        
        _gaoWeiJiQiuTotalSccore =0;
        _cuoQiuTotalSccore = 0;
        _tiaoQiuTotalSccore = 0;
        _diaoQiuTotalSccore = 0;
        _tuiQiuTotalSccore = 0;
        
        
        for (int i = 0; i<_qiuChangDatas.count; i++) {
            if ([[_qiuChangDatas[i] objectForKey:@"ball_stye"] integerValue] ==1 || [[_qiuChangDatas[i] objectForKey:@"ball_stye"] integerValue] == 2) {
                _gaoWeiJiQiuTotalSccore += [[_qiuChangDatas[i] objectForKey:@"ball_score"] integerValue];
                if ([[_qiuChangDatas[i] objectForKey:@"ball_back_hand"] integerValue] ==2) {
                    fsGaoWeiJiQiuCount++;
                    _fsGaoWeiJiQiuScore += [[_qiuChangDatas[i] objectForKey:@"ball_score"] integerValue];
                }
                if ([[_qiuChangDatas[i] objectForKey:@"ball_back_hand"] integerValue] ==3) {
                    zsGaoWeiJiQiuCount++;
                    _zsGaoWeiJiQiuScore += [[_qiuChangDatas[i] objectForKey:@"ball_score"] integerValue];
                }
            }
            if ([[_qiuChangDatas[i] objectForKey:@"ball_stye"] integerValue] ==3) {
                _tiaoQiuTotalSccore += [[_qiuChangDatas[i] objectForKey:@"ball_score"] integerValue];
                if ([[_qiuChangDatas[i] objectForKey:@"ball_back_hand"] integerValue] ==2) {
                    fsTiaoQiuTotalCount++;
                    _fsTiaoQiuTotalScore += [[_qiuChangDatas[i] objectForKey:@"ball_score"] integerValue];
                }
                if ([[_qiuChangDatas[i] objectForKey:@"ball_back_hand"] integerValue] ==3) {
                    zsTiaoQiuTotalCount++;
                    _zsTiaoQiuTotalScore += [[_qiuChangDatas[i] objectForKey:@"ball_score"] integerValue];
                }
            }
            if ([[_qiuChangDatas[i] objectForKey:@"ball_stye"] integerValue] ==4) {
                _cuoQiuTotalSccore += [[_qiuChangDatas[i] objectForKey:@"ball_score"] integerValue];
                if ([[_qiuChangDatas[i] objectForKey:@"ball_back_hand"] integerValue] ==2) {
                    fsCuoQiuTotalCount++;
                    _fsCuoQiuTotalScore += [[_qiuChangDatas[i] objectForKey:@"ball_score"] integerValue];
                }
                if ([[_qiuChangDatas[i] objectForKey:@"ball_back_hand"] integerValue] ==3) {
                    zsCuoQiuTotalCount++;
                    _zsCuoQiuTotalScore += [[_qiuChangDatas[i] objectForKey:@"ball_score"] integerValue];
                }
            }
            if ([[_qiuChangDatas[i] objectForKey:@"ball_stye"] integerValue] ==5) {
                _tuiQiuTotalSccore += [[_qiuChangDatas[i] objectForKey:@"ball_score"] integerValue];
                if ([[_qiuChangDatas[i] objectForKey:@"ball_back_hand"] integerValue] ==2) {
                    fsTuiQiuTotalCount++;
                    _fsTuiQiuTotalScore += [[_qiuChangDatas[i] objectForKey:@"ball_score"] integerValue];
                }
                if ([[_qiuChangDatas[i] objectForKey:@"ball_back_hand"] integerValue] ==3) {
                    zsTuiQiuTotalCount++;
                    _zsTuiQiuTotalScore += [[_qiuChangDatas[i] objectForKey:@"ball_score"] integerValue];
                }
            }
            if ([[_qiuChangDatas[i] objectForKey:@"ball_stye"] integerValue] ==6) {
                _diaoQiuTotalSccore += [[_qiuChangDatas[i] objectForKey:@"ball_score"] integerValue];
                if ([[_qiuChangDatas[i] objectForKey:@"ball_back_hand"] integerValue] ==2) {
                    fsDiaoQiuTotalCount++;
                    _fsDiaoQiuTotalScore += [[_qiuChangDatas[i] objectForKey:@"ball_score"] integerValue];
                }
                if ([[_qiuChangDatas[i] objectForKey:@"ball_back_hand"] integerValue] ==3) {
                    zsDiaoQiuTotalCount++;
                    _zsDiaoQiuTotalScore += [[_qiuChangDatas[i] objectForKey:@"ball_score"] integerValue];
                }
            }
        }
        
        int gaoWeiJiQiuCount = zsGaoWeiJiQiuCount+fsGaoWeiJiQiuCount;
        int cuoQiuCount = zsCuoQiuTotalCount+fsCuoQiuTotalCount;
        int tiaoQiuCount = zsTiaoQiuTotalCount+fsTiaoQiuTotalCount;
        int diaoQiuCount = zsDiaoQiuTotalCount+fsDiaoQiuTotalCount;
        int tuiQiuCount = zsTuiQiuTotalCount+fsTuiQiuTotalCount;
        
        
        if (zsGaoWeiJiQiuCount == 0) {
            zsGaoWeiJiQiuCount = 1;
        }
        if (fsGaoWeiJiQiuCount == 0) {
            fsGaoWeiJiQiuCount = 1;
        }
        if (zsCuoQiuTotalCount == 0) {
            zsCuoQiuTotalCount = 1;
        }
        if (fsCuoQiuTotalCount == 0) {
            fsCuoQiuTotalCount = 1;
        }
        if (zsTiaoQiuTotalCount == 0) {
            zsTiaoQiuTotalCount = 1;
        }
        if (fsTiaoQiuTotalCount == 0) {
            fsTiaoQiuTotalCount = 1;
        }
        if (zsDiaoQiuTotalCount == 0) {
            zsDiaoQiuTotalCount = 1;
        }
        if (fsDiaoQiuTotalCount == 0) {
            fsDiaoQiuTotalCount = 1;
        }
        if (zsTuiQiuTotalCount == 0) {
            zsTuiQiuTotalCount = 1;
        }
        if (fsTuiQiuTotalCount == 0) {
            fsTuiQiuTotalCount = 1;
        }
        
        if (gaoWeiJiQiuCount == 0) {
            gaoWeiJiQiuCount = 1;
        }
        if (cuoQiuCount == 0) {
            cuoQiuCount = 1;
        }
        if (tiaoQiuCount == 0) {
            tiaoQiuCount = 1;
        }
        if (diaoQiuCount == 0) {
            diaoQiuCount = 1;
        }
        if (tuiQiuCount == 0) {
            tuiQiuCount = 1;
        }
        
        _zsGaoWeiJiQiuScore = _zsGaoWeiJiQiuScore/zsGaoWeiJiQiuCount;
        _fsGaoWeiJiQiuScore = _fsGaoWeiJiQiuScore/fsGaoWeiJiQiuCount;
        _zsCuoQiuTotalScore = _zsCuoQiuTotalScore/zsCuoQiuTotalCount;
        _fsCuoQiuTotalScore = _fsCuoQiuTotalScore/fsCuoQiuTotalCount;
        _zsTiaoQiuTotalScore = _zsTiaoQiuTotalScore/zsTiaoQiuTotalCount;
        _fsTiaoQiuTotalScore = _fsTiaoQiuTotalScore/fsTiaoQiuTotalCount;
        _zsDiaoQiuTotalScore = _zsDiaoQiuTotalScore/zsDiaoQiuTotalCount;
        _fsDiaoQiuTotalScore = _fsDiaoQiuTotalScore/fsDiaoQiuTotalCount;
        _zsTuiQiuTotalScore = _zsTuiQiuTotalScore/zsTuiQiuTotalCount;
        _fsTuiQiuTotalScore = _zsGaoWeiJiQiuScore/fsTuiQiuTotalCount;
        
        _gaoWeiJiQiuTotalSccore = _zsGaoWeiJiQiuScore+_fsGaoWeiJiQiuScore;
        _cuoQiuTotalSccore = _zsCuoQiuTotalScore+_fsCuoQiuTotalScore;
        _tiaoQiuTotalSccore = _zsTiaoQiuTotalScore+_fsTiaoQiuTotalScore;
        _diaoQiuTotalSccore = _zsDiaoQiuTotalScore+_fsDiaoQiuTotalScore;
        _tuiQiuTotalSccore = _zsTuiQiuTotalScore+_fsTuiQiuTotalScore;
        
        int qiuchangScore = (_gaoWeiJiQiuTotalSccore + _cuoQiuTotalSccore + _tiaoQiuTotalSccore + _diaoQiuTotalSccore + _tuiQiuTotalSccore) / 5;
        
        _zhengShouValue.text = [NSString stringWithFormat:@"%d次",zhengShouCount];
        _fanShouValue.text = [NSString stringWithFormat:@"%d次",fanShouCount];
        _CaloriesValue.text = [NSString stringWithFormat:@"%d",(int)calories];
        _shiJianValue.text = _jiShiLabel.text;
        
        _averageSpeedValue.text = [NSString stringWithFormat:@"%dkm/h",(int)(speed/_qiuChangDatas.count)];
        _averageLiDUValue.text = [NSString stringWithFormat:@"%dN",(int)(lidu/_qiuChangDatas.count)];
        
        NSMutableAttributedString *averageSpeedstr = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@", _averageSpeedValue.text]];
        [averageSpeedstr addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:249/255.0 green:94/255.0 blue:0 alpha:1.0] range:NSMakeRange(0,averageSpeedstr.length)];
        [averageSpeedstr addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.3] range:NSMakeRange(averageSpeedstr.length-4,4)];
        _averageSpeedValue.attributedText = averageSpeedstr;
        
        NSMutableAttributedString *averageLiDUstr = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@", _averageLiDUValue.text]];
        [averageLiDUstr addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:249/255.0 green:94/255.0 blue:0 alpha:1.0] range:NSMakeRange(0,averageLiDUstr.length)];
        [averageLiDUstr addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.3] range:NSMakeRange(averageLiDUstr.length-1,1)];
        _averageLiDUValue.attributedText = averageLiDUstr;
        
        _maxSpeedValue.text = [NSString stringWithFormat:@"%dkm/h",(int)mydb->game_in.games_max_speed];
        NSMutableAttributedString *maxSpeedstr = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@", _maxSpeedValue.text]];
        [maxSpeedstr addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:249/255.0 green:94/255.0 blue:0 alpha:1.0] range:NSMakeRange(0,maxSpeedstr.length)];
        [maxSpeedstr addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.3] range:NSMakeRange(maxSpeedstr.length-4,4)];
        _maxSpeedValue.attributedText = maxSpeedstr;
        
        _maxLiDUValue.text = [NSString stringWithFormat:@"%dN",(int)mydb->game_in.games_max_strength];
        NSMutableAttributedString *maxLiDUstr = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@", _maxLiDUValue.text]];
        [maxLiDUstr addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:249/255.0 green:94/255.0 blue:0 alpha:1.0] range:NSMakeRange(0,maxLiDUstr.length)];
        [maxLiDUstr addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.3] range:NSMakeRange(maxLiDUstr.length-1,1)];
        _maxLiDUValue.attributedText = maxLiDUstr;
        
        //保存数据库
        if(_ball_num>0){
            mydb->game_in.games_kaluli = calories;
            mydb->game_in.games_score = qiuchangScore;
            [mydb Insert_game:mydb->game_in];
            
            my_end_time = mydb->game_in.games_end_time;
            
            NSDate *startDate = [NSDate dateWithTimeIntervalSinceReferenceDate:mydb->game_in.games_start_time - 8*3600];
            
            NSDateFormatter *dateFormatterOfstart = [[NSDateFormatter alloc] init];
            [dateFormatterOfstart setTimeZone:[NSTimeZone defaultTimeZone]];
            [dateFormatterOfstart setDateFormat:@"yyyy-MM-dd HH:mm:ss"];//@"yyyy-MM-dd HH:mm:ss"
            NSString *startDateStr = [dateFormatterOfstart stringFromDate:startDate];
            
            NSDate *endDate = [NSDate dateWithTimeIntervalSinceReferenceDate:my_end_time - 8*3600];
            NSDateFormatter *dateFormatterOfEnd = [[NSDateFormatter alloc] init];
            [dateFormatterOfEnd setDateFormat:@"yyyy-MM-dd HH:mm:ss"];//@"yyyy-MM-dd HH:mm:ss"
            NSString *endDateStr = [dateFormatterOfEnd stringFromDate:endDate];
            
            NSURL *url = [[NSURL alloc]initWithString:[NSString stringWithFormat: @"%@SZearth/servlet/Updata", httpPort]];
            NSDictionary *gamesDictionary = @{@"games_start_time": startDateStr, @"games_end_time": endDateStr, @"games_max_speed":[[NSNumber alloc]initWithInt:mydb->game_in.games_max_speed], @"games_max_strength":[[NSNumber alloc]initWithInt:mydb->game_in.games_max_strength], @"games_score": [[NSNumber alloc]initWithInt:mydb->game_in.games_score], @"games_kaluli": [[NSNumber alloc]initWithInt:(int)calories], @"games_extend1": [[NSNumber alloc]initWithInt:0], @"games_extend2": [[NSNumber alloc]initWithInt:0], @"games_extend3": [[NSNumber alloc]initWithInt:0]};
            [self.qiuChangDatas insertObject:@{@"email": _userEmail} atIndex:0];
            if (self.qiuChangDatas.count > 0) {
                [self.qiuChangDatas insertObject:gamesDictionary atIndex:1];
            } else {
                [self.qiuChangDatas addObject:gamesDictionary];
            }
            
            //
            NSString *currentDateStr = [self currentDate];
            _httpHead = [[SZEarthHttpHead alloc]initWithValid:[NSString stringWithFormat:@"%@%@%@",currentDateStr,_userEmail,[[NSUserDefaults standardUserDefaults] objectForKey:@"user_password"]] andID:[[NSNumber alloc]initWithInt:-1] Length:[[NSNumber alloc]initWithInteger:self.qiuChangDatas.count] error:[[NSNumber alloc]initWithInt:0]];
            
            //加密
            NSData *ValidData = [_httpHead.valid dataUsingEncoding:NSUTF8StringEncoding];
            _httpHead.valid = [ValidData base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
            
            NSDictionary *headDictionary = @{@"valid":_httpHead.valid, @"length": _httpHead.length, @"error": _httpHead.error, @"id": _httpHead.ID};
            
            NSDictionary *dictionary = @{@"head": headDictionary, @"body" : self.qiuChangDatas};
            
            
            
            if ([NSJSONSerialization isValidJSONObject:dictionary]) {
                NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dictionary options:NSJSONWritingPrettyPrinted error:nil];
                NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url];
                [request setHTTPMethod:@"POST"];
                [[[NSURLSession sharedSession] uploadTaskWithRequest:request fromData:jsonData completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
                    if (error) {
                        [_unSendArray addObjectsFromArray:_qiuChangDatas];
                        [[NSUserDefaults standardUserDefaults] setObject:_unSendArray forKey:@"unSendArray"];
                    } else {
                        [_unSendArray removeAllObjects];
                        [self.qiuChangDatas removeAllObjects];
                    }
                    _started = 0;
                    
                }] resume];
            }
        }
        
        [_myTimer setFireDate:[NSDate distantFuture]];
    }
}

-(void)timeFireMethod{ //倒计时
    _miao_count++;
    if(_miao_count==60){
        _fen_count++;
        _miao_count = 0;
    }
    if (_fen_count==60) {
        _shi_count++;
        _fen_count = 0;
        _miao_count = 0;
    }
    NSString *miaoString;
    NSString *fenString;
    NSString *shiString;
    if(_miao_count<10) {
        miaoString = [NSString stringWithFormat:@"0%d",_miao_count];
    } else {
        miaoString = [NSString stringWithFormat:@"%d",_miao_count];
    }
    if(_fen_count<10) {
        fenString = [NSString stringWithFormat:@"0%d",_fen_count];
    } else {
        fenString = [NSString stringWithFormat:@"%d",_fen_count];
    }
    if(_shi_count<10) {
        shiString = [NSString stringWithFormat:@"0%d",_shi_count];
    } else {
        shiString = [NSString stringWithFormat:@"%d",_shi_count];
    }
    _jiShiLabel.text = [NSString stringWithFormat:@"%@:%@:%@",shiString, fenString, miaoString];
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@", _jiShiLabel.text]];
    [str addAttribute:NSFontAttributeName value:[UIFont boldSystemFontOfSize:24] range:NSMakeRange(0,str.length)];
    [str addAttribute:NSFontAttributeName value:[UIFont boldSystemFontOfSize:14] range:NSMakeRange(2,str.length-2)];
    _jiShiLabel.attributedText = str;
    
}

-(void)tapView {
    if (_menuTableView.hidden == NO) {
        _menuTableView.hidden = YES;
        _indicatorImageView.hidden = YES;
        _backgroundViewButton.hidden = YES;
    }
}

-(void)tapQiuChangModeSegment:(id)sender{
    if(((UISegmentedControl*)sender).selectedSegmentIndex == 1){ //切换到球场模式
        [self showDanCiMdeViewOrNo:NO];
        
    } else {
        
        [self showDanCiMdeViewOrNo:YES];
    }
}


-(void)tapViewMoreButton {
    _scoreDetailVC.gaoWeiJiQiuTotalSccore = _gaoWeiJiQiuTotalSccore;
    _scoreDetailVC.cuoQiuTotalSccore = _cuoQiuTotalSccore;
    _scoreDetailVC.diaoQiuTotalSccore = _diaoQiuTotalSccore;
    _scoreDetailVC.tuiQiuTotalSccore = _tuiQiuTotalSccore;
    _scoreDetailVC.tiaoQiuTotalSccore = _tiaoQiuTotalSccore;
    
    _scoreDetailVC.zsGaoWeiJiQiuScore = _zsGaoWeiJiQiuScore;
    _scoreDetailVC.fsGaoWeiJiQiuScore = _fsGaoWeiJiQiuScore;
    _scoreDetailVC.zsCuoQiuTotalScore = _zsCuoQiuTotalScore;
    _scoreDetailVC.fsCuoQiuTotalScore = _fsCuoQiuTotalScore;
    _scoreDetailVC.zsTuiQiuTotalScore = _zsTuiQiuTotalScore;
    _scoreDetailVC.fsTuiQiuTotalScore = _fsTuiQiuTotalScore;
    _scoreDetailVC.zsTiaoQiuTotalScore = _zsTiaoQiuTotalScore;
    _scoreDetailVC.fsTiaoQiuTotalScore = _fsTiaoQiuTotalScore;
    _scoreDetailVC.zsDiaoQiuTotalScore = _zsDiaoQiuTotalScore;
    _scoreDetailVC.fsDiaoQiuTotalScore = _fsDiaoQiuTotalScore;
    
    _isBackToLastVC = NO;
    
    [self showViewController:_scoreDetailVC sender:self];
}

-(void)showDanCiMdeViewOrNo:(BOOL)isShow{
    if (isShow) {
//        _mainImageView.image = [UIImage imageNamedFromCustomBundle:@"LOGO"];
        _mainImageView.hidden = NO;
        _circleImageView.hidden = NO;
        _wanYiBaLabel.hidden = NO;
        _speedImageView.hidden = NO;
        _speedLabel.hidden = NO;
        _liDuImageView.hidden = NO;
        _liDuLabel.hidden = NO;
        _bottomView.hidden = NO;
        _jiQiuLeiXingLabel.hidden = NO;
        _jiQiuLeiXingValue.hidden = NO;
        _huiPaiPingJiaLabel.hidden = NO;
        _huiPaiPingJiaImageView.hidden = NO;
        _baoFaLiLabel.hidden = NO;
        _baoFaLiImageView.hidden = NO;
        _faLiShiJiLabel.hidden = NO;
        _faLiShiJiImageView.hidden= NO;
        _circlePercenViewOfSpeed.hidden = NO;
        _circlePercenViewOfLidu.hidden = NO;
        _currentSpeed.hidden = NO;
        _currentLiDu.hidden = NO;
        
        _jiShiImageView.hidden = YES;
        _startButtonTiShiLabel.hidden = YES;
        _jiShiLabel.hidden = YES;
        _jiShiDanWeiLabel.hidden = YES;
        _startPlayImageView.hidden = YES;
        _bottomImageView.hidden = YES;
        _zhengShouLabel.hidden = YES;
        _zhengShouValue.hidden = YES;
        _fanShouLabel.hidden = YES;
        _fanShouValue.hidden = YES;
        _shiJianLabel.hidden = YES;
        _shiJianValue.hidden = YES;
        _CaloriesLabel.hidden = YES;
        _CaloriesValue.hidden = YES;
        _averageSpeedLabel.hidden = YES;
        _averageSpeedValue.hidden = YES;
        _averageLiDULabel.hidden = YES;
        _averageLiDUValue.hidden = YES;
        _maxSpeedLabel.hidden = YES;
        _maxSpeedValue.hidden = YES;
        _maxLiDULabel.hidden = YES;
        _maxLiDUValue.hidden = YES;
        _viewMoreBT.hidden = YES;
        
        
    } else {
//        _mainImageView.image = [UIImage imageNamedFromCustomBundle:@"计时器"];
        _mainImageView.hidden = YES;
        _circleImageView.hidden = YES;
        _wanYiBaLabel.hidden = YES;
        _speedImageView.hidden = YES;
        _speedLabel.hidden = YES;
        _liDuImageView.hidden = YES;
        _liDuLabel.hidden = YES;
        _bottomView.hidden = YES;
        _jiQiuLeiXingLabel.hidden = YES;
        _jiQiuLeiXingValue.hidden = YES;
        _huiPaiPingJiaLabel.hidden = YES;
        _huiPaiPingJiaImageView.hidden = YES;
        _baoFaLiLabel.hidden = YES;
        _baoFaLiImageView.hidden = YES;
        _faLiShiJiLabel.hidden = YES;
        _faLiShiJiImageView.hidden= YES;
        _circlePercenViewOfSpeed.hidden = YES;
        _circlePercenViewOfLidu.hidden = YES;
        _currentSpeed.hidden = YES;
        _currentLiDu.hidden = YES;
        
        _jiShiImageView.hidden = NO;
        _startButtonTiShiLabel.hidden = NO;
        _jiShiLabel.hidden = NO;
        _jiShiDanWeiLabel.hidden = NO;
        _startPlayImageView.hidden = NO;
        _bottomImageView.hidden = NO;
        _zhengShouLabel.hidden = NO;
        _zhengShouValue.hidden = NO;
        _fanShouLabel.hidden = NO;
        _fanShouValue.hidden = NO;
        _shiJianLabel.hidden = NO;
        _shiJianValue.hidden = NO;
        _CaloriesLabel.hidden = NO;
        _CaloriesValue.hidden = NO;
        _averageSpeedLabel.hidden = NO;
        _averageSpeedValue.hidden = NO;
        _averageLiDULabel.hidden = NO;
        _averageLiDUValue.hidden = NO;
        _maxSpeedLabel.hidden = NO;
        _maxSpeedValue.hidden = NO;
        _maxLiDULabel.hidden = NO;
        _maxLiDUValue.hidden = NO;
        _viewMoreBT.hidden = NO;
    }
}

//添加布局约束
-(void) layoutView: (UIView*)view multiplierX: (CGFloat)multiplierX multiplierY: (CGFloat)multiplierY multiplierWidth: (CGFloat)multiplierWidth multiplierHeight: (CGFloat)multiplierHeight{
    if ([view isKindOfClass:[UILabel class]]) {
        ((UILabel*)view).adjustsFontSizeToFitWidth = YES;
    }
    if (view.translatesAutoresizingMaskIntoConstraints) {
        view.translatesAutoresizingMaskIntoConstraints = NO;
    }
    
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
    
    [self.view addConstraints:@[centerXContraint,centerYContraint,widthContraint,heightContraint]];
    
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _dataList.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (_currentPeripheral.peripheral.state != CBPeripheralStateConnected) {  //隐藏解除绑定相关
        if (indexPath.row==1) {
            return 0;
        } else {
            return self.view.frame.size.width * 0.5 / 3.0;
        }
    }
    return self.view.frame.size.width * 0.5 / 4.0;
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
    if (indexPath.section == 0) {
        if (cell==nil) {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        }
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    if (indexPath.row==1) {
        if (_currentPeripheral.peripheral.state == CBPeripheralStateConnected) {  //隐藏解除绑定相关
            cell.textLabel.text = _dataList[indexPath.row];
        } else {
            cell.textLabel.text = @"";
        }
    } else {
        cell.textLabel.text = _dataList[indexPath.row];
    }
    
    cell.textLabel.textColor = [UIColor whiteColor];
    cell.backgroundColor = [UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:0.8];
    cell.textLabel.textAlignment = NSTextAlignmentCenter;
    return cell;
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    _isBackToLastVC = NO;
    if (indexPath.row == 0) {
        _IntroductionVC.currentPeripheral = _currentPeripheral;
        _IntroductionVC.cm = _cm;
        [_cm stopScan];
        [_bluetoothList removeAllObjects];
        
        [self showViewController:_IntroductionVC sender:self];
    }
    
    if (indexPath.row == 1) {
        double version = [[UIDevice currentDevice].systemVersion doubleValue];//判定系统版本。
        if(version<8.0f){
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"" message:@"确定取消绑定当前设备？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
            alertView.delegate = self;
            [alertView show];
        } else {
            _isBackToLastVC = YES;
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:@"确定取消绑定当前设备？" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
            UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                if (_currentPeripheral) {
                    [_cm cancelPeripheralConnection:_currentPeripheral.peripheral];
                }
                _currentPeripheral = nil;
                _ConnectionStateString = @"未连接";
                self.navigationItem.title = _ConnectionStateString;
                [[NSUserDefaults standardUserDefaults] setObject:nil forKey:@"perihperalUUIDString"];
                [_cm stopScan];
            } ];
            [alertController addAction:cancelAction];
            [alertController addAction:okAction];
            [self showDetailViewController:alertController sender:self];
        }
    }
    
    if (indexPath.row == 2) {
        [self showViewController:_calendarVC sender:self];
    }
    if (indexPath.row == 3) {
        [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
        [self.navigationController.navigationBar setShadowImage:[UIImage new]];
        _settingsVC.currentPeripheral = _currentPeripheral;
        _settingsVC.IntroductionVC2 = _IntroductionVC;
        _settingsVC.IntroductionVC2.currentPeripheral = _currentPeripheral;
        _settingsVC.IntroductionVC2.cm = _cm;
        _settingsVC.IntroductionVC2.BluetoothList = _bluetoothList;
        [_bluetoothList removeAllObjects];
        [self showViewController:_settingsVC sender:self];
    }
}

//uialertview delegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex==1) {
        if (_currentPeripheral) {
            [_cm cancelPeripheralConnection:_currentPeripheral.peripheral];
        }
        _currentPeripheral = nil;
        _ConnectionStateString = @"未连接";
        self.navigationItem.title = _ConnectionStateString;
        [[NSUserDefaults standardUserDefaults] setObject:nil forKey:@"perihperalUUIDString"];
        [_cm stopScan];
    }
}

//蓝牙协议
//首次搜索蓝牙
- (void) centralManagerDidUpdateState:(CBCentralManager *)central
{
    if (central.state == CBCentralManagerStatePoweredOn)
    {
        if (self.currentPeripheral.peripheral) {
            [self.cm connectPeripheral:self.currentPeripheral.peripheral options:@{CBConnectPeripheralOptionNotifyOnNotificationKey: [NSNumber numberWithBool:YES]}];
        } else {
           [self.cm scanForPeripheralsWithServices:@[[SZEarthUARTPeripheral uartServiceUUID]] options:@{CBCentralManagerScanOptionAllowDuplicatesKey: [NSNumber numberWithBool:NO]}];
        }
    }
    if (central.state == CBCentralManagerStatePoweredOff) {
        if (self.currentPeripheral.peripheral) {
            [self.cm cancelPeripheralConnection:self.currentPeripheral.peripheral];
            //蓝牙设置界面
            NSURL *url = [NSURL URLWithString:@"prefs:root=Bluetooth"];
            if ([[UIApplication sharedApplication] canOpenURL:url])
            {
                [[UIApplication sharedApplication] openURL:url];
            }
        }
    }
    
}

- (void) centralManager:(CBCentralManager *)central didDiscoverPeripheral:(CBPeripheral *)peripheral advertisementData:(NSDictionary *)advertisementData RSSI:(NSNumber *)RSSI
{
    
    
    SZEarthUARTPeripheral *tempPeripheral = [[SZEarthUARTPeripheral alloc] initWithPeripheral:peripheral delegate:self];
    
    //自动连接
    if (_isCurrentViewController) {
        
        if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"perihperalUUIDString"] isEqualToString: tempPeripheral.peripheral.identifier.UUIDString]) {
            _currentPeripheral = tempPeripheral;
            [self.cm connectPeripheral:tempPeripheral.peripheral options:@{CBConnectPeripheralOptionNotifyOnNotificationKey: [NSNumber numberWithBool:YES]}];
            
        } else if ([[NSUserDefaults standardUserDefaults] objectForKey:@"perihperalUUIDString"] == nil){
            
        }
    } else {
        [_IntroductionVC.BluetoothList addObject:tempPeripheral];
        [_IntroductionVC.searchView.tableView reloadData];
        if (_IntroductionVC.searchView.hidden) {
            _IntroductionVC.searchView.hidden = NO;
        }
        [_IntroductionVC.tableTitle addObject:peripheral.name];
        _IntroductionVC.searchView.backgroundImageView.image = [UIImage imageNamedFromCustomBundle:@"连接设备"];
        [_IntroductionVC.searchView.okButtonView setTitle:@"立即绑定" forState:UIControlStateNormal];
    }
}

- (void) centralManager:(CBCentralManager *)central didConnectPeripheral:(CBPeripheral *)peripheral
{
    _currentPeripheral = [[SZEarthUARTPeripheral alloc] initWithPeripheral:peripheral delegate:self];
    if (_isCurrentViewController) {
        if ([self.currentPeripheral.peripheral isEqual:peripheral])
        {
            [self.currentPeripheral didConnect]; //却少这步连接不上 ,连接服务
            [[NSUserDefaults standardUserDefaults] setObject:self.currentPeripheral.peripheral.identifier.UUIDString forKey:@"perihperalUUIDString"];
            _ConnectionStateString = @"已连接";
            self.navigationItem.title = _ConnectionStateString;
            
        }
    } else {
        [self.currentPeripheral didConnect]; //却少这步连接不上 ,连接服务
        [[NSUserDefaults standardUserDefaults] setObject:self.currentPeripheral.peripheral.identifier.UUIDString forKey:@"perihperalUUIDString"];
    }
    [_menuTableView reloadData];
    [self.cm stopScan];
    
}

- (void)centralManager:(CBCentralManager *)central didDisconnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error
{
    if (_isCurrentViewController) {
        _ConnectionStateString = @"未连接";
        self.navigationItem.title = _ConnectionStateString;
    }
    
    [self.cm scanForPeripheralsWithServices:@[[SZEarthUARTPeripheral uartServiceUUID]] options:@{CBCentralManagerScanOptionAllowDuplicatesKey: [NSNumber numberWithBool:NO]}];
    
    [_menuTableView reloadData];
    
    if (_currentPeripheral) {
        [self.cm connectPeripheral:_currentPeripheral.peripheral options:@{CBConnectPeripheralOptionNotifyOnNotificationKey: [NSNumber numberWithBool:YES]}];
    }
    
    //停止计时
//    [_myTimer setFireDate:[NSDate distantFuture]];
    
    
    
}

// - SZEarthUARTPeripheralDelegate
- (void) didReadHardwareRevisionString:(NSString *)string
{
    [self addTextToConsole:[NSString stringWithFormat:@"Hardware revision: %@", string] dataType:LOGGING];
}

- (void) didReceiveData:(NSString *)string
{
    if (_is_bobao_end) {
        
        [self addTextToConsole:string dataType:RX];
        [self addTextToConsole:string dataType:TX];
    }
}


- (void) addTextToConsole:(NSString *) string dataType:(ConsoleDataType) dataType
{
    NSString *direction;
    
    if ([[NSUserDefaults standardUserDefaults] integerForKey:@"set_sound"] == 0) {
        _set_sound = 0; //播报
    } else {
        _set_sound = 1;
    }
    
    if ([[NSUserDefaults standardUserDefaults] integerForKey:@"isBoBaoSpeed"] == 0) {
        _isBoBaoSpeed = 0; //播报
    } else {
        _isBoBaoSpeed = 1;
    }
    if ([[NSUserDefaults standardUserDefaults] integerForKey:@"isBoBaoLiDu"] == 0) {
        _isBoBaoLiDu = 0; //播报
    } else {
        _isBoBaoLiDu = 1;
    }
    if ([[NSUserDefaults standardUserDefaults] integerForKey:@"isBoBaoJiQiuType"] == 0) {
        _isBoBaoJiQiuType = 0; //播报
    } else {
        _isBoBaoJiQiuType = 1;
    }
    
    //力度最大28，速度最大280
    
    switch (dataType)
    {
        case RX:
            
            direction = @"RX";
            
            //接收－－解码－－刷新界面----------------------
            
            [resolveBluetooth getValue:[SZEarthResolveBluetooth tran_rec:string]];
            
            if((resolveBluetooth->speed>230 && resolveBluetooth->power<18) || (resolveBluetooth->speed>170 && resolveBluetooth->power<3) || (resolveBluetooth->speed>160 && resolveBluetooth->power<1) || (resolveBluetooth->speed>190 && resolveBluetooth->power<4)) {
                return;
            }
            
            int startTime = [SZEarthMy_DB getTime];
            
            if (resolveBluetooth->hit_type != 7 && resolveBluetooth->hit_type != 0 ) {
                _ball_num++;
            }
            
            
            if(resolveBluetooth->cmd==1){
                dispatch_async(dispatch_queue_create("queue", nil), ^{
                    
                    dispatch_sync(dispatch_get_main_queue(), ^(){
                        // 这里的代码会在主线程执行
                        
                        NSMutableAttributedString *currentstr = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%dkm/h", resolveBluetooth->speed]];
                        [currentstr addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:249/255.0 green:94/255.0 blue:0 alpha:1.0] range:NSMakeRange(0,currentstr.length)];
                        [currentstr addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.3] range:NSMakeRange(currentstr.length-4,4)];
                        _currentSpeed.attributedText = currentstr;
                        
                        currentstr = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%dN", resolveBluetooth->power]];
                        [currentstr addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:249/255.0 green:94/255.0 blue:0 alpha:1.0] range:NSMakeRange(0,currentstr.length)];
                        [currentstr addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.3] range:NSMakeRange(currentstr.length-1,1)];
                        _currentLiDu.attributedText = currentstr;
                        
                        [_jiQiuLeiXingValue setText:[NSString stringWithFormat:@"%@",[SZEarthResolveBluetooth Tran_Type:resolveBluetooth->hit_type]]];
                        
                        int ball_score;
                        switch (resolveBluetooth->hit_type) {
                            case 1:
                                ball_score = [self high_ball_score:(float)resolveBluetooth->speed ball_maxstrength:(float)resolveBluetooth->power ball_hitmoment:resolveBluetooth->zhuanpai ball_extend1:(float)resolveBluetooth->baofali ball_extend2:(float)resolveBluetooth->falishiji];
                                break;
                            case 2:
                                ball_score = [self high_ball_score:(float)resolveBluetooth->speed ball_maxstrength:(float)resolveBluetooth->power ball_hitmoment:resolveBluetooth->zhuanpai ball_extend1:(float)resolveBluetooth->baofali ball_extend2:(float)resolveBluetooth->falishiji];
                                break;
                            case 3:
                                ball_score = [self pick_ball_score:(float)resolveBluetooth->speed ball_maxstrength:(float)resolveBluetooth->power ball_hitmoment:resolveBluetooth->zhuanpai ball_extend1:(float)resolveBluetooth->baofali ball_extend2:(float)resolveBluetooth->falishiji];
                                break;
                            case 4:
                                ball_score = [self rub_ball_socre:(float)resolveBluetooth->speed ball_maxstrength:(float)resolveBluetooth->power ball_hitmoment:resolveBluetooth->zhuanpai ball_extend1:(float)resolveBluetooth->baofali ball_extend2:(float)resolveBluetooth->falishiji];
                                break;
                            case 5:
                                ball_score = [self push_ball_score:(float)resolveBluetooth->speed ball_maxstrength:(float)resolveBluetooth->power ball_hitmoment:resolveBluetooth->zhuanpai ball_extend1:(float)resolveBluetooth->baofali ball_extend2:(float)resolveBluetooth->falishiji];
                                break;
                            case 6:
                                ball_score = [self hang_ball_score:(float)resolveBluetooth->speed ball_maxstrength:(float)resolveBluetooth->power ball_hitmoment:resolveBluetooth->zhuanpai ball_extend1:(float)resolveBluetooth->baofali ball_extend2:(float)resolveBluetooth->falishiji];
                                break;
                            default:
                                ball_score = 0;
                                break;
                        }
                        ball_score = abs(ball_score);
                        if (abs(ball_score)>100) {
                            ball_score = 100;
                        }
                        _scoreLabel.text = [NSString stringWithFormat:@"恭喜你！获得%d分",ball_score];
                        
                        
                        if (ball_score == 0 ) {
                            _huiPaiPingJiaImageView.image = [UIImage imageNamedFromCustomBundle:@"0"];
                        } else if (ball_score > 3 * 100/4.0) {
                            _huiPaiPingJiaImageView.image = [UIImage imageNamedFromCustomBundle:@"4"];
                        } else if (ball_score > 2 * 100/4.0) {
                            _huiPaiPingJiaImageView.image = [UIImage imageNamedFromCustomBundle:@"3"];
                        } else if (ball_score > 100/4.0) {
                            _huiPaiPingJiaImageView.image = [UIImage imageNamedFromCustomBundle:@"2"];
                        } else if (ball_score > 0) {
                            _huiPaiPingJiaImageView.image = [UIImage imageNamedFromCustomBundle:@"1"];
                        }
                        
                        int pingjia2 = abs((resolveBluetooth->falishiji) );
                        if(pingjia2>=10) {
                            [_faLiShiJiImageView setImage:[UIImage imageNamedFromCustomBundle:@"0"]];
                        } else if(pingjia2>=8) {
                            [_faLiShiJiImageView setImage:[UIImage imageNamedFromCustomBundle:@"1"]];
                        } else if(pingjia2>=6) {
                            [_faLiShiJiImageView setImage:[UIImage imageNamedFromCustomBundle:@"2"]];
                        } else if(pingjia2>=3) {
                            [_faLiShiJiImageView setImage:[UIImage imageNamedFromCustomBundle:@"3"]];
                        } else {
                            [_faLiShiJiImageView setImage:[UIImage imageNamedFromCustomBundle:@"4"]];
                        }
                        
                        int ball_baofali = abs( (resolveBluetooth->baofali)/10 );
                        if(ball_baofali>=4) {
                            [_baoFaLiImageView setImage:[UIImage imageNamedFromCustomBundle:@"4"]];
                        } else if(ball_baofali>=3){
                            [_baoFaLiImageView setImage:[UIImage imageNamedFromCustomBundle:@"3"]];
                        } else if(ball_baofali>=2) {
                            [_baoFaLiImageView setImage:[UIImage imageNamedFromCustomBundle:@"2"]];
                        } else if(ball_baofali>=1) {
                            [_baoFaLiImageView setImage:[UIImage imageNamedFromCustomBundle:@"1"]];
                        } else {
                            [_baoFaLiImageView setImage:[UIImage imageNamedFromCustomBundle:@"0"]];
                        }
                                                
                        if (resolveBluetooth->hit_type != 7 && resolveBluetooth->hit_type != 0 && _started == 1) {
                            
                            if(resolveBluetooth->speed > mydb->game_in.games_max_speed) {
                                mydb->game_in.games_max_speed = resolveBluetooth->speed;
                            }
                            if(resolveBluetooth->power > mydb->game_in.games_max_strength){
                                mydb->game_in.games_max_strength = resolveBluetooth->power;
                            }
                            
                            float ball_kaluli = resolveBluetooth->speed / 3.6 /2.0 * resolveBluetooth->power * 4.4492 / 2.0 * 0.02 / 4.19;
                            
//                            int ball_score = abs((resolveBluetooth->zhuanpai/150));
                            
                            
                            NSDate *startDate = [NSDate dateWithTimeIntervalSinceReferenceDate:startTime - 8*3600];
                            NSDateFormatter *dateFormatterOfstart = [[NSDateFormatter alloc] init];
                            [dateFormatterOfstart setDateFormat:@"yyyy-MM-dd HH:mm:ss"];//@"yyyy-MM-dd HH:mm:ss"
                            NSString *startDateStr = [dateFormatterOfstart stringFromDate:startDate];
                            
                            NSDictionary *dictionary = @{@"ball_back_hand":[[NSNumber alloc]initWithInt:resolveBluetooth->hand], @"ball_stye":[[NSNumber alloc]initWithInt:resolveBluetooth->hit_type], @"ball_maxspeed":[[NSNumber alloc]initWithInt:resolveBluetooth->speed], @"ball_maxstrength":[[NSNumber alloc]initWithInt:resolveBluetooth->power], @"zhuanpai":[[NSNumber alloc]initWithInt:resolveBluetooth->zhuanpai], @"ball_play_time":startDateStr, @"baofali":[[NSNumber alloc]initWithInt:resolveBluetooth->baofali], @"falishiji":[[NSNumber alloc]initWithInt:resolveBluetooth->falishiji], @"ball_score":[[NSNumber alloc]initWithInt:ball_score], @"ball_kaluli":[[NSNumber alloc]initWithFloat:ball_kaluli], @"ball_extend1": [[NSNumber alloc]initWithInt:resolveBluetooth->baofali], @"ball_extend2": [[NSNumber alloc]initWithInt:resolveBluetooth->falishiji], @"ball_extend3": [[NSNumber alloc]initWithInt:0], @"ball_hitmoment": [[NSNumber alloc]initWithInt:resolveBluetooth->zhuanpai], @"ball_angle_face":[[NSNumber alloc]initWithInt:0], @"ball_angle_stick":[[NSNumber alloc]initWithInt:0], @"ball_data_length":[[NSNumber alloc]initWithInt:0]};
                            [_qiuChangDatas addObject:dictionary];
                            
                            
                        }
                        if ([UIScreen mainScreen].bounds.size.height < 568) {
                            //添加圆形进度条
                            [_circlePercenViewOfSpeed drawCircleWithPercent:resolveBluetooth->speed*100/280
                                                                   duration:0.2
                                                                  lineWidth:self.view.frame.size.width*0.04
                                                                  clockwise:YES
                                                                    lineCap:kCALineCapRound
                                                                  fillColor:[UIColor clearColor]
                                                                strokeColor:[UIColor colorWithRed:254/255.0 green:51/255.0 blue:95/255.0 alpha:1.0]
                                                             animatedColors:nil];
                            [_circlePercenViewOfSpeed startAnimation];
                            
                            [_circlePercenViewOfLidu drawCircleWithPercent:-resolveBluetooth->power*100/28 duration:0.2 lineWidth:self.view.frame.size.width*0.04 startAngle:-M_PI-0.1 clockwise:NO lineCap:kCALineCapRound fillColor:[UIColor clearColor] strokeColor:[UIColor colorWithRed:109/255.0 green:70/255.0 blue:247/255.0 alpha:1.0] animatedColors:nil];
                            [_circlePercenViewOfLidu startAnimation];
                        } else {
                            //添加圆形进度条
                            [_circlePercenViewOfSpeed drawCircleWithPercent:resolveBluetooth->speed*100/280
                                                                   duration:0.2
                                                                  lineWidth:self.view.frame.size.width*0.049
                                                                  clockwise:YES
                                                                    lineCap:kCALineCapRound
                                                                  fillColor:[UIColor clearColor]
                                                                strokeColor:[UIColor colorWithRed:254/255.0 green:51/255.0 blue:95/255.0 alpha:1.0]
                                                             animatedColors:nil];
                            [_circlePercenViewOfSpeed startAnimation];
                            
                            [_circlePercenViewOfLidu drawCircleWithPercent:-resolveBluetooth->power*100/28 duration:0.2 lineWidth:self.view.frame.size.width*0.049 startAngle:-M_PI-0.1 clockwise:NO lineCap:kCALineCapRound fillColor:[UIColor clearColor] strokeColor:[UIColor colorWithRed:109/255.0 green:70/255.0 blue:247/255.0 alpha:1.0] animatedColors:nil];
                            [_circlePercenViewOfLidu startAnimation];
                        }
                        
                        if (resolveBluetooth->hit_type != 7 && resolveBluetooth->hit_type != 0 ) {
                            [mydb Insert_ball:_userEmail ball_stye:resolveBluetooth->hit_type ball_maxspeed:resolveBluetooth->speed ball_maxstrength:resolveBluetooth->power ball_back_hand:resolveBluetooth->hand ball_hitmoment:resolveBluetooth->zhuanpai ball_play_time:startTime];
                            
                        }
                        
                    });
                    
                    if((_set_sound == 0) && _started != 1 ){ //声音开启且不在球场模式下
                        if (_is_bobao_end) {
//                            if ([[self getPreferredLanguage] hasPrefix: @"zh"]) {
                                if ((resolveBluetooth->hit_type != 7) && (resolveBluetooth->hit_type != 0)) {
                                    _is_bobao_end = NO;
                                    if (_isBoBaoSpeed == 0) {
                                        [SZEarthMySound playSoundOfPowerOrSpeed:NO]; //播报速度
                                        [SZEarthMySound playArrayURL:resolveBluetooth->speed isPower:NO actionType:0];
                                    }
                                    if (_isBoBaoLiDu == 0) {
                    
                                        [SZEarthMySound playSoundOfPowerOrSpeed:YES];
                                        [SZEarthMySound playArrayURL:resolveBluetooth->power isPower:YES actionType:0];
                                    }
                                }
//                            }
                            if (_isBoBaoJiQiuType == 0 && resolveBluetooth->hit_type != 0) {
                                [SZEarthMySound playSound:resolveBluetooth->hit_type];

                            }
                            _is_bobao_end = YES;
                        }
                    }
                });
                
                }
    
            if(resolveBluetooth->cmd==2){
                
            }
            
            if (resolveBluetooth->cmd == 15) {
                [[NSUserDefaults standardUserDefaults] setObject: [NSString stringWithFormat:@"%d",resolveBluetooth->lingmindu] forKey:@"lingmindu"];
            }
            
            
            break;
            
        case TX:
            direction = @"TX";
            break;
            
        case LOGGING:
            direction = @"Log";
    }
    
    
}

//高位球得分算法
-(float)high_ball_score:(float) ball_maxspeed ball_maxstrength:(float) ball_maxstrength ball_hitmoment:(int) ball_hitmoment ball_extend1:(float) ball_extend1 ball_extend2:(float) ball_extend2 {
    float score=0;
    float score1=0;
    float score2=0;
    float score3=0;
    float score4=0;
    //发力时期得分
    if(abs((int)ball_extend2)>10){
        score1=0;
    }else{
        score1=((10-abs((int)ball_extend2))/10.0f)*30;
    }
    
    
    //爆发力得分
    if(abs((int)ball_extend1)>100){
        score2=30;
    }else{
        score2=(abs((int)ball_extend1)/100.0f)*30;
    }
//    _faLiShiJicore = score1;
//    _baoFaLiScore = score2;
    
    //发力效率得分
    if(ball_maxspeed<100){
        ball_maxspeed=100;
    }else if(ball_maxspeed>240){
        ball_maxspeed=240;
    }
    if(ball_maxstrength<6){
        ball_maxstrength=6;
    }else if(ball_maxstrength>21){
        ball_maxstrength=21;
    }
    score3=(ball_maxspeed/ball_maxstrength-5)/35.0f*10;
    //转臂得分
    if(abs(ball_hitmoment)>2000){
        score4=30;
    }else{
        score4=(abs(ball_hitmoment)/2000.0f)*30;
    }
    //单个球总得分
    score=round(score1+score2+score3+score4);
    return score;
}

//挑球得分算法
-(float)pick_ball_score:(float) ball_maxspeed ball_maxstrength:(float) ball_maxstrength ball_hitmoment:(int) ball_hitmoment ball_extend1:(float) ball_extend1 ball_extend2:(float) ball_extend2 {
    float score=0;
    float score1=0;
    float score2=0;
    float score3=0;
    float score4=0;
    //发力时期得分
    if(abs((int)ball_extend2)>10){
        score1=0;
    }else{
        score1=((10-abs((int)ball_extend2))/10.0f)*30;
    }

    //爆发力得分
    if(abs((int)ball_extend1)>70){
        score2=30;
    }else{
        score2=(abs((int)ball_extend1)/70.0f)*30;
    }
//    _faLiShiJicore = score1;
//    _baoFaLiScore = score2;
    //发力效率得分
    if(ball_maxspeed<10){
        ball_maxspeed=10;
    }else if(ball_maxspeed>200){
        ball_maxspeed=200;
    }
    if(ball_maxstrength<3){
        ball_maxstrength=3;
    }else if(ball_maxstrength>20){
        ball_maxstrength=20;
    }
    score3=(ball_maxspeed/ball_maxstrength-1)/66.0f*10;
    //转臂得分
    if(abs(ball_hitmoment)>2000){
        score4=30;
    }else{
        score4=(abs(ball_hitmoment)/2000.0f)*30;
    }
    //单个球总得分
    score=round(score1+score2+score3+score4);
    return score;
}

//搓球得分算法
-(float)rub_ball_socre:(float) ball_maxspeed ball_maxstrength:(float) ball_maxstrength ball_hitmoment:(int) ball_hitmoment ball_extend1:(float) ball_extend1 ball_extend2:(float) ball_extend2 {
    float score=0;
    float score2=0;
    float score3=0;
    float score4=0;
    
    
    //发力效率得分
    if(ball_maxspeed<15){
        ball_maxspeed=15;
    }else if(ball_maxspeed>80){
        ball_maxspeed=80;
    }
    score2=((80-ball_maxspeed)/65.0f)*40;
    if(ball_maxstrength<1){
        ball_maxstrength=1;
    }else if(ball_maxstrength>6){
        ball_maxstrength=6;
    }
    score3=((6-ball_maxstrength)/5.0f)*40;
    //转臂得分
    if(abs(ball_hitmoment)<20){
        ball_hitmoment=20;
    }
    if(abs(ball_hitmoment)>400){
        ball_hitmoment=400;
    }
    if(abs(ball_hitmoment)<=210){
        score3=((abs(ball_hitmoment)-20)/190.0f)*20;
    }else{
        score3=(400-abs(ball_hitmoment))/190.0f*20;
    }
    
//    _faLiShiJicore = 0;
//    _baoFaLiScore = 0;
    
    //单个球总得分
    score=round(score2+score3+score4);
    return score;
}

//吊球得分算法
-(float)hang_ball_score:(float) ball_maxspeed ball_maxstrength:(float) ball_maxstrength ball_hitmoment:(int) ball_hitmoment ball_extend1:(float) ball_extend1 ball_extend2:(float) ball_extend2 {
    float score=0;
    float score1=0;
    float score2=0;
    float score3=0;
    float score4=0;
    float score5=0;
    //发力时期得分
    if(abs((int)ball_extend2)>100){
        score1=0;
    }else{
        score1=((100-abs((int)ball_extend2))/100.0f)*20;
    }
    //爆发力得分
    if(abs((int)ball_extend1)>65){
        ball_extend1=65;
    }
    if(abs((int)ball_extend1)<1){
        ball_extend1=1;
    }
    if(abs((int)ball_extend1)<=65){
        score2=((abs((int)ball_extend1)-1)/33.0f)*20;
    }else{
        score2=(65-abs((int)ball_extend1))/33.0f*20;
    }
    //发力效率得分
    if(ball_maxspeed<30){
        ball_maxspeed=30;
    }else if(ball_maxspeed>100){
        ball_maxspeed=100;
    }
    if(abs((int)ball_maxspeed)<=100){
        score3=((abs((int)ball_maxspeed)-1)/65.0f)*20;
		  }else{
              score3=(100-abs((int)ball_maxspeed))/65.0f*20;
          }
    if(ball_maxstrength<2){
        ball_maxstrength=2;
    }else if(ball_maxstrength>15){
        ball_maxstrength=15;
    }
//    if(abs((int)ball_maxspeed)<=15){
//        score4=((abs((int)ball_maxspeed)-2)/8.5f)*20;
//    }else{
//        score4=(15-abs((int)ball_maxspeed))/8.5f*20;
//    }
    if(abs((int)ball_maxstrength)<=15){
        score4=((abs((int)ball_maxstrength)-2)/8.5f)*20;
    }else{
        score4=(abs((int)ball_maxstrength)-15)/8.5f*20;
    }
    //转臂得分
    if(abs(ball_hitmoment)>1000){
        ball_hitmoment=1000;
    }
    if(abs(ball_hitmoment)<=1000){
        score5=((abs(ball_hitmoment))/500.0f)*20;
    }else{
        score5=(abs(ball_hitmoment-1000))/500.0f*20;
    }
//    _faLiShiJicore = score1;
//    _baoFaLiScore = score2;
    //单个球总得分
    score=round(score1+score2+score3+score4+score5);
    return score;
    
}

//推球得分算法
-(float)push_ball_score:(float) ball_maxspeed ball_maxstrength:(float) ball_maxstrength ball_hitmoment:(int) ball_hitmoment ball_extend1:(float) ball_extend1 ball_extend2:(float) ball_extend2 {
    float score=0;
    float score1=0;
    float score2=0;
    float score3=0;
    float score4=0;
    //发力时期得分
    if(abs((int)ball_extend2)>10){
        score1=0;
    }else{
        score1=((10-abs((int)ball_extend2))/10.0f)*30;
    }
    //爆发力得分
    if(abs((int)ball_extend1)>70){
        score2=30;
    }else{
        score2=(abs((int)ball_extend1)/70.0f)*30;
    }
    //发力效率得分
    if(ball_maxspeed<10){
        ball_maxspeed=10;
    }else if(ball_maxspeed>200){
        ball_maxspeed=200;
    }
    if(ball_maxstrength<3){
        ball_maxstrength=3;
    }else if(ball_maxstrength>20){
        ball_maxstrength=20;
    }
    score3=(ball_maxspeed/ball_maxstrength-1)/66.0f*10;
    //转臂得分
    if(abs(ball_hitmoment)>2000){
        score4=30;
    }else{
        score4=(abs(ball_hitmoment)/2000.0f)*30;
    }
//    _faLiShiJicore = score1;
//    _baoFaLiScore = score2;
    //单个球总得分
    score=round(score1+score2+score3+score4);
    return score;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
    //取消定时器
    [_myTimer invalidate];
    _myTimer = nil;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
