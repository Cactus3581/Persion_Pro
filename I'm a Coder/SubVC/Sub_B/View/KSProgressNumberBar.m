//
//  KSProgressNumberBar.m
//  PowerWord7
//
//  Created by xiaruzhen on 2017/5/31.
//  Copyright © 2017年 Kingsoft. All rights reserved.
//

#import "KSProgressNumberBar.h"
#import "KSProgressIndicatorView.h"

static CGFloat const insetX = 20;
static CGFloat const insetY = 20;
static CGFloat const IndicatorW = 1.5*insetX;
static CGFloat const IndicatorH = 20;
static CGFloat const insprogressY = 25;
static CGFloat const kProgressWidth = 4.f;
static CGFloat const kwidth = 250.f;
static CGFloat const kheight = 80.f;
static KSProgressNumberBar  *progressBar = nil;

@interface KSProgressNumberBar () <CAAnimationDelegate>
@property (nonatomic, strong) KSProgressIndicatorView *indicator;
@property (nonatomic, strong) CAShapeLayer *containerLayer;
@property (nonatomic, strong) CAShapeLayer *progressLayer;
@property (nonatomic, strong) CADisplayLink *displayLink;
@property (nonatomic, strong) UIView *backView;

@end

@implementation KSProgressNumberBar

+ (instancetype)progressBar
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{

    });
    
    progressBar = [[KSProgressNumberBar alloc]init];
    return progressBar;
}

+ (void)show
{
    progressBar = [self progressBar];
    [progressBar configure];
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        //[self configure];
    }
    return self;
}

+ (void)setProgress:(CGFloat)progress
{    
    progressBar.progresss = progress;
}


- (void)setProgresss:(CGFloat)progresss
{
    _progresss = progresss;
    progresss = MIN(MAX(progresss, 0.0), 1.0);
    

    if (progresss<=1.0f) {
        dispatch_async(dispatch_get_main_queue(), ^{
            //指示器移动并且数字不断变化
            [progressBar.indicator setProgress:progresss];
        });
    }else
    {
        NSLog(@"%.2f",progresss);
    }


    
}


- (void)configure
{
    [[UIApplication sharedApplication].keyWindow addSubview:self];
    self.frame = [UIScreen mainScreen].bounds;
    UIColor *color = [UIColor blueColor];
    self.backgroundColor = [color colorWithAlphaComponent:.5f];
    [self addSubview:self.backView];
    [self.backView.layer addSublayer:self.containerLayer];
    [self.backView.layer addSublayer:self.progressLayer];
    [self.backView addSubview:self.indicator];
    __weak typeof(self) weakSelf = self;
    self.indicator.completeBlock = ^(BOOL flag){
//        if (weakSelf.completeBlock) {
//            weakSelf.completeBlock(flag);
            [weakSelf.displayLink invalidate];
            weakSelf.displayLink = nil;
            [weakSelf removeFromSuperview];
//        }
    };

//    [self resume];

    [self.displayLink addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
}

- (void)resume
{
    [progressBar.indicator setProgress:0.0f];
    self.indicator.transform = CGAffineTransformMakeTranslation((CGRectGetWidth(self.backView.frame)-insetX*2)*0, 0);
    self.progressLayer.path = [self progressPathWithProgress:0].CGPath;
}

- (void)refreshUI
{
    self.indicator.transform = CGAffineTransformMakeTranslation((CGRectGetWidth(self.backView.frame)-insetX*2)*_progresss, 0);
    self.progressLayer.path = [self progressPathWithProgress:_progresss].CGPath;
}

- (UIView *)backView
{
    if (!_backView) {
        _backView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kwidth, kheight)];
        _backView.center = CGPointMake(self.frame.size.width/2, self.frame.size.height/2);
        _backView.layer.cornerRadius = 5.0f;
        _backView.backgroundColor = [UIColor whiteColor];
        _backView.alpha = 1.0f;
    }
    return _backView;
}

- (KSProgressIndicatorView *)indicator
{
    if (!_indicator) {
        _indicator = [[KSProgressIndicatorView alloc] initWithFrame:(CGRect){insetX-IndicatorW/2.0,insetY,IndicatorW,IndicatorH}];
    }
    return _indicator;
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
    layer.fillColor = [UIColor lightGrayColor].CGColor;
    layer.strokeColor = [UIColor lightGrayColor].CGColor;
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

- (void)dealloc
{
    
}

@end
