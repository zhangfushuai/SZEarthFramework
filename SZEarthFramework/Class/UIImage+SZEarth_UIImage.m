//
//  UIImage+SZEarth_UIImage.m
//  SZEarthFramework
//
//  Created by Earth on 16/3/18.
//  Copyright © 2016年 Earth. All rights reserved.
//

#import "UIImage+SZEarth_UIImage.h"

@implementation UIImage (SZEarth_UIImage)

+(UIImage *) imageNamedFromCustomBundle:(NSString *)imgName
{
    NSBundle *mainbundle = [NSBundle mainBundle];
    NSString *bundle_path = [mainbundle.resourcePath stringByAppendingPathComponent:@"Frameworks/SZEarthFramework.framework/SZEarthFramework.bundle"];
    NSBundle *bundle = [NSBundle bundleWithPath: bundle_path];
    NSString *tempImgPath = [NSString stringWithFormat:@"image/%@",imgName];
    NSString *img_path = [bundle pathForResource:tempImgPath ofType:@"png"];
    UIImage* image = [UIImage imageWithContentsOfFile:img_path];
    return image;
}

@end
