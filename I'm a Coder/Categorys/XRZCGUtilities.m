//
//  XRZCGUtilities.m
//  UCard
//
//  Created by xiaruzhen on 2017/3/28.
//  Copyright © 2017年 Synjones. All rights reserved.
//

#import "XRZCGUtilities.h"

/**
 获取宽度／高度
 */
CGFloat getWidth(){
    return [UIScreen mainScreen].bounds.size.width;
}

CGFloat getHeight(){
    return [UIScreen mainScreen].bounds.size.height;

}

CGFloat getWidthUnique(){
    UIInterfaceOrientation statusBarOrientation = [[UIApplication sharedApplication] statusBarOrientation];
    if (statusBarOrientation==UIInterfaceOrientationLandscapeRight ||statusBarOrientation==UIInterfaceOrientationLandscapeLeft) {
        return [UIScreen mainScreen].bounds.size.height;
    }else
    {
        return [UIScreen mainScreen].bounds.size.width;
    }
}

CGFloat getHeightUnique(){
    UIInterfaceOrientation statusBarOrientation = [[UIApplication sharedApplication] statusBarOrientation];
    if (statusBarOrientation==UIInterfaceOrientationLandscapeRight ||statusBarOrientation==UIInterfaceOrientationLandscapeLeft) {
        return [UIScreen mainScreen].bounds.size.width;
    }else
    {
        return [UIScreen mainScreen].bounds.size.height;
    }
}



/**
 获取宽度比例
 */
CGFloat KScreenWidthRatio(){
    return [UIScreen mainScreen].bounds.size.width/(375.0);
}

CGFloat KScreenWidthRatioUnique(){
    UIInterfaceOrientation statusBarOrientation = [[UIApplication sharedApplication] statusBarOrientation];
    if (statusBarOrientation==UIInterfaceOrientationLandscapeRight ||statusBarOrientation==UIInterfaceOrientationLandscapeLeft) {
        return [UIScreen mainScreen].bounds.size.height/(375.0);
    }else
    {
        return [UIScreen mainScreen].bounds.size.width/(375.0);
    }
    
}

CGFloat XRZScreenScale() {
    static CGFloat scale;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        scale = [UIScreen mainScreen].scale;
    });
    return scale;
}


CGFloat XRZScreenWidthRatio(){
    static CGFloat ratio;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        ratio = [UIScreen mainScreen].bounds.size.width / 375.0f;
    });
    return ratio;
}

CGFloat XRZScreenHeightRatio(){
    static CGFloat ratio;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        ratio = [UIScreen mainScreen].bounds.size.height / 667.0f;
    });
    return ratio;
}

CGSize XRZScreenSize() {
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
}

CGRect XRZScreenBounds(){
    static CGRect bounds;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        bounds = [UIScreen mainScreen].bounds;
    });
    return bounds;
}
