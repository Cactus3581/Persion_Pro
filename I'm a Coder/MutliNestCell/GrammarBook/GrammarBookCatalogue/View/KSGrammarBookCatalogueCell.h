//
//  KSGrammarBookCatalogueCell.h
//  PowerWord7
//
//  Created by xiaruzhen on 2017/7/10.
//  Copyright © 2017年 Kingsoft. All rights reserved.
//

#import "KSGrammarBookCatalogueModel.h"

@interface KSGrammarBookCatalogueCell : UITableViewCell
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *scheduleLabel;
@property (nonatomic, strong) UIView *backView;
@property (nonatomic,assign) BOOL isReadingChapter;//正在读的章节
@end
