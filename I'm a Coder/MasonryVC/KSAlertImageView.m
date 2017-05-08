//
//  KSAlertImageView.m
//  PowerWord7
//
//  Created by xiaruzhen on 2017/5/3.
//  Copyright © 2017年 Kingsoft. All rights reserved.
//

#import "KSAlertImageView.h"
#import "UIImageView+WebCache.h"

#ifndef KSFont
#define KSFont(_s_) [UIFont systemFontOfSize:widthRatioFont(_s_)]
#endif

static CGFloat const KbtH = 50;
static CGFloat const KalertW = 590/2;
static CGFloat const Kcorners = 16;
static CGFloat const Kedge = 40;


@implementation KSAlertImageView

+ (instancetype)alterViewWithModel:(id)model
                   cancelBtClcik:(cancelBlock)cancelBlock
                     sureBtClcik:(sureBlock)sureBlock {
    KSAlertImageView *alterView = [[KSAlertImageView alloc]initWithModel:model];
    alterView.cancel_block = cancelBlock;
    alterView.sure_block = sureBlock;
    return alterView;
}

- (instancetype)initWithModel:(id)model {
    self = [super init];
    if (self) {
        [self initializeUI];
    }
    return self;
}

#pragma mark - initialize methods
- (void)initializeUI {
    self.maskView = [[UIView alloc]init];
    UIColor *color = [UIColor lightGrayColor];
    self.maskView.backgroundColor = [color colorWithAlphaComponent:.5f];
    self.backgroundColor = [UIColor whiteColor];
    self.alpha = 1.0f;
    [[UIApplication sharedApplication].keyWindow addSubview:_maskView];
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    [self.maskView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.equalTo(window);
        make.center.equalTo(window);
    }];
    [_maskView addSubview:self];
    self.lineView = [[UIView alloc]init];
    self.lineView.backgroundColor =  [UIColor lightGrayColor];
    self.alertImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"guide_background"]];
    self.alertRightBt = [UIButton buttonWithType:UIButtonTypeCustom];
    self.alertLeftBt = [UIButton buttonWithType:UIButtonTypeCustom];
    self.alertImageView.contentMode =UIViewContentModeScaleAspectFill;
    self.alertImageView.clipsToBounds = YES;
    [self.alertLeftBt setTitle:@"不用了" forState:UIControlStateNormal];
    self.alertLeftBt.backgroundColor =  [UIColor lightGrayColor];
    self.alertLeftBt.titleLabel.font = KSFont(17);
    [self.alertLeftBt addTarget:self action:@selector(cancelBtClick) forControlEvents:UIControlEventTouchUpInside];
    self.alertRightBt.backgroundColor =  [UIColor redColor];
    self.alertRightBt.titleLabel.font = KSFont(17);
    [self.alertRightBt addTarget:self action:@selector(sureBtClick) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.alertImageView];
    [self addSubview:self.lineView];
    [self addSubview:self.alertRightBt];
    [self addSubview:self.alertLeftBt];
    [self mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(_maskView);
        make.height.width.mas_equalTo(widthRatioUnique(KalertW));
    }];
    
    [self.alertImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self);
        make.bottom.equalTo(self).offset(-widthRatioUnique(KbtH));
    }];
    
    self.layer.cornerRadius = widthRatioUnique(Kcorners);
    self.layer.masksToBounds = YES;
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.alertImageView);
        make.right.equalTo(self.mas_centerX);
        make.top.equalTo(self.alertImageView.mas_bottom).offset(1);
        make.height.mas_equalTo(1);
    }];
    
    [self.alertLeftBt mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.equalTo(self);
        make.right.equalTo(self.lineView);
        make.top.equalTo(self.lineView.mas_bottom);
    }];
    
    [self.alertRightBt mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self);
        make.bottom.equalTo(self);
        make.top.equalTo(self.alertImageView.mas_bottom).offset(1);
        make.left.equalTo(self.alertLeftBt.mas_right);
    }];
    
    
    [self.alertRightBt setTitle:@"test" forState:UIControlStateNormal];
}

- (void)layoutSubviews {
    [super layoutSubviews];
}


#pragma mark----取消按钮点击事件
- (void)cancelBtClick {
    [self removeAlert:NO];
}

#pragma mark----确定按钮点击事件
- (void)sureBtClick {
    [self removeAlert:YES];
}

- (void)removeAlert:(BOOL)isAgree {
    [UIView animateWithDuration:0.25 animations:^{
        _maskView.alpha = 0.0;
        self.alpha = .0f;
    } completion:^(BOOL finished) {
        [_maskView removeFromSuperview];
        [self removeFromSuperview];
        if (isAgree) {
            self.sure_block();
        }else
        {
            self.cancel_block();
        }
    }];
}



// 返回字体比例
static inline CGFloat widthRatioFont(CGFloat number){
    return number * KScreenWidthRatioFont();
}

CGFloat KScreenWidthRatioFont();
CGFloat KScreenWidthRatioFont(){
    static CGFloat ratio;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        ratio = [UIScreen mainScreen].bounds.size.width / 375.0f;
    });
    return ratio;
}

@end
