//
//  KSRequestTask.h
//  I'm a Coder
//
//  Created by xiaruzhen on 2017/8/13.
//  Copyright © 2017年 xiaruzhen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "KSFileHandle.h"

#define RequestTimeout 10.0

@class KSRequestTask;
@protocol KSRequestTaskDelegate <NSObject>

@required
- (void)requestTaskDidUpdateCache; //更新缓冲进度代理方法

@optional
- (void)requestTaskDidReceiveResponse;//服务器响应
- (void)requestTaskDidFinishLoadingWithCache:(BOOL)cache;//请求完成,下载完成会调用该方法
- (void)requestTaskDidFailWithError:(NSError *)error;//下载失败

@end

@interface KSRequestTask : NSObject

@property (nonatomic, weak) id<KSRequestTaskDelegate> delegate;
@property (nonatomic, strong) NSURL * requestURL; //请求网址
@property (nonatomic, assign) NSUInteger requestOffset; //请求起始位置
@property (nonatomic, assign) NSUInteger fileLength; //文件长度
@property (nonatomic, assign) NSUInteger cacheLength; //缓冲长度
@property (nonatomic, assign) BOOL cache; //是否缓存文件
@property (nonatomic, assign) BOOL cancel; //是否取消请求

/**
 *  开始请求
 */
- (void)start;

@end
