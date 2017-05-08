//
//  DatabaseViewController.m
//  I'm a Coder
//
//  Created by xiaruzhen on 2017/2/6.
//  Copyright © 2017年 xiaruzhen. All rights reserved.
//

#import "DatabaseViewController.h"
#import "FMDatabaseManager.h"
#import "FMDatabaseQueueManager.h"

#import "DataBaseModel.h"
#import "BaseTableViewCell.h"

@interface DatabaseViewController () <UITableViewDataSource,UITableViewDelegate,UISearchBarDelegate>
@property (nonatomic,assign) NSInteger i;
@property (nonatomic,strong) NSMutableArray *array;

@end

@implementation DatabaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.i = 1;
    [self creatBT];
    // 模糊查询
    UISearchBar *searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 64, K_width, 44)];
    searchBar.delegate = self;
    [self.view addSubview:searchBar];
    
    self.tableView.frame =CGRectMake(0, CGRectGetMaxY(searchBar.frame)+40, K_width, K_height-(CGRectGetMaxY(searchBar.frame)+40));
    self.tableView.backgroundColor = [UIColor redColor];


}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.array.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"BaseTableViewCell";
    BaseTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell==nil) {
        cell = [[BaseTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    cell.textLabel.text = self.array[indexPath.row];
    return cell;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 30;
}

#pragma mark - 模糊查询功能演示
//- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
//{
//    
//    
//    NSString *querySql = [NSString stringWithFormat:@"SELECT * FROM STUDENT WHERE name LIKE '%%%@%%' OR store LIKE '%%%@%%'", searchText, searchText];
//    NSArray *modals = [DatabaseManager quaryAction:querySql];
//    
//    [self.array addObjectsFromArray:modals];
//    
//    NSLog(@"searchText = %@",searchText);
//    
//    [DatabaseManager quaryAction:querySql];
//    
//    [self.tableView reloadData];
//}




- (void)MaskInViewBt_1
{
    self.i  = self.i+1;
    NSNumber *score = [NSNumber numberWithInteger:self.i];
    DataBaseModel *model = [DataBaseModel initializeWithName:@"哈8" Sex:@"男" Age:@23 Score:score];

    [FMDatabaseManager insertAction:model];
//    [FMDatabaseQueueManager insertAction:model];

}

- (void)MaskInViewBt_2
{
    
    self.i  = self.i+1;
    NSNumber *score = [NSNumber numberWithInteger:self.i];
    DataBaseModel *model = [DataBaseModel initializeWithName:@"哈4" Sex:@"男" Age:@18 Score:score];
    
//    [FMDatabaseManager modifyAction:model];
    [FMDatabaseQueueManager modifyAction:model];

}

- (void)MaskInViewBt_3
{
    //删除数据后执行一次查询工作刷新表格
    DataBaseModel *model = [DataBaseModel initializeWithName:@"哈5" Sex:@"男" Age:@18 Score:@88];
    
//    [FMDatabaseManager deleteAction:model];
    [FMDatabaseQueueManager deleteAction:model];


}
- (void)MaskInViewBt_4
{
    DataBaseModel *model = [DataBaseModel initializeWithName:@"哈3" Sex:@"男" Age:@18 Score:@2];
    
//    [FMDatabaseManager quaryAction_one:model];
    [FMDatabaseQueueManager quaryAction_one:model];


}
- (void)MaskInViewBt_5
{
    
    [FMDatabaseManager transaction];
//    [FMDatabaseQueueManager transactionByQueue];

    
}

// 获取这些目录路径的方法：
- (void)creatPath
{
    // 1，获取家目录路径的函数：
    NSString *homeDir = NSHomeDirectory();
    NSLog(@"%@",homeDir);
    // 2，获取Documents目录路径的方法：
    NSArray *documentsPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docDir = [documentsPaths objectAtIndex:0];
    NSLog(@"%@",docDir);
    
    // 3，获取Caches目录路径的方法：
    NSArray *cachesPaths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *cachesDir = [cachesPaths objectAtIndex:0];
    NSLog(@"%@",cachesDir);
    
    // 4，获取tmp目录路径的方法：
    NSString *tmpDir = NSTemporaryDirectory();
    NSLog(@"%@",tmpDir);
    
    // 5，获取应用程序程序包中资源文件路径的方法：
    //例如获取程序包中一个图片资源（apple.png）路径的方法：
    NSString *imagePath = [[NSBundle mainBundle] pathForResource:@"apple" ofType:@"png"];
    UIImage *appleImage = [[UIImage alloc] initWithContentsOfFile:imagePath];
    //代码中的mainBundle类方法用于返回一个代表应用程序包的对象。
    NSLog(@"%@",imagePath);
}

- (void)creatBT
{
    CGFloat widthBt = K_width/5;
    NSArray *array = @[@"插入",@"修改",@"删除",@"查询",@"待加入"];
    for (int i = 0; i<5; i++) {
        UIButton *bt = [UIButton buttonWithType:UIButtonTypeCustom];
        bt.frame = CGRectMake(widthBt*i,64+30+10, widthBt, 30);
        
        if (i==0) {
            [bt addTarget:self action:@selector(MaskInViewBt_1) forControlEvents:UIControlEventTouchUpInside];

        }else if (i==1)
        {
            [bt addTarget:self action:@selector(MaskInViewBt_2) forControlEvents:UIControlEventTouchUpInside];

        }else if (i==2)
        {
            [bt addTarget:self action:@selector(MaskInViewBt_3) forControlEvents:UIControlEventTouchUpInside];

        }else if (i==3)
        {
            [bt addTarget:self action:@selector(MaskInViewBt_4) forControlEvents:UIControlEventTouchUpInside];

        }else if (i==4)
        {
            [bt addTarget:self action:@selector(MaskInViewBt_5) forControlEvents:UIControlEventTouchUpInside];

        }
        [bt setTitle:array[i] forState:UIControlStateNormal];
        [bt setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        bt.titleLabel.font = [UIFont systemFontOfSize:12];
        [self.view addSubview:bt];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}



@end
