//
//  ScoreDetailTableViewCell.m
//  exampleSDK
//
//  Created by quan on 16/3/6.
//  Copyright © 2016年 Earth. All rights reserved.
//

#import "SZEarthScoreDetailTableViewCell.h"

@implementation SZEarthScoreDetailTableViewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier frame:(CGRect)frame
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    NSInteger width = frame.size.width/4.0;
    _styleLabel = [[UILabel alloc]initWithFrame:CGRectMake(frame.origin.x, 0, width, self.frame.size.height)];
    _zhengShouLabel = [[UILabel alloc]initWithFrame:CGRectMake(frame.origin.x+width, 0, width, self.frame.size.height)];
    _fanShouLabel = [[UILabel alloc]initWithFrame:CGRectMake(frame.origin.x+width*2, 0, width, self.frame.size.height)];
    _totalLabel = [[UILabel alloc]initWithFrame:CGRectMake(frame.origin.x+width*3, 0, width, self.frame.size.height)];
    
    _styleLabel.textAlignment = NSTextAlignmentCenter;
    _zhengShouLabel.textAlignment = NSTextAlignmentCenter;
    _fanShouLabel.textAlignment = NSTextAlignmentCenter;
    _totalLabel.textAlignment = NSTextAlignmentCenter;
    
    [self.contentView addSubview:_styleLabel];
    [self.contentView addSubview:_zhengShouLabel];
    [self.contentView addSubview:_fanShouLabel];
    [self.contentView addSubview:_totalLabel];
    
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
