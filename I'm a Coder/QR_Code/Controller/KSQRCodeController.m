//
//  KSQRCodeController.m
//  PowerWord7
//
//  Created by xiaruzhen on 2017/7/27.
//  Copyright © 2017年 Kingsoft. All rights reserved.
//

#import "KSQRCodeController.h"
#import <AVFoundation/AVFoundation.h>
#import <ImageIO/ImageIO.h>

@interface KSQRCodeController ()<AVCaptureMetadataOutputObjectsDelegate>

/** 设备 */
@property (nonatomic, strong) AVCaptureDevice * device;
/** 输入输出的中间桥梁 */
@property (nonatomic, strong) AVCaptureSession * session;
/** 相机图层 */
@property (nonatomic, strong) AVCaptureVideoPreviewLayer * previewLayer;
/** 扫描支持的编码格式的数组 */
@property (nonatomic, strong) NSMutableArray * metadataObjectTypes;
/** 遮罩层 */
@property (weak, nonatomic) IBOutlet UIView *maskView;

/** 返回按钮 */
@property (weak, nonatomic) IBOutlet UIButton *backButton;

/** 手电筒 */
@property (nonatomic, strong) UIButton * flashlight;
/** 返回提示Label */
@property (nonatomic, strong) UILabel * backHintLabel;
/** 手电筒提示Label */
@property (nonatomic, strong) UILabel * flashlightHintLabel;

@end

@implementation KSQRCodeController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self congigureCapture];
    [self congigureSubViews];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
}

/**
 *  添加遮罩层
 */
- (void)congigureSubViews{
    //返回提示Label
    CGFloat backHint_width = 60;
    CGFloat backHint_height = 30;
    
    self.backHintLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, backHint_width, backHint_height)];
    self.backHintLabel.text = @"返回";
    self.backHintLabel.textAlignment = NSTextAlignmentCenter;
    self.backHintLabel.textColor = [UIColor whiteColor];
//    [self.view addSubview:self.backHintLabel];
    
    //手电筒
    CGFloat flashlight_width = 40;
    CGFloat flashlight_height = 40;
    
    self.flashlight = [UIButton buttonWithType:UIButtonTypeCustom];
    self.flashlight.frame = CGRectMake(0, 0, flashlight_width, flashlight_height);
    [self.flashlight setImage:[UIImage imageNamed:@"Flashlight_N"] forState:UIControlStateNormal];
    [self.flashlight addTarget:self action:@selector(flashlightAction:) forControlEvents:UIControlEventTouchUpInside];
//    [self.view addSubview:self.flashlight];
    
    //手电筒提示Label
    CGFloat flashlightHint_width = 60;
    CGFloat flashlightHint_height = 30;
    
    self.flashlightHintLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, flashlightHint_width, flashlightHint_height)];
    self.flashlightHintLabel.text = @"手电筒";
    self.flashlightHintLabel.textAlignment = NSTextAlignmentCenter;
    self.flashlightHintLabel.textColor = [UIColor whiteColor];
//    [self.view addSubview:self.flashlightHintLabel];
}

/**
 *  扫描初始化
 */
- (void)congigureCapture{
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

#pragma mark - 取消事件

/**
 * 取消事件
 */
- (IBAction)cancelAction:(id)sender {
    if (self.navigationController) {
        [self.navigationController popViewControllerAnimated:YES];
    }else{
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
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

#pragma mark - 打开/关闭 手电筒

- (void)flashlightAction:(UIButton *)sender{
    sender.selected = !sender.selected;
    if (sender.selected) {
        [sender setImage:[UIImage imageNamed:@"Flashlight_H"] forState:UIControlStateSelected];
//        self.flashlightHintLabel.textColor = ZFColor(133, 235, 0, 1);
        
        //打开闪光灯
        AVCaptureDevice *captureDevice = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
        NSError *error = nil;
        
        if ([captureDevice hasTorch]) {
            BOOL locked = [captureDevice lockForConfiguration:&error];
            if (locked) {
                captureDevice.torchMode = AVCaptureTorchModeOn;
                [captureDevice unlockForConfiguration];
            }
        }
        
    }else{
        [sender setImage:[UIImage imageNamed:@"Flashlight_N"] forState:UIControlStateSelected];
        self.flashlightHintLabel.textColor = [UIColor whiteColor];
        
        //关闭闪光灯
        AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
        if ([device hasTorch]) {
            [device lockForConfiguration:nil];
            [device setTorchMode: AVCaptureTorchModeOff];
            [device unlockForConfiguration];
        }
    }
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

@end
