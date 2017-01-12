//
//  Root_A_VC.m
//  I'm Coder
//
//  Created by xiaruzhen on 2017/1/12.
//  Copyright © 2017年 xiaruzhen. All rights reserved.
//

#import "Root_A_VC.h"
#import "Sub_A_ViewController.h"

@interface Root_A_VC ()

@end

@implementation Root_A_VC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}


- (void)push:(UIButton *)bt
{
    Sub_A_ViewController *sub_a = [[Sub_A_ViewController alloc]init];
    sub_a.hidesBottomBarWhenPushed = YES;
    sub_a.title  =@"sub_a";
    [self.navigationController pushViewController:sub_a animated:YES];
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
