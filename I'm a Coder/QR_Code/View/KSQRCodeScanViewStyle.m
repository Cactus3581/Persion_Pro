//
//  KSQRCodeScanViewStyle.m
//  PowerWord7
//
//  Created by xiaruzhen on 2017/7/26.
//  Copyright © 2017年 Kingsoft. All rights reserved.
//

#import "KSQRCodeScanViewStyle.h"

@implementation KSQRCodeScanViewStyle

- (instancetype)init {
    if (self =  [super init]) {
        _isNeedShowRetangle = YES;
        _whRatio = 1.0;
        _colorRetangleLine = [UIColor whiteColor];
        _centerUpOffset = 44;
//        _xScanRetangleOffset = kScreenUniqueWidth/4.0;

        _anmiationStyle = KScanViewAnimationStyle_LineMove;
        _photoframeAngleStyle = KScanViewPhotoframeAngleStyle_Outer;
        _colorAngle = [UIColor colorWithRed:0. green:167./255. blue:231./255. alpha:1.0];
        _notRecoginitonArea = [UIColor colorWithRed:0. green:.0 blue:.0 alpha:.5];
        _photoframeAngleW = 24;
        _photoframeAngleH = 24;
        _photoframeLineW = 7;
    }
    return self;
}

@end
