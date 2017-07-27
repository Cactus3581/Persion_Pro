//
//  KSQRCodeViewController.h
//  I'm a Coder
//
//  Created by xiaruzhen on 2017/7/27.
//  Copyright © 2017年 xiaruzhen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface KSQRCodeViewController : UIViewController
@property (nonatomic, copy) void (^returnScanBarCodeValue)(NSString * barCodeString);

@end
