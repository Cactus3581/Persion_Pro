//
//  CollectionViewController.m
//  I'm a Coder
//
//  Created by xiaruzhen on 2017/2/15.
//  Copyright © 2017年 xiaruzhen. All rights reserved.
//

#import "CollectionViewController.h"
#import "CustomFlowLayout.h"
#import "CustomCollectionCell.h"
#import "Cell_two.h"
#import "Cell_three.h"

#import "Section_one_ReusableView.h"
#import "Section_two_ReusableView.h"
#import "Section_three_ReusableView.h"

@interface CollectionViewController ()<UICollectionViewDelegate,UICollectionViewDataSource>
@property (nonatomic,strong) UICollectionView *collectionView;
@property (nonatomic,strong) NSArray *array;

@end

@implementation CollectionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"CollectionView";
    self.view.backgroundColor = [UIColor redColor];
    [self.view addSubview:self.collectionView];
    self.array =@[@"熊出没",@"死神来了19",@"钢铁侠0",@"海上钢琴师",@"最后一只恐龙",@"苍井空",@"假如爱有天意",@"好好先生",@"特种部队",@"生化危机",@"生化危机"];
}

#pragma mark - 布局collectionview
- (UICollectionView *)collectionView
{
    if (!_collectionView) {
        CustomFlowLayout *flowLayout = [[CustomFlowLayout alloc]init];
        _collectionView=[[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, K_width, K_height) collectionViewLayout:flowLayout];
        _collectionView.dataSource=self;
        _collectionView.delegate=self;
        _collectionView.alwaysBounceVertical =YES;
        _collectionView.showsVerticalScrollIndicator = NO;
        _collectionView.backgroundColor = [UIColor redColor];
        //注册item
        [_collectionView registerClass:[CustomCollectionCell class] forCellWithReuseIdentifier:@"CustomCollectionCell"];
        [_collectionView registerClass:[Cell_two class] forCellWithReuseIdentifier:@"Cell_two"];
        [_collectionView registerClass:[Cell_three class] forCellWithReuseIdentifier:@"Cell_three"];
        
        [_collectionView registerClass:[Section_one_ReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"Section_one_ReusableView"];
        
        [_collectionView registerClass:[Section_two_ReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"Section_two_ReusableView"];
        
        
        [_collectionView registerClass:[Section_three_ReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"Section_three_ReusableView"];
        
        
        
        
    }
    return _collectionView;
}

//定义展示的UICollectionViewCell的个数
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return  self.array.count;
}

//定义展示的Section的个数
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

//每个UICollectionView展示的内容
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * CellIdentifier1 = @"CustomCollectionCell";
    CustomCollectionCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:CellIdentifier1 forIndexPath:indexPath];
    cell.nameText = self.array[indexPath.row];
    return cell;
}

//设定Cell尺寸，定义某个Cell的尺寸
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSString *str = self.array[indexPath.row];
    /* 根据每一项的字符串确定每一项的size */
    NSDictionary *dict = @{NSFontAttributeName:[UIFont systemFontOfSize:12]};
    CGSize size = [str boundingRectWithSize:CGSizeMake(0, 30) options:NSStringDrawingUsesFontLeading|NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingTruncatesLastVisibleLine attributes:dict context:nil].size;
    size.height = 30;
    size.width += 10;
    return size;
}

//-(UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
//{
//
//    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
//        if (indexPath.section == 0) {
//            Section_one_ReusableView *headView = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"Section_one_ReusableView" forIndexPath:indexPath];
//
//            return headView;
//        }
//        if (indexPath.section == 1) {
//            Section_two_ReusableView *orderStatusView = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"Section_two_ReusableView" forIndexPath:indexPath];
//            return orderStatusView;
//        }
//        if (indexPath.section == 2) {
//            Section_three_ReusableView *walletView = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"Section_three_ReusableView" forIndexPath:indexPath];
//            return walletView;
//        }
//    }
//    return nil;
//}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

