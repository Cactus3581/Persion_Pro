//
//  MultithReadingViewController.m
//  I'm a Coder
//
//  Created by xiaruzhen on 2017/3/17.
//  Copyright © 2017年 xiaruzhen. All rights reserved.
//

#import "MultithReadingViewController.h"

@interface MultithReadingViewController ()

@end

@implementation MultithReadingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];

    dispatch_queue_t chuanqueue = dispatch_queue_create("a", DISPATCH_QUEUE_SERIAL);
    dispatch_queue_t bingqueue = dispatch_queue_create("b", DISPATCH_QUEUE_CONCURRENT);
    
    dispatch_queue_t mainqueue = dispatch_get_main_queue();
    dispatch_queue_t globalqueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    
    //    [self testSync:globalqueue];
    //    [self testAsync:globalqueue];
    [self setGCD];
    
}

- (void)setGCD
{
    //    dispatch_apply(10000, dispatch_get_global_queue(0, 0), ^(size_t index) {
    //        NSLog(@"GCD- %zd -- %@", index, [NSThread currentThread]);
    //    });
    
    
    __block NSInteger time = 59; //倒计时时间
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_source_t timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    dispatch_source_set_timer(timer,DISPATCH_TIME_NOW,1.0*NSEC_PER_SEC, 0); //每秒执行
    dispatch_source_set_event_handler(timer, ^{
        if(time <= 0){ //倒计时结束，关闭
            dispatch_source_cancel(timer);
            dispatch_async(dispatch_get_main_queue(), ^{
                //设置按钮的样式
            });
        }else{
            dispatch_async(dispatch_get_main_queue(), ^{
                //设置label读秒效果
            });
            time--;
        }
    });
    dispatch_resume(timer);
}

- (void)testSync:(dispatch_queue_t)queue
{
    NSLog(@"tongbu_%@",[NSThread currentThread]);
    dispatch_sync(queue, ^{
        NSLog(@"tongbu_%@",[NSThread currentThread]);
    });
    NSLog(@"tongbu_%@",[NSThread currentThread]);
    
}
- (void)testAsync:(dispatch_queue_t)queue
{
    
    //    dispatch_async(queue, ^{
    //        NSLog(@"yibu1_%@",[NSThread currentThread]);
    //        NSLog(@"yibu2_%@",[NSThread currentThread]);
    //
    //        NSLog(@"yibu3_%@",[NSThread currentThread]);
    //        NSLog(@"yibu4_%@",[NSThread currentThread]);
    //        NSLog(@"yibu5_%@",[NSThread currentThread]);
    //        NSLog(@"yibu6_%@",[NSThread currentThread]);
    //        NSLog(@"yibu7_%@",[NSThread currentThread]);
    //
    //        NSLog(@"yibu8_%@",[NSThread currentThread]);
    //
    //    });
    dispatch_async(queue, ^{
        NSLog(@"yibu1_%@",[NSThread currentThread]);
    });
    dispatch_async(queue, ^{
        NSLog(@"yibu2_%@",[NSThread currentThread]);
    });
    dispatch_async(queue, ^{
        NSLog(@"yibu3_%@",[NSThread currentThread]);
    });
    dispatch_async(queue, ^{
        NSLog(@"yibu4_%@",[NSThread currentThread]);
    });
    dispatch_async(queue, ^{
        NSLog(@"yibu5_%@",[NSThread currentThread]);
    });
    dispatch_async(queue, ^{
        NSLog(@"yibu6_%@",[NSThread currentThread]);
    });
    dispatch_async(queue, ^{
        NSLog(@"yibu7_%@",[NSThread currentThread]);
    });
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
