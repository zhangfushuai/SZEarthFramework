//
//  SelectSoundTypeView.m
//  smartbadminton
//
//  Created by quan on 15/10/29.
//  Copyright © 2015年 Earth. All rights reserved.
//

#import "SZEarthSelectMenuView.h"
#import "UIImage+SZEarth_UIImage.h"

@implementation SZEarthSelectMenuView
NSInteger height;
@synthesize delegate = _delegate;
@synthesize lastPath =_lastPath;
- (id)initWithFrame:(CGRect)frame withRowCounts:(NSInteger)rowCounts
{
    self = [super initWithFrame:frame];
    if (self) {
        //
        _rowCounts = rowCounts;
        height = frame.size.height / 2.5;
        self.tableView = [[UITableView alloc]initWithFrame: CGRectMake(0, 0, frame.size.width * 0.7, height ) style:UITableViewStylePlain];
        self.tableView.rowHeight = height / (_rowCounts + 1);
        self.tableView.layer.cornerRadius = 20;
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
        self.tableView.center = self.center;
        self.tableView.scrollEnabled = NO;
        self.backgroundColor = [UIColor colorWithWhite:0.8 alpha:0.6];
//        [self addTarget:self action:@selector(hideView) forControlEvents:UIControlEventTouchDown];
        [self addSubview:self.tableView];
    }
    return self;
}

-(void)hideView {
    if (_delegate != nil && [_delegate respondsToSelector:@selector(hideSelectMenuView)]) {
        [_delegate hideSelectMenuView];
    }
    self.hidden = YES;
}

-(void)touchOkButton {
    if (_delegate != nil && [_delegate respondsToSelector:@selector(tapOkButton)]) {
        [_delegate tapOkButton];
    }
//    self.hidden = YES;
}

//-(NSInteger)numberOfSectionsInSelectMenuView ;
//
//-(NSInteger)numberOfRowsInSectionOfSelectMenuView:(NSInteger)section;
//
//- (NSString*)textOfCellForRowOfSelectMenuViewAtIndexPath:(NSIndexPath *)indexPath;
//
//-(void)didSelectRowOfSelectMenuViewAtIndexPath:(NSIndexPath *)indexPath;

//mark: - uitableview datasource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (_delegate && [_delegate respondsToSelector:@selector(numberOfSectionsInSelectMenuView)]) {
        return [_delegate numberOfSectionsInSelectMenuView];
    }
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (_delegate && [_delegate respondsToSelector:@selector(numberOfRowsInSectionOfSelectMenuView:)]) {
        return [_delegate numberOfRowsInSectionOfSelectMenuView:section];
    }
    return _rowCounts;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return height / _rowCounts;
}


-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView *footerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width * 0.7, height / (_rowCounts+1))];
    UIButton *OKButton = [[UIButton alloc]initWithFrame:CGRectMake(20, footerView.frame.size.height*0.3, self.frame.size.width * 0.2, height / (_rowCounts+1) - footerView.frame.size.height*0.3)];
    [OKButton setTitle:@"确定" forState:UIControlStateNormal];
    OKButton.backgroundColor = [UIColor colorWithRed:249/255.0 green:94/255.0 blue:0 alpha:1.0];
    OKButton.layer.cornerRadius = 10;
    [OKButton addTarget:self action:@selector(touchOkButton) forControlEvents:UIControlEventTouchDown];
    
    UIButton *cancelButton = [[UIButton alloc]initWithFrame:CGRectMake(self.frame.size.width * 0.7 - self.frame.size.width * 0.2 - 20, footerView.frame.size.height*0.3, self.frame.size.width * 0.2, height / (_rowCounts+1) - footerView.frame.size.height*0.3)];
    [cancelButton setTitle:@"取消" forState:UIControlStateNormal];
    cancelButton.backgroundColor = [UIColor colorWithRed:249/255.0 green:94/255.0 blue:0 alpha:1.0];
    cancelButton.layer.cornerRadius = 10;
    [cancelButton addTarget:self action:@selector(hideView) forControlEvents:UIControlEventTouchDown];
    
    [footerView addSubview:OKButton];
    [footerView addSubview:cancelButton];
    
    return footerView;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell==nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    
    if (indexPath.row == 0) {
        cell.textLabel.textAlignment = NSTextAlignmentCenter;
        cell.userInteractionEnabled = NO; 
    } else {
        UIImageView *accessoryView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 20, 20)];
        accessoryView.image = [UIImage imageNamedFromCustomBundle:@"YES"];
        accessoryView.tag = indexPath.row;
        cell.accessoryView = accessoryView;
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (_delegate && [_delegate respondsToSelector:@selector(textOfCellForRowOfSelectMenuViewAtIndexPath:)]) {
        cell.textLabel.text = [_delegate textOfCellForRowOfSelectMenuViewAtIndexPath:indexPath];
    } else {
//        cell.textLabel.text = @"选择提示语音";
    }
    
    return cell;
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (_delegate && [_delegate respondsToSelector:@selector(selectMenuView: WillDisplayCellForRowAtIndexPath:)]) {
        [_delegate selectMenuView:cell WillDisplayCellForRowAtIndexPath:(NSIndexPath *)indexPath];
    } else {
        if (indexPath.row==1) {
            if ([[NSUserDefaults standardUserDefaults] integerForKey:@"isBoBaoSpeed"] == 0) {
                ((UIImageView*)cell.accessoryView).image = [UIImage imageNamedFromCustomBundle:@"YES"];
            } else {
                ((UIImageView*)cell.accessoryView).image = [UIImage imageNamedFromCustomBundle:@"NO"];
            }
        }
        if (indexPath.row == 2) {
            if ([[NSUserDefaults standardUserDefaults] integerForKey:@"isBoBaoLiDu"] == 0) {
                ((UIImageView*)cell.accessoryView).image = [UIImage imageNamedFromCustomBundle:@"YES"];
            } else {
                ((UIImageView*)cell.accessoryView).image = [UIImage imageNamedFromCustomBundle:@"NO"];
            }
        }
        if (indexPath.row == 3) {
            if ([[NSUserDefaults standardUserDefaults] integerForKey:@"isBoBaoJiQiuType"] == 0) {
                ((UIImageView*)cell.accessoryView).image = [UIImage imageNamedFromCustomBundle:@"YES"];
            } else {
                ((UIImageView*)cell.accessoryView).image = [UIImage imageNamedFromCustomBundle:@"NO"];
            }
        }
    }
    
    
}

//mark: - uitableview delegate

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    if (_delegate && [_delegate respondsToSelector:@selector(didSelectRowOfSelectMenuViewAtIndexPath:)]) {
        [_delegate didSelectRowOfSelectMenuViewAtIndexPath:indexPath];
    }
    
    
}

-(void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (_delegate && [_delegate respondsToSelector:@selector(selectMenuView:didDeselectRowAtIndexPath:)]) {
        [_delegate selectMenuView:tableView didDeselectRowAtIndexPath:indexPath];
    }
}

@end
