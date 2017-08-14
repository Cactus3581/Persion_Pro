//
//  GestureTransition.h
//  I'm a Coder
//
//  Created by xiaruzhen on 2017/3/26.
//  Copyright © 2017年 xiaruzhen. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^GestureConifg)();

typedef NS_ENUM(NSUInteger, GestureTransitionDirection) {//手势的方向
    GestureDirectionLeft = 0,
    GestureDirectionRight,
    GestureDirectionUp,
    GestureDirectionDown
};

typedef NS_ENUM(NSUInteger, GestureTransitionType) {//手势控制哪种转场
    GestureTransitionTypePresent = 0,
    GestureTransitionTypeDismiss,
    GestureTransitionTypePush,
    GestureTransitionTypePop,
};

@interface GestureTransition : UIPercentDrivenInteractiveTransition


/**初始化对象*/
+ (instancetype)interactiveTransitionWithTransitionType:(GestureTransitionType)type GestureDirection:(GestureTransitionDirection)direction;
- (instancetype)initWithTransitionType:(GestureTransitionType)type GestureDirection:(GestureTransitionDirection)direction;

/** 给传入的控制器添加手势*/
- (void)addPanGestureForViewController:(UIViewController *)viewController;


/**记录是否开始手势，判断pop操作是手势触发还是返回键触发*/
@property (nonatomic, assign) BOOL interation;

/**促发手势present的时候的config，config中初始化并present需要弹出的控制器*/
@property (nonatomic, copy) GestureConifg presentConifg;

/**促发手势push的时候的config，config中初始化并push需要弹出的控制器*/
@property (nonatomic, copy) GestureConifg pushConifg;

@end
