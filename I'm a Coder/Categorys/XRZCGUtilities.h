//
//  XRZCGUtilities.h
//  UCard
//
//  Created by xiaruzhen on 2017/3/28.
//  Copyright © 2017年 Synjones. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
NS_ASSUME_NONNULL_BEGIN

CGFloat KScreenWidthRatioUnique();

CGFloat KScreenWidthRatio();
CGFloat getWidthUnique();

CGFloat getHeightUnique();

CGFloat getWidth();

CGFloat getHeight();

CGFloat XRZScreenScale();

CGFloat XRZScreenWidthRatio();

CGFloat XRZScreenHeightRatio();

CGSize XRZScreenSize();

CGRect XRZScreenBounds();


//得到当前屏幕宽度比例
static inline CGFloat widthRatioUnique(CGFloat number){
    // 1. 横竖屏下宽度唯一，都是指的竖屏下的宽度
    return number * KScreenWidthRatioUnique();
}

static inline CGFloat widthRatio(CGFloat number){
    // 2. 横竖屏下宽度高度会切换，竖屏下宽度高度不变，横屏下，切换；
    return number * KScreenWidthRatio();
}

//得到当前屏幕宽度和高度：横竖屏下宽度高度唯一，都是指的竖屏下的宽度高度
static inline CGFloat widthUnique() {
    return getWidthUnique();
}

static inline CGFloat heightUnique() {
    return getHeightUnique();
}

//得到当前屏幕宽度：横竖屏下宽度高度会切换，竖屏下宽度高度不变，横屏下宽度为竖屏下的高度；
static inline CGFloat XRZGetWidth() {
    return getWidth();
}

static inline CGFloat XRZGetHeight() {
    return getHeight();
}

static inline CGFloat heightRatio(CGFloat number){
    return number * XRZScreenHeightRatio();
}

static inline CGFloat DegreesToRadians(CGFloat degrees){
    return degrees * M_PI / 180;
}

static inline CGFloat RadiansToDegrees(CGFloat radians){
    return radians * 180 / M_PI;
}


// main screen's scale
#ifndef kScreenScale
#define kScreenScale XRZScreenScale()
#endif

// main screen's bounds
#ifndef kScreenBounds
#define kScreenBounds XRZScreenBounds()
#endif

//// main screen's size (portrait)
//#ifndef kScreenSize
//#define kScreenSize XRZScreenSize()
//#endif
//
//// main screen's width (portrait)
//#ifndef kScreenWidth
//#define kScreenWidth XRZScreenSize().width
//#endif
//
//// main screen's height (portrait)
//#ifndef kScreenHeight
//#define kScreenHeight XRZScreenSize().height
//#endif

// main screen's height (portrait)
#ifndef kWidthRatio
#define kWidthRatio XRZScreenWidthRatio()
#endif

#ifndef kWidthRatios
#define kWidthRatios KScreenWidthRatio()
#endif

// main screen's height (portrait)
#ifndef kHeightRatio
#define kHeightRatio XRZScreenHeightRatio()
#endif

NS_ASSUME_NONNULL_END
