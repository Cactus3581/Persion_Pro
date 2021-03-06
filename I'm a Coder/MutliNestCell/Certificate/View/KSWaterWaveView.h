//
//  KSWaterWaveView.h
//  I'm a Coder
//
//  Created by xiaruzhen on 2017/7/14.
//  Copyright © 2017年 xiaruzhen. All rights reserved.
//

#import <UIKit/UIKit.h>

#define kWATERWAVE_DEFAULT_SPEED 0.1;
#define kWATERWAVE_DEFAULT_PEAK  6.0
#define kWATERWAVE_DEFAULT_PERIOD 1.2
#define kFIRSTWAVE_DEFAULT_COLOR [UIColor colorWithRed:223/255.0 green:83/255.0 blue:64/255.0 alpha:0.5]
#define kSECONDEWAVE_DEFAULT_COLOR [UIColor colorWithRed:236/255.0f green:90/255.0f blue:66/255.0f alpha:0.5]
#define kExplain_Default_Font 16
#define kExplain_Default_Color [UIColor grayColor]
#define kComplete_Default_Font 20
#define kComplete_Default_Color [UIColor blackColor]

typedef NS_ENUM(NSInteger ,mCurveType) {
    kCurveTypeSin, // 正弦
    kCurveTypeCos  // 余弦
};

@interface KSWaterWaveView : UIView

@property (nonatomic, assign) CGFloat percent; //完成进度比例 DEFAULT:0.0
@property (nonatomic, assign) CGFloat speed;   //水波纹横向移动的速度 DEFAULT:0.1
@property (nonatomic, assign) CGFloat peak;    //峰值:水波纹的纵向高度 DEFAULT:6.0
@property (nonatomic, assign) CGFloat period;  //周期数:一定宽度内水波纹的周期个数 DEFAULT:1.2

@property (nonatomic, strong) UIColor *firstWaveColor;
@property (nonatomic, strong) UIColor *secondWaveColor;

@property (nonatomic, copy)   NSString *titleText;
@property (nonatomic, strong) UIColor *titleColor;
@property (nonatomic, assign) CGFloat titleFont;

@property (nonatomic, copy)   NSString *completeProgressText;
@property (nonatomic, strong) UIColor *completeProgressColor;
@property (nonatomic, assign) CGFloat completeProgressFont;


/**
 工厂方法获取view

 @return waterWaveView
 */
+ (instancetype)waterWaveView;

/**
 开启水波纹动画
 */
- (void)startWave;

/**
 停止
 */
- (void)stopWave;

@end

