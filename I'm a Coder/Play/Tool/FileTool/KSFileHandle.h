//
//  KSFileHandle.h
//  I'm a Coder
//
//  Created by xiaruzhen on 2017/8/13.
//  Copyright © 2017年 xiaruzhen. All rights reserved.
//

#import <Foundation/Foundation.h>
#
@interface KSFileHandle : NSObject


/**
 *  创建临时文件
 */
+ (BOOL)createTempFile;

/**
 *  往临时文件写入数据
 */
+ (void)writeTempFileData:(NSData *)data;

/**
 *  读取临时文件数据
 */
+ (NSData *)readTempFileDataWithOffset:(NSUInteger)offset length:(NSUInteger)length;

/**
 *  保存临时文件到缓存文件夹
 */
+ (void)cacheTempFileWithFileName:(NSString *)name;

/**
 *  是否存在缓存文件 存在：返回文件路径 不存在：返回nil
 */
+ (NSString *)cacheFileExistsWithURL:(NSURL *)url;

/**
 *  清空缓存文件
 */
+ (BOOL)clearCache;

@end

