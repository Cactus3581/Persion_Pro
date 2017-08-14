//
//  KSPlayerViewController.m
//  I'm a Coder
//
//  Created by xiaruzhen on 2017/8/11.
//  Copyright © 2017年 xiaruzhen. All rights reserved.
//

#import "KSPlayerViewController.h"
#import "KSPlayerView.h"
#import "KSSecondPlayController.h"
#import "KSPlayerView.h"

@interface KSPlayerViewController ()
@property (strong, nonatomic) KSPlayerView *playView;

@end

@implementation KSPlayerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self configureSubviews];
    [self configurePlay];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if (_playView) {
        self.playView.keepDelegate = YES;
    }
}

- (void)configureSubviews {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setTitle:@"push" forState:UIControlStateNormal];
    button.backgroundColor = [UIColor redColor];
    [button addTarget:self action:@selector(playButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    [button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.bottom.equalTo(self.view).offset(-50);
    }];
    
    UIButton *button1 = [UIButton buttonWithType:UIButtonTypeCustom];
    [button1 setTitle:@"push" forState:UIControlStateNormal];
    button1.backgroundColor = [UIColor redColor];
    [button1 addTarget:self action:@selector(playButtonClick1) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button1];
    [button1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.bottom.equalTo(self.view).offset(-90);
    }];
    
    UIButton *button3 = [UIButton buttonWithType:UIButtonTypeCustom];
    [button3 setTitle:@"push" forState:UIControlStateNormal];
    button3.backgroundColor = [UIColor redColor];
    [button3 addTarget:self action:@selector(playButtonClick3) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button3];
    [button3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.bottom.equalTo(self.view).offset(-120);
    }];
}

- (void)playButtonClick {
    KSSecondPlayController *vc = [[KSSecondPlayController alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)playButtonClick1 {
    self.playView.urlString = @"http://comment.cache.iciba.com/dialogue/40/18765902/64f32efc-6fd2-4cee-85ed-c7837da8a0b7.mp3";

}

- (void)playButtonClick3 {
    self.playView.urlString = @"http://voice.iciba.com/upload/voa/mp317171717-03-01-03-22-55.mp3";

}

- (void)configurePlay {
    if (!_playView) {
        self.playView= [[KSPlayerView alloc]init];
        [self.view addSubview:self.playView];
        [self.playView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.view).offset(15);
            make.right.equalTo(self.view).offset(-15);
            make.center.equalTo(self.view);
            make.height.mas_equalTo(40);
        }];
    }

    self.playView.urlString = @"http://voice.iciba.com/upload/voa/mp317171717-03-01-03-22-55.mp3";
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
