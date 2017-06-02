//
//  KSProgressIndicatorView.h
//  PowerWord7
//
//  Created by xiaruzhen on 2017/5/31.
//  Copyright © 2017年 Kingsoft. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef void(^CompleteBlock)(BOOL success);
@interface KSProgressIndicatorView : UIView
@property (nonatomic, assign) CGFloat progress; // [0,1]
@property (nonatomic, copy) CompleteBlock completeBlock;

@end
