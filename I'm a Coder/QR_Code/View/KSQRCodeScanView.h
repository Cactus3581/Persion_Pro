//
//  KSQRCodeScanView.h
//  PowerWord7
//
//  Created by xiaruzhen on 2017/7/26.
//  Copyright © 2017年 Kingsoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KSQRCodeScanLineAnimation.h"
#import "KSQRCodeNetLatticeAnimation.h"
#import "KSQRCodeScanViewStyle.h"
/**
 扫码区域显示效果
 */
@interface KSQRCodeScanView : UIView

/**
 @brief  初始化
 @param frame 位置大小
 @param style 类型
 
 @return instancetype
 */
//-(id)initWithFrame:(CGRect)frame style:(KSQRCodeScanViewStyle* )style;

-(instancetype)initWithStyle:(KSQRCodeScanViewStyle*)style;

/**
 *  设备启动中文字提示
 */
- (void)startDeviceReadyingWithText:(NSString*)text;

/**
 *  设备启动完成： 关闭相机启动中的文字提示

 */
- (void)stopDeviceReadying;

/**
 *  开始扫描动画
 */
- (void)startScanAnimation;

/**
 *  结束扫描动画
 */
- (void)stopScanAnimation;

/**
 @brief  根据矩形区域，获取扫码识别兴趣区域
 @param view  视频流显示UIView
 @param style 效果界面参数
 @return 识别区域
 */
+ (CGRect)getScanRectWithPreView:(UIView *)view style:(KSQRCodeScanViewStyle *)style;

@end
