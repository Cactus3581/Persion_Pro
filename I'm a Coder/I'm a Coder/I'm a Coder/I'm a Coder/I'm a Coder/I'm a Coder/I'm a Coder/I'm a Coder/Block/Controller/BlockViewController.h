//
//  BlockViewController.h
//  I'm a Coder
//
//  Created by xiaruzhen on 2017/2/13.
//  Copyright © 2017年 xiaruzhen. All rights reserved.
//

#import "BaseViewController.h"

//1.重新起个名字
typedef void(^PassValueBlock)(NSString *);

@interface BlockViewController : BaseViewController

@property (nonatomic,strong) NSString *titleName;
@property (nonatomic,assign) NSInteger row;

//2.声明block属性
@property(nonatomic,copy)PassValueBlock  passValueBlock;

@end
