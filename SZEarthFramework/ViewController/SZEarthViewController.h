//
//  SZEarthViewController.h
//  SZEarthSDK3
//
//  Created by Earth on 16/3/2.
//  Copyright © 2016年 Earth. All rights reserved.
//

#import <UIKit/UIKit.h>

#define httpPort @"http://szearth.cn:8090/"   //外网
//#define httpPort @"http://113.108.41.10:8090/" //外网
//#define httpPort @"http://192.168.10.6:8080/"  //内网

@interface SZEarthViewController : UIViewController<UITableViewDataSource, UITableViewDelegate, UIAlertViewDelegate>


@property (strong, nonatomic) NSMutableArray *bluetoothList;

@property (strong,nonatomic) UITableView *menuTableView; //选择列表
@property (strong,nonatomic) UIImageView *indicatorImageView;
@property (strong,nonatomic) UIButton *backgroundViewButton;
@property (strong,nonatomic) NSArray *dataList;

@property (strong, nonatomic) UIImageView *mainImageView; //单次模式下

@property (strong, nonatomic) UIImageView *jiShiImageView; //球场模式下

@property (strong, nonatomic) UIImageView *speedImageView;

@property (strong, nonatomic) UILabel *speedLabel;

@property (strong, nonatomic) UIImageView *liDuImageView;

@property (strong, nonatomic) UILabel *liDuLabel;

@property (strong, nonatomic) UISegmentedControl *qiuChangSegment;

@property (strong, nonatomic) UIView *bottomView;

@property (strong , nonatomic) UILabel *scoreLabel;

@property (strong, nonatomic) UILabel *jiQiuLeiXingLabel;
@property (strong, nonatomic) UILabel *jiQiuLeiXingValue;

@property (strong, nonatomic) UILabel *huiPaiPingJiaLabel;
@property (strong, nonatomic) UIImageView *huiPaiPingJiaImageView;

@property (strong, nonatomic) UILabel *baoFaLiLabel;
@property (strong, nonatomic) UIImageView *baoFaLiImageView;

@property (strong, nonatomic) UILabel *faLiShiJiLabel;
@property (strong, nonatomic) UIImageView *faLiShiJiImageView;

@property (strong, nonatomic) UILabel *currentSpeed; //当前速度
@property (strong, nonatomic) UILabel *currentLiDu; //当前速度
@property (strong, nonatomic) UILabel *startButtonTiShiLabel; //开始按钮提示标签
@property (strong, nonatomic) UILabel *wanYiBaLabel; //玩一把？

@property (strong, nonatomic) UIButton *startPlayImageView;

@property (strong, nonatomic) UILabel *jiShiLabel;
@property (strong, nonatomic) UILabel *xiaoShiLabel;
@property (strong, nonatomic) UILabel *jiShiDanWeiLabel;

@property (strong,nonatomic) UIImageView *bottomImageView;
@property (strong,nonatomic) UILabel *zhengShouLabel;
@property (strong,nonatomic) UILabel *zhengShouValue;
@property (strong,nonatomic) UILabel *fanShouLabel;
@property (strong,nonatomic) UILabel *fanShouValue;
@property (strong,nonatomic) UILabel *shiJianLabel;
@property (strong,nonatomic) UILabel *shiJianValue;
@property (strong,nonatomic) UILabel *CaloriesLabel;
@property (strong,nonatomic) UILabel *CaloriesValue;

@property (strong,nonatomic) UILabel *averageSpeedLabel;
@property (strong,nonatomic) UILabel *averageSpeedValue;
@property (strong,nonatomic) UILabel *averageLiDULabel;
@property (strong,nonatomic) UILabel *averageLiDUValue;
@property (strong,nonatomic) UILabel *maxSpeedLabel;
@property (strong,nonatomic) UILabel *maxSpeedValue;
@property (strong,nonatomic) UILabel *maxLiDULabel;
@property (strong,nonatomic) UILabel *maxLiDUValue;

@property (strong,nonatomic) UIButton *viewMoreBT;

@property BOOL hasNavigationBar;

@property(strong,nonatomic) NSMutableArray *qiuChangDatas; //球场模式下各个球的数据

@property (strong, nonatomic) NSMutableArray *unSendArray; //未发送成功时，暂时存储;


@property (strong,nonatomic) UIImageView *circleImageView;

@property BOOL isExistUser;

@property BOOL isBackToLastVC;

@property int isBoBaoSpeed; //1不播报，0播报;以下同理
@property int isBoBaoLiDu; 
@property int isBoBaoJiQiuType;

//@property int huiPaiPingJiaScore;
//@property int baoFaLiScore;
//@property int faLiShiJicore;

@property int gaoWeiJiQiuTotalSccore;
@property int tiaoQiuTotalSccore;
@property int cuoQiuTotalSccore;
@property int diaoQiuTotalSccore;
@property int tuiQiuTotalSccore;

@property int zsGaoWeiJiQiuScore;
@property int fsGaoWeiJiQiuScore;
@property int zsCuoQiuTotalScore;
@property int fsCuoQiuTotalScore;
@property int zsTuiQiuTotalScore;
@property int fsTuiQiuTotalScore;
@property int zsTiaoQiuTotalScore;
@property int fsTiaoQiuTotalScore;
@property int zsDiaoQiuTotalScore;
@property int fsDiaoQiuTotalScore;




@end
