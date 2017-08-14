//
//  AVPLayViewController.m
//  I'm a Coder
//
//  Created by xiaruzhen on 2017/8/7.
//  Copyright © 2017年 xiaruzhen. All rights reserved.
//

#import "AVPLayViewController.h"
#import "AVSecondController.h"
#import "AudioPlayerView.h"

@interface AVPLayViewController ()

@end

@implementation AVPLayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self setAVPlayView];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}

- (void)setAVPlayView {
    [self.view addSubview:self.playerView];
    [self.playerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(30);
        make.right.equalTo(self.view).offset(-30);
        make.centerY.equalTo(self.view);
        make.height.mas_equalTo(40);
    }];
    
    UIButton *bt = [UIButton buttonWithType:UIButtonTypeCustom];
    [bt setTitle:@"push" forState:UIControlStateNormal];
    [bt setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [bt addTarget:self action:@selector(tapButton) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:bt];
    [bt mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.bottom.equalTo(self.view).offset(-60);
        make.height.mas_equalTo(40);
        make.width.mas_equalTo(60);

    }];
    
    UIButton *bt1 = [UIButton buttonWithType:UIButtonTypeCustom];
    [bt1 setTitle:@"push" forState:UIControlStateNormal];
    [bt1 setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [bt1 addTarget:self action:@selector(tapButton1) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:bt1];
    [bt1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.bottom.equalTo(self.view).offset(-120);
        make.height.mas_equalTo(40);
        make.width.mas_equalTo(60);
        
    }];
}

- (void)tapButton {
    AVSecondController *vc = [[AVSecondController alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)tapButton1 {
    [self.playerView preparePlay];

}

- (AVplayerView *)playerView {
    if (!_playerView) {
        _playerView = [AVplayerView shareAVplayerView];
        _playerView.urlString = @"http://comment.cache.iciba.com/dialogue/40/21701595/8188da59-5d14-498f-ba72-3b19dc7185db.mp3";
    }
    return _playerView;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
