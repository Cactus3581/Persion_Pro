//
//  KSResourceLoader.h
//  I'm a Coder
//
//  Created by xiaruzhen on 2017/8/13.
//  Copyright © 2017年 xiaruzhen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
#import "KSRequestTask.h"
#define MimeType @"audio/mpeg"

@class KSResourceLoader;
@protocol KSResourceLoaderDelegate <NSObject>

@required
- (void)loader:(KSResourceLoader *)loader cacheProgress:(CGFloat)progress;

@optional
- (void)loader:(KSResourceLoader *)loader failLoadingWithError:(NSError *)error;

@end

@interface KSResourceLoader : NSObject<AVAssetResourceLoaderDelegate,KSRequestTaskDelegate>

@property (nonatomic, weak) id<KSResourceLoaderDelegate> delegate;
@property (atomic, assign) BOOL seekRequired; //Seek标识
@property (nonatomic, assign) BOOL cacheFinished;

- (void)stopLoading;

@end


