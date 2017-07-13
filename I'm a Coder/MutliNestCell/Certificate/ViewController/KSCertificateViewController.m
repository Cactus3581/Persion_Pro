//
//  KSCertificateViewController.m
//  I'm a Coder
//
//  Created by xiaruzhen on 2017/7/13.
//  Copyright © 2017年 xiaruzhen. All rights reserved.
//

#import "KSCertificateViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "KSAppDeclareView.h"

@interface KSCertificateViewController ()

@end

@implementation KSCertificateViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor lightGrayColor];
    [self.saveImageButton setTitleColor:[UIColor greenColor] forState:UIControlStateNormal];
    self.saveImageButton.layer.borderColor = [UIColor greenColor].CGColor;
    self.saveImageButton.layer.borderWidth = 1.0 /[UIScreen mainScreen].scale;
    self.saveImageButton.layer.cornerRadius = 3.0f;
    
    [self.shareButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.shareButton.layer.cornerRadius = 3.0f;
    self.shareButton.backgroundColor = [UIColor greenColor];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}

- (IBAction)modifyNameAction:(id)sender {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:@"输入名字" preferredStyle:UIAlertControllerStyleAlert];
    [alertController addTextFieldWithConfigurationHandler:^(UITextField *textField){
        textField.placeholder = @"修改名字";
    }];
    
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        UITextField *couponNumber = alertController.textFields.firstObject;
        if (couponNumber.text.length>0) {
            [self exchange:couponNumber.text];
        }
    }];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    [alertController addAction:okAction];
    [alertController addAction:cancelAction];
    [self presentViewController:alertController animated:YES completion:nil];
}

- (void)exchange:(NSString *)string {
    self.userNameLabel.text = string;
}

- (IBAction)saveImageAction:(id)sender {
    self.disMissButton.hidden = YES;
    UIImage *img = [self captureView:self.view];
    
    KSAppDeclareView *view = [[[NSBundle mainBundle] loadNibNamed:@"KSAppDeclareView" owner:self options:nil]lastObject];
    view.bounds = CGRectMake(0, 0, self.view.bounds.size.width, 90);

    
    UIImage *img1 = [self captureView:view];
    self.backViewTop.image = nil;
    UIImage *img2 = [self composeWithHeader:img content:img1];
//    self.backViewTop.image = img2;
    
    UIImageView *imageview = [[UIImageView alloc]initWithFrame:[UIScreen mainScreen].bounds];
    [self.view addSubview:imageview];
    imageview.image = img2;



    
//    UIImageWriteToSavedPhotosAlbum(image, nil, nil,nil);

}

#pragma mark -  截图功能
-(UIImage*)captureView:(UIView *)theView{
    CGRect rect = theView.frame;
    if ([theView isKindOfClass:[UIScrollView class]]) {
        rect.size = ((UIScrollView *)theView).contentSize;
    }
    UIGraphicsBeginImageContextWithOptions(rect.size, NO, [UIScreen mainScreen].scale);
    CGContextRef context = UIGraphicsGetCurrentContext();
    [theView.layer renderInContext:context];
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return img;
}

- (UIImage *)composeWithHeader:(UIImage *)header content:(UIImage *)content {
    CGSize size = CGSizeMake(content.size.width, header.size.height +content.size.height);
    UIGraphicsBeginImageContext(size);
    [header drawInRect:CGRectMake(0,
                                  0,
                                  header.size.width,
                                  header.size.height)];
    [content drawInRect:CGRectMake(0,
                                   header.size.height,
                                   content.size.width,
                                   content.size.height)];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

- (IBAction)shareAction:(id)sender {
    
}

- (IBAction)dismiss:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - 屏幕旋转及statusbar
// 不自动旋转
- (BOOL)shouldAutorotate {
    return NO;
}
// 竖屏显示
- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation {
    return UIInterfaceOrientationPortrait;
}

// 隐藏statusbar
-(BOOL)prefersStatusBarHidden {
    return YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
