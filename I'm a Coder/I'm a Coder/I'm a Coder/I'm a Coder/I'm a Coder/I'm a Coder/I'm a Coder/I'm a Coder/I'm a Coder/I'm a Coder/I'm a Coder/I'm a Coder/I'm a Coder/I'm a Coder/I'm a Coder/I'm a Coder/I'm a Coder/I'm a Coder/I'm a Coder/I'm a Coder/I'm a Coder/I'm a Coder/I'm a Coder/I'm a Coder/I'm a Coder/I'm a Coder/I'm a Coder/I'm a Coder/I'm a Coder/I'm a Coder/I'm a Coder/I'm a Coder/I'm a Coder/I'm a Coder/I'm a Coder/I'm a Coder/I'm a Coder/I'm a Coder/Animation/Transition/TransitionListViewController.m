//
//  TransitionListViewController.m
//  I'm a Coder
//
//  Created by xiaruzhen on 2017/3/26.
//  Copyright © 2017年 xiaruzhen. All rights reserved.
//

#import "TransitionListViewController.h"

@interface TransitionListViewController ()

@end

@implementation TransitionListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"效果列表";
    self.dataArray = @[@"神奇移动",@"popView"];
    self.tableview.rowHeight = 66;
}


- (void)configCell:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}
- (void)didSelectableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSArray *array = @[@""];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
