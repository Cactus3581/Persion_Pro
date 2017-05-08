//
//  DataManager.h
//  I'm a Coder
//
//  Created by xiaruzhen on 2017/2/17.
//  Copyright © 2017年 xiaruzhen. All rights reserved.
//

#import "BaseModel.h"


@interface DataManager : BaseModel
+ (DataManager *)shareDataManager;
- (NSString *)getPath:(NSString *)pathName;

@end
