//
//  MPlayerView.m
//  I'm a Coder
//
//  Created by xiaruzhen on 2017/5/8.
//  Copyright © 2017年 xiaruzhen. All rights reserved.
//

#import "MPlayerView.h"

@implementation MPlayerView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initalizeUI];
    }
    
    return self;
}

- (void)initalizeUI
{
    self.mPlayer = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@""]];
    self.backgroundColor = [UIColor redColor];
    [self addSubview:self.mPlayer];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    [self.mPlayer mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.centerY.centerX.equalTo(self);
    }];
    NSLog(@"self.frame %@",NSStringFromCGRect(self.frame));
    NSLog(@"self.mPlayer.frame %@",NSStringFromCGRect(self.mPlayer.frame));
}
@end
