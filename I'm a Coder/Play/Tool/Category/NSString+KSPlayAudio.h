//
//  NSString+KSPlayAudio.h
//  I'm a Coder
//
//  Created by xiaruzhen on 2017/8/14.
//  Copyright © 2017年 xiaruzhen. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (KSPlayAudio)
/**
 *  临时文件路径
 */
+ (NSString *)tempFilePath;

/**
 *  缓存文件夹路径
 */
+ (NSString *)cacheFolderPath;

/**
 *  获取网址中的文件名
 */
+ (NSString *)fileNameWithURL:(NSURL *)url;
@end
