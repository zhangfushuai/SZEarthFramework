//
//  SelectSoundTypeView.h
//  smartbadminton
//
//  Created by quan on 15/10/29.
//  Copyright © 2015年 Earth. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SZEarthSelectMenuViewDelegate <NSObject>
@optional
-(void)hideSelectMenuView;

-(void)tapOkButton;

-(NSInteger)numberOfSectionsInSelectMenuView ;

-(NSInteger)numberOfRowsInSectionOfSelectMenuView:(NSInteger)section;

- (NSString*)textOfCellForRowOfSelectMenuViewAtIndexPath:(NSIndexPath *)indexPath;

-(void)selectMenuView:(UITableViewCell*)cell WillDisplayCellForRowAtIndexPath:(NSIndexPath *)indexPath;

-(void)didSelectRowOfSelectMenuViewAtIndexPath:(NSIndexPath *)indexPath;

-(void)selectMenuView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath;

@end

@interface SZEarthSelectMenuView : UIButton<UITableViewDataSource,UITableViewDelegate>


@property(strong, nonatomic) UITableView *tableView;

@property (weak,nonatomic) id<SZEarthSelectMenuViewDelegate> delegate;

@property(nonatomic,strong)NSIndexPath *lastPath;

@property NSInteger rowCounts;


- (id)initWithFrame:(CGRect)frame withRowCounts:(NSInteger)rowCounts;

@end
