//
//  KSQRCodeViewController.m
//  I'm a Coder
//
//  Created by xiaruzhen on 2017/7/27.
//  Copyright © 2017年 xiaruzhen. All rights reserved.
//

#import "KSQRCodeViewController.h"
#import <AVFoundation/AVFoundation.h>
#import "KSQRCodeMaskView.h"
#import <ImageIO/ImageIO.h>

@interface KSQRCodeViewController ()<AVCaptureMetadataOutputObjectsDelegate>

/** 设备 */
@property (nonatomic, strong) AVCaptureDevice * device;
/** 输入输出的中间桥梁 */
@property (nonatomic, strong) AVCaptureSession * session;
/** 相机图层 */
@property (nonatomic, strong) AVCaptureVideoPreviewLayer * previewLayer;
/** 扫描支持的编码格式的数组 */
@property (nonatomic, strong) NSMutableArray * metadataObjectTypes;
/** 遮罩层 */
@property (nonatomic, strong) KSQRCodeMaskView * maskView;

@end

@implementation KSQRCodeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self capture];
    self.maskView = [[KSQRCodeMaskView alloc] init];
    [self.view addSubview:self.maskView];
    [self.maskView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
}

- (void)capture{
    //获取摄像设备
    self.device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    //创建输入流
    AVCaptureDeviceInput * input = [AVCaptureDeviceInput deviceInputWithDevice:self.device error:nil];
    //创建输出流
    AVCaptureMetadataOutput * metadataOutput = [[AVCaptureMetadataOutput alloc] init];
    //设置代理 在主线程里刷新
    [metadataOutput setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
    //初始化链接对象
    self.session = [[AVCaptureSession alloc] init];
    //高质量采集率
    self.session.sessionPreset = AVCaptureSessionPresetHigh;
    [self.session addInput:input];
    [self.session addOutput:metadataOutput];
    self.previewLayer = [AVCaptureVideoPreviewLayer layerWithSession:self.session];
    self.previewLayer.frame = self.view.bounds;
    self.previewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
    self.previewLayer.backgroundColor = [UIColor yellowColor].CGColor;
    [self.view.layer addSublayer:self.previewLayer];
    //设置扫描支持的编码格式(如下设置条形码和二维码兼容)
    metadataOutput.metadataObjectTypes = self.metadataObjectTypes;
    //开始捕获
    [self.session startRunning];
}

#pragma mark - AVCaptureMetadataOutputObjectsDelegate
- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection{
    if (metadataObjects.count > 0) {
        [self.session stopRunning];
        AVMetadataMachineReadableCodeObject * metadataObject = metadataObjects.firstObject;
        self.returnScanBarCodeValue(metadataObject.stringValue);
        
        if (self.navigationController) {
            [self.navigationController popViewControllerAnimated:YES];
        }else{
            [self dismissViewControllerAnimated:YES completion:nil];
        }
    }
}

- (NSMutableArray *)metadataObjectTypes{
    if (!_metadataObjectTypes) {
        _metadataObjectTypes = [NSMutableArray arrayWithObjects:AVMetadataObjectTypeAztecCode, AVMetadataObjectTypeCode128Code, AVMetadataObjectTypeCode39Code, AVMetadataObjectTypeCode39Mod43Code, AVMetadataObjectTypeCode93Code, AVMetadataObjectTypeEAN13Code, AVMetadataObjectTypeEAN8Code, AVMetadataObjectTypePDF417Code, AVMetadataObjectTypeQRCode, AVMetadataObjectTypeUPCECode, nil];
        // >= iOS 8
        if (floor(NSFoundationVersionNumber) > NSFoundationVersionNumber_iOS_7_1) {
            [_metadataObjectTypes addObjectsFromArray:@[AVMetadataObjectTypeInterleaved2of5Code, AVMetadataObjectTypeITF14Code, AVMetadataObjectTypeDataMatrixCode]];
        }
    }
    return _metadataObjectTypes;
}

- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator {
    [super viewWillTransitionToSize:size withTransitionCoordinator:coordinator];
    self.previewLayer.frame = self.view.bounds;
    self.previewLayer.frame = CGRectMake(0, 0, size.width, size.height);
    [self.maskView set_preview_frame:CGRectMake(0, 0, size.width, size.height)];
    [self shouldRotateToOrientation:(UIDeviceOrientation)[UIApplication sharedApplication].statusBarOrientation];
}


-(void)shouldRotateToOrientation:(UIDeviceOrientation)orientation {
    UIDeviceOrientation deviceOrientation;
    switch (orientation) {
        case UIDeviceOrientationPortrait:
            deviceOrientation = UIDeviceOrientationPortrait;
            break;
        case UIDeviceOrientationPortraitUpsideDown:
            deviceOrientation = UIDeviceOrientationPortraitUpsideDown;
            break;
        case UIDeviceOrientationLandscapeLeft:
            deviceOrientation = UIDeviceOrientationLandscapeLeft;
            break;
        case UIDeviceOrientationLandscapeRight:
            deviceOrientation = UIDeviceOrientationLandscapeRight;
            break;
            
        default:
            deviceOrientation = UIDeviceOrientationPortrait;
            break;
    }
    
    [self set_preview_videoOrientation:deviceOrientation];
}

- (void)set_preview_videoOrientation:(UIDeviceOrientation)deviceOrientation {
    AVCaptureVideoOrientation video_orientation;
    switch (deviceOrientation) {
        case UIDeviceOrientationPortrait:
            video_orientation = AVCaptureVideoOrientationPortrait;
            break;
        case UIDeviceOrientationPortraitUpsideDown:
            video_orientation = AVCaptureVideoOrientationPortraitUpsideDown;
            break;
        case UIDeviceOrientationLandscapeLeft:
            video_orientation = AVCaptureVideoOrientationLandscapeLeft;
            break;
        case UIDeviceOrientationLandscapeRight:
            video_orientation = AVCaptureVideoOrientationLandscapeRight;
            break;
            
        default:
            video_orientation = AVCaptureVideoOrientationPortrait;
            break;
    }
    [_previewLayer connection].videoOrientation = video_orientation;//旋转相机
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
