//
//  KSAlertWindow.m
//  I'm a Coder
//
//  Created by xiaruzhen on 2017/7/12.
//  Copyright © 2017年 xiaruzhen. All rights reserved.
//

#import "KSAlertWindow.h"
#import "KSCertificateView.h"
@interface KSAlertWindow()
@property (nonatomic,strong) KSCertificateView *certificateView;
@end

@implementation KSAlertWindow

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.windowLevel = UIWindowLevelAlert;
        // 这里，不能设置UIWindow的alpha属性，会影响里面的子view的透明度，这里我们用一张透明的图片
        // 设置背影半透明
//        self.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"alert_bg.png"]];
        
        [self addSubview:self.certificateView];
        self.certificateView.frame = self.bounds;
//        [self.certificateView mas_makeConstraints:^(MASConstraintMaker *make) {
////            make.top.bottom.leading.trailing.equalTo(self);
//        }];
    }
    return self;
}

- (void)show {
    [self makeKeyAndVisible];
}

- (void)dismiss {
    [self resignKeyWindow];
}

- (KSCertificateView *)certificateView {
    if (!_certificateView) {
        _certificateView = [[[NSBundle mainBundle] loadNibNamed:@"KSCertificateView" owner:self options:nil]lastObject];
    }
    return _certificateView;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    // 点击消失
    [self dismiss];
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    
}


@end
