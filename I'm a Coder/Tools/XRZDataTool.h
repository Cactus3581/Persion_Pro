//
//  XRZDataTool.h
//  I'm a Coder
//
//  Created by xiaruzhen on 2017/5/9.
//  Copyright © 2017年 xiaruzhen. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/**
 判断是否为字符串

 @return 字符串
 */
static inline NSString * XRZValidateString(NSString *rawString) {
    if (!rawString || [rawString isKindOfClass: [NSNull class]]) {
        return @"";
    }
    if (![rawString isKindOfClass:[NSString class]]) {
        return [NSString stringWithFormat:@"%@", rawString];
    }
    return rawString;
};


/**
 判断是否为字典

 @return 字典
 */
static inline NSDictionary * XRZValidateDict(NSDictionary *rawDict) {
    if (![rawDict isKindOfClass:[NSDictionary class]]) {
        return @{};
    }
    return rawDict;
};

/**
 判断是否为数组
 
 @return 数组
 */
static inline NSArray * XRZValidateArray(NSArray *rawArray) {
    if (![rawArray isKindOfClass:[NSArray class]]) {
        return @[];
    }
    return rawArray;
};

/**
 判断是否越界
 
 @return id|nil
 */
static inline id XRZValidateArrayObjAtIdx(NSArray * rawArray, NSUInteger idx) {
    if (![rawArray isKindOfClass:[NSArray class]] || !rawArray.count) {
        return nil;
    }
    return idx > rawArray.count - 1 ? nil : rawArray[idx];
    
};

/**
 判断是否为NSNumber
 
 @return NSNumber
 */
static inline NSNumber * XRZValidateNumber(NSNumber *rawNumber) {
    if ([rawNumber isKindOfClass:[NSNumber class]]) {
        return rawNumber;
    }
    if ([rawNumber isKindOfClass:[NSString class]]) {
        id result;
        NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
        result=[formatter numberFromString:(NSString *)rawNumber];
        if(!(result)) {
            result=@0;
        }
        return result;
    }
    return @0;
};

NS_ASSUME_NONNULL_END
