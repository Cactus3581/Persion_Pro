//
//  BaseNavigationVC.m
//  I'm Coder
//
//  Created by xiaruzhen on 2017/1/12.
//  Copyright © 2017年 xiaruzhen. All rights reserved.
//

#import "BaseNavigationVC.h"

@interface BaseNavigationVC ()

@end

@implementation BaseNavigationVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIButton *pushBt = [UIButton buttonWithType:UIButtonTypeSystem];
    pushBt.frame = CGRectMake(0, 0, 30, 30);
    [pushBt setTitle:@"push" forState:UIControlStateNormal];
    [pushBt addTarget:self action:@selector(push:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:pushBt];
    self.navigationItem.rightBarButtonItem = rightItem;
}

- (void)push:(UIButton *)bt
{
    
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
