//
//  FillInTheInformation.m
//  exampleSDK
//
//  Created by Earth on 16/3/21.
//  Copyright © 2016年 Earth. All rights reserved.
//

#import "SZEarthFillInTheInformationViewCell.h"

@implementation SZEarthFillInTheInformationViewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier andFrame:(CGRect)frame {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    CGFloat width = frame.size.height*0.6;
    
    CGFloat heightOfImageView = frame.size.height*0.6;
    
    CGFloat heightOfTitleLabel = frame.size.height*0.2;
    
    CGFloat zuoYouBianJu = frame.size.width*0.25;
    
    CGFloat shuiZhiBianJu = frame.size.height*0.1;
    
    _imageViewfirst = [[UIButton alloc]initWithFrame:CGRectMake(zuoYouBianJu, shuiZhiBianJu, width, heightOfImageView)];
    
    _imageViewSecond = [[UIButton alloc]initWithFrame:CGRectMake(frame.size.width-zuoYouBianJu-width, shuiZhiBianJu, width, heightOfImageView)];
    
    _bottomfirstTitleLabel = [[UILabel alloc]initWithFrame:CGRectMake(zuoYouBianJu, shuiZhiBianJu*2 + heightOfImageView, width, heightOfTitleLabel)];
    
    _bottomSecondTitleLabel = [[UILabel alloc]initWithFrame:CGRectMake(frame.size.width-zuoYouBianJu-width, shuiZhiBianJu*2 + heightOfImageView, width, heightOfTitleLabel)];
    
    _bottomfirstTitleLabel.textAlignment = NSTextAlignmentCenter;
    _bottomSecondTitleLabel.textAlignment = NSTextAlignmentCenter;
    
    _bottomfirstTitleLabel.adjustsFontSizeToFitWidth = YES;
    _bottomSecondTitleLabel.adjustsFontSizeToFitWidth = YES;
    
    [self.contentView addSubview:_imageViewfirst];
    [self.contentView addSubview:_imageViewSecond];
    [self.contentView addSubview:_bottomfirstTitleLabel];
    [self.contentView addSubview:_bottomSecondTitleLabel];
    
    return self;
}

@end
