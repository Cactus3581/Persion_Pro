//
//  KSGrammarCertificateController.m
//  I'm a Coder
//
//  Created by xiaruzhen on 2017/7/13.
//  Copyright © 2017年 xiaruzhen. All rights reserved.
//

#import "KSGrammarCertificateController.h"
#import <QuartzCore/QuartzCore.h>
#import "KSAppDeclareView.h"

@interface KSGrammarCertificateController ()
@end

@implementation KSGrammarCertificateController
- (void)viewDidLoad {
    [super viewDidLoad];
    [self configueView];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}

#pragma mark - Configue Subviews
- (void)configueView {
    self.view.backgroundColor = [UIColor lightGrayColor];
    self.backShotView.backgroundColor = [UIColor lightGrayColor];
    self.backViewTop.backgroundColor = [UIColor whiteColor];
    
    self.backBottomView.backgroundColor = [UIColor clearColor];
    
    [self.saveImageButton setTitleColor:[UIColor greenColor] forState:UIControlStateNormal];
    self.saveImageButton.layer.borderColor = [UIColor greenColor].CGColor;
    self.saveImageButton.layer.borderWidth = 1.0 /[UIScreen mainScreen].scale;
    self.saveImageButton.layer.cornerRadius = 3.0f;
    
    [self.shareButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.shareButton.layer.cornerRadius = 3.0f;
    self.shareButton.backgroundColor = [UIColor greenColor];
    
    UIImage *image = [UIImage imageNamed:@"circle_money"];
    CGSize strSize = [@"保存到本地" sizeWithAttributes:@{NSFontAttributeName:self.saveImageButton.titleLabel.font}];
    CGFloat imageWidth = image.size.width;
    CGFloat titleWidth = strSize.width;
    CGFloat edge = self.saveImageButton.frame.size.width-imageWidth-titleWidth;
    [self.saveImageButton setImageEdgeInsets:UIEdgeInsetsMake(0, -20, 0, 0)];
    [self.saveImageButton setTitleEdgeInsets:UIEdgeInsetsMake(0, -10, 0, 0)];
    
    [self configueShadowColor];
}

#pragma mark - Configue ShadowColor
- (void)configueShadowColor {
    self.backViewTop.layer.shadowColor = [UIColor blackColor].CGColor;//shadowColor阴影颜色
    self.backViewTop.layer.shadowOffset = CGSizeMake(0,0);//shadowOffset阴影偏移，默认(0, -3),这个跟shadowRadius配合使用
    self.backViewTop.layer.shadowOpacity = 0.6;//阴影透明度，默认0
    self.backViewTop.layer.shadowRadius = 10;//阴影半径，默认3
    //路径阴影
    UIBezierPath *path = [UIBezierPath bezierPath];
    float width = self.backViewTop.bounds.size.width;
    float height = self.backViewTop.bounds.size.height;
    float x = self.backViewTop.bounds.origin.x;
    float y = self.backViewTop.bounds.origin.y;
    float addWH = 0.0f;
    CGPoint topLeft      = self.backViewTop.bounds.origin;
    CGPoint topMiddle = CGPointMake(x+(width/2),y-addWH);
    CGPoint topRight     = CGPointMake(x+width,y);
    CGPoint rightMiddle = CGPointMake(x+width+addWH,y+(height/2));
    CGPoint bottomRight  = CGPointMake(x+width,y+height);
    CGPoint bottomMiddle = CGPointMake(x+(width/2),y+height+addWH);
    CGPoint bottomLeft   = CGPointMake(x,y+height);
    CGPoint leftMiddle = CGPointMake(x-addWH,y+(height/2));
    [path moveToPoint:topLeft];
    //添加四个二元曲线
    [path addQuadCurveToPoint:topRight
                 controlPoint:topMiddle];
    [path addQuadCurveToPoint:bottomRight
                 controlPoint:rightMiddle];
    [path addQuadCurveToPoint:bottomLeft
                 controlPoint:bottomMiddle];
    [path addQuadCurveToPoint:topLeft
                 controlPoint:leftMiddle];
    //设置阴影路径
    self.backViewTop.layer.shadowPath = path.CGPath;
}

#pragma mark - 修改名字
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

#pragma mark - 图片相关操作
- (IBAction)saveImageAction:(id)sender {
    UIImage *topImage = [self captureView:self.backShotView];
    
    KSAppDeclareView *bottomView = [[[NSBundle mainBundle] loadNibNamed:@"KSAppDeclareView" owner:self options:nil]lastObject];
    bottomView.frame = CGRectMake(0, self.view.bounds.size.height, self.view.bounds.size.width, 90);
    [self.view addSubview:bottomView];
    UIImage *bottomImage = [self captureView:bottomView];
    [bottomView removeFromSuperview];
    
    UIImage *resultImage = [self composeWithTopImage:topImage bottomImage:bottomImage];
    UIImageView *imageview = [[UIImageView alloc]initWithFrame:[UIScreen mainScreen].bounds];
    imageview.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:imageview];
    imageview.image = resultImage;
//    [self saveImage:resultImage];
}

#pragma mark - 存储本地
- (void)saveImage:(UIImage *)image {
    if (!image) {
        return;
    }
    UIImageWriteToSavedPhotosAlbum(image, self, @selector(image:didFinishSavingWithError:contextInfo:),nil);
}

-(void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo {
    if (error) {
        NSLog(@"保存失败!");
    } else {
        NSLog(@"保存成功!");
    }
}

#pragma mark -  截图功能
-(UIImage*)captureView:(UIView *)theView{
    CGRect rect = theView.frame;
    if ([theView isKindOfClass:[UIScrollView class]]) {
        rect.size = ((UIScrollView *)theView).contentSize;
    }
    UIGraphicsBeginImageContextWithOptions(rect.size, NO, [UIScreen mainScreen].scale);
//    UIGraphicsBeginImageContextWithOptions(rect.size, NO, 0.0);
    CGContextRef context = UIGraphicsGetCurrentContext();
    [theView.layer renderInContext:context];
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return img;
}

#pragma mark - 拼接图片
- (UIImage *)composeWithTopImage:(UIImage *)top bottomImage:(UIImage *)bottom {
    CGSize size = CGSizeMake(top.size.width, top.size.height+bottom.size.height);
    UIGraphicsBeginImageContext(size);
    [top drawInRect:CGRectMake(0,0,top.size.width,top.size.height)];
    [bottom drawInRect:CGRectMake(0,top.size.height,top.size.width,bottom.size.height)];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

#pragma mark - 分享功能
- (IBAction)shareAction:(id)sender {
    
}

#pragma mark - Dismiss
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
}

@end
