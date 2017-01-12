//
//  MyCollectionViewCell.m
//  RiLiTest
//
//  Created by quan on 16/3/5.
//  Copyright © 2016年 quan. All rights reserved.
//

#import "SZEarthMyCollectionViewCell.h"
#import "UIImage+SZEarth_UIImage.h"
@implementation SZEarthMyCollectionViewCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        _botlabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.width)];
        _botlabel.textAlignment = NSTextAlignmentCenter;
        _botlabel.textColor = [UIColor blueColor];
        _botlabel.font = [UIFont systemFontOfSize:15];
        
        _dotImageView = [[UIImageView alloc]initWithFrame:CGRectMake(_botlabel.center.x-frame.size.width*0.2/2, _botlabel.frame.size.height-frame.size.width*0.2, frame.size.width*0.2, frame.size.width*0.2)];
        _dotImageView.image = [UIImage imageNamedFromCustomBundle:@"椭圆点点"];
        [self.contentView addSubview:_botlabel];
        [self.contentView addSubview:_dotImageView];
    }
    
    return self;
}

@end
