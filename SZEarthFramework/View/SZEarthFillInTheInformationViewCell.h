//
//  FillInTheInformation.h
//  exampleSDK
//
//  Created by Earth on 16/3/21.
//  Copyright © 2016年 Earth. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SZEarthFillInTheInformationViewCell : UITableViewCell

@property (strong, nonatomic) UILabel *bottomfirstTitleLabel;
@property (strong, nonatomic) UILabel *bottomSecondTitleLabel;
@property (strong, nonatomic) UIButton *imageViewfirst;
@property (strong, nonatomic) UIButton *imageViewSecond;

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier andFrame:(CGRect)frame;

@end
