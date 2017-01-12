//
//  SZEarthSDK3.m
//  SZEarthSDK3
//
//  Created by Earth on 16/3/2.
//  Copyright © 2016年 Earth. All rights reserved.
//

#import "SZEarthSDK.h"
#import "SZEarthViewController.h"
#import <SystemConfiguration/SystemConfiguration.h>
#import <netinet/in.h>

@implementation SZEarthSDK

-(instancetype)initWithUserName:(NSString*)userName userEmail:(NSString*)userEmail userImage:(UIImage*)image pinPaiName:(NSString*)pinPaiName completed:(void(^)(BOOL isExitsThisUser, BOOL theNetworkIsAvailable))completed {
    
    self = [super init];
    
    [self existThisUser:userName userEmail:userEmail userImage:image pinPaiName:pinPaiName completed:completed];
    
    return self;
}

+(UINavigationController*)createViewControllerExistUser:(BOOL)isExistUser {
    SZEarthViewController *earthMainViewController = [[SZEarthViewController alloc]init];
    earthMainViewController.hasNavigationBar = NO;
    earthMainViewController.isExistUser = isExistUser;
    UINavigationController *mainViewController = [[UINavigationController alloc]initWithRootViewController:earthMainViewController];
    return mainViewController;
}

//检查本机是否联网
+ (BOOL)connectedToNetwork {
    
    //创建零地址，0.0.0.0的地址表示查询本机的网络连接状态
    struct sockaddr_in zeroAddress;
    bzero(&zeroAddress, sizeof(zeroAddress));
    zeroAddress.sin_len = sizeof(zeroAddress);
    zeroAddress.sin_family = AF_INET;
    // Recover reachability flags
    SCNetworkReachabilityRef defaultRouteReachability = SCNetworkReachabilityCreateWithAddress(NULL, (struct sockaddr *)&zeroAddress);
    SCNetworkReachabilityFlags flags;
    //获得连接的标志
    BOOL didRetrieveFlags = SCNetworkReachabilityGetFlags(defaultRouteReachability, &flags);
    CFRelease(defaultRouteReachability);
    //如果不能获取连接标志，则不能连接网络，直接返回
    if (!didRetrieveFlags)
    {
        return NO;
    }
    //根据获得的连接标志进行判断
    BOOL isReachable = flags & kSCNetworkFlagsReachable;
    BOOL needsConnection = flags & kSCNetworkFlagsConnectionRequired;
    return (isReachable && !needsConnection) ? YES : NO;
}


-(void)existThisUser:(NSString*)userName userEmail:(NSString*)userEmail userImage:(UIImage*)image pinPaiName:(NSString*)pinPaiName completed:(void(^)(BOOL isExitsThisUser, BOOL theNetworkIsAvailable))completed {
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
    NSData *imageData = UIImagePNGRepresentation(image);
    NSMutableDictionary *userDataDictionary = [NSMutableDictionary dictionaryWithObjectsAndKeys:userName, @"userName", userEmail, @"userEmail", imageData, @"userImage", pinPaiName, @"pinPaiName", nil];
    [userDefaults setObject:userDataDictionary forKey:@"SZEarthuserDataDictionary"];
    
    NSURL *url = [[NSURL alloc]initWithString:[NSString stringWithFormat:@"%@SZearth/servlet/emailVerify", httpPort]];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url];
    [request setHTTPMethod:@"post"];
    NSURLSession *session = [NSURLSession sharedSession];
    NSDictionary *dictionary = [NSDictionary dictionaryWithObjectsAndKeys:userEmail, @"userEmail", nil];
    NSData *fromData = [NSJSONSerialization dataWithJSONObject:dictionary options:NSJSONWritingPrettyPrinted error:nil];
    
    if ([[userDefaults objectForKey:@"SZEarthUserEmail"] isEqualToString:userEmail]) {
        [userDefaults setObject:userName forKey:@"SZEarthUserName"];
        [userDefaults setObject:imageData forKey:@"SZEarthUserImageData"];
        [userDefaults setObject:pinPaiName forKey:@"SZEarthPinPaiName"];
        if ([SZEarthSDK connectedToNetwork]) {
            completed(YES, YES);
            [[session uploadTaskWithRequest:request fromData:fromData completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
                NSLog(@"data :  %@", data);
                if (!error) {
                    NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
                    NSLog(@"dictionary :  %@", dictionary);
                    if ([[dictionary objectForKey:@"verify"] intValue] == 1) {
                        [userDefaults setInteger:[[dictionary objectForKey:@"user_sex"] integerValue]-1 forKey:@"SZEarthUserSex"];
                        [userDefaults setInteger:[[dictionary objectForKey:@"user_hand"] integerValue]-1 forKey:@"SZEarthhand"];
                    }
                }
                
            }] resume];
        } else {
            completed(YES, NO);
        }
    } else {
        [[session uploadTaskWithRequest:request fromData:fromData completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
            
            if (!error) {
                NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
                NSLog(@"dictionary :  %@", dictionary);
                if ([[dictionary objectForKey:@"verify"] intValue] == 1) {
                    NSData *imageData = UIImagePNGRepresentation(image);
                    [userDefaults setObject:userName forKey:@"SZEarthUserName"];
                    [userDefaults setObject:userEmail forKey:@"SZEarthUserEmail"];
                    [userDefaults setObject:imageData forKey:@"SZEarthUserImageData"];
                    [userDefaults setObject:pinPaiName forKey:@"SZEarthPinPaiName"];
                    [userDefaults setInteger:[[dictionary objectForKey:@"user_sex"] integerValue]-1 forKey:@"SZEarthUserSex"];
                    [userDefaults setInteger:[[dictionary objectForKey:@"user_hand"] integerValue]-1 forKey:@"SZEarthhand"];
                    dispatch_async(dispatch_get_main_queue(), ^{
                        completed(YES, YES);
                    });
                } else {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        completed(NO, YES);
                    });
                }
                
            } else {
                dispatch_async(dispatch_get_main_queue(), ^{
                    completed(NO, NO);
                });
            }
            
        }] resume];
    }
}


@end
