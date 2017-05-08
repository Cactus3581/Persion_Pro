//
//  Root_A_VC.m
//  I'm Coder
//
//  Created by xiaruzhen on 2017/1/12.
//  Copyright © 2017年 xiaruzhen. All rights reserved.
//

#import "Root_A_VC.h"
#import "Sub_A_ViewController.h"
#import "Sub_B_ViewController.h"
#import "Sub_C_ViewController.h"
#import "BaseTableViewCell.h"
#import "BlockAnimatonVC.h"
#import "CoreAnimationVC.h"
#import "DatabaseViewController.h"
#import "AboutCopyViewController.h"
#import "BlockViewController.h"
#import "NetRequestViewController.h"
#import "RunTimeViewController.h"
#import "DataPersistenceVC.h"
#import "MultithReadingViewController.h"
#import "Static_ConstViewController.h"
#import "XRZCatergory.h"
#import "MasonryViewController.h"
#import "PopViewAnaimationVC.h"
#import "TransitionViewController.h"

#import "TransitionListViewController.h"
#import "KVCViewController.h"

@interface Root_A_VC ()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic,strong) NSArray *array;
@property (nonatomic,strong) Sub_A_ViewController *sub_A_ViewController;



@end

@implementation Root_A_VC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.array = @[@"视图与图层",@"CALayer",@"drawRect_cg",@"drawLayer_oc",@"drawLayer_cg"];
    self.navigationItem.leftBarButtonItem = nil;
    self.navigationItem.rightBarButtonItem = nil;
}



- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.array.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"BaseTableViewCell";
    BaseTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell==nil) {
        cell = [[BaseTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
//        cell.textLabel.font = XFont(2);
    }
//    cell.textLabel.text = self.array[indexPath.row];
    return cell;

}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"heightForRowAtIndexPath = %.2f",widthRatio(230));
    return widthRatio(260);
}



- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
//    Sub_A_ViewController *sub_a = [[Sub_A_ViewController alloc]init];
//    Sub_B_ViewController *sub_a = [[Sub_B_ViewController alloc]init];
//    Sub_C_ViewController *sub_a = [[Sub_C_ViewController alloc]init];
    
//    BlockAnimatonVC *sub_a = [[BlockAnimatonVC alloc]init];
//    CoreAnimationVC *sub_a = [[CoreAnimationVC alloc]init];
//
//
//
//    DatabaseViewController *sub_a = [[DatabaseViewController alloc]init];
    
    
    
//    AboutCopyViewController *sub_a = [[AboutCopyViewController alloc]init];
//    sub_a.direction = 3;
//    sub_a.dir = 1|2;
    
    
    
//    BlockViewController *sub_a = [[BlockViewController alloc]init];
//    NetRequestViewController *sub_a = [[NetRequestViewController alloc]init];
    
//    RunTimeViewController *sub_a = [[RunTimeViewController alloc]init];
    
//    MultithReadingViewController *sub_a = [[MultithReadingViewController alloc]init];

    
//    DataPersistenceVC *sub_a = [[DataPersistenceVC alloc]init];

//    Static_ConstViewController *sub_a = [[Static_ConstViewController alloc]init];

    MasonryViewController *sub_a = [[MasonryViewController alloc]init];


//    PopViewAnaimationVC *sub_a = [[PopViewAnaimationVC alloc]init];
//    [sub_a initaccol:XWInteractiveTransitionTypePop];
//    XWInteractiveTransitionType type = XWInteractiveTransitionTypePop;
//    sub_a.type =     XWInteractiveTransitionTypeDismiss|XWInteractiveTransitionTypePush|XWInteractiveTransitionTypePop,
//    
////    sub_a.XWInteractiveTransitionType = XWInteractiveTransitionTypePush;
    
//    TransitionViewController *sub_a = [[TransitionViewController alloc]init];
//    TransitionListViewController *sub_a = [[TransitionListViewController alloc]init];
    
//    KVCViewController *sub_a = [[KVCViewController alloc]init];


    sub_a.hidesBottomBarWhenPushed = YES;

    [self.navigationController pushViewController:sub_a animated:YES];
    
//    [self transitionAnimation];
}


- (void)transitionAnimation
{
    CATransition  *transition = [CATransition animation];
//    2.设置动画时长,设置代理人
    transition.duration = 1.0f;
    transition.delegate = self;
//    3.设置切换速度效果
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];

    transition.type = kCATransitionFade;

    transition.subtype = kCATransitionFromTop;//顶部
    CoreAnimationVC *sub_a = [[CoreAnimationVC alloc]init];
    
    

    sub_a.hidesBottomBarWhenPushed = YES;
    
    [self.navigationController.view.layer addAnimation:transition forKey:nil];
    [self.navigationController pushViewController:sub_a animated:NO];
}
- (Sub_A_ViewController *)sub_A_ViewController
{
    if (!_sub_A_ViewController) {
        _sub_A_ViewController =  [[Sub_A_ViewController alloc]init];
    }
    return _sub_A_ViewController;
}

- (NSArray *)array
{
    if (!_array) {
        _array = [NSArray array];
    }
    return _array;
}



- (void)push:(UIButton *)bt
{
    Sub_A_ViewController *sub_a = [[Sub_A_ViewController alloc]init];
    sub_a.hidesBottomBarWhenPushed = YES;
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
