//
//  KSGrammarBookCatalogueModel.h
//  PowerWord7
//
//  Created by xiaruzhen on 2017/7/10.
//  Copyright © 2017年 Kingsoft. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM (NSUInteger,ScrollPosition){
    ScrollPositionTop = 1,
    ScrollPositionMiddle = 2,
    ScrollPositionBottom = 3
};

// 一个大区
@interface KSGrammarBookCatalogueModel : NSObject
@property (nonatomic,strong) NSArray *detail;
@property (nonatomic,copy) NSString *title;
@property (nonatomic,strong) NSNumber *type;
@property (nonatomic,copy) NSString *num;
@property (nonatomic,assign) BOOL singleLine;

/**
 model转换及拿取本地数据赋值

 @param successBlock successBlock description
 @param failBlock failBlock description
 */
+ (void)dealDataWithSuccess:(void (^)(NSInteger section,NSInteger cell,NSInteger subCell,ScrollPosition scrollPosition,NSArray *resultArray))successBlock fail:(void (^)())failBlock;

+ (void)dealDataWithArray:(NSArray *)array readChapter:(NSString *)chapterNumber success:(void (^)(NSInteger section,NSInteger cell,NSInteger subCell,ScrollPosition scrollPosition))successBlock fail:(void (^)())failBlock;
@end

// 一个大区里的大cell
@interface KSGrammarBookCatalogueSubModel : NSObject
@property (nonatomic,assign) BOOL isCanExpand;//是否可以显示
@property (nonatomic,assign) BOOL isExpand;//收缩/展开
@property (nonatomic,assign) BOOL singleLine;

@property (nonatomic,strong) NSArray *detail;
@property (nonatomic,copy) NSString *title;
@property (nonatomic,strong) NSNumber *type;
@property (nonatomic,copy) NSString *num;

@end

// cell里的小cell 章节
@interface KSGrammarBookCatalogueCellSubModel : NSObject
@property (nonatomic,assign) BOOL isReadingChapter;//正在读的章节
@property (nonatomic,copy) NSString *schedule;//进度

@property (nonatomic,copy) NSString *title;
@property (nonatomic,strong) NSNumber *type;
@property (nonatomic,copy) NSString *num;
@property (nonatomic,strong) NSNumber *block;
@property (nonatomic,copy) NSString *path;
@end
