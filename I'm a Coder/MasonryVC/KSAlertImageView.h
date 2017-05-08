//
//  KSAlertImageView.h
//  PowerWord7
//
//  Created by xiaruzhen on 2017/5/3.
//  Copyright © 2017年 Kingsoft. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface KSAlertImageView : UIView
@property (nonatomic,strong) UIView *maskView;
@property (nonatomic,strong) UIImageView *alertImageView;
@property (nonatomic,strong) UIButton *alertRightBt;
@property (nonatomic,strong) UIButton *alertLeftBt;
@property (nonatomic,strong) UIView *lineView;

//取消按钮点击事件
typedef void(^cancelBlock)();

//确定按钮点击事件
typedef void(^sureBlock)();

@property(nonatomic,copy) cancelBlock cancel_block;
@property(nonatomic,copy) sureBlock sure_block;
/**
 *  @param cancelBlock 取消按钮点击事件
 *  @param sureBlock   确定按钮点击事件
 *
 */
+ (instancetype)alterViewWithModel:(id)model
                   cancelBtClcik:(cancelBlock)cancelBlock
                     sureBtClcik:(sureBlock)sureBlock;
@end

