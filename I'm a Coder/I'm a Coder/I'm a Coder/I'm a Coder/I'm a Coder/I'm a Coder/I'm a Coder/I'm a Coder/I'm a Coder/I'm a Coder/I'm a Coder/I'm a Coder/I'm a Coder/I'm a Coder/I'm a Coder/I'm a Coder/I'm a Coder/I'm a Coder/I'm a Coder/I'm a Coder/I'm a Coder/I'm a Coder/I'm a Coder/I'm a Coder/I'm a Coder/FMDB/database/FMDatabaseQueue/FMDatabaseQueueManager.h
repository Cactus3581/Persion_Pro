//
//  FMDatabaseQueueManager.h
//  I'm a Coder
//
//  Created by xiaruzhen on 2017/2/7.
//  Copyright © 2017年 xiaruzhen. All rights reserved.
//

#import "BaseModel.h"
#import <Foundation/Foundation.h>
#import "FMDB.h"
#import "DataBaseModel.h"
@interface FMDatabaseQueueManager : BaseModel
+ (void)insertAction:(DataBaseModel *)model;
+ (void)modifyAction:(DataBaseModel *)model;
+ (void)deleteAction:(DataBaseModel *)model;
+ (void)quaryAction_one:(DataBaseModel *)model;
+ (void)transactionByQueue;
@end
