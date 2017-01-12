//
//  RootTabBarViewController.m
//  I'm Coder
//
//  Created by xiaruzhen on 2017/1/12.
//  Copyright © 2017年 xiaruzhen. All rights reserved.
//

#import "RootTabBarViewController.h"
#import "Root_A_VC.h"
#import "Root_B_VC.h"
#import "Root_C_VC.h"
#import "Root_D_VC.h"
#import "Root_E_VC.h"
#import "BaseNavigationVC.h"

@interface RootTabBarViewController ()

@end

@implementation RootTabBarViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self setUpAllChildViewController];
    
    
}

/**
 *  添加所有子控制器方法
 */
- (void)setUpAllChildViewController{
     Root_A_VC *oneVC = [[Root_A_VC alloc]init];
     [self setUpOneChildViewController:oneVC image:[UIImage imageNamed:@""] title:@"A"];
     Root_B_VC *twoVC = [[Root_B_VC alloc]init];
     [self setUpOneChildViewController:twoVC image:[UIImage imageNamed:@""] title:@"B"];
     Root_C_VC *threeVC = [[Root_C_VC alloc]init];
     [self setUpOneChildViewController:threeVC image:[UIImage imageNamed:@""] title:@"C"];
     Root_D_VC *fourVC = [[Root_D_VC alloc]init];
     [self setUpOneChildViewController:fourVC image:[UIImage imageNamed:@""] title:@"D"];
    Root_E_VC *fiveVC = [[Root_E_VC alloc]init];
    [self setUpOneChildViewController:fiveVC image:[UIImage imageNamed:@""] title:@"E"];
 }

/**
   *  添加一个子控制器的方法
 */
- (void)setUpOneChildViewController:(UIViewController *)viewController image:(UIImage *)image title:(NSString *)title{
    
    viewController.view.backgroundColor = [UIColor whiteColor];
    BaseNavigationVC *navC = [[BaseNavigationVC alloc]initWithRootViewController:viewController];
    navC.title = title;
    navC.tabBarItem.image = image;
//    [navC.navigationBar setBackgroundImage:[UIImage imageNamed:@"commentary_num_bg"] forBarMetrics:UIBarMetricsDefault];
    viewController.navigationItem.title = title;
    [self addChildViewController:navC];
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
