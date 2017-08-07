//
//  KSQRCodeScanBaseController.h
//  PowerWord7
//
//  Created by xiaruzhen on 2017/7/26.
//  Copyright © 2017年 Kingsoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import "KSQRCodeScanResult.h"
#import "KSQRCodeScanView.h"
#import "KSQRCodeScanTool.h"

typedef NS_ENUM(NSInteger, SCANCODETYPE) {
    SCT_QRCode, //QR二维码
    SCT_BarCode93,
    SCT_BarCode128,//支付条形码(支付宝、微信支付条形码)
    SCT_BarCodeITF,//燃气回执联 条形码?
    SCT_BarEAN13 //一般用做商品码
};

/**
 扫码结果回调。也可通过继承本控制器，override方法scanResultWithArray即可
 */
@protocol KScanViewControllerDelegate <NSObject>

@optional
- (void)scanResultWithArray:(NSArray<KSQRCodeScanResult*>*)array;

@end

@interface KSQRCodeScanBaseController : UIViewController<UIImagePickerControllerDelegate,UINavigationControllerDelegate>

#pragma mark ---- 需要初始化参数 ------
/**
 当前选择的识别码制
 */
@property (nonatomic, assign) SCANCODETYPE scanCodeType;

/**
 @brief 是否需要扫码图像
 */
@property (nonatomic, assign) BOOL isNeedScanImage;

/**
 @brief  启动区域识别功能
 */
@property(nonatomic,assign) BOOL isOpenInterestRect;

/**
 相机启动提示,如 相机启动中...
 */
@property (nonatomic, copy) NSString *cameraInvokeMsg;

/**
 *  界面效果参数
 */
@property (nonatomic, strong) KSQRCodeScanViewStyle *style;

/**
 @brief  扫码功能封装工具
 */
@property (nonatomic,strong) KSQRCodeScanTool *scanTool;

#pragma mark - 扫码界面效果及提示等
/**
 @brief  扫码区域视图,二维码一般都是框
 */
@property (nonatomic,strong) KSQRCodeScanView* qRScanView;

/**
 @brief  扫码存储的当前图片
 */
@property(nonatomic,strong) UIImage* scanImage;

/**
 @brief  闪关灯开启状态记录
 */
@property(nonatomic,assign)BOOL isOpenFlash;

//打开相册
- (void)openLocalPhoto:(BOOL)allowsEditing;

//开关闪光灯
- (void)openOrCloseFlash;

//启动扫描
- (void)reStartDevice;

//关闭扫描
- (void)stopScan;

//扫码结果代理，另外一种方案是通过继承本控制器，override方法scanResultWithArray即可
@property (nonatomic, weak) id<KScanViewControllerDelegate> delegate;

@end
