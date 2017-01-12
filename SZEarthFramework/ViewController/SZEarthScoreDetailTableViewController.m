//
//  ScoreDetailTableViewController.m
//  exampleSDK
//
//  Created by quan on 16/3/6.
//  Copyright © 2016年 Earth. All rights reserved.
//

#import "SZEarthScoreDetailTableViewController.h"
#import "UIImage+SZEarth_UIImage.h"

@interface SZEarthScoreDetailTableViewController ()

@end

@implementation SZEarthScoreDetailTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [NSString stringWithFormat:@"%d",_gaoWeiJiQiuTotalSccore];
    
//    int totalScore = _gaoWeiJiQiuTotalSccore + _cuoQiuTotalSccore + _diaoQiuTotalSccore + _tuiQiuTotalSccore + _tiaoQiuTotalSccore;
    
    _styleDataArray = [[NSMutableArray alloc]initWithObjects:@"类型", @"高位", @"挑球", @"搓球", @"吊球", @"推球", nil];
    _zhengShouDataArray = [[NSMutableArray alloc]initWithObjects:@"正手", [NSString stringWithFormat:@"%d",_zsGaoWeiJiQiuScore], [NSString stringWithFormat:@"%d", _zsTiaoQiuTotalScore], [NSString stringWithFormat:@"%d", _zsCuoQiuTotalScore], [NSString stringWithFormat:@"%d", _zsDiaoQiuTotalScore], [NSString stringWithFormat:@"%d", _zsTuiQiuTotalScore], nil];
    _fanShouDataArray = [[NSMutableArray alloc]initWithObjects:@"反手", [NSString stringWithFormat:@"%d",_fsGaoWeiJiQiuScore], [NSString stringWithFormat:@"%d", _fsTiaoQiuTotalScore], [NSString stringWithFormat:@"%d", _fsCuoQiuTotalScore], [NSString stringWithFormat:@"%d", _fsDiaoQiuTotalScore], [NSString stringWithFormat:@"%d", _fsTuiQiuTotalScore], nil];
    _totalDataArray = [[NSMutableArray alloc]initWithObjects:@"总计", [NSString stringWithFormat:@"%d分", _gaoWeiJiQiuTotalSccore], [NSString stringWithFormat:@"%d分", _tiaoQiuTotalSccore], [NSString stringWithFormat:@"%d分", _cuoQiuTotalSccore], [NSString stringWithFormat:@"%d分", _diaoQiuTotalSccore], [NSString stringWithFormat:@"%d分", _tuiQiuTotalSccore], nil];
    
    self.tableView.tableHeaderView = [self createHeaderView];
    
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationItem.title = @"总分详情";
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(UIView*)createHeaderView {
    UIView *headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height*0.25)];
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(self.view.frame.size.width*0.5-headerView.frame.size.height*0.5*0.5, headerView.frame.size.height*0.1, headerView.frame.size.height*0.5, headerView.frame.size.height*0.5)];
    UILabel *tishiLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, headerView.frame.size.height*0.6, self.view.frame.size.width, headerView.frame.size.height*0.2)];
    tishiLabel.text = @"恭喜你!获得";
    tishiLabel.textColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.7];
    UILabel *scoreLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, headerView.frame.size.height*0.78, self.view.frame.size.width, headerView.frame.size.height*0.2)];
    scoreLabel.text = [NSString stringWithFormat:@"%d分",_gaoWeiJiQiuTotalSccore+_cuoQiuTotalSccore+_tiaoQiuTotalSccore+_tuiQiuTotalSccore+_diaoQiuTotalSccore];
//    scoreLabel.text = @"260分";
    
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@", scoreLabel.text]];
    [str addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:249/255.0 green:94/255.0 blue:0 alpha:1.0] range:NSMakeRange(0,str.length)];
    [str addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.5] range:NSMakeRange(str.length-1,1)];
    [str addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:26] range:NSMakeRange(0,str.length-1)];
    scoreLabel.attributedText = str;
    
    imageView.image = [UIImage imageNamedFromCustomBundle:@"jiangBei"];
    
    tishiLabel.textAlignment = NSTextAlignmentCenter;
    scoreLabel.textAlignment = NSTextAlignmentCenter;
    
    [headerView addSubview:imageView];
    [headerView addSubview:tishiLabel];
    [headerView addSubview:scoreLabel];
    headerView.backgroundColor = [UIColor colorWithWhite:0.9 alpha:1.0];
    return headerView;
    
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 6;
}

//-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
//    return 1;
//}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *reuseID = @"CellID";
    SZEarthScoreDetailTableViewCell *cell = [[SZEarthScoreDetailTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseID frame:self.view.frame];
    
    cell.styleLabel.text = _styleDataArray[indexPath.row];
    cell.zhengShouLabel.text = _zhengShouDataArray[indexPath.row];
    cell.fanShouLabel.text = _fanShouDataArray[indexPath.row];
    cell.totalLabel.text = _totalDataArray[indexPath.row];
    if (indexPath.row>0) {
        cell.styleLabel.textColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.7];
        cell.zhengShouLabel.textColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
        cell.fanShouLabel.textColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
        NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@", cell.totalLabel.text]];
        [str addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:249/255.0 green:94/255.0 blue:0 alpha:1.0] range:NSMakeRange(0,str.length)];
        [str addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.3] range:NSMakeRange(str.length-1,1)];
        [str addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:26] range:NSMakeRange(0,str.length-1)];
        cell.totalLabel.attributedText = str;
        
    }else {
        cell.styleLabel.textColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.7];
        cell.zhengShouLabel.textColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.7];
        cell.fanShouLabel.textColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.7];
        cell.totalLabel.textColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.7];
    }
    cell.selectionStyle =  UITableViewCellSelectionStyleNone;
    return cell;
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
