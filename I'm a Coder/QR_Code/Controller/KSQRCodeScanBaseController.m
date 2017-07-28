//
//  KSQRCodeScanBaseController.m
//  PowerWord7
//
//  Created by xiaruzhen on 2017/7/26.
//  Copyright © 2017年 Kingsoft. All rights reserved.
//

#import "KSQRCodeScanBaseController.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import <Photos/Photos.h>

@interface KSQRCodeScanBaseController ()
@end

@implementation KSQRCodeScanBaseController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor blackColor];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self configureSubViews];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
    [self stopScan];
    [_qRScanView stopScanAnimation];
}

#pragma mark -初始化
- (void)configureSubViews {
    [self drawScanView];
    [self requestCameraPemissionWithResult:^(BOOL granted) {
        if (granted) {
            //不延时，可能会导致界面黑屏并卡住一会
            [self performSelector:@selector(startScan) withObject:nil afterDelay:0.3];
        }else{
            [_qRScanView stopDeviceReadying];
            [self showError:@"请到设置隐私中开启相机权限"];
        }
    }];
}

#pragma mark - 绘制扫描区域
- (void)drawScanView {
    if (!_qRScanView) {
        CGRect rect = self.view.frame;
        rect.origin = CGPointMake(0, 0);
        //self.qRScanView = [[KSQRCodeScanView alloc]initWithFrame:rect style:_style];
        self.qRScanView = [[KSQRCodeScanView alloc]initWithStyle:_style];
        [self.view addSubview:_qRScanView];
        [self.view sendSubviewToBack:_qRScanView];
        [self.qRScanView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.left.right.equalTo(self.view);
        }];
    }
    [_qRScanView startDeviceReadyingWithText:_cameraInvokeMsg];
}

#pragma mark - 启动设备
- (void)startScan {
//    UIView *videoView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame))];
//    UIView *videoView = [[UIView alloc]init];
    UIView *videoView = [[UIView alloc]initWithFrame:self.view.bounds];
    videoView.backgroundColor = [UIColor clearColor];
    [self.view insertSubview:videoView atIndex:0];
//    [videoView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.bottom.left.right.equalTo(self.view);
//    }];
    __weak __typeof(self) weakSelf = self;
    if (!_scanTool ) {
        CGRect cropRect = CGRectZero;
        if (_isOpenInterestRect) {
            //设置只识别框内区域
            cropRect = [KSQRCodeScanView getScanRectWithPreView:self.view style:_style];
        }

        NSString *strCode = AVMetadataObjectTypeQRCode;
        if (_scanCodeType != SCT_BarCodeITF ) {
            strCode = [self codeWithType:_scanCodeType];
        }
        //AVMetadataObjectTypeITF14Code 扫码效果不行,另外只能输入一个码制，虽然接口是可以输入多个码制
        self.scanTool = [[KSQRCodeScanTool alloc]initWithPreView:self.view ObjectType:@[strCode] cropRect:cropRect success:^(NSArray<KSQRCodeScanResult *> *array) {
            [weakSelf scanResultWithArray:array];
        }];
        [_scanTool setNeedCaptureImage:_isNeedScanImage];
    }
    [_scanTool startScan];
    [_qRScanView stopDeviceReadying];
    [_qRScanView startScanAnimation];
    self.view.backgroundColor = [UIColor clearColor];
}

- (void)reStartDevice {
    [_scanTool startScan];
}

- (void)stopScan {
    [_scanTool stopScan];
}

#pragma mark -扫码结果处理
- (void)scanResultWithArray:(NSArray<KSQRCodeScanResult*>*)array {
    //设置了委托的处理
    if (_delegate) {
        [_delegate scanResultWithArray:array];
    }
    //也可以通过继承KScanViewController，重写本方法即可
}

#pragma mark - 其他功能：开关闪光灯；从相册导入扫描
//开关闪光灯
- (void)openOrCloseFlash {
    [_scanTool changeTorch];
    self.isOpenFlash =!self.isOpenFlash;
}

#pragma mark --打开相册并识别图片
/*
 *  打开本地照片，选择图片识别
 */
- (void)openLocalPhoto:(BOOL)allowsEditing {
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    picker.delegate = self;
    //部分机型有问题
    picker.allowsEditing = allowsEditing;
    [self presentViewController:picker animated:YES completion:nil];
}

//当选择一张图片后进入这里
-(void)imagePickerController:(UIImagePickerController*)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    [picker dismissViewControllerAnimated:YES completion:nil];
    __block UIImage* image = [info objectForKey:UIImagePickerControllerEditedImage];
    if (!image){
        image = [info objectForKey:UIImagePickerControllerOriginalImage];
    }
    __weak __typeof(self) weakSelf = self;
    if ([[[UIDevice currentDevice]systemVersion]floatValue] >= 8.0) {
        [KSQRCodeScanTool recognizeImage:image success:^(NSArray<KSQRCodeScanResult *> *array) {
            [weakSelf scanResultWithArray:array];
        }];
    }
    else {
        [self showError:@"低于ios8.0系统不支持识别图片条码"];
    }
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (NSString*)codeWithType:(SCANCODETYPE)type {
    switch (type) {
        case SCT_QRCode:
            return AVMetadataObjectTypeQRCode;
            break;
        case SCT_BarCode93:
            return AVMetadataObjectTypeCode93Code;
            break;
        case SCT_BarCode128:
            return AVMetadataObjectTypeCode128Code;
            break;
        case SCT_BarCodeITF:
            return @"ITF条码:暂不支持";
            break;
        case SCT_BarEAN13:
            return AVMetadataObjectTypeEAN13Code;
            break;
        default:
            return AVMetadataObjectTypeQRCode;
            break;
    }
}

- (void)showError:(NSString*)str {
}

- (void)requestCameraPemissionWithResult:(void(^)( BOOL granted))completion {
    if ([AVCaptureDevice respondsToSelector:@selector(authorizationStatusForMediaType:)]) {
        AVAuthorizationStatus permission =
        [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
        switch (permission) {
            case AVAuthorizationStatusAuthorized:
                completion(YES);
                break;
            case AVAuthorizationStatusDenied:
            case AVAuthorizationStatusRestricted:
                completion(NO);
                break;
            case AVAuthorizationStatusNotDetermined: {
                [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo
                                         completionHandler:^(BOOL granted) {
                                             dispatch_async(dispatch_get_main_queue(), ^{
                                                 if (granted) {
                                                     completion(true);
                                                 } else {
                                                     completion(false);
                                                 }
                                             });
                                             
                                         }];
            }
                break;
        }
    }
}

+ (BOOL)photoPermission {
    if ([[[UIDevice currentDevice] systemVersion] floatValue] < 8.0) {
        ALAuthorizationStatus author = [ALAssetsLibrary authorizationStatus];
        if ( author == ALAuthorizationStatusDenied ) {
            return NO;
        }
        return YES;
    }
    PHAuthorizationStatus authorStatus = [PHPhotoLibrary authorizationStatus];
    if ( authorStatus == PHAuthorizationStatusDenied ) {
        return NO;
    }
    return YES;
}

- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator {
    [super viewWillTransitionToSize:size withTransitionCoordinator:coordinator];
    if (_scanTool) {
        [_scanTool set_preview_frame:CGRectMake(0, 0, size.width, size.height)];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
