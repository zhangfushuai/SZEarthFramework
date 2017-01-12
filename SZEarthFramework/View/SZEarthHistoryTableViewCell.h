//
//  HistoryTableViewCell.h
//  exampleSDK
//
//  Created by quan on 16/3/6.
//  Copyright © 2016年 Earth. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SZEarthHistoryTableViewCell : UITableViewCell

@property (strong,nonatomic) UILabel *averageValueLabel;
@property (strong,nonatomic) UILabel *maxValueLabel;
@property (strong,nonatomic) UILabel *averageSpeedValue;
@property (strong,nonatomic) UILabel *averageLiDUValue;
@property (strong,nonatomic) UILabel *maxSpeedValue;
@property (strong,nonatomic) UILabel *maxLiDUValue;
@property (strong,nonatomic) UILabel *caloriesLabel;
@property (strong,nonatomic) UILabel *caloriesValue;
@property (strong,nonatomic) UILabel *caloriesDanWei;
@property (strong,nonatomic) UILabel *scoreLabel;
@property (strong,nonatomic) UILabel *scoreValue;

@property int endTime;

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier frame:(CGRect)frame;

@end
