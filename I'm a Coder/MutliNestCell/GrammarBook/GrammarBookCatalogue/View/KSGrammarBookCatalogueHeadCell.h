//
//  KSGrammarBookCatalogueHeadCell.h
//  PowerWord7
//
//  Created by xiaruzhen on 2017/7/10.
//  Copyright © 2017年 Kingsoft. All rights reserved.
//
#import "KSGrammarBookCatalogueModel.h"

@class KSGrammarBookCatalogueModel;

@protocol KSGrammarBookCatalogueHeadCellDelegate <NSObject>
@optional
-(void) expandCellAction:(UIButton *)expandButton expand:(BOOL)isExpand model:(KSGrammarBookCatalogueSubModel *)model indexPath:(NSIndexPath *)indexPath;
-(void) pushViewControllerWithModel:(KSGrammarBookCatalogueCellSubModel *)model indexPath:(NSIndexPath *)indexPath;
@end

@interface KSGrammarBookCatalogueHeadCell : UITableViewCell <UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, strong) UILabel *chapterNameLabel;
@property (nonatomic, strong) UIView *lineView;
@property (nonatomic, strong) UIButton *expandButton;
@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSIndexPath *indexPath;
@property (nonatomic,assign) BOOL isCanExpand;//是否可以显示
@property (nonatomic, assign) BOOL isExpand;

@property (nonatomic, assign) KSGrammarBookCatalogueSubModel *model;
@property (nonatomic, weak) id<KSGrammarBookCatalogueHeadCellDelegate> delegate;

- (void)showTableView;
- (void)hiddenTableView;
@end
