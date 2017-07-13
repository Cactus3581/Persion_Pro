//
//  KSGrammarUnfinishedController.m
//  I'm a Coder
//
//  Created by xiaruzhen on 2017/7/14.
//  Copyright © 2017年 xiaruzhen. All rights reserved.
//

#import "KSGrammarUnfinishedController.h"

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

#pragma mark - Configue Subviews
- (void)configueView {
    self.view.backgroundColor = [UIColor lightGrayColor];
    [self.keepButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.keepButton.layer.cornerRadius = 3.0f;
    self.keepButton.backgroundColor = [UIColor greenColor];
    
    [self configueShadowColor];
}

#pragma mark - Configue ShadowColor
- (void)configueShadowColor {
    self.backImageVIew.layer.shadowColor = [UIColor blackColor].CGColor;//shadowColor阴影颜色
    self.backImageVIew.layer.shadowOffset = CGSizeMake(0,0);//shadowOffset阴影偏移，默认(0, -3),这个跟shadowRadius配合使用
    self.backImageVIew.layer.shadowOpacity = 0.6;//阴影透明度，默认0
    self.backImageVIew.layer.shadowRadius = 10;//阴影半径，默认3
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
