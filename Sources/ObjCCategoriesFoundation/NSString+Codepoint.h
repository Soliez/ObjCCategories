//
//  NSString+Codepoint.h
//  ObjCCategories
//
//  Created by Erik Solis  on 2026-04-06.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSString (CodePoint)

+ (nullable instancetype)stringWithCodePoint:(uint32_t)codePoint;

- (uint32)firstCodePoint;
- (BOOL)getFistCodePoint:(uint32_t *)outCodePoint;

@end

NS_ASSUME_NONNULL_END
