//
//  NSURL+KSPlayAudio.h
//  I'm a Coder
//
//  Created by xiaruzhen on 2017/8/14.
//  Copyright © 2017年 xiaruzhen. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSURL (KSPlayAudio)
/**
 *  自定义scheme
 */
- (NSURL *)customSchemeURL;

/**
 *  还原scheme
 */
- (NSURL *)originalSchemeURL;
@end
