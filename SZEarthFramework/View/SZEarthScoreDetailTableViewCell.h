//
//  ScoreDetailTableViewCell.h
//  exampleSDK
//
//  Created by quan on 16/3/6.
//  Copyright © 2016年 Earth. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SZEarthScoreDetailTableViewCell : UITableViewCell

@property (strong,nonatomic) UILabel *styleLabel;
@property (strong,nonatomic) UILabel *zhengShouLabel;
@property (strong,nonatomic) UILabel *fanShouLabel;
@property (strong,nonatomic) UILabel *totalLabel;

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier frame:(CGRect)frame;

@end
