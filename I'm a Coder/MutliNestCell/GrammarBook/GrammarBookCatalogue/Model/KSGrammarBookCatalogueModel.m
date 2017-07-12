//
//  KSGrammarBookCatalogueModel.m
//  PowerWord7
//
//  Created by xiaruzhen on 2017/7/10.
//  Copyright © 2017年 Kingsoft. All rights reserved.
//

#import "KSGrammarBookCatalogueModel.h"

static CGFloat headViewH = 40.0f;
static CGFloat headViewW = 33.0f + 10.0f;
static CGFloat HeadCellH = 35.0f;
static CGFloat HeadCellW = 18.0f+30.0f+15.0f;

@implementation KSGrammarBookCatalogueModel
+ (NSDictionary *)mj_objectClassInArray {
    return @{@"detail":[KSGrammarBookCatalogueSubModel class]};
}

#pragma 处理数据
+ (void)dealDataWithSuccess:(void (^)(NSInteger section,NSInteger cell,NSInteger subCell,ScrollPosition scrollPosition,NSArray *resultArray))successBlock fail:(void (^)())failBlock {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
        NSArray *array = [self getReadingChapter: @"7.4.9"];
        NSInteger section = 0,row = 0,rowIn = 0;// 以上本地获取正在读的章节
        NSInteger section1 = 1,row1 = 1,rowIn1 = 1;// 记住本地获取正在读的章节
        NSMutableArray *arraySource = [NSMutableArray array];
        for (NSDictionary *dict in [self getData]) {
            section ++,row = 0;
            KSGrammarBookCatalogueModel *model = [KSGrammarBookCatalogueModel mj_objectWithKeyValues:dict]; // 模型转换
            [KSGrammarBookCatalogueModel calculatedHeightWithCatalogueModel:model]; // 计算头部高度
            for (KSGrammarBookCatalogueSubModel *submodel in model.detail) {
                submodel.isExpand = NO; //默认不展开
                [KSGrammarBookCatalogueModel calculatedHeightWithCatalogueSubModel:submodel];// 计算cell高度
                row ++,rowIn = 0;
                submodel.isCanExpand = YES; //是否开启收缩展开功能
                for (KSGrammarBookCatalogueCellSubModel *cellModel in submodel.detail) {
                    rowIn ++;
                    cellModel.schedule = [self getReadingChapterSchedule]; // 获取进度并赋值
                    if (array.count==3) { //三层模型写死
                        if (section == [array[0] integerValue]&& row == [array[1] integerValue]&& rowIn == [array[2] integerValue]) {//获取正在读的章节
                            cellModel.isReadingChapter = YES;
                            submodel.isExpand = YES;////需要展开
                            section1 = section,row1 = row,rowIn1 = rowIn;
                        }else {
                            cellModel.isReadingChapter = NO;
                        }
                    }
                }
            }
            [arraySource addObject:model];
        }
        ScrollPosition scrollPosition = [self configuePosition:rowIn1];

        dispatch_async(dispatch_get_main_queue(), ^{
            if (arraySource.count) {
                successBlock(section1,row1,rowIn1,scrollPosition,arraySource.copy);
            }else {
                failBlock();
            }
        });
    });
}

/**
 知道章节号，遍历找到对应的model给它赋值；获取进度并赋值
 
 @param arrayData array description
 @param chapterNumber chapterNumber description
 @param successBlock successBlock description
 @param failBlock failBlock description
 */
+ (void)dealDataWithArray:(NSArray *)arrayData readChapter:(NSString *)chapterNumber success:(void (^)(NSInteger section,NSInteger cell,NSInteger subCell,ScrollPosition scrollPosition))successBlock fail:(void (^)())failBlock {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
        NSArray *array = [self getReadingChapter:chapterNumber];
        NSInteger section = 0,row = 0,rowIn = 0;// 以上本地获取正在读的章节,知道章节号，遍历找到对应的model给它赋值
        NSInteger section1 = 1,row1 = 1,rowIn1 = 1;// 记住本地获取正在读的章节
        for (KSGrammarBookCatalogueModel *catalogueModel in arrayData) {
            section ++,row = 0;
            for (KSGrammarBookCatalogueSubModel *submodel in catalogueModel.detail) {
                row ++,rowIn = 0;
                submodel.isExpand = NO; //默认不展开
                submodel.isCanExpand = YES; //是否开启收缩展开功能
                for (KSGrammarBookCatalogueCellSubModel *cellModel in submodel.detail) {
                    rowIn ++;
                    cellModel.schedule = [self getReadingChapterSchedule]; // 获取进度并赋值
                    if (array.count==3) { //三层模型写死
                        if (section == [array[0] integerValue]&& row == [array[1] integerValue]&& rowIn == [array[2] integerValue]) {//获取正在读的章节
                            cellModel.isReadingChapter = YES;
                            submodel.isExpand = YES;////需要展开
                            section1 = section,row1 = row,rowIn1 = rowIn;
                        }else {
                            cellModel.isReadingChapter = NO;
                        }
                    }
                }
            }
        }
        ScrollPosition scrollPosition = [self configuePosition:rowIn1];
        dispatch_async(dispatch_get_main_queue(), ^{
            if (array.count) {
                successBlock(section1,row1,rowIn1,scrollPosition);
            }else {
                failBlock();
            }
        });
    });
}

#pragma 获取滑动位置
+ (ScrollPosition)configuePosition:(NSInteger)row {
    ScrollPosition scrollPosition;
    if (row<=3) {
        scrollPosition = ScrollPositionTop;
    }else if (row <=6) {
        scrollPosition = ScrollPositionMiddle;
    }else {
        scrollPosition = ScrollPositionBottom;
    }
    return scrollPosition;
}

#pragma 获取源数据
+ (NSArray *)getData {
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"index1.toc" ofType:nil];
    NSString *jsonString = [[NSString alloc]initWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:nil];
    NSArray *dataSource = [NSJSONSerialization JSONObjectWithData:[jsonString dataUsingEncoding:NSUTF8StringEncoding] options:0 error:nil]; // 拉取源数据
    return dataSource;
}

#pragma 获取正在读的章节的编号
+ (NSArray *)getReadingChapter:(NSString *)chapterString {
    NSArray *array = [chapterString componentsSeparatedByString:@"."];
    if (!array.count) {
        array = @[@1,@1,@1];
    }
    return array.mutableCopy;
}

#pragma 获取每个小节的阅读进度
+ (NSString *)getReadingChapterSchedule {
    return @"马上学习";
}

#pragma 计算高度判断几行
+ (void)calculatedHeightWithCatalogueModel:(KSGrammarBookCatalogueModel *)catalogueModel {
    CGFloat height = [self getHeight:[NSString stringWithFormat:@"%@  %@",catalogueModel.num,catalogueModel.title] font:21.0 width:kScreenSize.width -headViewW];
    height > headViewH ? (catalogueModel.singleLine = NO) : (catalogueModel.singleLine = YES);
}

+ (void)calculatedHeightWithCatalogueSubModel:(KSGrammarBookCatalogueSubModel *)catalogueSubModel {
    CGFloat height = [self getHeight:[NSString stringWithFormat:@"%@  %@",catalogueSubModel.num,catalogueSubModel.title] font:15.0 width:kScreenSize.width-HeadCellW];
    height > HeadCellH ? (catalogueSubModel.singleLine = NO) : (catalogueSubModel.singleLine = YES);
}

+ (CGFloat )getHeight:(NSString *)str font:(CGFloat)font width:(CGFloat)width {
    if (!str.length) {
        return 0;
    }
    NSDictionary *dict = @{NSFontAttributeName:[UIFont systemFontOfSize:font]};
    CGSize size = [str boundingRectWithSize:CGSizeMake(width, MAXFLOAT) options:NSStringDrawingUsesFontLeading|NSStringDrawingUsesLineFragmentOrigin attributes:dict context:nil].size;
    return ceilf(size.height);
}

//
//- (NSArray *)detail {
//    NSMutableArray *array = [NSMutableArray array];
//    for (NSDictionary *dic in _detail) {
//        KSGrammarBookCatalogueSubModel *model = [[KSGrammarBookCatalogueSubModel alloc]init];
//        model = [KSGrammarBookCatalogueSubModel mj_objectWithKeyValues:dic];
//        [array addObject:model];
//    }
//    return array;
//}
@end

@implementation KSGrammarBookCatalogueSubModel
+ (NSDictionary *)mj_objectClassInArray {
    return @{@"detail":[KSGrammarBookCatalogueCellSubModel class]};
}

//- (NSArray *)detail {
//    NSMutableArray *array = [NSMutableArray array];
//    for (NSDictionary *dic in _detail) {
//        KSGrammarBookCatalogueCellSubModel *model = [[KSGrammarBookCatalogueCellSubModel alloc]init];
//        model = [KSGrammarBookCatalogueCellSubModel mj_objectWithKeyValues:dic];
//        [array addObject:model];
//    }
//    return array;
//}
@end


@implementation KSGrammarBookCatalogueCellSubModel
@end
