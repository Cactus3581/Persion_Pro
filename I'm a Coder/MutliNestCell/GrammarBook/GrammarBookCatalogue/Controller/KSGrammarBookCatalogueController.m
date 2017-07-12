//
//  KSGrammarBookCatalogueController.m
//  PowerWord7
//
//  Created by xiaruzhen on 2017/7/10.
//  Copyright © 2017年 Kingsoft. All rights reserved.
//

#import "KSGrammarBookCatalogueController.h"
#import "KSGrammarBookCatalogueModel.h"
#import "KSGrammarBookCatalogueHeaderView.h"
#import "KSGrammarBookCatalogueHeadCell.h"
#import "MJExtension.h"
#import "KSGrammarBookCatalogueFooterView.h"
#import "Sub_B_ViewController.h"

#define kScreen_Width self.view.bounds.size.width
@interface KSGrammarBookCatalogueController ()<UITableViewDelegate,UITableViewDataSource,KSGrammarBookCatalogueHeadCellDelegate,Sub_B_ViewControllerDelegate>
@property (nonatomic,strong) NSArray *arraySource;//显示的数据
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSIndexPath *indexPath;
@property (nonatomic, copy) NSString *chapterString;

@end

static CGFloat headViewH = 40.0f;
static CGFloat headViewDoubleH = 60.0f;
static CGFloat footViewH = 15.0f;
static CGFloat HeadCellH = 35.0f;
static CGFloat HeadCellDoubleH = 52.5f;
static CGFloat normalCellH = 72.0f;

@implementation KSGrammarBookCatalogueController
- (void)viewDidLoad {
    [super viewDidLoad];
//    self.automaticallyAdjustsScrollViewInsets = NO;
    self.view.backgroundColor = [UIColor whiteColor];
    [self initTableView];
    [self initData];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

#pragma mark -数据源
- (void)initData {
    __weak typeof (self) weakSelf = self;
    [KSGrammarBookCatalogueModel dealDataWithSuccess:^(NSInteger section, NSInteger cell, NSInteger subCell, ScrollPosition scrollPosition, NSArray *resultArray) {
        self.indexPath = [NSIndexPath indexPathForRow:cell inSection:section];
        self.chapterString = [NSString stringWithFormat:@"%ld,%ld,%ld",section,cell,subCell];
        weakSelf.arraySource = resultArray.copy;
        [weakSelf.tableView reloadData];
        [weakSelf scrollPositionWithsection:section cell:cell subCell:subCell scrollPosition:scrollPosition animated:NO];
    } fail:^{
        
    }];
}

- (void)dealData {
    __weak typeof (self) weakSelf = self;
    [KSGrammarBookCatalogueModel dealDataWithArray:self.arraySource readChapter:self.chapterString success:^(NSInteger section, NSInteger cell, NSInteger subCell, ScrollPosition scrollPosition) {
        self.indexPath = [NSIndexPath indexPathForRow:cell inSection:section];
        [self.tableView reloadRowsAtIndexPaths:@[self.indexPath] withRowAnimation:UITableViewRowAnimationFade];
//        [weakSelf.tableView reloadData];
        [weakSelf scrollPositionWithsection:section cell:cell subCell:subCell scrollPosition:scrollPosition animated:NO];
    } fail:^{
        
    }];
}

#pragma mark 滑动到最近一次读的章节
- (void)scrollPositionWithsection:(NSInteger)section cell:(NSInteger) cell subCell:(NSInteger)subCell scrollPosition:(ScrollPosition )scrollPosition animated:(BOOL)animated {
    //[self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:cell-1 inSection:section-1]  atScrollPosition:scrollPosition animated:animated];//枚举会爆黄
    switch (scrollPosition) {
        case ScrollPositionTop:
            [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:cell-1 inSection:section-1]  atScrollPosition:UITableViewScrollPositionTop animated:animated];
            break;
        case ScrollPositionMiddle:
            [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:cell-1 inSection:section-1]  atScrollPosition:UITableViewScrollPositionMiddle animated:animated];
            break;
        case ScrollPositionBottom:
            [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:cell-1 inSection:section-1]  atScrollPosition:UITableViewScrollPositionBottom animated:animated];
            break;
        default:
            break;
    }
}

- (NSArray *)arraySource {
    if (!_arraySource) {
        _arraySource = [NSArray array];
    }
    return _arraySource;
}

#pragma mark -初始化Tableview及delagate
- (void)initTableView {
    [self.tableView registerNib:[UINib nibWithNibName:@"KSGrammarBookCatalogueHeaderView" bundle:[NSBundle mainBundle]] forHeaderFooterViewReuseIdentifier:@"KSGrammarBookCatalogueHeaderView"];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = [UIColor whiteColor];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
}

#pragma mark - TableView delegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.arraySource.count;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    KSGrammarBookCatalogueModel *sectionModel = self.arraySource[section];
    NSArray *cellArray = sectionModel.detail;
    return cellArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier = @"KSGrammarBookCatalogueHeadCell";
    KSGrammarBookCatalogueHeadCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell==nil) {
        cell = [[KSGrammarBookCatalogueHeadCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    KSGrammarBookCatalogueModel *sectionModel = self.arraySource[indexPath.section];
    NSArray *cellArray = sectionModel.detail;
    KSGrammarBookCatalogueSubModel *chapterCellModel = cellArray[indexPath.row];
    cell.chapterNameLabel.text = [NSString stringWithFormat:@"%@  %@",chapterCellModel.num,chapterCellModel.title];
    cell.isExpand = chapterCellModel.isExpand;
    cell.indexPath = indexPath;
    cell.isCanExpand = chapterCellModel.isCanExpand;
    if (chapterCellModel.isExpand) {
        cell.model = chapterCellModel;
        [cell showTableView];
    } else {
        [cell hiddenTableView];
    }
    cell.delegate = self;
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    KSGrammarBookCatalogueHeaderView *header = [[[NSBundle mainBundle] loadNibNamed:@"KSGrammarBookCatalogueHeaderView" owner:self options:nil]lastObject];
    header.frame = CGRectMake(0, 0,kScreen_Width, headViewH);
    KSGrammarBookCatalogueModel *sectionModel= self.arraySource[section];
    header.chapterTitle = [NSString stringWithFormat:@"%@  %@",sectionModel.num,sectionModel.title];
    if (section ==0) {
        header.lineviewTop.constant = headViewH/2.0+5;
    }
    return header;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    KSGrammarBookCatalogueModel *sectionModel= self.arraySource[section];
    return sectionModel.singleLine ? headViewH : headViewDoubleH;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    KSGrammarBookCatalogueFooterView *footView = [[KSGrammarBookCatalogueFooterView alloc]initWithFrame:CGRectMake(0, 0, kScreen_Width, footViewH)];
    return footView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return footViewH;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
     KSGrammarBookCatalogueModel *sectionModel = self.arraySource[indexPath.section];
    NSArray *cellArray = sectionModel.detail;
    KSGrammarBookCatalogueSubModel *chapterCellModel = cellArray[indexPath.row];
    if (chapterCellModel.singleLine) {
        return chapterCellModel.isExpand ? chapterCellModel.detail.count * normalCellH + HeadCellH : HeadCellH;
    }else {
        return chapterCellModel.isExpand ? chapterCellModel.detail.count * normalCellH + HeadCellDoubleH : HeadCellDoubleH;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    //[self.tableView deselectRowAtIndexPath:indexPath animated:NO];
    [self expandActionWithIndexPath:indexPath];
}

- (void)expandActionWithIndexPath:(NSIndexPath *)indexPath {
    /*
    KSGrammarBookCatalogueModel *sectionModel = self.arraySource[indexPath.section];
    NSArray *cellArray = sectionModel.detail;
    KSGrammarBookCatalogueSubModel *chapterCellModel = cellArray[indexPath.row];
    chapterCellModel.isExpand = !chapterCellModel.isExpand;
    //cell刷新
    [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    //tableView刷新
    //[self.tableView reloadData];
    //区刷新
    //NSMutableIndexSet *idxSet = [[NSMutableIndexSet alloc] init];
    //[idxSet addIndex:indexPath.section];
    //[self.tableView reloadSections:idxSet.copy withRowAnimation:UITableViewRowAnimationFade];
     */
}

#pragma mark - Cell delegate
- (void)pushViewControllerWithModel:(KSGrammarBookCatalogueCellSubModel *)model indexPath:(NSIndexPath *)indexPath {
    [self dealData];

//    [self.tableView reloadRowsAtIndexPaths:@[self.indexPath] withRowAnimation:UITableViewRowAnimationFade];
//    [self performSelector:@selector(ewrerer) withObject:nil afterDelay:5.0];
}

- (void)ewrerer {
    Sub_B_ViewController *vc = [[Sub_B_ViewController alloc]init];
    vc.delegate = self;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - Sub_B delegate
- (void)pushViewControllerWithModel {
    [self dealData];
}

- (void)expandCellAction:(UIButton *)expandButton expand:(BOOL)isExpand model:(KSGrammarBookCatalogueSubModel *)model indexPath:(NSIndexPath *)indexPath{
    KSGrammarBookCatalogueModel *sectionModel = self.arraySource[indexPath.section];
    NSArray *cellArray = sectionModel.detail;
    KSGrammarBookCatalogueSubModel *chapterCellModel = cellArray[indexPath.row];
    chapterCellModel.isExpand = !chapterCellModel.isExpand;
    [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
}

@end
