//
//  UIFont+XRZFont.m
//  I'm a Coder
//
//  Created by xiaruzhen on 2017/3/19.
//  Copyright © 2017年 xiaruzhen. All rights reserved.
//

#import "UIFont+XRZFont.h"

@implementation UIFont (XRZFont)
//static inline CGFloat widthRatio(CGFloat number){
//    return number * XWScreenWidthRatio();
//}
//
CGFloat XWScreenWidthRatio(){
    static CGFloat ratio;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        ratio = [UIScreen mainScreen].bounds.size.width / 375.0f;
    });
    return ratio;
}


@end
