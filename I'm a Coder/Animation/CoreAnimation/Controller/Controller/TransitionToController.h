//
//  TransitionToController.h
//  I'm a Coder
//
//  Created by xiaruzhen on 2017/3/25.
//  Copyright © 2017年 xiaruzhen. All rights reserved.
//

#import "BaseViewController.h"
@class TransitionToController;
@protocol TransitionToControllerDelegate <NSObject>

-(void) dismissButton:(TransitionToController *)viewController;

- (id<UIViewControllerInteractiveTransitioning>)interactiveTransitionForPresent;

@end
@interface TransitionToController : BaseViewController
@property (nonatomic, weak) id<TransitionToControllerDelegate> delegate;

@end
