//
//  KSGrammarBookCatalogueFooterView.m
//  I'm a Coder
//
//  Created by xiaruzhen on 2017/7/11.
//  Copyright © 2017年 xiaruzhen. All rights reserved.
//

#import "KSGrammarBookCatalogueFooterView.h"

@implementation KSGrammarBookCatalogueFooterView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.lineView = [[UIView alloc]init];
        self.lineView.backgroundColor = [UIColor lightGrayColor];
        [self addSubview:self.lineView];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(18.0);
        make.top.bottom.equalTo(self);
        make.width.mas_equalTo(1.0f / [UIScreen mainScreen].scale);
    }];
}

@end
