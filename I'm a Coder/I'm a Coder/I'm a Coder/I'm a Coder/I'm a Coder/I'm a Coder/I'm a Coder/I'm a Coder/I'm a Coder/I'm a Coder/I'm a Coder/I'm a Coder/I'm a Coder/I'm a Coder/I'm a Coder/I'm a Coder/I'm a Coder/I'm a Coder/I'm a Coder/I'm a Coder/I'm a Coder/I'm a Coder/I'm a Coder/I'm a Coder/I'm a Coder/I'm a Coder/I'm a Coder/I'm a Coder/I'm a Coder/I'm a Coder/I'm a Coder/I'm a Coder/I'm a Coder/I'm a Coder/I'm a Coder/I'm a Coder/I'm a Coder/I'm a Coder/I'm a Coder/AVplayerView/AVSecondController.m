//
//  AVSecondController.m
//  I'm a Coder
//
//  Created by xiaruzhen on 2017/8/7.
//  Copyright © 2017年 xiaruzhen. All rights reserved.
//

#import "AVSecondController.h"

@interface AVSecondController ()

@end

@implementation AVSecondController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self setAVPlayView];
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)setAVPlayView {
    [self.view addSubview:self.playerView];
    [self.playerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(30);
        make.right.equalTo(self.view).offset(-30);
        make.centerY.equalTo(self.view);
        make.height.mas_equalTo(40);
    }];
}

- (AVplayerView *)playerView {
    if (!_playerView) {
        _playerView = [AVplayerView shareAVplayerView];
//        _playerView.urlString = @"http://comment.cache.iciba.com/dialogue/40/21701595/8188da59-5d14-498f-ba72-3b19dc7185db.mp3";
    }
    return _playerView;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end

