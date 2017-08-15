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
@property (strong, nonatomic) UISlider *slider;
@property (strong, nonatomic) UIProgressView *progressView;
@end

@implementation KSPlayerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
//    [self configureSubviews];
//    [self configurePlay];
    
    
    _slider = [[UISlider alloc]init];
    [_slider setThumbImage:[UIImage imageNamed:@"avplyer"] forState:UIControlStateNormal];
    _slider.minimumTrackTintColor = [UIColor redColor];//小于滑块当前值滑块条的颜色，默认为白色
    _slider.maximumTrackTintColor = [UIColor blueColor];//大于滑块当前值滑块条的颜色
    
    _progressView = [[UIProgressView alloc]initWithProgressViewStyle:UIProgressViewStyleDefault];
    //后面的颜色（譬如进度到30%，那么30%部分后面的颜色就是这个属性）
    [_progressView setProgressTintColor:[UIColor blackColor]];
    //前面的颜色
    [_progressView setTrackTintColor:[UIColor greenColor]];
    _progressView.progress=0.5;
    


    [self.view addSubview:self.slider];

//    [self.view addSubview:self.progressView];

    [_slider addSubview:self.progressView];
//    [_slider sendSubviewToBack:_progressView];
    
    
    [_slider mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(30);
        make.bottom.equalTo(self.view).offset(-50);
        make.height.mas_equalTo(50);
        make.width.mas_equalTo(100);


    }];
    [_slider addTarget:self action:@selector(sliderValueChanged:) forControlEvents:UIControlEventValueChanged];

    [self.progressView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.slider);
        make.right.equalTo(self.slider);
        make.centerY.equalTo(self.slider).offset(1);
        make.height.mas_offset(2);
    }];
    

}
- (void)sliderValueChanged:(UISlider *)sender {
//    _progressView.progress = sender.value;
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
