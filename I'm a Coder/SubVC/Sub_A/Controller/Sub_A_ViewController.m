//
//  Sub_A_ViewController.m
//  I'm a Coder
//
//  Created by xiaruzhen on 2017/1/12.
//  Copyright © 2017年 xiaruzhen. All rights reserved.
//

#import "Sub_A_ViewController.h"
#import "CustomDrawView.h"
#import "CustomDrawLayer.h"
#import "PathViewByBezier.h"
#define widthBt [UIScreen mainScreen].bounds.size.width/5.0
#define heightBt 30.0

@interface Sub_A_ViewController ()
@property (nonatomic,strong)UIView *view_test;

@property (nonatomic,strong)CALayer *closeLayer;
@end

@implementation Sub_A_ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title =self.titleName;
    self.view.backgroundColor = [UIColor whiteColor];
    [self dealWithData];
    [self setMakeTranslation];
    [self setTranslation];
    [self setMaskInView];
    [self setReset];

}
- (void)dealWithData
{
    switch (self.row) {
        case 0:
            [self creatView];
            break;
        case 1:

            break;
        case 2:
            break;
        case 3:
            break;
        case 4:
            break;
        case 5:
            break;
        case 6:
            break;
        case 7:
            
            break;
        case 8:
            
            break;
        default:
            break;
    }
}
#pragma mark - 创建View
- (void)creatView
{
    self.view_test = [[UIView alloc]initWithFrame:CGRectMake(10, 100, 300, 100)];
    self.view_test.backgroundColor = [UIColor redColor];
    UIImage *maskImage1 = [UIImage imageNamed:@"layerTest"];
    self.view_test.layer.contents = (__bridge id)maskImage1.CGImage;
    [self.view addSubview:self.view_test];
    
//    
//    UILabel *label = [[UILabel alloc]init];
//    label.frame =CGRectMake(10, 20, 40, 20);
//    label.text = @"滑动解锁";
//    self.view_test.layer.mask = label.layer;
    
}


- (void)setMakeTranslation
{
    UIButton *bt = [UIButton buttonWithType:UIButtonTypeCustom];
    bt.frame = CGRectMake(0, K_height-100, widthBt, heightBt);
    [bt addTarget:self action:@selector(MakeTranslationBt) forControlEvents:UIControlEventTouchUpInside];
    [bt setTitle:@"MakeTranslation" forState:UIControlStateNormal];
    [bt setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    bt.titleLabel.font = [UIFont systemFontOfSize:12];
    [self.view addSubview:bt];
}

- (void)MakeTranslationBt
{
    self.view_test.transform = CGAffineTransformMakeTranslation(30, 30);
}

- (void)setTranslation
{
    UIButton *bt = [UIButton buttonWithType:UIButtonTypeCustom];
    bt.frame = CGRectMake(widthBt,K_height-100, widthBt, heightBt);
    [bt addTarget:self action:@selector(TranslationBt) forControlEvents:UIControlEventTouchUpInside];
    [bt setTitle:@"Translation" forState:UIControlStateNormal];
    [bt setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    bt.titleLabel.font = [UIFont systemFontOfSize:12];
    [self.view addSubview:bt];
}

- (void)TranslationBt
{
    self.view_test.transform = CGAffineTransformTranslate(self.view_test.transform, 30, 30);
}

- (void)setMaskInView
{
    UIButton *bt = [UIButton buttonWithType:UIButtonTypeCustom];
    bt.frame = CGRectMake(2*widthBt,K_height-100, widthBt, heightBt);
    [bt addTarget:self action:@selector(MaskInViewBt) forControlEvents:UIControlEventTouchUpInside];
    [bt setTitle:@"Mask" forState:UIControlStateNormal];
    [bt setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    bt.titleLabel.font = [UIFont systemFontOfSize:12];
    [self.view addSubview:bt];
    
}

- (void)MaskInViewBt
{
    //第一种 maskLayer
    CALayer *maskLayer = [CALayer layer];
    maskLayer.frame = self.view_test.bounds;

    UIImage *maskImage = [UIImage imageNamed:@"maskImage"];
    maskLayer.contents = (__bridge id)maskImage.CGImage;
    //如果mask的背景色为非clearcolor 会完全展现。
//    maskLayer.backgroundColor = [UIColor whiteColor].CGColor;
    self.view_test.layer.mask = maskLayer;
    
    //第二种 maskView

    UIImageView *image = [[UIImageView alloc]initWithFrame:self.view_test.bounds];
    image.frame = CGRectMake(20, 20, 50, 50);

    image.image = maskImage;
//    self.view_test.maskView = image;
    
}


- (void)setReset
{
    UIButton *bt = [UIButton buttonWithType:UIButtonTypeCustom];
    bt.frame = CGRectMake(3*widthBt,K_height-100, widthBt, heightBt);
    [bt addTarget:self action:@selector(resetBt) forControlEvents:UIControlEventTouchUpInside];
    [bt setTitle:@"重写运行" forState:UIControlStateNormal];
    [bt setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    bt.titleLabel.font = [UIFont systemFontOfSize:12];
    [self.view addSubview:bt];
}

- (void)resetBt
{
    [self.view_test removeFromSuperview];
    self.view_test = nil;
    [self creatView];

}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
