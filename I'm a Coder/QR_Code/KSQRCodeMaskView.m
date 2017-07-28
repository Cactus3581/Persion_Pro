//
//  KSQRCodeMaskView.m
//  I'm a Coder
//
//  Created by xiaruzhen on 2017/7/27.
//  Copyright © 2017年 xiaruzhen. All rights reserved.
//

#import "KSQRCodeMaskView.h"

@interface KSQRCodeMaskView()
@property (nonatomic, strong) UIView * maskView;
@property (nonatomic, strong) UIImageView * topLeftImg;
@property (nonatomic, strong) UIImageView * topRightImg;
@property (nonatomic, strong) UIImageView * bottomLeftImg;
@property (nonatomic, strong) UIImageView * bottomRightImg;
@property (nonatomic, strong) UIBezierPath * bezier;
@property (nonatomic, strong) CAShapeLayer * shapeLayer;
@property (nonatomic, strong) UIView * backView;

@end

static CGFloat bedge = 60;

@implementation KSQRCodeMaskView

- (instancetype)init{
    self = [super init];
    if (self) {
        [self initSubViews];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
//    self.shapeLayer.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight);
//    [self.bezier appendPath:[[UIBezierPath bezierPathWithRect:CGRectMake(kScreenWidth/2-kScreenWidthUnique/6*4.0/2, kScreenHeight/2-kScreenWidthUnique/6*4.0/2, kScreenWidthUnique/6*4.0, kScreenWidthUnique/6*4.0)] bezierPathByReversingPath]];
//    [self.bezier appendPath:[[UIBezierPath bezierPathWithRect:CGRectMake(self.backView.frame.origin.x, self.backView.frame.origin.y, kScreenWidthUnique/6*4.0, kScreenWidthUnique/6*4.0)] bezierPathByReversingPath]];
}

- (CAShapeLayer *)shapeLayer {
    if (!_shapeLayer) {
        _shapeLayer = [CAShapeLayer layer];
        _shapeLayer.fillColor = [UIColor redColor].CGColor;
    }
//    _shapeLayer.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight);
    return _shapeLayer;
}

//- (UIBezierPath *)bezier {
//    if (!_bezier) {
//        //扫描框
////       _bezier = [UIBezierPath bezierPathWithRect:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
////        [_bezier appendPath:[[UIBezierPath bezierPathWithRect:CGRectMake(kScreenWidth/2-kScreenWidthUnique/6*4.0/2, kScreenHeight/2-kScreenWidthUnique/6*4.0/2, kScreenWidthUnique/6*4.0, kScreenWidthUnique/6*4.0)] bezierPathByReversingPath]];
//    }
//    return _bezier;
//}

- (void)initSubViews {
    //遮罩层
    self.maskView = [[UIView alloc] init];
    self.maskView.backgroundColor = [UIColor blackColor];
    self.maskView.alpha = 0.3;
    [self addSubview:self.maskView];
    [self.maskView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    
    //扫描框
    self.shapeLayer.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight);
   _bezier = [UIBezierPath bezierPathWithRect:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];

    [self.bezier appendPath:[[UIBezierPath bezierPathWithRect:CGRectMake(kScreenWidth/2-kScreenWidthUnique/6*4.0/2, kScreenHeight/2-kScreenWidthUnique/6*4.0/2, kScreenWidthUnique/6*4.0, kScreenWidthUnique/6*4.0)] bezierPathByReversingPath]];
    self.shapeLayer.path = self.bezier.CGPath;
    self.maskView.layer.mask = self.shapeLayer;
    
    //边框背景
    self.backView = [[UIView alloc]init];
    [self addSubview:self.backView];
    [self.backView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_offset(kScreenWidthUnique/6*4.0);
        make.centerY.centerX.equalTo(self);
        make.height.equalTo(self.backView.mas_width).multipliedBy(1.0);
    }];
    
    //边框
    UIImage * topLeft = [UIImage imageNamed:@"ScanQR1"];
    UIImage * topRight = [UIImage imageNamed:@"ScanQR2"];
    UIImage * bottomLeft = [UIImage imageNamed:@"ScanQR3"];
    UIImage * bottomRight = [UIImage imageNamed:@"ScanQR4"];
    
    //左上
    self.topLeftImg = [[UIImageView alloc] init];
    self.topLeftImg.image = topLeft;
    [self.backView addSubview:self.topLeftImg];
    
    //右上
    self.topRightImg = [[UIImageView alloc] init];
    self.topRightImg.image = topRight;
    [self.backView addSubview:self.topRightImg];
    
    //左下
    self.bottomLeftImg = [[UIImageView alloc] init];
    self.bottomLeftImg.image = bottomLeft;
    [self.backView addSubview:self.bottomLeftImg];
    
    //右下
    self.bottomRightImg = [[UIImageView alloc] init];
    self.bottomRightImg.image = bottomRight;
    [self.backView addSubview:self.bottomRightImg];
    
    [self.topLeftImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.mas_equalTo(20);
        make.left.top.equalTo(self.backView);
    }];
    
    [self.topRightImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.equalTo(self.topLeftImg);
        make.right.top.equalTo(self.backView);
    }];
    
    
    [self.bottomLeftImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.equalTo(self.topLeftImg);
        make.left.equalTo(self.topLeftImg);
        make.bottom.equalTo(self.backView);
    }];
    
    [self.bottomRightImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.equalTo(self.topLeftImg);
        make.right.equalTo(self.topRightImg);
        make.bottom.equalTo(self.backView);
    }];
}

- (void)set_preview_frame:(CGRect)rect {
    [_shapeLayer removeFromSuperlayer];
    _shapeLayer = nil;
    _bezier = nil;
    //扫描框
    self.shapeLayer.frame = CGRectMake(0, 0,rect.size.width,rect.size.height);
    _bezier = [UIBezierPath bezierPathWithRect:CGRectMake(0, 0, rect.size.width,rect.size.height)];

    [self.bezier appendPath:[[UIBezierPath bezierPathWithRect:CGRectMake(rect.size.width/2-kScreenWidthUnique/6*4.0/2, rect.size.height/2-kScreenWidthUnique/6*4.0/2, kScreenWidthUnique/6*4.0, kScreenWidthUnique/6*4.0)] bezierPathByReversingPath]];

    self.shapeLayer.path = self.bezier.CGPath;
//    [self.layer addSublayer:self.shapeLayer];
    
    self.maskView.layer.mask = self.shapeLayer;

//    self.shapeLayer.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight);
//    [self.bezier appendPath:[[UIBezierPath bezierPathWithRect:CGRectMake(667/2-kScreenWidthUnique/6*4.0/2, 375/2-kScreenWidthUnique/6*4.0/2, kScreenWidthUnique/6*4.0, kScreenWidthUnique/6*4.0)] bezierPathByReversingPath]];
//    [self.bezier appendPath:[[UIBezierPath bezierPathWithRect:CGRectMake(self.backView.frame.origin.x, self.backView.frame.origin.y, kScreenWidthUnique/6*4.0, kScreenWidthUnique/6*4.0)] bezierPathByReversingPath]];
}


@end
