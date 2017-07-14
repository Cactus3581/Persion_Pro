//
//  KSGrammarUnfinishedController.h
//  I'm a Coder
//
//  Created by xiaruzhen on 2017/7/14.
//  Copyright © 2017年 xiaruzhen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface KSGrammarUnfinishedController : UIViewController
@property (weak, nonatomic) IBOutlet UIButton *dismissButton;
@property (weak, nonatomic) IBOutlet UIImageView *backImageVIew;
@property (weak, nonatomic) IBOutlet UIButton *keepButton;
@property (weak, nonatomic) IBOutlet UILabel *bookNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *describeLabel;
@property (nonatomic,strong) UIView *circleBackView;
@property (nonatomic,strong) UIView *circleLittleBackView;

@end
