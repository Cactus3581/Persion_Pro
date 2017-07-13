//
//  KSCertificateView.m
//  I'm a Coder
//
//  Created by xiaruzhen on 2017/7/12.
//  Copyright © 2017年 xiaruzhen. All rights reserved.
//

#import "KSCertificateView.h"

@implementation KSCertificateView

- (void)awakeFromNib {
    [super awakeFromNib];
    self.backgroundColor = [UIColor lightGrayColor];
    self.backViewTop.backgroundColor = [UIColor whiteColor];
    self.bottomLabel.text = @"学英语\n就用金山词霸APP";
    //    self.backViewTop.layer.shadowColor = [UIColor blackColor].CGColor;
    //阴影的透明度
    self.backViewTop.layer.shadowOpacity = 0.8f;
    //阴影的圆角
    self.backViewTop.layer.shadowRadius = 4.f;
    //阴影偏移量
    self.backViewTop.layer.shadowOffset = CGSizeMake(4,4);
    
    
    self.backViewTop.layer.shadowColor = [UIColor blackColor].CGColor;//shadowColor阴影颜色
    self.backViewTop.layer.shadowOffset = CGSizeMake(0,0);//shadowOffset阴影偏移，默认(0, -3),这个跟shadowRadius配合使用
    self.backViewTop.layer.shadowOpacity = 1;//阴影透明度，默认0
    self.backViewTop.layer.shadowRadius = 3;//阴影半径，默认3
    
    //路径阴影
    UIBezierPath *path = [UIBezierPath bezierPath];
    
    float width = self.backViewTop.bounds.size.width;
    float height = self.backViewTop.bounds.size.height;
    float x = self.backViewTop.bounds.origin.x;
    float y = self.backViewTop.bounds.origin.y;
    float addWH = 10;
    
    CGPoint topLeft      = self.backViewTop.bounds.origin;
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
    self.backViewTop.layer.shadowPath = path.CGPath;
}

- (void)layoutSubviews {
    [super layoutSubviews];
//    self.bottomViewH.constant = widthRatio(90);
}

@end
