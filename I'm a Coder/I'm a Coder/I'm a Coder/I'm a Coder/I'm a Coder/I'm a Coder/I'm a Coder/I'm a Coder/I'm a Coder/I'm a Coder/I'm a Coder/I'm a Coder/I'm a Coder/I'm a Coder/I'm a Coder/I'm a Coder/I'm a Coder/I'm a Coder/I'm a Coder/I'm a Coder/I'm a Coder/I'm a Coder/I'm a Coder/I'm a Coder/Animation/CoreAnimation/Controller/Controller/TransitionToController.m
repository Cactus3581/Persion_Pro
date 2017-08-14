//
//  TransitionToController.m
//  I'm a Coder
//
//  Created by xiaruzhen on 2017/3/25.
//  Copyright © 2017年 xiaruzhen. All rights reserved.
//

#import "TransitionToController.h"
#import "GestureTransition.h"
#import "VCAnimation.h"

@interface TransitionToController ()<UIViewControllerTransitioningDelegate>
@property (nonatomic, strong) GestureTransition *gestureTransitionPresent;
@property (nonatomic, strong) GestureTransition *gestureTransitionDismiss;

@end

@implementation TransitionToController


- (instancetype)init
{
    self = [super init];
    if (self) {
        self.transitioningDelegate = self;
        self.modalPresentationStyle = UIModalPresentationCustom;
    }
    return self;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor lightGrayColor];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    button.frame = CGRectMake(80.0, 210.0, 160.0, 40.0);
    [button setTitle:@"Dismiss me" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];

    //手势操作
    _gestureTransitionDismiss = [GestureTransition interactiveTransitionWithTransitionType:GestureTransitionTypeDismiss GestureDirection:GestureDirectionDown];
    [_gestureTransitionDismiss addPanGestureForViewController:self];
}

-(void) buttonClicked:(id)sender
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(dismissButton:)]) {
        [self.delegate dismissButton:self];
    }
}
//Presented 动画效果
- (id <UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source
{
    return [VCAnimation transitionWithTransitionType:AnimationTransitionTypePresent];
    ;
}

//Dismissed 动画效果
- (id<UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed{
    
    return [VCAnimation transitionWithTransitionType:AnimationTransitionTypeDismiss];
    
    
}

////手势代理-Present
//- (id<UIViewControllerInteractiveTransitioning>)interactionControllerForPresentation:(id<UIViewControllerAnimatedTransitioning>)animator{
//    
//    GestureTransition *gestureTransitionPresent;
//    if (self.delegate && [self.delegate respondsToSelector:@selector(dismissButton:)]) {
//        gestureTransitionPresent = [_delegate interactiveTransitionForPresent];
//    }
//    
//    return gestureTransitionPresent.interation ? gestureTransitionPresent : nil;
//}



////手势代理-Dismiss
//- (id<UIViewControllerInteractiveTransitioning>)interactionControllerForDismissal:(id<UIViewControllerAnimatedTransitioning>)animator{
//    return _gestureTransitionDismiss.interation ? _gestureTransitionDismiss : nil;
//}


- (void)dealloc{
    NSLog(@"销毁了");
}

@end
