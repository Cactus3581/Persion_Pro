//
//  KSSlider.h
//  PowerWord7
//
//  Created by xiaruzhen on 2017/9/8.
//  Copyright © 2017年 Kingsoft. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol KSSliderDelegate <NSObject>

- (void)playAction;

@end

@interface KSSlider : UIView
@property (nonatomic,weak)id <KSSliderDelegate>delegate;

/**
 *  值
 */
@property(nonatomic,assign)CGFloat value;
/**
 *  滑块左侧显示的颜色
 */
@property(nonatomic,strong)UIColor *maximumTrackTintColor;
/**
 *  滑块右侧显示的颜色
 */
@property(nonatomic,strong)UIColor *minimumTrackTintColor;
/**
 *  5 <= 高度 <＝ 20
 */
@property(nonatomic,assign)CGFloat trackProgressHeight;
/**
 *  滑块图片
 */
@property(nonatomic,strong)UIImage *thumbImage;
/**
 *  滑块大小
 */
@property(nonatomic,assign)CGFloat sliderBlocksize;
/**
 *  滑块颜色
 */
@property(nonatomic,strong)UIColor *sliderBlockColor;

+ (instancetype) sliderWithProgressHeight:(CGFloat)progressHeight blockSize:(CGFloat)size;


/**
 滑块展示hud动画
 */
- (void)startAnimating;

/**
 滑块停止hud动画
 */
- (void)stopAnimating;


/**
 *  进度条setter方法
 *
 *  @param value 进度
 */
- (void)setValue:(CGFloat)value;

/**
 *  设置进度条底色
 *
 *  @param maximumTrackTintColor 颜色
 */
- (void)setMaximumTrackTintColor:(UIColor *)maximumTrackTintColor;

/**
 *  设置进度颜色
 *
 *  @param minimumTrackTintColor 颜色
 */
- (void)setMinimumTrackTintColor:(UIColor *)minimumTrackTintColor;

/**
 *  设置进度条高度
 *
 *  @param trackProgressHeight  高度
 */
- (void)setTrackProgressHeight:(CGFloat)trackProgressHeight;   // 20 >= trackProgressHeight >= 2

/**
 *  设置滑块按钮背景图
 *
 *  @param thumbImage 图片
 */
- (void)setThumbImage:(UIImage *)thumbImage;

/**
 *  设置按钮大小
 *
 *  @param sliderBlocksize 宽高
 */
- (void)setSliderBlocksize:(CGFloat)sliderBlocksize;

/**
 *  设置滑块颜色
 *
 *  @param sliderBlockColor 颜色
 */
- (void)setSliderBlockColor:(UIColor *)sliderBlockColor;

@end

