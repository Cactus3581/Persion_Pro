//
//  circleView.m
//  I'm a Coder
//
//  Created by xiaruzhen on 2017/8/5.
//  Copyright © 2017年 xiaruzhen. All rights reserved.
//

#import "circleView.h"
@interface circleView()
@property (nonatomic,assign) BOOL showAnimation;

@end

static CGFloat radius = 85.0f;
static CGFloat shapeLayerW = 16.0f;
static CGFloat layerW = 186.0f;
static CGFloat layerH = 140.0f;

@implementation circleView

- (instancetype)init {
    self = [super init];
    if (self) {
        [self configureAnimationViews];
    }
    return self;
}


#pragma mark - 油表进度动画
- (void)configureAnimationViews {
    //背景shapelayer
    self.backShapeLayer =[CAShapeLayer layer] ;
    UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter:CGPointMake(layerW/2.0, layerW/2.0) radius:radius startAngle:M_PI * 0.85 endAngle:M_PI * 0.15 clockwise:YES];
    self.backShapeLayer.lineCap = kCALineCapRound;
    self.backShapeLayer.path = path.CGPath;
    self.backShapeLayer.fillColor = [UIColor clearColor].CGColor;
    self.backShapeLayer.lineWidth = shapeLayerW;
    UIColor *color = [[UIColor darkGrayColor] colorWithAlphaComponent:.1f];
    self.backShapeLayer.strokeColor = color.CGColor;
    [self.layer addSublayer:self.backShapeLayer];
    
    //背景layer
    self.backLayer = [CALayer layer];
    self.backLayer.frame = CGRectMake(0, 0, layerW, layerH);
    [self.layer addSublayer:self.backLayer];
    
    //渐变层gradientLayer
    self.gradientLayer = [CAGradientLayer layer];
    self.gradientLayer.frame = CGRectMake(0, 0, layerW/2.0f, layerH);
    self.gradientLayer.startPoint = CGPointMake(0.5, 1.0);
    self.gradientLayer.endPoint = CGPointMake(0.5, 0);
    
    self.gradientLayer1 = [CAGradientLayer layer];
    self.gradientLayer1.frame = CGRectMake(layerW/2.0, 0, layerW/2.0, layerH);
    self.gradientLayer1.startPoint = CGPointMake(0.5, 0);
    self.gradientLayer1.endPoint = CGPointMake(0.5, 1);
    
    //maskShapeLayer & mask
    self.maskShapeLayer = [CAShapeLayer layer];
    self.maskShapeLayer.path = path.CGPath;
    self.maskShapeLayer.lineWidth = shapeLayerW;
    self.maskShapeLayer.fillColor = [UIColor clearColor].CGColor;
    self.maskShapeLayer.strokeColor = [UIColor redColor].CGColor;
    self.maskShapeLayer.lineCap = kCALineCapRound;
    self.maskShapeLayer.path = path.CGPath;
    
    [self.backLayer addSublayer:self.gradientLayer];
    [self.backLayer addSublayer:self.gradientLayer1];
    //    self.backLayer.mask = self.maskShapeLayer;
    

}
- (void)setTotlaScore:(NSInteger)totalScore score:(NSInteger)score {
    if (_showAnimation) {
        return;
    }
    _showAnimation = YES;

    CGFloat persentfloat = 1.00*score/totalScore;
    if (persentfloat <= 0.50) {
        NSMutableArray *colors1 = [NSMutableArray array];
        for (int hue  = 1; hue <= 5; hue++) {
            UIColor *colorX = [[UIColor whiteColor] colorWithAlphaComponent:1.0*hue/5.0];
            [colors1 addObject:(id)colorX.CGColor];
        }
        self.gradientLayer.colors = colors1;
        
        NSArray *locations = [NSArray array];
        if (persentfloat<0.2) {
            locations = @[@0.01,@0.05,@0.1,@0.15,@0.2];
        }else if (persentfloat<0.4) {
            locations = @[@0.1,@0.3,@0.5,@0.9];
        }else {
            locations = @[@0.1,@0.2,@0.3,@0.5,@0.6,@0.9];
        }
        self.gradientLayer.locations = locations;

        
        NSMutableArray *colors2 = [NSMutableArray array];
        for (int hue  = 1; hue <= 2; hue++) {
            UIColor *colorY = [[UIColor whiteColor] colorWithAlphaComponent:1];
            [colors2 addObject:(id)colorY.CGColor];
        }
//        self.gradientLayer1.colors = colors2;
    }else {
        NSMutableArray *colors1 = [NSMutableArray array];
        for (int hue  = 1; hue <= 7; hue++) {
            UIColor *colorX = [[UIColor whiteColor] colorWithAlphaComponent:1.0*hue/10.0];
            [colors1 addObject:(id)colorX.CGColor];
        }
        NSMutableArray *colors2 = [NSMutableArray array];
        for (int hue  = 0; hue <= 3; hue++) {
            UIColor *colorY = [[UIColor whiteColor] colorWithAlphaComponent:0.7+1.0*hue/10.00];
            [colors2 addObject:(id)colorY.CGColor];
        }
        self.gradientLayer.colors = colors1;
        self.gradientLayer.locations = @[@0.1,@0.2,@0.3,@0.4,@0.5,@0.6,@0.8];
        
        NSArray *locations = [NSArray array];
        UIColor *colorY1 = [[UIColor whiteColor] colorWithAlphaComponent:0.7];
        self.gradientLayer1.colors = colors2;
        if (persentfloat<0.7) {
            //            self.gradientLayer1.colors = @[colorY1,KSColor(70)];
            //            locations = @[@0.2,@0.8];
            locations = @[@0.2,@0.1,@0.1,@0.6];
            
        }else if (persentfloat<0.8) {
            locations = @[@0.2,@0.1,@0.1,@0.6];
        }else {
            locations = @[@0.2,@0.1,@0.2,@0.5];
        }
        self.gradientLayer1.locations = locations;
    }
    
    NSString *persent = [NSString stringWithFormat:@"%.2f",1.00*score/totalScore];
    self.animation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    self.animation.duration = 1.5;
    self.animation.fromValue = @0;
    self.animation.toValue = [NSNumber numberWithDouble:[persent doubleValue]];
    
    self.animation.removedOnCompletion = NO;
    self.animation.fillMode = kCAFillModeForwards;
    [self.maskShapeLayer addAnimation:self.animation forKey:nil];
}

@end
