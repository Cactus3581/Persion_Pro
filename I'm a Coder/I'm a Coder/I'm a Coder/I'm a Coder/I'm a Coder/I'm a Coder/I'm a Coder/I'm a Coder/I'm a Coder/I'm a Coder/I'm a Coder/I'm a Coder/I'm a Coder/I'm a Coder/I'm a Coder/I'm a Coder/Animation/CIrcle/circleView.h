//
//  circleView.h
//  I'm a Coder
//
//  Created by xiaruzhen on 2017/8/5.
//  Copyright © 2017年 xiaruzhen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface circleView : UIView
@property (nonatomic,strong) CAShapeLayer *backShapeLayer;
@property (nonatomic,strong) CAShapeLayer *maskShapeLayer;
@property (nonatomic,strong) CALayer *backLayer;

@property (nonatomic,strong) CAGradientLayer *gradientLayer;
@property (nonatomic,strong) CAGradientLayer *gradientLayer1;

@property (nonatomic,strong) UIBezierPath *path;
@property (nonatomic,strong) CABasicAnimation *animation;
- (void)setTotlaScore:(NSInteger)totalScore score:(NSInteger)score;

@end
