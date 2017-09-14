//
//  UIButton+KSEnlargeEdge.h
//  PowerWord7
//
//  Created by xiaruzhen on 2017/9/8.
//  Copyright © 2017年 Kingsoft. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIButton (KSEnlargeEdge)
/**
 增大点击区域
 @param size 上左下右的增大量
 */
- (void)be_setEnlargeEdge:(CGFloat)size;

/**
 增大点击区域
 @param size 上左下右的增大量
 */
- (void)be_setEnlargeEdgeWithTop:(CGFloat)top right:(CGFloat)right bottom:(CGFloat)bottom left:(CGFloat)left;
@end
