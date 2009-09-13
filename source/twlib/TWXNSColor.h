//
//  TWXNSColor.h
//
//  Copyright 2009 Trollwerks Inc. All rights reserved.
//

@interface NSColor (TWXNSColor)

+ (NSColor *)colorFromHexValue:(NSUInteger)hexValue;
+ (NSColor *)colorFromHexString:(NSString *)hexString;

@end
