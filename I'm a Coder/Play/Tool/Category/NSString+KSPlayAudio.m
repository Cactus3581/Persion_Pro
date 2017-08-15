//
//  NSString+KSPlayAudio.m
//  I'm a Coder
//
//  Created by xiaruzhen on 2017/8/14.
//  Copyright © 2017年 xiaruzhen. All rights reserved.
//

#import "NSString+KSPlayAudio.h"

@implementation NSString (KSPlayAudio)
+ (NSString *)tempFilePath {
    return [[NSHomeDirectory( ) stringByAppendingPathComponent:@"tmp"] stringByAppendingPathComponent:@"MusicTemp.mp3"];
}


+ (NSString *)cacheFolderPath {
    return [[NSHomeDirectory( ) stringByAppendingPathComponent:@"Library"] stringByAppendingPathComponent:@"MusicCaches"];
}

+ (NSString *)fileNameWithURL:(NSURL *)url {
    return [[url.path componentsSeparatedByString:@"/"] lastObject];
}
@end
