//
//  AVplayerView.h
//  yanagou
//
//  Created by xiaruzhen on 2016/10/11.
//  Copyright © 2016年 com.yanagou. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>


@interface AVplayerView : UIView

@property (strong, nonatomic) UILabel *currentTime;
@property (nonatomic, copy) NSString *urlString;//视频地址

- (void)play ;
- (void)pause ;
+ (instancetype)shareAVplayerView;
- (void)preparePlay;

@end
