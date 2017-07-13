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
#import "KSCertificateView.h"
#import "KSAlertWindow.h"
#import "AppDelegate.h"

#define kScreen_Width self.view.bounds.size.width
@interface KSGrammarBookCatalogueController ()<UITableViewDelegate,UITableViewDataSource,KSGrammarBookCatalogueHeadCellDelegate,Sub_B_ViewControllerDelegate>
@property (nonatomic,strong) NSArray *arraySource;//显示的数据
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, copy) NSString *chapterString;
@property (nonatomic,strong) KSCertificateView *certificateView;


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
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.navigationController.navigationBarHidden = YES;
    self.view.backgroundColor = [UIColor whiteColor];
//    [self initTableView];
//    [self initData];
    
//    KSAlertWindow *alert = [[KSAlertWindow alloc]initWithFrame:[UIScreen mainScreen].bounds];

//    [alert show];
    
    AppDelegate *delagete = [UIApplication sharedApplication].delegate;
//    [delagete setInterfaceOrientationMaskWithAppDelegate:delagete fullscreen:NO];

    
    [self.view addSubview:self.certificateView];
//    self.certificateView.frame = self.view.bounds;
    [self.certificateView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.leading.trailing.equalTo(self.view);
    }];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (KSCertificateView *)certificateView {
    if (!_certificateView) {
        _certificateView = [[[NSBundle mainBundle] loadNibNamed:@"KSCertificateView" owner:self options:nil]lastObject];
    }
    return _certificateView;
}
#pragma mark -数据源
- (void)initData {
    __weak typeof (self) weakSelf = self;
    [KSGrammarBookCatalogueModel dealDataWithSuccess:^(NSInteger section, NSInteger cell, NSInteger subCell, ScrollPosition scrollPosition, NSArray *resultArray) {
//        self.chapterString = [NSString stringWithFormat:@"%ld.%ld.%ld",section,cell,subCell];
        weakSelf.arraySource = resultArray.copy;
        [weakSelf.tableView reloadData];
        [weakSelf scrollPositionWithsection:section cell:cell subCell:subCell scrollPosition:scrollPosition animated:NO];
    } fail:^{
        
    }];
}

- (void)dealData {
    __weak typeof (self) weakSelf = self;
    [KSGrammarBookCatalogueModel dealDataWithArray:self.arraySource readChapter:self.chapterString success:^(NSInteger section, NSInteger cell, NSInteger subCell, ScrollPosition scrollPosition) {
//        self.chapterString = [NSString stringWithFormat:@"%ld.%ld.%ld",section,cell,subCell];
        [weakSelf.tableView reloadData];
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
    Sub_B_ViewController *vc = [[Sub_B_ViewController alloc]init];
    vc.delegate = self;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)expandCellAction:(UIButton *)expandButton expand:(BOOL)isExpand model:(KSGrammarBookCatalogueSubModel *)model indexPath:(NSIndexPath *)indexPath{
    KSGrammarBookCatalogueModel *sectionModel = self.arraySource[indexPath.section];
    NSArray *cellArray = sectionModel.detail;
    KSGrammarBookCatalogueSubModel *chapterCellModel = cellArray[indexPath.row];
    chapterCellModel.isExpand = !chapterCellModel.isExpand;
    [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
}

#pragma mark - Sub_B delegate
- (void)pushViewControllerWithModel {
    [self dealData];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation {
    return NO;
}
//一开始的方向  很重要
-(UIInterfaceOrientation)preferredInterfaceOrientationForPresentation {
    return UIInterfaceOrientationPortrait;
}

//支持旋转
- (BOOL)shouldAutorotate {
    return NO;
}

//支持的方向 因为界面A我们只需要支持竖屏
- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskPortrait;
}

@end
