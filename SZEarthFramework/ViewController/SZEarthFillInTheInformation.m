//
//  FillInTheInformation.m
//  exampleSDK
//
//  Created by Earth on 16/3/21.
//  Copyright © 2016年 Earth. All rights reserved.
//

#import "SZEarthFillInTheInformation.h"
#import "SZEarthViewController.h"
#import "SZEarthFillInTheInformationViewCell.h"
#import "UIImage+SZEarth_UIImage.h"
#import "SZEarthSDK.h"

@implementation SZEarthFillInTheInformation


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.tableView.rowHeight = self.view.frame.size.height*0.15;
    
    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(tapCompleteButton)];
    self.navigationItem.rightBarButtonItem = rightButton;
    
    _backgroundButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.navigationController.view.frame.size.height)];
    _backgroundButton.backgroundColor = [UIColor colorWithWhite:0.9 alpha:0.9];
    [_backgroundButton addTarget:self action:@selector(tapBackgroundButton) forControlEvents:UIControlEventTouchDown];
    _datePicker = [[UIDatePicker alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height*0.5)];
    _datePicker.backgroundColor = [UIColor whiteColor];
    _datePicker.center = self.view.center;
    _datePicker.maximumDate = [NSDate date];
    _datePicker.datePickerMode = UIDatePickerModeDate;
    
    _okButton = [[UIButton alloc]initWithFrame:CGRectMake(self.view.frame.size.width*0.5-self.view.frame.size.width*0.1, _datePicker.frame.origin.y+_datePicker.frame.size.height, self.view.frame.size.width*0.2, self.navigationController.view.frame.size.height*0.06)];
    [_okButton setTitle:@"确定" forState:UIControlStateNormal];
    _okButton.hidden = YES;
    _okButton.backgroundColor = [UIColor colorWithRed:249/255.0 green:94/255.0 blue:0 alpha:1.0];
    [_okButton addTarget:self action:@selector(tapBackgroundButton) forControlEvents:UIControlEventTouchDown];
    
    [_backgroundButton addSubview:_datePicker];
    [self.navigationController.view addSubview:_backgroundButton];
    [self.navigationController.view addSubview:_okButton];
    
    _backgroundButton.hidden = YES;
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"YYYY-MM-dd"];
    _dateString =  [dateFormatter stringFromDate:_datePicker.date];
    
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.navigationItem.hidesBackButton = YES;
    self.navigationItem.title = @"完善用户信息";
}

-(void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.navigationItem.title = @"";
    self.navigationController.navigationBar.translucent = YES;
}

-(void)tapCompleteButton {
    //注册用户
    [self httpRegisterUser];
}

//隐藏日期选择器
-(void)tapBackgroundButton {
    _backgroundButton.hidden = YES;
    _okButton.hidden = YES;
    NSDate *theDate = _datePicker.date;
    // 设定格式化格式
    // dd和DD的区别
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"YYYY-MM-dd"];
    
    _dateString = [dateFormatter stringFromDate:theDate];
    
    [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:2] withRowAnimation:UITableViewRowAnimationNone];
}

- (void)httpRegisterUser { //注册用户
    if ([SZEarthSDK connectedToNetwork]) {
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        
        NSDictionary *userDataDictionary = (NSDictionary*)[defaults objectForKey:@"SZEarthuserDataDictionary"];
        
        if (userDataDictionary) {
            NSDateFormatter *dateFormatter2 = [[NSDateFormatter alloc] init];
            [dateFormatter2 setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
            NSString *user_signin_date= [dateFormatter2 stringFromDate:[NSDate date]];
            
            NSDictionary *dictionary = @{@"body": @[@{@"user_name":  [NSString stringWithString:[[userDataDictionary objectForKey:@"userName"] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding]], @"user_email": [userDataDictionary objectForKey:@"userEmail"], @"user_password":@"123456", @"user_birthday": _dateString, @"user_sex":[[NSNumber alloc]initWithInteger:_userSex+1], @"user_hand":[[NSNumber alloc]initWithInteger:_userHands+1], @"racket":[NSString stringWithString:[[userDataDictionary objectForKey:@"pinPaiName"] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding]], @"user_weight":[[NSNumber alloc]initWithInt:0], @"user_height":[[NSNumber alloc]initWithInt:0], @"user_signin_date": user_signin_date}]};
            
            if ([NSJSONSerialization isValidJSONObject:dictionary]) {
                NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dictionary options:NSJSONWritingPrettyPrinted error:nil];
                __block NSString *responeString;
                NSURL *url = [[NSURL alloc]initWithString:[NSString stringWithFormat: @"%@SZearth/servlet/Reg", httpPort]];
                NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url];
                [request setHTTPMethod:@"POST"];
                
                [[[NSURLSession sharedSession] uploadTaskWithRequest:request fromData:jsonData completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
                    
                    if (data) {
                        dispatch_async(dispatch_get_main_queue(), ^{
                            NSError *error2 = nil;
                            NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error2];
                            responeString = [NSString stringWithFormat:@"%@",[dictionary objectForKey:@"error"]];
                            if ([responeString isEqualToString:@"1"]) {//注册成功
                                dispatch_async(dispatch_get_main_queue(), ^{
                                    NSUserDefaults *defaults =[NSUserDefaults standardUserDefaults];
                                    [defaults setObject:[userDataDictionary objectForKey:@"userName"] forKey:@"SZEarthUserName"];
                                    [defaults setObject:[userDataDictionary objectForKey:@"userEmail"] forKey:@"SZEarthUserEmail"];
                                    [defaults setObject:[userDataDictionary objectForKey:@"userImage"] forKey:@"SZEarthUserImageData"];
                                    [defaults setObject:[userDataDictionary objectForKey:@"pinPaiName"] forKey:@"SZEarthPinPaiName"];
                                    [defaults setInteger:_userSex forKey:@"SZEarthUserSex"];
                                    [defaults setInteger:_userHands forKey:@"SZEarthhand"];
                                    
                                    [self.navigationController popViewControllerAnimated:YES];
                                });
                            } else {
                                dispatch_async(dispatch_get_main_queue(), ^{
                                    [self showAlertViewWithTitle:@"网络错误!"];
                                });
                            }
                        });
                    }
                }] resume];
            } else {
                [self showAlertViewWithTitle:@"注册信息错误!"];
            }
        }
    } else {
        [self showAlertViewWithTitle:@"网络错误!"];
    }
    
}

//显示提示框
-(void)showAlertViewWithTitle:(NSString*)title {
    dispatch_async(dispatch_get_main_queue(), ^{
        double version = [[UIDevice currentDevice].systemVersion doubleValue];//判定系统版本。
        if(version<8.0f){
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"注册失败" message:title delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
            alertView.delegate = self;
            [alertView show];
        } else {
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"注册失败" message:title preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                [self.navigationController popToRootViewControllerAnimated:YES];
            } ];
            [alertController addAction:okAction];
            [self showDetailViewController:alertController sender:self];
        }
    });
}

//uialertview delegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex==0) {
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return self.view.frame.size.height*0.05;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 2) {
        return self.view.frame.size.height*0.08;
    }
    return self.view.frame.size.height*0.15;
}

-(NSString*)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    NSString *title = @"";
    if (section == 0) {
        title = @"握拍习惯";
    } else if (section == 1){
        title = @"性别";
    } else {
        title = @"生日";
    }
    return title;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *reuseID = @"CellID";
    SZEarthFillInTheInformationViewCell *cell = [[SZEarthFillInTheInformationViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseID andFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height*0.15)];
    if (indexPath.section == 0) {
        cell.bottomfirstTitleLabel.text = @"左手";
        cell.bottomSecondTitleLabel.text = @"右手";
        [cell.imageViewfirst setImage:[UIImage imageNamedFromCustomBundle:@"左手"] forState:UIControlStateNormal];
        [cell.imageViewSecond setImage:[UIImage imageNamedFromCustomBundle:@"右手"] forState:UIControlStateNormal];
        [cell.imageViewfirst addTarget:self action:@selector(tapZuoShou) forControlEvents:UIControlEventTouchDown];
        [cell.imageViewSecond addTarget:self action:@selector(tapYouShou) forControlEvents:UIControlEventTouchDown];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    } else if (indexPath.section == 1){
        cell.bottomfirstTitleLabel.text = @"男";
        cell.bottomSecondTitleLabel.text = @"女";
        [cell.imageViewfirst setImage:[UIImage imageNamedFromCustomBundle:@"男"] forState:UIControlStateNormal];
        [cell.imageViewSecond setImage:[UIImage imageNamedFromCustomBundle:@"女"] forState:UIControlStateNormal];
        [cell.imageViewfirst addTarget:self action:@selector(tapNan) forControlEvents:UIControlEventTouchDown];
        [cell.imageViewSecond addTarget:self action:@selector(tapNv) forControlEvents:UIControlEventTouchDown];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    } else {
        cell.bottomfirstTitleLabel.hidden = YES;
        cell.bottomSecondTitleLabel.hidden = YES;
        cell.imageViewfirst.hidden = YES;
        cell.imageViewSecond.hidden = YES;
        
        cell.textLabel.text = _dateString;
        
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section==2) {
        _backgroundButton.hidden = NO;
        _okButton.hidden = NO;
        
    }
}

//选择左手
-(void)tapZuoShou {
    _userHands = 0;
    SZEarthFillInTheInformationViewCell *cell = (SZEarthFillInTheInformationViewCell*)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    [cell.imageViewfirst setImage:[UIImage imageNamedFromCustomBundle:@"颜色左手"]  forState:UIControlStateNormal];
    [cell.imageViewSecond setImage:[UIImage imageNamedFromCustomBundle:@"右手"] forState:UIControlStateNormal];
}

//选择右手
-(void)tapYouShou {
    _userHands = 1;
    SZEarthFillInTheInformationViewCell *cell = (SZEarthFillInTheInformationViewCell*)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    [cell.imageViewfirst setImage:[UIImage imageNamedFromCustomBundle:@"左手"]  forState:UIControlStateNormal];
    [cell.imageViewSecond setImage:[UIImage imageNamedFromCustomBundle:@"颜色右手"] forState:UIControlStateNormal];
    
}

//选择男
-(void)tapNan {
    _userSex = 0;
    SZEarthFillInTheInformationViewCell *cell = (SZEarthFillInTheInformationViewCell*)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:1]];
    [cell.imageViewfirst setImage:[UIImage imageNamedFromCustomBundle:@"颜色男"]  forState:UIControlStateNormal];
    [cell.imageViewSecond setImage:[UIImage imageNamedFromCustomBundle:@"女"] forState:UIControlStateNormal];
}
//选择女
-(void)tapNv {
    _userSex = 1;
    SZEarthFillInTheInformationViewCell *cell = (SZEarthFillInTheInformationViewCell*)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:1]];
    [cell.imageViewfirst setImage:[UIImage imageNamedFromCustomBundle:@"男"]  forState:UIControlStateNormal];
    [cell.imageViewSecond setImage:[UIImage imageNamedFromCustomBundle:@"颜色女"] forState:UIControlStateNormal];
}

@end
