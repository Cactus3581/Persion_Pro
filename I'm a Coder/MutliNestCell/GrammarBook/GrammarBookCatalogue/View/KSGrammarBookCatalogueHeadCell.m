//
//  KSGrammarBookCatalogueHeadCell.m
//  PowerWord7
//
//  Created by xiaruzhen on 2017/7/10.
//  Copyright © 2017年 Kingsoft. All rights reserved.
//

#import "KSGrammarBookCatalogueHeadCell.h"
#import "KSGrammarBookCatalogueModel.h"
#import "KSGrammarBookCatalogueCell.h"

static CGFloat normalCellH = 72.0f;
@interface KSGrammarBookCatalogueHeadCell()
@property (nonatomic, assign) CGFloat tableViewH;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) NSIndexPath *subIndexPath;

@end

@implementation KSGrammarBookCatalogueHeadCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.dataArray = [NSMutableArray array];
        self.contentView.backgroundColor = [UIColor whiteColor];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        /*
        self.selectedBackgroundView = [[UIView alloc] initWithFrame:self.frame];
        self.selectedBackgroundView.backgroundColor = [UIColor whiteColor];
         */
        [self initSubviews];
    }
    return self;
}

- (void)initSubviews {
    self.lineView = [[UIView alloc]init];
    self.lineView.backgroundColor = [UIColor lightGrayColor];
    [self.contentView addSubview:self.lineView];

    self.chapterNameLabel = [[UILabel alloc] init];
    self.chapterNameLabel.font = [UIFont systemFontOfSize:15];
    self.chapterNameLabel.textColor = [UIColor lightGrayColor];
    self.chapterNameLabel.numberOfLines = 2;
    self.chapterNameLabel.backgroundColor = [UIColor whiteColor];

    [self.contentView addSubview:self.chapterNameLabel];
    [self.chapterNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.lineView).offset(15);
        make.top.equalTo(self.contentView).offset(10);
        make.right.equalTo(self.contentView).offset(-30);
    }];
    self.expandButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [self.expandButton setImage:[UIImage imageNamed:@"expandCell"] forState:UIControlStateNormal];
    [self.expandButton addTarget:self action:@selector(expandAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:self.expandButton];
    self.expandButton.layer.anchorPoint = CGPointMake(0.5, 0.5);
    [self.expandButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.mas_equalTo(20);
        //make.centerY.equalTo(self.chapterNameLabel.mas_centerY);
        make.top.equalTo(self.chapterNameLabel.mas_top);
        make.right.equalTo(self.contentView).offset(-5);
    }];
    self.tableView = [[UITableView alloc] init];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.scrollEnabled = NO;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.backgroundColor = [UIColor whiteColor];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(18.0);
        make.top.bottom.equalTo(self.contentView);
        make.width.mas_equalTo(1.0f / [UIScreen mainScreen].scale);
    }];
}

- (void)setIsCanExpand:(BOOL)isCanExpand {
    _isCanExpand = isCanExpand;
    self.expandButton.enabled = isCanExpand;
}

- (void)setIndexPath:(NSIndexPath *)indexPath {
    _indexPath = indexPath;
    
}
- (void)setModel:(KSGrammarBookCatalogueSubModel *)model {
    _model = model;
    self.tableViewH = 0.0f;
    [self.dataArray removeAllObjects];
    NSArray *array = model.detail;
    for (KSGrammarBookCatalogueCellSubModel *submodel in array) {
        [self.dataArray addObject:submodel];
    }
    self.tableViewH = normalCellH * self.dataArray.count;
}

- (void)showTableView {
    [self.contentView addSubview:self.tableView];
    [self.tableView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.chapterNameLabel);
        make.bottom.equalTo(self).priorityHigh();
        make.right.equalTo(self).offset(-10);
        make.height.mas_equalTo(self.tableViewH).priorityHigh();
        make.top.lessThanOrEqualTo(self.chapterNameLabel.mas_bottom).offset(0).priorityLow();
    }];
    [self.tableView reloadData];
    /*
    [self.tableView setNeedsLayout];
    [self.tableView layoutIfNeeded];
    [self.lineView setNeedsLayout];
    [self.lineView layoutIfNeeded];
    [self setNeedsLayout];
    [self layoutIfNeeded];
    */
}

- (void)hiddenTableView {
    [self.tableView removeFromSuperview];
}

#pragma mark - TableView delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier = @"KSGrammarBookCatalogueCell";
    KSGrammarBookCatalogueCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell==nil) {
        cell = [[KSGrammarBookCatalogueCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    KSGrammarBookCatalogueCellSubModel *submodel = self.dataArray[indexPath.row];
    cell.titleLabel.text = submodel.title;
    cell.scheduleLabel.text = submodel.schedule;
    cell.isReadingChapter = submodel.isReadingChapter;
    cell.selectedBackgroundView = [[UIView alloc] initWithFrame:cell.frame];
    cell.selectedBackgroundView.backgroundColor = [UIColor whiteColor];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    KSGrammarBookCatalogueCellSubModel *submodel = self.dataArray[indexPath.row];
    submodel.isReadingChapter = !submodel.isReadingChapter;
    [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
    if (_delegate && [_delegate respondsToSelector:@selector(pushViewControllerWithModel:indexPath:)]) {
        [_delegate pushViewControllerWithModel:submodel indexPath:indexPath];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return normalCellH;
}

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (void)expandAction:(UIButton *)bt {
    [self rotateAnimation];
}

- (void)setIsExpand:(BOOL)isExpand {
    _isExpand = isExpand;
    if (isExpand) {
        self.expandButton.imageView.transform = CGAffineTransformMakeRotation(M_PI);
    }else {
        self.expandButton.imageView.transform = CGAffineTransformIdentity;
    }
}

/**
 *  旋转动画
 */
-(void)rotateAnimation{
    CABasicAnimation *anima = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    if (_isExpand) {
        //anima.fromValue = [NSNumber numberWithFloat:M_PI];
        anima.toValue = [NSNumber numberWithFloat:M_PI*2];
    }else {
        anima.toValue = [NSNumber numberWithFloat:M_PI];
    }
    anima.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    anima.removedOnCompletion = NO;
    anima.fillMode = kCAFillModeForwards;
    anima.duration = 0.25f;
    [self.expandButton.layer addAnimation:anima forKey:@"rotateAnimation"];
    if (_delegate && [_delegate respondsToSelector:@selector(expandCellAction:expand:model:indexPath:)]) {
        [_delegate expandCellAction:self.expandButton expand:self.isExpand model:self.model indexPath:self.indexPath];
    }
}

-(void)rotateAnimation2{
    if (!_isExpand) {
        //self.expandButton.layer.anchorPoint = CGPointMake(0.5, 0.0);
        [UIView animateWithDuration:1 animations:^{
            self.expandButton.imageView.transform = CGAffineTransformMakeRotation(M_PI);
        }];
    }
    else {
        //self.expandButton.layer.anchorPoint = CGPointMake(0.5, 1.0);
        [UIView animateWithDuration:1 animations:^{
            self.expandButton.imageView.transform = CGAffineTransformIdentity;
        }];
    }
    _isExpand = !_isExpand;
}

@end
