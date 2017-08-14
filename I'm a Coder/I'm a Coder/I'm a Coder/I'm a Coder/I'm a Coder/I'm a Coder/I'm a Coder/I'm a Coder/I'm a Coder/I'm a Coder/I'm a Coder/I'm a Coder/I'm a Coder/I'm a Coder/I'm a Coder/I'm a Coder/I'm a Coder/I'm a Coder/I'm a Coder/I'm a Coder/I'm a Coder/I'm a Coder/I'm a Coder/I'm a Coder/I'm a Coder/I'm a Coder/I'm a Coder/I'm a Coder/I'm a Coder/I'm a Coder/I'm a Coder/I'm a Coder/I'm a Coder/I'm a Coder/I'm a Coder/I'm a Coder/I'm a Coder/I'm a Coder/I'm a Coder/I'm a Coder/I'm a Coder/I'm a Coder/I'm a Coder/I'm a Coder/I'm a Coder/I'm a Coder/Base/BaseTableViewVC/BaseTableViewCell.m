//
//  BaseTableViewCell.m
//  I'm a Coder
//
//  Created by xiaruzhen on 2017/1/12.
//  Copyright © 2017年 xiaruzhen. All rights reserved.
//

#import "BaseTableViewCell.h"

@implementation BaseTableViewCell


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.contentView.backgroundColor = [UIColor greenColor];
        
        [self initCell];
    }
    return self;
}


- (void)initCell
{
    self.testImage = [[UIImageView alloc]init];
    self.testImage.image =[UIImage imageNamed:@"transitionWithType01"];

    [self addSubview:self.testImage];
    
    self.testImage1 = [[UIImageView alloc]init];
    self.testImage1.image =[UIImage imageNamed:@"transitionWithType01"];
    [self addSubview:self.testImage1];
    self.testImage1.contentMode =UIViewContentModeScaleAspectFill;
    self.testImage1.clipsToBounds = YES;
    
    self.testImage.contentMode =UIViewContentModeScaleAspectFill;
    self.testImage.clipsToBounds = YES;
    
    
    [self.testImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.mas_centerY);
        make.left.equalTo(self).offset(widthRatio(10));
        make.right.equalTo(self.mas_centerX).offset(-widthRatio(5));
        make.height.mas_equalTo(self.testImage1.mas_width).multipliedBy(4/3.0);
    }];
    
    [self.testImage1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.mas_centerY);
        make.left.equalTo(self.mas_centerX).offset(widthRatio(5));
        make.right.equalTo(self).offset(-widthRatio(10));
    
    make.height.mas_equalTo(self.testImage1.mas_width).multipliedBy(4/3.0);// 高/宽 == 0.6
        
    }];

}

- (void)layoutSubviews
{
    [super layoutSubviews];
    NSLog(@"%.2f",self.contentView.frame.size.width);
    NSLog(@"%.2f",widthRatio(20));

    [self.testImage mas_updateConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.mas_centerY);
        make.left.equalTo(self).offset(widthRatio(10));
        make.right.equalTo(self.mas_centerX).offset(-widthRatio(5));
        make.height.mas_equalTo(self.testImage1.mas_width).multipliedBy(4/3.0);
    }];
    
    [self.testImage1 mas_updateConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.mas_centerY);
        make.left.equalTo(self.mas_centerX).offset(widthRatio(5));
        make.right.equalTo(self).offset(-widthRatio(10));
        make.height.equalTo(self.testImage1.mas_width).multipliedBy(4/3.0);// 高/宽 == 0.6
    }];
    
    NSLog(@"widthRatio(10) =  %.2f",widthRatio(10));
    
    self.testImage1.contentMode =UIViewContentModeScaleAspectFill;
    self.testImage1.clipsToBounds = YES;
    
    self.testImage.contentMode =UIViewContentModeScaleAspectFill;
    self.testImage.clipsToBounds = YES;
    NSLog(@"%@",NSStringFromCGRect(self.testImage.frame));

    
    NSLog(@"width %.2f",self.testImage.bounds.size.width);
    NSLog(@"height %.2f",self.testImage.bounds.size.height);

}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
