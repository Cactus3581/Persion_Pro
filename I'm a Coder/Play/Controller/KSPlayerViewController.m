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
#import "KSSlider.h"
#import "UIButton+KSEnlargeEdge.h"

@interface KSPlayerViewController ()
@property (strong, nonatomic) KSPlayerView *playView;
@property (strong, nonatomic) UISlider *slider;
@property (strong, nonatomic) UIProgressView *progressView;
@property (nonatomic,strong) CALayer *layer1;
@property (nonatomic,strong) CALayer *layer2;
@property (nonatomic,strong) CALayer *layer3;
@property (nonatomic,strong) CALayer *layer4;
@property (nonatomic,strong) KSSlider *customslider;
@property(nonatomic,strong)UIButton *sliderBtn;

@end

@implementation KSPlayerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    
//    _sliderBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
//    _sliderBtn.backgroundColor = [UIColor lightGrayColor];
//    _sliderBtn.backgroundColor = [UIColor lightGrayColor];
//
//    _sliderBtn.userInteractionEnabled = YES;
//    _sliderBtn.layer.cornerRadius = 20 / 2;
//    
//    [_sliderBtn addTarget:self action:@selector(dragMovin)forControlEvents: UIControlEventTouchUpInside];
//    [self.view addSubview:_sliderBtn];
//    
//    
//    [_sliderBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.center.equalTo(self.view);
//        make.width.and.height.mas_equalTo(20);
//    }];
//    [_sliderBtn be_setEnlargeEdge:10];
    
    self.customslider = [[KSSlider alloc]init];
    self.customslider.value = 1;
    self.customslider.sliderBlocksize = 10;

    self.customslider.trackProgressHeight = 2;
    self.customslider.minimumTrackTintColor = [UIColor yellowColor];
    self.customslider.maximumTrackTintColor = [UIColor lightGrayColor];
    self.customslider.sliderBlockColor = [UIColor greenColor];
    [self.view addSubview:self.customslider];
    
    [self.customslider mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(30);
        make.width.mas_equalTo(100);
        make.top.equalTo(self.view.mas_top).offset(100);
        make.centerX.equalTo(self.view);
    }];
    [self.customslider startAnimating];
    
//    UIView *view  = [[UIView alloc]initWithFrame:CGRectMake(10, 98, 12, 10)];
//    [self.view addSubview:view];
//    view.backgroundColor = [UIColor greenColor];
//    self.layer1 = [CALayer layer];
//    self.layer1.anchorPoint = CGPointMake(0.5,1);
//    self.layer1.frame = CGRectMake(10, 103, 2, 5);
//    self.layer1.backgroundColor = [UIColor redColor].CGColor;
//    [self.view.layer addSublayer:self.layer1];
//    
//    self.layer2 = [CALayer layer];
//    self.layer2.anchorPoint = CGPointMake(0.5,1);
//    self.layer2.frame = CGRectMake(13, 98, 2, 10);
//    self.layer2.backgroundColor = [UIColor redColor].CGColor;
//    [self.view.layer addSublayer:self.layer2];
//    
//    self.layer3 = [CALayer layer];
//    self.layer3.anchorPoint = CGPointMake(0.5,1);
//    self.layer3.frame = CGRectMake(16, 103, 2, 5);
//    self.layer3.backgroundColor = [UIColor redColor].CGColor;
//    [self.view.layer addSublayer:self.layer3];
//    
//    self.layer4 = [CALayer layer];
//    self.layer4.anchorPoint = CGPointMake(0.5,1);
//    self.layer4.frame = CGRectMake(19, 98, 2, 10);
//    self.layer4.backgroundColor = [UIColor redColor].CGColor;
//    [self.view.layer addSublayer:self.layer4];
//    [self configureSubviews];
//    [self configurePlay];
    
//    
//    _slider = [[UISlider alloc]init];
//    [_slider setThumbImage:[UIImage imageNamed:@"avplyer"] forState:UIControlStateNormal];
//    _slider.minimumTrackTintColor = [UIColor redColor];//小于滑块当前值滑块条的颜色，默认为白色
//    _slider.maximumTrackTintColor = [UIColor blueColor];//大于滑块当前值滑块条的颜色
//    
//    _progressView = [[UIProgressView alloc]initWithProgressViewStyle:UIProgressViewStyleDefault];
//    //后面的颜色（譬如进度到30%，那么30%部分后面的颜色就是这个属性）
//    [_progressView setProgressTintColor:[UIColor blackColor]];
//    //前面的颜色
//    [_progressView setTrackTintColor:[UIColor greenColor]];
//    _progressView.progress=0.5;
//    
//
//
//    [self.view addSubview:self.slider];
//
////    [self.view addSubview:self.progressView];
//
//    [_slider addSubview:self.progressView];
////    [_slider sendSubviewToBack:_progressView];
//    
//    
//    [_slider mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(self.view).offset(30);
//        make.bottom.equalTo(self.view).offset(-50);
//        make.height.mas_equalTo(50);
//        make.width.mas_equalTo(100);
//
//
//    }];
//    [_slider addTarget:self action:@selector(sliderValueChanged:) forControlEvents:UIControlEventValueChanged];
//
//    [self.progressView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(self.slider);
//        make.right.equalTo(self.slider);
//        make.centerY.equalTo(self.slider).offset(1);
//        make.height.mas_offset(2);
//    }];
    

}

- (void)dragMovin {
    
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
