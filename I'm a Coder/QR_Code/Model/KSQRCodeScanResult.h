//
//  KSQRCodeScanResult.h
//  PowerWord7
//
//  Created by xiaruzhen on 2017/7/26.
//  Copyright © 2017年 Kingsoft. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KSQRCodeScanResult : NSObject

/**
 @brief  条码字符串
 */
@property (nonatomic, copy) NSString *strScanned;

/**
 @brief  扫码图像
 */
@property (nonatomic, strong) UIImage *imgScanned;

/**
 @brief  扫码的类型,AVMetadataObjectType:AVMetadataObjectTypeQRCode，AVMetadataObjectTypeEAN13Code等
 */
@property (nonatomic, copy) NSString *strBarCodeType;

- (instancetype)initWithScanString:(NSString *)str imgScan:(UIImage *)img barCodeType:(NSString *)type;

@end
