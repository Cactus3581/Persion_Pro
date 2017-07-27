//
//  KSQRCodeScanController.m
//  PowerWord7
//
//  Created by xiaruzhen on 2017/7/26.
//  Copyright © 2017年 Kingsoft. All rights reserved.
//

#import "KSQRCodeScanController.h"
#import <AFHTTPSessionManager.h>
@interface KSQRCodeScanController ()

@end

@implementation KSQRCodeScanController

- (IBAction)dismissAction:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.cameraInvokeMsg = @"相机启动中";
}

#pragma mark -实现类继承该方法，作出对应处理
- (void)scanResultWithArray:(NSArray<KSQRCodeScanResult*>*)array {
    if (!array ||  array.count < 1) {
        [self popAlertMsgWithScanResult:nil];
        return;
    }
    KSQRCodeScanResult*scanResult = array[0];
    NSString*strResult = scanResult.strScanned;
    self.scanImage = scanResult.imgScanned;
    if (!strResult) {
        [self popAlertMsgWithScanResult:nil];
        return;
    }
    [self showNextVCWithScanResult:scanResult];
}

- (void)popAlertMsgWithScanResult:(NSString*)strResult {
    if (!strResult) {
        strResult = @"识别失败";
    }
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)showNextVCWithScanResult:(KSQRCodeScanResult*)strResult {
    NSString *strScanned = strResult.strScanned;
    NSString * urlString =[NSString stringWithFormat:@"%@&client=%@",strScanned,@(3)];
    NSLog(@"%@",urlString);
    NSLog(@"%@",strScanned);
    NSString *urlStr = [urlString stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    AFHTTPSessionManager *httpManager = [AFHTTPSessionManager manager];
    httpManager.responseSerializer.acceptableContentTypes = [httpManager.responseSerializer.acceptableContentTypes setByAddingObjectsFromSet:[NSSet setWithObjects:@"application/json", @"text/html",@"text/plain",nil]];
    //[httpManager.requestSerializer setValue:@"" forHTTPHeaderField:@""];
    
    __weak typeof(self) weakSelf = self;
    [httpManager POST:urlStr parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"%@",responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@",error);
        [weakSelf popAlertMsgWithScanResult:nil];
    }];
    
    
        if ([strScanned hasPrefix:@"http"]) {
            NSURL * url = [NSURL URLWithString:[NSString stringWithFormat:@"%@&client=%@",strScanned,@(3)]];
    
            if ([[UIApplication sharedApplication] canOpenURL: url]) {
                [[UIApplication sharedApplication] openURL: url];
            }
        }else {
            AFHTTPSessionManager *httpManager = [AFHTTPSessionManager manager];
            httpManager.responseSerializer.acceptableContentTypes = [httpManager.responseSerializer.acceptableContentTypes setByAddingObjectsFromSet:[NSSet setWithObjects:@"application/json", @"text/html",@"text/plain",nil]];
            //[httpManager.requestSerializer setValue:@"" forHTTPHeaderField:@""];
            [httpManager POST:urlString parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                NSLog(@"%@",responseObject);
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                NSLog(@"%@",error);
            }];
        }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
