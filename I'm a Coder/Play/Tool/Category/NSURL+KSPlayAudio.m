//
//  NSURL+KSPlayAudio.m
//  I'm a Coder
//
//  Created by xiaruzhen on 2017/8/14.
//  Copyright © 2017年 xiaruzhen. All rights reserved.
//

#import "NSURL+KSPlayAudio.h"

@implementation NSURL (KSPlayAudio)
- (NSURL *)customSchemeURL {
    NSURLComponents * components = [[NSURLComponents alloc] initWithURL:self resolvingAgainstBaseURL:NO];
    components.scheme = @"streaming";
    return [components URL];
}

- (NSURL *)originalSchemeURL {
    NSURLComponents * components = [[NSURLComponents alloc] initWithURL:self resolvingAgainstBaseURL:NO];
    components.scheme = @"http";
    return [components URL];
}
@end
