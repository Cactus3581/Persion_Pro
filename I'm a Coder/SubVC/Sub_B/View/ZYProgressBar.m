//
//  ZYProgressBar.m
//  ZYDownloadProgress
//
//  Created by zY on 17/1/9.
//  Copyright © 2017年 zY. All rights reserved.
//

#import "ZYProgressBar.h"
#import "ZYProgressIndicator.h"

static CGFloat const insetX = 20;
static CGFloat const insetY = 20;
static CGFloat const IndicatorW = 1.5*insetX;
static CGFloat const IndicatorH = 20;
static CGFloat const insprogressY = 25;
static CGFloat const kProgressWidth = 4.f;

static CGFloat const kwidth = 250.f;
static CGFloat const kheight = 80.f;


static ZYProgressBar  *progressBar = nil;

@interface ZYProgressBar () <CAAnimationDelegate>
@property (nonatomic, strong) ZYProgressIndicator *indicator;
@property (nonatomic, strong) CAShapeLayer *containerLayer;
@property (nonatomic, strong) CAShapeLayer *progressLayer;
@property (nonatomic, strong) CADisplayLink *displayLink;
@property (nonatomic, strong) UIView *backView;

@end

@implementation ZYProgressBar

+ (instancetype)show
{
    ZYProgressBar *progressBar = [[ZYProgressBar alloc]init];
    return progressBar;
}

+ (void)hide
{
    progressBar.alpha = 0.f;
    [progressBar removeFromSuperview];
    [progressBar.displayLink removeFromRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
    [progressBar.displayLink invalidate];
    progressBar.displayLink = nil;
}

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
    [[UIApplication sharedApplication].keyWindow addSubview:self];
    self.frame = [UIScreen mainScreen].bounds;
    UIColor *color = [UIColor whiteColor];
    self.backgroundColor = [color colorWithAlphaComponent:.5f];
    self.backView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kwidth, kheight)];
    self.backView.center = CGPointMake(self.frame.size.width/2, self.frame.size.height/2);
    self.backView.layer.cornerRadius = 5.0f;
    self.backView.backgroundColor = [UIColor whiteColor];
    self.backView.alpha = 1.0f;
    [self addSubview:self.backView];
    
    [self.backView.layer addSublayer:self.containerLayer];
    [self.backView.layer addSublayer:self.progressLayer];
    
    self.indicator = [[ZYProgressIndicator alloc] initWithFrame:(CGRect){insetX-IndicatorW/2.0,insetY,IndicatorW,IndicatorH}];
    [self.backView addSubview:self.indicator];

    __weak typeof(self) weakSelf = self;
    self.indicator.completeBlock = ^(BOOL flag){
        if (weakSelf.completeBlock) {
            weakSelf.completeBlock(flag);
        }
    };
    [self.displayLink addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
}

- (void)setProgress:(CGFloat)progress
{
    progress = MIN(MAX(progress, 0.0), 1.0);
    _progress = progress;
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.indicator setProgress:progress];
    });
    if (progress==1.0f) {
        [self.displayLink removeFromRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
        [self.displayLink invalidate];
        self.displayLink = nil; 
    }
}

- (UIBezierPath *)progressPathWithProgress:(CGFloat)progress
{
    UIBezierPath *path = [UIBezierPath bezierPath];
    CGPoint startPoint = (CGPoint){insetX+kProgressWidth/2.0,insprogressY+kProgressWidth/2.0+insetY};
    CGPoint endPoint = (CGPoint){(CGRectGetWidth(self.backView.frame)-(insetX+kProgressWidth/2.0)*2)*progress+insetX+kProgressWidth/2.0,startPoint.y};
    [path moveToPoint:startPoint];
    [path addLineToPoint:endPoint];
    [path closePath];
    return path;
}

- (CAShapeLayer *)containerLayer
{
    if (!_containerLayer) {
        _containerLayer = [self defaultLayer];
        CGRect rect = (CGRect){insetX,insprogressY+insetY,self.backView.bounds.size.width-insetX*2,kProgressWidth};
        _containerLayer.path = [UIBezierPath bezierPathWithRoundedRect:rect cornerRadius:5].CGPath;
    }
    return _containerLayer;
}

- (CAShapeLayer *)progressLayer
{
    if (!_progressLayer) {
        _progressLayer = [self defaultLayer];
        _progressLayer.lineWidth = kProgressWidth;
        _progressLayer.strokeColor = [UIColor blueColor].CGColor;
    }
    return _progressLayer;
}

- (CAShapeLayer *)defaultLayer
{
    CAShapeLayer *layer = [CAShapeLayer layer];
    layer.fillColor = [UIColor grayColor].CGColor;
    layer.strokeColor = [UIColor grayColor].CGColor;
    layer.lineCap = kCALineCapRound;
    layer.lineJoin = kCALineJoinRound;
    layer.frame = self.bounds;
    return layer;
}

- (CADisplayLink *)displayLink
{
    if (!_displayLink) {
        _displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(refreshUI)];
    }
    return _displayLink;
}


- (void)refreshUI
{
    self.indicator.transform = CGAffineTransformMakeTranslation((CGRectGetWidth(self.backView.frame)-insetX*2)*_progress, 0);
    self.progressLayer.path = [self progressPathWithProgress:_progress].CGPath;
}


- (void)dealloc
{
    
}

@end
