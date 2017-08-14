//
//  AudioPlayerView.h
//  I'm a Coder
//
//  Created by xiaruzhen on 2017/8/7.
//  Copyright © 2017年 xiaruzhen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AudioPlayerManager.h"

@interface AudioPlayerView : UIView
@property (nonatomic,copy) NSString *url;
//单例方法
+ (AudioPlayerView *)sharePlayView;

@end
