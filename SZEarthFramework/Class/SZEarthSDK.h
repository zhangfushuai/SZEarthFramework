//
//  SZEarthSDK3.h
//  SZEarthSDK3
//
//  Created by Earth on 16/3/2.
//  Copyright © 2016年 Earth. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface SZEarthSDK : NSObject

//创建导航条控制器
+(UINavigationController*)createViewControllerExistUser:(BOOL)isExistUser;

//-(instancetype)initWithUserName:(NSString*)userName userEmail:(NSString*)userEmail userImage:(UIImage*)image pinPaiName:(NSString*)pinPaiName userSex:(NSInteger)sex userHands:(NSInteger)userHands;

//初始化控制器
-(instancetype)initWithUserName:(NSString*)userName userEmail:(NSString*)userEmail userImage:(UIImage*)image pinPaiName:(NSString*)pinPaiName completed:(void(^)(BOOL isExitsThisUser, BOOL theNetworkIsAvailable))completed;

+ (BOOL)connectedToNetwork;

@end
