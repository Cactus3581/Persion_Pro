//
//  XRZCGUtilities.m
//  UCard
//
//  Created by xiaruzhen on 2017/3/28.
//  Copyright © 2017年 Synjones. All rights reserved.
//

#import "XRZCGUtilities.h"

/**
 获取size
 */
CGSize XRZScreenSize() {
    return [UIScreen mainScreen].bounds.size;
}

/**
 获取宽度比例
 */
CGFloat XRZScreenWidthRatio(){
    return [UIScreen mainScreen].bounds.size.width/(375.0f);
}


/**
 获取size
 */
CGSize XRZScreenSizeUnique() {
    static CGSize size;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        size = [UIScreen mainScreen].bounds.size;
        if (size.height < size.width) {
            CGFloat tmp = size.height;
            size.height = size.width;
            size.width = tmp;
        }
    });
    return size;
    
    /*
     UIInterfaceOrientation statusBarOrientation = [[UIApplication sharedApplication] statusBarOrientation];
     if (statusBarOrientation==UIInterfaceOrientationLandscapeRight ||statusBarOrientation==UIInterfaceOrientationLandscapeLeft) {
     return [UIScreen mainScreen].bounds.size.width;
     }else
     {
     return [UIScreen mainScreen].bounds.size.height;
     }
     */
}

/**
 获取宽度比例
 */
CGFloat XRZScreenWidthRatioUnique(){
    static CGFloat ratio;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        CGSize size = [UIScreen mainScreen].bounds.size;
        ratio = [UIScreen mainScreen].bounds.size.width / 375.0f;
        if (size.height < size.width) {
            ratio = size.height / 375.0f;
        }
    });
    return ratio;
    
    /*
     UIInterfaceOrientation statusBarOrientation = [[UIApplication sharedApplication] statusBarOrientation];
     if (statusBarOrientation==UIInterfaceOrientationLandscapeRight ||statusBarOrientation==UIInterfaceOrientationLandscapeLeft) {
     return [UIScreen mainScreen].bounds.size.height/(375.0);
     }else
     {
     return [UIScreen mainScreen].bounds.size.width/(375.0);
     }
     */
}

/**
 Macro
 */
CGFloat XRZScreenScale() {
    static CGFloat scale;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        scale = [UIScreen mainScreen].scale;
    });
    return scale;
}

CGRect XRZScreenBounds(){
    static CGRect bounds;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        bounds = [UIScreen mainScreen].bounds;
    });
    return bounds;
}
