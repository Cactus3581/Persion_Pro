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
#import "DataBaseModel.h"
#import "Masonry.h"

#include "suanfa.h"


@interface RootTabBarViewController ()

@end

@implementation RootTabBarViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    DataBaseModel *model = [[DataBaseModel alloc]init];
    BOOL boola = [model isKindOfClass:[DataBaseModel class]];
    BOOL boolb = [DataBaseModel isKindOfClass:[DataBaseModel class]];
    BOOL boolc = [model isKindOfClass:[NSObject class]];
//    BOOL boolc = [DataBaseModel isKindOfClass:DataBaseModel];
    
    BOOL boold = [model isMemberOfClass:[DataBaseModel class]];
    BOOL boole = [model isMemberOfClass:[NSObject class]];
    BOOL boolf = [DataBaseModel isMemberOfClass:[DataBaseModel class]];

    NSLog(@"%d,%d,%d,%d,%d,%d",boola,boolb,boolc,boold,boole,boolf);
    
    [self setUpAllChildViewController];
    
    //算法
    [self algorithm];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}
CGFloat XWScreenScale() {
    static CGFloat scale;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        scale = [UIScreen mainScreen].scale;
    });
    return scale;
}
- (void)algorithm
{
//    get_next1(7);
//    char str[] = {@"a",@"b",@"d",@"c",@"e",@"f",@"d",};
//    char str1[] = {@"e",@"f",@"d"};
//
//    get_next(str,str1,7);
    
    int array[10] = {111,22,323,42,51,162,73,181,91,100};
    
    //计算C语言中的数字长度
    int length = sizeof(array) / sizeof(array[0]);
    NSLog(@"%d",length);
    
    //冒泡
    int *bubble_sortArray = bubble_sort(array,length);
    for (int i = 0; i<length-1; i++) {
        printf("\n%d\n",bubble_sortArray[i]);
    }
    
    //递归-斐波那契奇数列
    int fibResult =  fib(5);
    printf("\n%d\n",fibResult);
    
    for (int i = 0; i<length; i++) {
        printf("\n%d\n",array[i]);
    }
    //快速排序
    quicksort(array,0,length-1);
    
    for (int i = 0; i<length; i++) {
        printf("\n%d\n",array[i]);
    }
    
    //二分查找-递归方法
    int binarySearch1Result = binarySearch1(array,0,length-1,array[4]);
    NSLog(@"%d",binarySearch1Result);

    //二分查找-非递归方法
    int binarySearch2Result = binarySearch2(array,0,length-1,array[6]);
    NSLog(@"%d",binarySearch2Result);
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
@end
