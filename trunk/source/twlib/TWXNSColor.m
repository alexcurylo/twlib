//
//  TWXNSColor.m
//
//  Copyright 2009 Trollwerks Inc. All rights reserved.
//

#import "TWXNSColor.h"

@implementation NSColor (TWXNSColor)

+ (NSColor *)colorFromHexValue:(NSUInteger)hexValue
{
   NSColor *result = NULL;
   
   result = [NSColor colorWithCalibratedRed:((CGFloat)((hexValue & 0xFF0000) >> 16)) / 255.f
      green:((CGFloat)((hexValue & 0xFF00) >> 8)) / 255.f
      blue:((CGFloat)(hexValue & 0xFF)) / 255.f
      alpha:1.f
   ];
   
   return result;
}

+ (NSColor *)colorFromHexString:(NSString *)hexString
{
      // or just use scanInteger and pass to colorFromHexValue?
   
   NSColor *result = NULL;
   
   NSRange range = { 0, 2 };
   NSString *redString = [hexString substringWithRange:range];  
   range.location = 2;  
   NSString *greenString = [hexString substringWithRange:range];  
   range.location = 4;  
   NSString *blueString = [hexString substringWithRange:range];  
   
   NSUInteger red = 0, green = 0, blue = 0;  
   [[NSScanner scannerWithString:redString] scanHexInt:&red];  
   [[NSScanner scannerWithString:greenString] scanHexInt:&green];  
   [[NSScanner scannerWithString:blueString] scanHexInt:&blue];  
   
   result = [NSColor colorWithCalibratedRed:(CGFloat)red / 255.f
      green:(CGFloat)green / 255.f
      blue:(CGFloat)blue / 255.f
      alpha:1.f
   ];
   
   return result;
}

@end
