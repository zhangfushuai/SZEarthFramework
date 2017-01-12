//
//  ScoreDetailTableViewController.h
//  exampleSDK
//
//  Created by quan on 16/3/6.
//  Copyright © 2016年 Earth. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SZEarthScoreDetailTableViewCell.h"

@interface SZEarthScoreDetailTableViewController : UITableViewController

@property (strong,nonatomic) NSMutableArray *styleDataArray;
@property (strong,nonatomic) NSMutableArray *zhengShouDataArray;
@property (strong,nonatomic) NSMutableArray *fanShouDataArray;
@property (strong,nonatomic) NSMutableArray *totalDataArray;

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
