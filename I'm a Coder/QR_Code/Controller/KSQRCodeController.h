//
//  KSQRCodeController.h
//  PowerWord7
//
//  Created by xiaruzhen on 2017/7/27.
//  Copyright © 2017年 Kingsoft. All rights reserved.
//


@interface KSQRCodeController : UIViewController
@property (nonatomic, copy) void (^returnScanBarCodeValue)(NSString * barCodeString);

@end
