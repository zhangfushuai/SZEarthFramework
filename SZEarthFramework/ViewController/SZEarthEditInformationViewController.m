//
//  EditInformationViewController.m
//  exampleSDK
//
//  Created by Earth on 16/3/4.
//  Copyright © 2016年 Earth. All rights reserved.
//

#import "SZEarthEditInformationViewController.h"
#import "UIImage+SZEarth_UIImage.h"
#import "SZEarthViewController.h"

@implementation SZEarthEditInformationViewController

-(void)viewDidLoad {
    [super viewDidLoad];
    
    _dataList = [[NSMutableArray alloc]initWithObjects:@"握拍方式", @"左手", @"右手", nil];
    
    self.tableView.rowHeight = self.view.frame.size.height*0.08;
    
    _handLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width*0.2, self.tableView.rowHeight)];
    _handLabel.textAlignment = NSTextAlignmentRight;
    
    if ([self.tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [self.tableView setSeparatorInset:UIEdgeInsetsZero];
    }
    
    if ([self.tableView respondsToSelector:@selector(setLayoutMargins:)]) {
        [self.tableView setLayoutMargins:UIEdgeInsetsZero];
    }
    
    _selectedListView = [[SZEarthSelectMenuView alloc]initWithFrame:self.navigationController.view.frame withRowCounts:3];
    
    [self.navigationController.view addSubview:_selectedListView];
    _selectedListView.delegate = self;
    _selectedListView.hidden= YES;
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamedFromCustomBundle:@"导航条"] forBarMetrics:UIBarMetricsDefault];
    
    self.navigationItem.title = @"用户信息";
    
    if ([[NSUserDefaults standardUserDefaults] integerForKey:@"SZEarthhand"]==0) {
        _handLabel.text = _dataList[1];
    } else {
        _handLabel.text = _dataList[2];
    }
}

-(void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0;
}

- (CGFloat) tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (section == tableView.numberOfSections-1) {
        return 1;
    }
    
    return 0;
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
    if (cell==nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    if (indexPath.row == 0) {
        cell.textLabel.text = @"握拍方式";
        cell.accessoryView = _handLabel;
    }
//    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section==0) {
        if (indexPath.row==0) {
            if (_selectedListView.hidden) {
                _selectedListView.hidden = NO;
            } else {
                _selectedListView.hidden = YES;
            }
        }
    }
}

// -- SelectMenuViewDelegate
-(void)hideSelectMenuView{ //点击取消时
    [[NSUserDefaults standardUserDefaults] setInteger:_hand forKey:@"SZEarthhand"];
    [_selectedListView.tableView reloadData];
}

-(void)tapOkButton {
    _selectedListView.hidden = YES;
    [self changHands];
}

-(NSInteger)numberOfSectionsInSelectMenuView {
    return 1;
}

-(NSInteger)numberOfRowsInSectionOfSelectMenuView:(NSInteger)section{
    return _dataList.count;
}

- (NSString*)textOfCellForRowOfSelectMenuViewAtIndexPath:(NSIndexPath *)indexPath{
    return _dataList[indexPath.row];
}

-(void)selectMenuView:(UITableViewCell*)cell WillDisplayCellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row==1) {
        if ([[NSUserDefaults standardUserDefaults] integerForKey:@"SZEarthhand"]==0) {
            ((UIImageView*)cell.accessoryView).image = [UIImage imageNamedFromCustomBundle:@"YES"];
            [_selectedListView.tableView selectRowAtIndexPath:indexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
        } else {
            ((UIImageView*)cell.accessoryView).image = [UIImage imageNamedFromCustomBundle:@"NO"];
        }
    }
    if (indexPath.row == 2) {
        if ([[NSUserDefaults standardUserDefaults] integerForKey:@"SZEarthhand"]==0) {
            ((UIImageView*)cell.accessoryView).image = [UIImage imageNamedFromCustomBundle:@"NO"];
        } else {
            ((UIImageView*)cell.accessoryView).image = [UIImage imageNamedFromCustomBundle:@"YES"];
            [_selectedListView.tableView selectRowAtIndexPath:indexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
        }
    }
}

-(void)didSelectRowOfSelectMenuViewAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [_selectedListView.tableView cellForRowAtIndexPath:indexPath];
        if (indexPath.row == 1) {
            [[NSUserDefaults standardUserDefaults] setInteger:0 forKey:@"SZEarthhand"];
            ((UIImageView*)cell.accessoryView).image = [UIImage imageNamedFromCustomBundle:@"YES"];
        }
        if (indexPath.row == 2) {
            [[NSUserDefaults standardUserDefaults] setInteger:1 forKey:@"SZEarthhand"];
            ((UIImageView*)cell.accessoryView).image = [UIImage imageNamedFromCustomBundle:@"YES"];
        }
    
}

-(void)selectMenuView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    _hand = [[NSUserDefaults standardUserDefaults] integerForKey:@"SZEarthhand"];
    if (indexPath.row == 1) {
        [[NSUserDefaults standardUserDefaults] setInteger:1 forKey:@"SZEarthhand"];
        ((UIImageView*)cell.accessoryView).image = [UIImage imageNamedFromCustomBundle:@"NO"];
    }
    if (indexPath.row == 2) {
        [[NSUserDefaults standardUserDefaults] setInteger:0 forKey:@"SZEarthhand"];
        ((UIImageView*)cell.accessoryView).image = [UIImage imageNamedFromCustomBundle:@"NO"];
    }
    
}

//修改左右手
-(void)changHands {
    NSURL *url = [[NSURL alloc]initWithString:[NSString stringWithFormat:@"%@SZearth/servlet/ModifyHand", httpPort]];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url];
    [request setHTTPMethod:@"post"];
    NSURLSession *session = [NSURLSession sharedSession];
    NSInteger hands = [[NSUserDefaults standardUserDefaults] integerForKey:@"SZEarthhand"]+1;
    NSDictionary *dictionary = [NSDictionary dictionaryWithObjectsAndKeys:[[NSUserDefaults standardUserDefaults] objectForKey:@"SZEarthUserEmail"], @"userEmail", [[NSNumber alloc]initWithInteger:hands], @"userHand", nil];
    NSData *fromData = [NSJSONSerialization dataWithJSONObject:dictionary options:NSJSONWritingPrettyPrinted error:nil];
    [[session uploadTaskWithRequest:request fromData:fromData completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        if (!error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                if ([[NSUserDefaults standardUserDefaults] integerForKey:@"SZEarthhand"]==0) {
                    _handLabel.text = _dataList[1];
                } else {
                    _handLabel.text = _dataList[2];
                }
                [self showAlertViewWithTitle:@"修改成功" message:@"恭喜您修改成功!"];
            });
            
        } else {
            dispatch_async(dispatch_get_main_queue(), ^{
                [[NSUserDefaults standardUserDefaults] setInteger:_hand forKey:@"SZEarthhand"];
                [_selectedListView.tableView reloadData];
                [self showAlertViewWithTitle:@"修改失败" message:@"网络请求失败!"];
            });
        }
        
    }] resume];
}

-(void)showAlertViewWithTitle:(NSString*)title message:(NSString*)message{
    dispatch_async(dispatch_get_main_queue(), ^{
        double version = [[UIDevice currentDevice].systemVersion doubleValue];//判定系统版本。
        if(version<8.0f){
            _alertView = [[UIAlertView alloc] initWithTitle:title message:message delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
            _alertView.delegate = self;
            [_alertView show];
        } else {
            _alertController = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                _selectedListView.hidden = YES;
            } ];
            [_alertController addAction:okAction];
            [self showDetailViewController:_alertController sender:self];
        }
    });
}

//uialertview delegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex==0) {
        _selectedListView.hidden = YES;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
