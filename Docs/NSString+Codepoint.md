# ObjCCategoriesFoundation - `NSString+Codepoint` Documentation

NSString+Codepoint adds Python-like [`chr()`](https://docs.python.org/3/library/functions.html#chr) and [`ord`](https://docs.python.org/3/library/functions.html#ord) functionality to NSString.


## Methods included

### Class Methods

-   ```objectivec
    + (nullable instancetype)stringWithCodePoint:(uint32_t)codePoint
    
### Instance Methods

-   ```objectivec
    - (uint32)firstCodePoint
    
-   ```objectivec
    - (BOOL)getFistCodePoint:(uint32_t *)outCodePoint
