//
//  KSCertificateViewController.h
//  I'm a Coder
//
//  Created by xiaruzhen on 2017/7/13.
//  Copyright © 2017年 xiaruzhen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface KSCertificateViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIView *backBottomView;
@property (weak, nonatomic) IBOutlet UIButton *saveImageButton;
@property (weak, nonatomic) IBOutlet UIButton *shareButton;

@property (weak, nonatomic) IBOutlet UIButton *disMissButton;

@property (weak, nonatomic) IBOutlet UIImageView *backViewTop;
@property (weak, nonatomic) IBOutlet UIImageView *crownImageView;
@property (weak, nonatomic) IBOutlet UILabel *congratulationLabel;
@property (weak, nonatomic) IBOutlet UILabel *englishLabel;
@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *bookLabel;
@property (weak, nonatomic) IBOutlet UILabel *resultLabel;
@property (weak, nonatomic) IBOutlet UILabel *timelabel;
@property (weak, nonatomic) IBOutlet UIImageView *badgeImageView;

@property (weak, nonatomic) IBOutlet UIButton *modifyNameButton;

@end
