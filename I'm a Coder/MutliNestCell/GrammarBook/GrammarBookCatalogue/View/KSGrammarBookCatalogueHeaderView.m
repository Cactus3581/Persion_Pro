//
//  KSGrammarBookCatalogueHeaderView.m
//  PowerWord7
//
//  Created by xiaruzhen on 2017/7/10.
//  Copyright © 2017年 Kingsoft. All rights reserved.
//

#import "KSGrammarBookCatalogueHeaderView.h"
#define SINGLE_LINE_WIDTH (1.0 / [UIScreen mainScreen].scale)
#define SINGLE_LINE_ADJUST_OFFSET ((1.0 / [UIScreen mainScreen].scale) / 2)

@implementation KSGrammarBookCatalogueHeaderView

- (void)awakeFromNib {
    [super awakeFromNib];
    _headView.backgroundColor = [UIColor blackColor];
    self.lineView.backgroundColor = [UIColor lightGrayColor];
    [self bringSubviewToFront:_headView];
    self.chapterName.numberOfLines = 2;
    self.chapterName.backgroundColor = [UIColor whiteColor];
    self.lineViewW.constant = SINGLE_LINE_WIDTH;
}

- (void)setChapterTitle:(NSString *)chapterTitle {
    _chapterName.text = chapterTitle;
}

@end
