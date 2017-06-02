//
//  ZYProgressIndicator.m
//  ZYDownloadProgress
//
//  Created by zY on 17/1/9.
//  Copyright © 2017年 zY. All rights reserved.
//

#import "ZYProgressIndicator.h"

@interface ZYProgressIndicator ()
@property (nonatomic, strong) CAShapeLayer *triangleLayer;
@property (nonatomic, strong) CAShapeLayer *rectangleLayer;
@property (nonatomic, strong) UILabel *progressLabel;
@end

@implementation ZYProgressIndicator

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self configure];
    }
    return self;
}

- (void)configure
{
    self.triangleLayer = [self defaultLayer];
    self.rectangleLayer = [self defaultLayer];
    [self.layer addSublayer:self.triangleLayer];
    [self.layer addSublayer:self.rectangleLayer];
    
    
    CGFloat width = CGRectGetWidth(self.frame);
    CGFloat height = CGRectGetHeight(self.frame);
    
    CGFloat triangle_width = width/3;
    CGFloat triangle_height = height/4;
    
    CGFloat rectangle_width = width;
    CGFloat rectangle_height = height-triangle_height;
    
    CGRect rectangleRect = CGRectMake(0, 0, rectangle_width, rectangle_height);
    UIBezierPath *rectanglePath = [UIBezierPath bezierPathWithRoundedRect:rectangleRect cornerRadius:1];
    self.rectangleLayer.path = rectanglePath.CGPath;
    
    CGPoint startPoint = (CGPoint){triangle_width,rectangle_height};
    CGPoint bottomPoint = (CGPoint){width/2,height};
    CGPoint endPoint = (CGPoint){width/3*2,rectangle_height};
    UIBezierPath *triganlePath = [UIBezierPath bezierPath];
    [triganlePath moveToPoint:startPoint];
    [triganlePath addLineToPoint:bottomPoint];
    [triganlePath addLineToPoint:endPoint];
    [triganlePath closePath];
    self.triangleLayer.path = triganlePath.CGPath;
    
    self.progressLabel = [[UILabel alloc] init];
    self.progressLabel.frame = CGRectMake(0, 0, rectangle_width, rectangle_height) ;
    self.progressLabel.text = @"0%";
    self.progressLabel.textAlignment = NSTextAlignmentCenter;
    self.progressLabel.textColor = [UIColor whiteColor];
    self.progressLabel.backgroundColor = [UIColor blackColor];

    self.progressLabel.font = [UIFont systemFontOfSize:10];
    NSLog(@"%@,%@",NSStringFromCGRect(self.progressLabel.frame),NSStringFromCGRect(self.triangleLayer.frame));
    [self addSubview:self.progressLabel];
}

- (void)setProgress:(CGFloat)progress
{
    _progress = progress;
    self.progressLabel.text = [NSString stringWithFormat:@"%d%%",(int)(100*progress)];
    if (progress==1) {
        [self downloadSuccess];
    }
}

- (void)downloadSuccess
{
    if (self.completeBlock) {
        self.completeBlock(YES);
    }
    self.progressLabel.text = @"完成";
    CABasicAnimation *rotationAnim = [CABasicAnimation animationWithKeyPath:@"transform.rotation.y"];
    rotationAnim.toValue = @(M_PI);
    rotationAnim.duration = 0.2;
    [self.rectangleLayer addAnimation:rotationAnim forKey:nil];
    [self.triangleLayer addAnimation:rotationAnim forKey:nil];
    [self.progressLabel.layer addAnimation:rotationAnim forKey:nil];
}

- (CAShapeLayer *)defaultLayer
{
    CAShapeLayer *layer = [CAShapeLayer layer];
    layer.fillColor = [UIColor blackColor].CGColor;
    layer.strokeColor = [UIColor blackColor].CGColor;
    layer.lineCap = kCALineCapRound;
    layer.lineJoin = kCALineJoinRound;
    layer.frame = self.bounds;
    return layer;
}

@end
