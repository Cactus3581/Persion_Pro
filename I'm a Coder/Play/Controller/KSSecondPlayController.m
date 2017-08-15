//
//  KSSecondPlayController.m
//  I'm a Coder
//
//  Created by xiaruzhen on 2017/8/11.
//  Copyright © 2017年 xiaruzhen. All rights reserved.
//

#import "KSSecondPlayController.h"
#import "KSPlayerView.h"

@interface KSSecondPlayController ()
@end

@implementation KSSecondPlayController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.view.backgroundColor = [UIColor whiteColor];
    [self configureSubviews];
    [self configurePlay];
}

- (void)configureSubviews {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setTitle:@"push" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(playButtonClick) forControlEvents:UIControlEventTouchUpInside];
}

- (void)playButtonClick {
    KSSecondPlayController *vc = [[KSSecondPlayController alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)configurePlay {
    KSPlayerView *playView= [[KSPlayerView alloc]init];
    [self.view addSubview:playView];
    [playView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(15);
        make.right.equalTo(self.view).offset(-15);
        make.center.equalTo(self.view);
        make.height.mas_equalTo(40);

    }];
    playView.urlString = @"http://voice.iciba.com/upload/voa/mp317171717-03-01-03-22-55.mp3";
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
}

- (void)dealloc {
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
