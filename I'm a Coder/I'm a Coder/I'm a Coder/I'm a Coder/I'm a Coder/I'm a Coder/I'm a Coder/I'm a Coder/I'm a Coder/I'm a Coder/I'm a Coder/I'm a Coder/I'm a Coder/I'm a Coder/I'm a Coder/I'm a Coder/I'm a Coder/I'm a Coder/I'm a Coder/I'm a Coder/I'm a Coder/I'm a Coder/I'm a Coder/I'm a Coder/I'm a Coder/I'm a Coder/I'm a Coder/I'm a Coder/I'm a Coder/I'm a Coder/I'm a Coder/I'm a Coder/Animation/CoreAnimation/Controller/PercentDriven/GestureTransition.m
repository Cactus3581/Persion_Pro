//
//  GestureTransition.m
//  I'm a Coder
//
//  Created by xiaruzhen on 2017/3/26.
//  Copyright © 2017年 xiaruzhen. All rights reserved.
//

#import "GestureTransition.h"

@interface GestureTransition()

@property (nonatomic, weak) UIViewController *vc;
/**手势方向*/
@property (nonatomic, assign) GestureTransitionDirection direction;
/**手势类型*/
@property (nonatomic, assign) GestureTransitionType type;

@end

@implementation GestureTransition

+ (instancetype)interactiveTransitionWithTransitionType:(GestureTransitionType)type GestureDirection:(GestureTransitionDirection)direction{
    
    return [[self alloc] initWithTransitionType:type GestureDirection:direction];
}

- (instancetype)initWithTransitionType:(GestureTransitionType)type GestureDirection:(GestureTransitionDirection)direction{
    self = [super init];
    if (self) {
        _direction = direction;
        _type = type;
    }
    return self;
}


- (void)addPanGestureForViewController:(UIViewController *)viewController{
    
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handleGesture:)];
    
    self.vc = viewController;
    [viewController.view addGestureRecognizer:pan];
}

/**
 *  手势过渡的过程
 */
- (void)handleGesture:(UIPanGestureRecognizer *)panGesture{
    //手势百分比
    CGFloat persent = 0;
    switch (_direction) {
        case GestureDirectionLeft:{
            CGFloat transitionX = -[panGesture translationInView:panGesture.view].x;
            persent = transitionX / panGesture.view.frame.size.width;
        }
            break;
        case GestureDirectionRight:{
            CGFloat transitionX = [panGesture translationInView:panGesture.view].x;
            persent = transitionX / panGesture.view.frame.size.width;
        }
            break;
        case GestureDirectionUp:{
            CGFloat transitionY = -[panGesture translationInView:panGesture.view].y;
            persent = transitionY / panGesture.view.frame.size.width;
        }
            break;
        case GestureDirectionDown:{
            CGFloat transitionY = [panGesture translationInView:panGesture.view].y;
            persent = transitionY / panGesture.view.frame.size.width;
        }
            break;
    }
    switch (panGesture.state) {
        case UIGestureRecognizerStateBegan:
            //手势开始的时候标记手势状态，并开始相应的事件
            self.interation = YES;
            [self startGesture];
            break;
        case UIGestureRecognizerStateChanged:{
            //手势过程中，通过updateInteractiveTransition设置pop过程进行的百分比
            [self updateInteractiveTransition:persent];
            break;
        }
        case UIGestureRecognizerStateEnded:{
            //手势完成后结束标记并
            self.interation = NO;
            //判断移动距离是否过半，过则finishInteractiveTransition完成转场操作，否者取消转场操作
            if (persent > 0.5) {
                [self finishInteractiveTransition];
            }else{
                [self cancelInteractiveTransition];
            }
            break;
        }
        default:
            break;
    }
}

- (void)startGesture{
    switch (_type) {
        case GestureTransitionTypePresent:{
            if (_presentConifg) {
                _presentConifg();
            }
        }
            break;
            
        case GestureTransitionTypeDismiss:
            [_vc dismissViewControllerAnimated:YES completion:nil];
            break;
        case GestureTransitionTypePush:{
            if (_pushConifg) {
                _pushConifg();
            }
        }
            break;
        case GestureTransitionTypePop:
            [_vc.navigationController popViewControllerAnimated:YES];
            break;
    }
}


@end
