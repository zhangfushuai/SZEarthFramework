//
//  EditInformationViewController.h
//  exampleSDK
//
//  Created by Earth on 16/3/4.
//  Copyright © 2016年 Earth. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SZEarthSelectMenuView.h"

@interface SZEarthEditInformationViewController : UITableViewController<SZEarthSelectMenuViewDelegate, UIAlertViewDelegate>

@property (strong,nonatomic) UILabel *handLabel; //左手还是右手握拍

@property (strong,nonatomic) SZEarthSelectMenuView *selectedListView;

@property (strong, nonatomic) NSMutableArray *dataList;

@property NSInteger hand; //0右手，1左手

@property (strong, nonatomic) UIAlertView *alertView;
@property (strong, nonatomic) UIAlertController *alertController;

@end
