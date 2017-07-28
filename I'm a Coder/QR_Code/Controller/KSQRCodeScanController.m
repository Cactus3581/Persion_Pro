//
//  KSQRCodeScanController.m
//  PowerWord7
//
//  Created by xiaruzhen on 2017/7/26.
//  Copyright © 2017年 Kingsoft. All rights reserved.
//

#import "KSQRCodeScanController.h"

@interface KSQRCodeScanController ()

@end

@implementation KSQRCodeScanController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.cameraInvokeMsg = @"正在加载";
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
    [self dismiss];
}

- (void)showNextVCWithScanResult:(KSQRCodeScanResult*)strResult {
    NSString * urlString =[NSString stringWithFormat:@"%@&client=%@",strResult.strScanned,@([[PowerWordUtilities utils] clientType])];
    //NSString *urlStr = [urlString stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    AFHTTPSessionManager *httpManager = [AFHTTPSessionManager manager];
    httpManager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:kContentType];
    //[httpManager.requestSerializer setValue:@"" forHTTPHeaderField:@""];
    __weak typeof(self) weakSelf = self;
    [httpManager POST:urlString parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSHTTPURLResponse *response = (NSHTTPURLResponse *)task.response;
        NSDictionary *allHeaders = response.allHeaderFields;
        NSString *location = KSValidateDict(allHeaders)[@"Location"];
        NSInteger type ;
        if ([KSValidateString(location) hasPrefix:@"http"]) {
            type = 0;
        }else {
            type = 2;
        }
        [KSDynamicViewControllerHelper pushViewControllerWithNavigationController:nil pushType:type linkData:location];
        [weakSelf removeSelf];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [weakSelf.qRScanView stopScanAnimation];
        [weakSelf stopScan];
        [weakSelf showAlert];
    }];
}

- (void)showAlert {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:@"服务器返回error" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *alertAction = [UIAlertAction actionWithTitle:@"重现扫描" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self.qRScanView startScanAnimation];
        [self reStartDevice];
    }];
    [alertController addAction:alertAction];
    UIAlertAction *alertActionCancel = [UIAlertAction actionWithTitle:@"放弃" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        [self dismiss];
    }];
    [alertController addAction:alertActionCancel];
    [self presentViewController:alertController animated:YES completion:nil];
}

- (void)removeSelf {
    if (self.navigationController) {
        NSMutableArray *array = [NSMutableArray arrayWithArray:self.navigationController.viewControllers];
        [array enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([obj isKindOfClass:[self class]]) {
                [array removeObject:obj];
                *stop = YES;
            }
        }];
        self.navigationController.viewControllers = array;
    }
}

- (IBAction)dismissAction:(id)sender {
    [self dismiss];
}

- (void)dismiss {
    if (self.navigationController) {
        [self.navigationController popViewControllerAnimated:YES];
    }else {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
