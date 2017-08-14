//
//  BaseListViewController.h
//  I'm a Coder
//
//  Created by xiaruzhen on 2017/3/26.
//  Copyright © 2017年 xiaruzhen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BaseListViewController : UIViewController
@property (nonatomic,strong) UITableView *tableview;
@property (nonatomic,strong) NSArray *dataArray;
- (void)didSelectableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath;

- (void)configCell:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;
@end
