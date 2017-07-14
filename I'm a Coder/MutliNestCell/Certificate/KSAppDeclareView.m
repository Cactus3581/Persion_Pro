//
//  KSAppDeclareView.m
//  I'm a Coder
//
//  Created by xiaruzhen on 2017/7/13.
//  Copyright © 2017年 xiaruzhen. All rights reserved.
//

#import "KSAppDeclareView.h"

@implementation KSAppDeclareView

- (void)awakeFromNib {
    [super awakeFromNib];
    self.backgroundColor = [UIColor whiteColor];
    self.backBottomView.backgroundColor = [UIColor whiteColor];
    self.bottomLabel.text = @"学英语\n就用金山词霸APP";
}

@end
