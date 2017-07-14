//
//  KSGrammarUnfinishedController.m
//  I'm a Coder
//
//  Created by xiaruzhen on 2017/7/14.
//  Copyright © 2017年 xiaruzhen. All rights reserved.
//

#import "KSGrammarUnfinishedController.h"
#import "KSWaterWaveView.h"

@interface KSGrammarUnfinishedController ()

@end

@implementation KSGrammarUnfinishedController

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

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    self.circleBackView.layer.cornerRadius  = self.circleBackView.bounds.size.width/2;
    self.circleLittleBackView.layer.cornerRadius  = self.circleLittleBackView.bounds.size.width/2;
    [self configueShadowColor];
}

#pragma mark - Configue Subviews
- (void)configueView {
    self.view.backgroundColor = [UIColor lightGrayColor];
    [self.keepButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.keepButton.layer.cornerRadius = 3.0f;
    self.keepButton.backgroundColor = [UIColor greenColor];
    [self waterWave];
}

- (void)waterWave {
    UIView *circleBackView = [[UIView alloc]init];
    circleBackView.layer.borderWidth = 1.0f / [UIScreen mainScreen].scale;
    circleBackView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    circleBackView.backgroundColor = [UIColor clearColor];
    self.circleBackView = circleBackView;
    [self.backImageVIew addSubview:self.circleBackView];
    [self.circleBackView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.backImageVIew.mas_centerY).offset(40);
        make.right.equalTo(self.backImageVIew).offset(-50);
        make.left.equalTo(self.backImageVIew).offset(50);
        make.height.mas_equalTo(self.circleBackView.mas_width).multipliedBy(1);
    }];
    
    
    self.circleLittleBackView = [[UIView alloc]init];
    self.circleLittleBackView.layer.borderWidth = 1.0f / [UIScreen mainScreen].scale;
    self.circleLittleBackView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.circleLittleBackView.backgroundColor = [UIColor clearColor];
    [self.circleBackView addSubview:self.circleLittleBackView];
    [self.circleLittleBackView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.circleBackView);
        make.right.equalTo(self.circleBackView).offset(-16);
        make.left.equalTo(self.circleBackView).offset(16);
        make.height.mas_equalTo(self.circleLittleBackView.mas_width).multipliedBy(1);
    }];
    
    KSWaterWaveView *waterWaveView = [KSWaterWaveView waterWaveView];
    waterWaveView.percent = 0.56;
    waterWaveView.speed = 0.1;
    waterWaveView.peak = 6;
    waterWaveView.titleText = @"完成度";
    waterWaveView.titleFont = 16;
    waterWaveView.titleColor = [UIColor blueColor];
    waterWaveView.completeProgressText = @"56%";
    waterWaveView.completeProgressColor = [UIColor blueColor];
    waterWaveView.completeProgressFont = 75;
    [self.circleLittleBackView addSubview:waterWaveView];
    [waterWaveView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.circleLittleBackView);
        make.right.equalTo(self.circleLittleBackView).offset(-2);
        make.left.equalTo(self.circleLittleBackView).offset(2);
        make.height.mas_equalTo(waterWaveView.mas_width).multipliedBy(1);
    }];
    [waterWaveView startWave];
}

#pragma mark - Configue ShadowColor
- (void)configueShadowColor {
    self.backImageVIew.layer.shadowColor = [UIColor blackColor].CGColor;
    self.backImageVIew.layer.shadowOffset = CGSizeMake(0,0);
    self.backImageVIew.layer.shadowOpacity = 0.6;
    self.backImageVIew.layer.shadowRadius = 10;
    //路径阴影
    UIBezierPath *path = [UIBezierPath bezierPath];
    float width = self.backImageVIew.bounds.size.width;
    float height = self.backImageVIew.bounds.size.height;
    float x = self.backImageVIew.bounds.origin.x;
    float y = self.backImageVIew.bounds.origin.y;
    float addWH = 0.0f;
    CGPoint topLeft      = self.backImageVIew.bounds.origin;
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
    self.backImageVIew.layer.shadowPath = path.CGPath;
}

#pragma mark - 跳往下一章
- (IBAction)keepStepAction:(id)sender {
    
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
