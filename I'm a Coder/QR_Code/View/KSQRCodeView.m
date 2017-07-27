//
//  KSQRCodeView.m
//  PowerWord7
//
//  Created by xiaruzhen on 2017/7/27.
//  Copyright © 2017年 Kingsoft. All rights reserved.
//

#import "KSQRCodeView.h"
@interface KSQRCodeView()
@property (nonatomic, strong) UIImageView * scanLineImg;
@property (nonatomic, strong) UIBezierPath * bezier;
@property (nonatomic, strong) CAShapeLayer * shapeLayer;
@property (weak, nonatomic) IBOutlet UIView *maskView;
@property (weak, nonatomic) IBOutlet UIImageView *topLeftImg;
@property (weak, nonatomic) IBOutlet UIImageView *topRightImg;
@property (weak, nonatomic) IBOutlet UIImageView *bottomLeftImg;
@property (weak, nonatomic) IBOutlet UIImageView *bottomRightImg;
@end

@implementation KSQRCodeView

- (void)awakeFromNib {
    [super awakeFromNib];
    [self congigureSunviews];
}

/**
 *  添加UI
 */
- (void)congigureSunviews{
    //遮罩层
    self.maskView.backgroundColor = [UIColor blackColor];
    self.maskView.alpha = 0.3;
    self.maskView.layer.mask = [self maskLayer];
    //边框
    UIImage * topLeft = [UIImage imageNamed:@"ScanQR1"];
    UIImage * topRight = [UIImage imageNamed:@"ScanQR2"];
    UIImage * bottomLeft = [UIImage imageNamed:@"ScanQR3"];
    UIImage * bottomRight = [UIImage imageNamed:@"ScanQR4"];
    
    //左上
    self.topLeftImg.image = topLeft;
    
    //右上
    self.topRightImg.image = topRight;
    
    //左下
    self.bottomLeftImg.image = bottomLeft;
    
    //右下
    self.bottomRightImg.image = bottomRight;
    
    //扫描线
    UIImage * scanLine = [UIImage imageNamed:@"QRCodeScanLine"];
    self.scanLineImg = [[UIImageView alloc] init];
    self.scanLineImg.image = scanLine;
    self.scanLineImg.contentMode = UIViewContentModeScaleAspectFit;
    [self addSubview:self.scanLineImg];
    [self.scanLineImg.layer addAnimation:[self animation] forKey:nil];
}

/**
 *  动画
 */
- (CABasicAnimation *)animation{
    CABasicAnimation * animation = [CABasicAnimation animationWithKeyPath:@"position"];
    animation.duration = 3;
    animation.fillMode = kCAFillModeForwards;
    animation.removedOnCompletion = NO;
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    animation.repeatCount = MAXFLOAT;
    
//    animation.fromValue = [NSValue valueWithCGPoint:CGPointMake(self.center.x, (self.center.y - self.frame.size.height * ZFScanRatio * 0.5 + self.scanLineImg.image.size.height * 0.5))];
//    animation.toValue = [NSValue valueWithCGPoint:CGPointMake(self.center.x, (self.center.y + self.frame.size.height * ZFScanRatio * 0.5 - self.scanLineImg.image.size.height * 0.5))];
    return animation;
}

/**
 *  遮罩层bezierPath
 *
 *  @return UIBezierPath
 */
- (UIBezierPath *)maskPath{
    self.bezier = nil;
    self.bezier = [UIBezierPath bezierPathWithRect:CGRectMake(0, 0, 100, 100)];
    [self.bezier appendPath:[[UIBezierPath bezierPathWithRect:CGRectMake((self.frame.size.width - (self.frame.size.width )) * 0.5, (self.frame.size.height - (self.frame.size.width )) * 0.5, self.frame.size.width , self.frame.size.width )] bezierPathByReversingPath]];

    return self.bezier;
}

/**
 *  遮罩层ShapeLayer
 *
 *  @return CAShapeLayer
 */
- (CAShapeLayer *)maskLayer{
    [self.shapeLayer removeFromSuperlayer];
    self.shapeLayer = nil;
    self.shapeLayer = [CAShapeLayer layer];
    self.shapeLayer.frame = CGRectMake(50, 50, 100, 100);
    self.shapeLayer.path = [self maskPath].CGPath;
    return self.shapeLayer;
}

/**
 *  移除动画
 */
- (void)removeAnimation{
    [self.scanLineImg.layer removeAllAnimations];
}

@end

