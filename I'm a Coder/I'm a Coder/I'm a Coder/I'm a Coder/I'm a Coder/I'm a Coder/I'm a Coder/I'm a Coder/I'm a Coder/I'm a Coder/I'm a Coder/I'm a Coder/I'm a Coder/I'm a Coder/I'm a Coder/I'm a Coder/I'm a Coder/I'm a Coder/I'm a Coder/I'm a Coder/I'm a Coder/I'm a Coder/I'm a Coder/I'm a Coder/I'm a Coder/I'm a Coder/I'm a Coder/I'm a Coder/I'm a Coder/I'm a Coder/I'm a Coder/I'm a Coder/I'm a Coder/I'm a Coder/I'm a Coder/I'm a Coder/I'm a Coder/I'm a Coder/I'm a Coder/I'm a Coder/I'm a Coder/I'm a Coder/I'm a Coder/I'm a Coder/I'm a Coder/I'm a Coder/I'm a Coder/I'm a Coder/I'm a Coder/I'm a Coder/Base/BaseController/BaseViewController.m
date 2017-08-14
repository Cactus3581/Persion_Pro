//
//  BaseViewController.m
//  I'm Coder
//
//  Created by xiaruzhen on 2017/1/12.
//  Copyright © 2017年 xiaruzhen. All rights reserved.
//

#import "BaseViewController.h"

@interface BaseViewController ()

@property (nonatomic,strong) UIButton *pushBt;
@property (nonatomic,strong) UIButton *popBt;
@end

@implementation BaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self creatRightItem];
}
- (void)creatRightItem
{
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:self.pushBt];
    self.navigationItem.rightBarButtonItem = rightItem;
    
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithCustomView:self.popBt];
    self.navigationItem.leftBarButtonItem = leftItem;
}
- (UIButton *)pushBt
{
    if (!_pushBt) {
        _pushBt = [UIButton buttonWithType:UIButtonTypeSystem];
        _pushBt.frame = CGRectMake(0, 0, 40, 40);
        [_pushBt setTitle:@"push" forState:UIControlStateNormal];
        [_pushBt addTarget:self action:@selector(push:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return _pushBt;
}

- (UIButton *)popBt
{
    if (!_popBt) {
        _popBt = [UIButton buttonWithType:UIButtonTypeSystem];
        _popBt.frame = CGRectMake(0, 0, 40, 40);
        [_popBt setTitle:@"pop" forState:UIControlStateNormal];
        [_popBt addTarget:self action:@selector(pop:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _popBt;
}

- (void)push:(UIButton *)bt
{
    
}

- (void)pop:(UIButton *)bt
{
    [self.navigationController popViewControllerAnimated:YES];
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
