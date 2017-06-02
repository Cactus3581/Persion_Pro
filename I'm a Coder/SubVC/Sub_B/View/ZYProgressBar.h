//
//  ZYProgressBar.h
//  ZYDownloadProgress
//
//  Created by zY on 17/1/9.
//  Copyright © 2017年 zY. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^CompleteBlock)(BOOL success);

@interface ZYProgressBar : UIView

@property (nonatomic, assign) CGFloat progress; // [0,1]

@property (nonatomic, copy) CompleteBlock completeBlock;
+ (instancetype)show;
+ (void)hide;
@end
