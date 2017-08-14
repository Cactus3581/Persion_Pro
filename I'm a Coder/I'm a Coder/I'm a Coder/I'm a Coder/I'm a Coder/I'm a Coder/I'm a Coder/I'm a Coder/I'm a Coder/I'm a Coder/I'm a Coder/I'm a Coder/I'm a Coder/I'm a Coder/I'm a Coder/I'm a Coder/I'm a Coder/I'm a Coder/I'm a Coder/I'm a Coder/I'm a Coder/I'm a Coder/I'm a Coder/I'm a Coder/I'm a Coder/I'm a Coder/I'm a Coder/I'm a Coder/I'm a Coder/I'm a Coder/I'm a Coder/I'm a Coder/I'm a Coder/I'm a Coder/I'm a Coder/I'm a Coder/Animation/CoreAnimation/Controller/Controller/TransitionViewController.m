//
//  TransitionViewController.m
//  I'm a Coder
//
//  Created by xiaruzhen on 2017/3/25.
//  Copyright © 2017年 xiaruzhen. All rights reserved.
//

#import "TransitionViewController.h"
#import "TransitionToController.h"
#import "GestureTransition.h"
#import "VCAnimation.h"

@interface TransitionViewController ()<TransitionToControllerDelegate>

@property (nonatomic, strong) GestureTransition *gestureTransition;

@end

@implementation TransitionViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    button.frame = CGRectMake(80.0, 210.0, 160.0, 40.0);
    [button setTitle:@"Click me" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    
    NSLog(@"%.2f,%.2f,%.2f,%.2f",self.navigationController.view.frame.origin.x,self.navigationController.view.frame.origin.y,self.navigationController.view.frame.size.width,self.navigationController.view.frame.size.height);
    
    
    //手势操作
    _gestureTransition = [GestureTransition interactiveTransitionWithTransitionType:GestureTransitionTypePresent GestureDirection:GestureDirectionUp];
    typeof(self)weakSelf = self;
    _gestureTransition.presentConifg = ^(){
        [weakSelf buttonClicked:button];
    };
    [_gestureTransition addPanGestureForViewController:self.navigationController];
    
}

-(void) buttonClicked:(id)sender
{
    TransitionToController *vc2 =  [[TransitionToController alloc] init];
    vc2.delegate = self;
    [self presentViewController:vc2 animated:YES completion:nil];
}





//手势代理
//-(id<UIViewControllerInteractiveTransitioning>)interactionControllerForDismissal:(id<UIViewControllerAnimatedTransitioning>)animator {
//    return _gestureTransition;
//}


//协议方法-1
- (id<UIViewControllerInteractiveTransitioning>)interactiveTransitionForPresent{
    return _gestureTransition;
}

//协议方法-2
-(void)dismissButton:(TransitionToController *)viewController
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
