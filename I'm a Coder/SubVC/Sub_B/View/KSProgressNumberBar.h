//
//  KSProgressNumberBar.h
//  PowerWord7
//
//  Created by xiaruzhen on 2017/5/31.
//  Copyright © 2017年 Kingsoft. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^CompleteBlock)(BOOL success);
@interface KSProgressNumberBar : UIView
@property (nonatomic, assign) CGFloat progresss;
@property (nonatomic, copy) CompleteBlock completeBlock;

+ (void)show;
+ (void)setProgress:(CGFloat)progress;

@end
