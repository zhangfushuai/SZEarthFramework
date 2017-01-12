//
//  SZEarthResultViewController.h
//  exampleSDK
//
//  Created by Earth on 16/3/10.
//  Copyright © 2016年 Earth. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ResultChartView.h"
#import "ResultBottonView.h"
#import "SZEarthMy_DB.h"

@interface SZEarthResultViewController : UIViewController

@property (strong, nonatomic) ResultChartView *resultChartView;

@property (strong ,nonatomic) ResultBottonView *bottonView;

@property NSInteger maxCount;

@property NSInteger zsGaoWeicount;
@property NSInteger fsGaoWeicount;
@property NSInteger zsTiaoQiucount;
@property NSInteger fsTiaoQiucount;
@property NSInteger zsCuoQiucount;
@property NSInteger fsCuoQiucount;
@property NSInteger zsDiaoQiucount;
@property NSInteger fsDiaoQiucount;
@property NSInteger zsTuiQiucount;
@property NSInteger fsTuiQiucount;

@property int startTime;
@property int endTime;

@property NSMutableDictionary *bottonDictionary;

@end
