//
//  historyViewController.h
//  RiLiTest
//
//  Created by quan on 16/3/5.
//  Copyright © 2016年 quan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SZEarthHistoryTableViewCell.h"
#import "SZEarthResultViewController.h"
#import "SZEarthMy_DB.h"

@interface SZEarthHistoryViewController : UITableViewController

@property int startDate;
@property int endDate;

@property (strong,nonatomic) NSMutableArray *dataList;

@property (strong,nonatomic) NSMutableArray *titleList;


@property (strong,nonatomic) SZEarthMy_DB *myDB;

@property NSString *selectedDateString;


@end
