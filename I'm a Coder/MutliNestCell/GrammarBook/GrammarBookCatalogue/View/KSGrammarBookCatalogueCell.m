//
//  KSGrammarBookCatalogueCell.m
//  PowerWord7
//
//  Created by xiaruzhen on 2017/7/10.
//  Copyright © 2017年 Kingsoft. All rights reserved.
//

#import "KSGrammarBookCatalogueCell.h"
#import "KSGrammarBookCatalogueHeadCell.h"

@implementation KSGrammarBookCatalogueCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.contentView.backgroundColor = [UIColor whiteColor];
        [self initSubviews];
    }
    return self;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    if(selected){
        self.scheduleLabel.textColor = [UIColor greenColor];
    }
    else {
    }
}

- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated {
    [super setHighlighted:highlighted animated:animated];
    if (highlighted) {
        self.backView.backgroundColor = [UIColor purpleColor];
    }else {
    }
}
- (void)setIsReadingChapter:(BOOL)isReadingChapter {
    _isReadingChapter = isReadingChapter;
    if (isReadingChapter) {
        self.backView.layer.borderColor = [UIColor blueColor].CGColor;
        self.scheduleLabel.textColor = [UIColor blueColor];
        self.titleLabel.textColor = [UIColor blueColor];
    }else {
        self.backView.layer.borderColor = [UIColor lightGrayColor].CGColor;
        self.scheduleLabel.textColor = [UIColor lightGrayColor];
        self.titleLabel.textColor = [UIColor lightGrayColor];
    }
}

- (void)initSubviews {
    self.backView = [[UIView alloc] init];
    [self.contentView addSubview:self.backView];
    [self.backView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(1);
        make.top.equalTo(self.contentView).offset(5);
        make.bottom.equalTo(self.contentView).offset(-5);
        make.right.equalTo(self.contentView).offset(-15);
    }];

    self.backView.layer.cornerRadius = 4;
    self.backView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.titleLabel = [[UILabel alloc] init];
    self.titleLabel.font = [UIFont systemFontOfSize:13];
    [self.backView addSubview:self.titleLabel];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.backView).offset(13);
        make.bottom.equalTo(self.backView.mas_centerY).offset(0);
        make.right.equalTo(self.backView).offset(-10);
    }];
    self.scheduleLabel = [[UILabel alloc] init];
    self.scheduleLabel.font = [UIFont systemFontOfSize:10];
    self.scheduleLabel.textColor = [UIColor lightTextColor];
    [self.backView addSubview:self.scheduleLabel];
    [self.scheduleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.backView).offset(13);
        make.top.equalTo(self.backView.mas_centerY).offset(5);
        make.right.equalTo(self.backView).offset(-10);
    }];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.backView.layer.borderWidth = 1.0f / [UIScreen mainScreen].scale;
}


@end
