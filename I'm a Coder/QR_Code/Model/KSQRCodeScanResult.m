//
//  KSQRCodeScanResult.m
//  PowerWord7
//
//  Created by xiaruzhen on 2017/7/26.
//  Copyright © 2017年 Kingsoft. All rights reserved.
//

#import "KSQRCodeScanResult.h"

@implementation KSQRCodeScanResult

- (instancetype)initWithScanString:(NSString *)str imgScan:(UIImage *)img barCodeType:(NSString *)type {
    if (self = [super init]) {
        self.strScanned = str;
        self.imgScanned = img;
        self.strBarCodeType = type;
    }
    return self;
}

@end
