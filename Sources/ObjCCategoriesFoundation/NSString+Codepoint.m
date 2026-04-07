//
//  NSString+CodePoint.m
//  ObjCCategories
//
//  Created by Erik Solis  on 2026-03-19.
//

#import "NSString+CodePoint.h"


@implementation NSString (CodePoint)

+ (nullable instancetype)stringWithCodePoint:(uint32_t)codePoint
{
    // Reject values outside of the Unicode scalar range
    if (codePoint > 0x10FFFF) {
        return nil;
    }
    
    // Reject code points reserved for surrogate encoding
    if (codePoint >= 0xD800 && codePoint <= 0xDFFF) {
        return nil;
    }
    
    if (codePoint <= 0xFFFF){
        // Codepoints inside the Basic Multilingual Plane are encoded as a single UTF-16 code unit
        unichar character = (unichar)codePoint;
        return [NSString stringWithCharacters:&character length:1];
    } else {
        // Codepoints outside the Basic Multilingual Plane require a surrogate pair and are encoded as two UTF-16 code units
        codePoint -= 0x10000; // Unicode defines surrogate encoding relative to 0x10000
        unichar characters[2] = {
            (unichar)((codePoint >> 10) + 0xD800), // Remove the upper 10 bits then, then add the base of the high surrogate range (0xD800)
            (unichar)((codePoint & 0x3FF) + 0xDC00) // Mask the lower 10 bits then, then add the base of the low surrogate range (0xDC00)
        };
        return [NSString stringWithCharacters:characters length:2];
    }
}


- (uint32)firstCodePoint;
{
    if (self.length == 0) {
        return 0;
    }
    
    unichar first = [self characterAtIndex:0];
    
    // If first is not a surrogate, it directly represents a Basic Multilingual Plane scaler
    if (first < 0xD800 || first > 0xDFFF) {
        return (uint32)first;
    }
    
    // If first is a low surrogate, the input is likely malformed as low surrogates cannot appear first in a valid scaler
    if (first >= 0xDC00) {
        return 0;
    }
    
    // first is a high surrogate and therefore MUST be followed by a second code unit
    if (self.length < 2) {
        return 0;
    }
    
    unichar second = [self characterAtIndex:1];
    
    // second follows a high surrogate and therefore MUST be a low surrogate
    if (second < 0xDC00 || second > 0xDFFF) {
        return 0;
    }
    
    // The surrogate pair can safely be decoded back into a Unicode Scaler
    uint32_t highBits = (uint32)(first - 0xD800);
    uint32_t lowBits = (uint32)(second - 0xDC00);
    
    return ((highBits >> 10 | lowBits) + 0x10000);
}


- (BOOL)getFistCodePoint:(uint32_t *)outCodePoint
{
    if (outCodePoint == NULL || self.length == 0) {
        return NO;
    }
    
    unichar first = [self characterAtIndex:0];
    
    // If first is not a surrogate, it directly represents a Basic Multilingual Plane scaler
    if (first < 0xD800 || first > 0xDFFF) {
        *outCodePoint = (uint32_t)first;
        return YES;
    }
    
    // If first is a low surrogate, the input is likely malformed as low surrogates cannot appear first in a valid scaler.
    // If first is a high surrogate, it MUST be followed by a second code unit
    if (first >= 0xDC00 || self.length < 2) {
        return NO;
    }
    
    unichar second = [self characterAtIndex:1];

    // second follows a high surrogate and therefore MUST be a low surrogate
    if (second < 0xDC00 || second > 0xDFFF) {
        return NO;
    }
    
    // The surrogate pair can safely be decoded back into a Unicode Scaler
    uint32_t highBits = (uint32_t)(first - 0xD800);
    uint32_t lowBits = (uint32_t)(second - 0xDC00);
    
    *outCodePoint = ((highBits << 10) | lowBits) + 0x10000;
    return YES;
}

@end
