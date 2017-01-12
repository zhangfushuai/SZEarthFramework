//
//  FillInTheInformation.h
//  exampleSDK
//
//  Created by Earth on 16/3/21.
//  Copyright © 2016年 Earth. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SZEarthFillInTheInformation : UITableViewController<UIAlertViewDelegate>

@property (strong, nonatomic) UIButton *backgroundButton;
@property (strong, nonatomic) UIDatePicker *datePicker;

@property NSInteger userSex;
@property NSInteger userHands;

@property NSString *dateString;
@property (strong, nonatomic) UIButton *okButton;
//@property (strong, nonatomic) UIButton *cancelButton;

@end
