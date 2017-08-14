//
//  XRZCGUtilities.h
//  UCard
//
//  Created by xiaruzhen on 2017/3/28.
//  Copyright © 2017年 Synjones. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

CGSize XRZScreenSize();
CGFloat XRZScreenWidthRatio();

CGSize XRZScreenSizeUnique();
CGFloat XRZScreenWidthRatioUnique();

CGFloat XRZScreenScale();
CGRect  XRZScreenBounds();

#pragma mark - 横竖屏-宽高不会切换
static inline CGFloat widthRatioUnique(CGFloat number) {
    return number * XRZScreenWidthRatioUnique();
}

#pragma mark - 横竖屏-宽高会切换
static inline CGFloat widthRatio(CGFloat number) {
    return number * XRZScreenWidthRatio();
}


static inline CGFloat DegreesToRadians(CGFloat degrees) {
    return degrees * M_PI / 180;
}

static inline CGFloat RadiansToDegrees(CGFloat radians) {
    return radians * 180 / M_PI;
}


// main screen's scale 屏幕的像素倍数
#ifndef kScreenScale
#define kScreenScale XRZScreenScale()
#endif

// main screen's bounds
#ifndef kScreenBounds
#define kScreenBounds XRZScreenBounds()
#endif

// main screen's size (portrait||landscape)
#ifndef kScreenSize
#define kScreenSize XRZScreenSize()
#endif

// main screen's size (portrait)
#ifndef kScreenSizeUnique
#define kScreenSizeUnique XRZScreenSizeUnique()
#endif

// main screen's width ((portrait||landscape))
#ifndef kScreenWidth
#define kScreenWidth XRZScreenSize().width
#endif

// main screen's width (portrait)
#ifndef kScreenWidthUnique
#define kScreenWidthUnique XRZScreenSizeUnique().width
#endif

// main screen's height ((portrait||landscape))
#ifndef kScreenHeight
#define kScreenHeight XRZScreenSize().height
#endif

// main screen's height (portrait)
#ifndef kScreenHeightUnique
#define kScreenHeightUnique XRZScreenSizeUnique().height
#endif

NS_ASSUME_NONNULL_END
