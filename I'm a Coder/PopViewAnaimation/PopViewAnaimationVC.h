//
//  PopViewAnaimationVC.h
//  I'm a Coder
//
//  Created by xiaruzhen on 2017/3/25.
//  Copyright © 2017年 xiaruzhen. All rights reserved.
//

#import "BaseViewController.h"

//枚举的定义
typedef NS_ENUM(NSUInteger, XWInteractiveTransitionType) {//手势控制哪种转场
    XWInteractiveTransitionTypePresent = 0,
    XWInteractiveTransitionTypeDismiss,
    XWInteractiveTransitionTypePush,
    XWInteractiveTransitionTypePop,
};

@interface PopViewAnaimationVC : BaseViewController
//枚举的使用
- (void)initaccol:(XWInteractiveTransitionType) type;
@property (nonatomic,assign)XWInteractiveTransitionType type;
@end
