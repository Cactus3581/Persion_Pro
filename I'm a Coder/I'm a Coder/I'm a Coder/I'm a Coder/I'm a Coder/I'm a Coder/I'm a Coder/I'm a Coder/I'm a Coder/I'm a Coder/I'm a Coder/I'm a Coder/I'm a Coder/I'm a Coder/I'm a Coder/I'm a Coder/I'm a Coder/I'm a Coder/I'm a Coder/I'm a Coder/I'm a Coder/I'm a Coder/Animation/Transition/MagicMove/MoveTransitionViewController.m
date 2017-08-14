//
//  MoveTransitionViewController.m
//  I'm a Coder
//
//  Created by xiaruzhen on 2017/3/26.
//  Copyright © 2017年 xiaruzhen. All rights reserved.
//

#import "MoveTransitionViewController.h"

@interface MoveTransitionViewController ()

@end

@implementation MoveTransitionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"神奇移动效果列表";
    self.dataArray = @[@"一般效果",@"九宫格效果"];
    self.tableview.rowHeight = 66;
}

- (void)configCell:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

- (void)didSelectableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSArray *array = @[@"",@""];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
