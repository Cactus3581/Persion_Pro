//
//  UIFont+XRZAdd.h
//  UCard
//
//  Created by xiaruzhen on 2017/3/28.
//  Copyright © 2017年 Synjones. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreGraphics/CoreGraphics.h>
#import <CoreText/CoreText.h>
#import "XRZCGUtilities.h"
@interface UIFont (XRZAdd)

NS_ASSUME_NONNULL_BEGIN

#ifndef XFont
#define XFont(_s_) [UIFont systemFontOfSize:widthRatio(_s_)]
#endif

#pragma mark - check font type

@property (nonatomic, readonly) BOOL isBold NS_AVAILABLE_IOS(7_0); ///< Whether the font is bold.
@property (nonatomic, readonly) BOOL isItalic NS_AVAILABLE_IOS(7_0); ///< Whether the font is italic.
@property (nonatomic, readonly) BOOL isMonoSpace NS_AVAILABLE_IOS(7_0); ///< Whether the font is mono space.
@property (nonatomic, readonly) BOOL isColorGlyphs NS_AVAILABLE_IOS(7_0); ///< Whether the font is color glyphs (such as Emoji).
@property (nonatomic, readonly) CGFloat fontWeight NS_AVAILABLE_IOS(7_0); ///< Font weight from -1.0 to 1.0. Regular weight

#pragma mark - font type change

@property (nullable, nonatomic, readonly) UIFont *boldFont;
@property (nullable, nonatomic, readonly) UIFont *italicFont;
@property (nullable, nonatomic, readonly) UIFont *boldItalicFont;
@property (nullable, nonatomic, readonly) UIFont *normalFont;

#pragma mark - create font

+ (nullable UIFont *)xrz_fontWithCTFont:(CTFontRef)CTFont;
+ (nullable UIFont *)xrz_fontWithCGFont:(CGFontRef)CGFont size:(CGFloat)size;


@property (nullable, nonatomic, readonly) CTFontRef ctFontRef CF_RETURNS_RETAINED;
@property (nullable, nonatomic, readonly) CGFontRef cgFontRef CF_RETURNS_RETAINED;

#pragma mark - Load and unload font

+ (BOOL)xrz_loadFontFromPath:(NSString *)path;
+ (void)xrz_unloadFontFromPath:(NSString *)path;
+ (nullable UIFont *)xrz_loadFontFromData:(NSData *)data;
+ (BOOL)xrz_unloadFontFromData:(UIFont *)font;

@end

NS_ASSUME_NONNULL_END
