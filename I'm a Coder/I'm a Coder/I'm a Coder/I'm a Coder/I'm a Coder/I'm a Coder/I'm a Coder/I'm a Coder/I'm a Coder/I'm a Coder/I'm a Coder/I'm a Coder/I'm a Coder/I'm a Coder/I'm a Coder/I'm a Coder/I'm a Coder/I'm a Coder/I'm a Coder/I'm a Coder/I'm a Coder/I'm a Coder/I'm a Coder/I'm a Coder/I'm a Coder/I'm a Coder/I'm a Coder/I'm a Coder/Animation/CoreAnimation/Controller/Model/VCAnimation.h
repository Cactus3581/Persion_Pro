//
//  VCAnimation.h
//  I'm a Coder
//
//  Created by xiaruzhen on 2017/3/26.
//  Copyright © 2017年 xiaruzhen. All rights reserved.
//

#import "BaseModel.h"

typedef NS_ENUM(NSUInteger, animationActionType) {//手势控制哪种转场
    AnimationTransitionTypePresent = 0,
    AnimationTransitionTypeDismiss,
    AnimationTransitionTypePush,
    AnimationTransitionTypePop,
};

@interface VCAnimation : BaseModel<UIViewControllerAnimatedTransitioning>

@property (nonatomic,assign) animationActionType type;

+ (instancetype)transitionWithTransitionType:(animationActionType)type;

@end
