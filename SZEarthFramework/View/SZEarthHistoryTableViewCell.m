//
//  HistoryTableViewCell.m
//  exampleSDK
//
//  Created by quan on 16/3/6.
//  Copyright © 2016年 Earth. All rights reserved.
//

#import "SZEarthHistoryTableViewCell.h"

@implementation SZEarthHistoryTableViewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier frame:(CGRect)frame
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    NSInteger width = (frame.size.width)/4.8;
    NSInteger height = frame.size.height*0.23/3.0;
    
    _averageSpeedValue = [[UILabel alloc]initWithFrame:CGRectMake(frame.origin.x+width*0.2, 0, width, height)];
    _averageLiDUValue = [[UILabel alloc]initWithFrame:CGRectMake(frame.origin.x+width*0.2, height, width, height)];
    _averageValueLabel = [[UILabel alloc]initWithFrame:CGRectMake(frame.origin.x+width*0.2, height*2, width, height)];
    
    _maxSpeedValue = [[UILabel alloc]initWithFrame:CGRectMake(frame.origin.x+width*0.4+width, 0, width, height)];
    _maxLiDUValue = [[UILabel alloc]initWithFrame:CGRectMake(frame.origin.x+width*0.4+width, height, width, height)];
    _maxValueLabel = [[UILabel alloc]initWithFrame:CGRectMake(frame.origin.x+width*0.4+width, height*2, width, height)];
    
    
    _caloriesValue = [[UILabel alloc]initWithFrame:CGRectMake(frame.origin.x+width*0.6+width*2, 0, width, height)];
    _caloriesDanWei = [[UILabel alloc]initWithFrame:CGRectMake(frame.origin.x+width*0.6+width*2, height, width, height)];
    _caloriesLabel = [[UILabel alloc]initWithFrame:CGRectMake(frame.origin.x+width*0.6+width*2, height*2, width, height)];
    
    _scoreValue = [[UILabel alloc]initWithFrame:CGRectMake(frame.origin.x+width*0.8+width*3, height, width, height)];
    _scoreLabel = [[UILabel alloc]initWithFrame:CGRectMake(frame.origin.x+width*0.8+width*3, height*2, width, height)];
    
    _averageSpeedValue.adjustsFontSizeToFitWidth = YES;
    _averageLiDUValue.adjustsFontSizeToFitWidth = YES;
    _averageValueLabel.adjustsFontSizeToFitWidth = YES;
    
    _maxSpeedValue.adjustsFontSizeToFitWidth = YES;
    _maxLiDUValue.adjustsFontSizeToFitWidth = YES;
    _maxValueLabel.adjustsFontSizeToFitWidth = YES;
    
    _caloriesLabel.adjustsFontSizeToFitWidth = YES;
    _caloriesValue.adjustsFontSizeToFitWidth = YES;
    _caloriesDanWei.adjustsFontSizeToFitWidth = YES;
    
    _scoreValue.adjustsFontSizeToFitWidth = YES;
    _scoreLabel.adjustsFontSizeToFitWidth = YES;
    
    _averageSpeedValue.textColor = [UIColor redColor];
    _averageLiDUValue.textColor = [UIColor redColor];
    _maxSpeedValue.textColor = [UIColor redColor];
    _maxLiDUValue.textColor = [UIColor redColor];
    _caloriesDanWei.textColor = [UIColor redColor];
    _caloriesValue.textColor = [UIColor redColor];
    _scoreValue.textColor = [UIColor redColor];
    
    
    [self.contentView addSubview:_averageSpeedValue];
    [self.contentView addSubview:_averageLiDUValue];
    [self.contentView addSubview:_averageValueLabel];
    
    [self.contentView addSubview:_maxSpeedValue];
    [self.contentView addSubview:_maxLiDUValue];
    [self.contentView addSubview:_maxValueLabel];
    
    [self.contentView addSubview:_caloriesLabel];
    [self.contentView addSubview:_caloriesValue];
    [self.contentView addSubview:_caloriesDanWei];
    
    [self.contentView addSubview:_scoreValue];
    [self.contentView addSubview:_scoreLabel];
    
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    
}

@end
