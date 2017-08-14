//
//  KSPlayerView.h
//  I'm a Coder
//
//  Created by xiaruzhen on 2017/8/11.
//  Copyright © 2017年 xiaruzhen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface KSPlayerView : UIView
@property (nonatomic, copy) NSString *urlString;//视频地址
@property (nonatomic, assign) BOOL keepDelegate;//保持代理关系：（因为iOS delegate只能一对一，待优化，可考虑通知，但是用通知的话，代码就会变多了）
- (void)play;
- (void)pause;
@end
