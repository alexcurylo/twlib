//
//  TWXNSString.h
//
//  Copyright 2010 Trollwerks Inc. All rights reserved.
//

@interface NSString (TWXNSString)

- (BOOL)contains:(NSString *)substring;

- (NSString *)stringByEscapingForURLArgument;

// suitable for [NSArray sortedArrayUsingSelector:]
- (NSComparisonResult)compareByValue:(NSString *)otherString

/*
+ (id)stringWithUUID;

+ (id)stringWithMachineSerialNumber;

- (NSUInteger)lineCount;

// AppleScript helpers

- (void)revealInFinder;
- (void)openInFinder;

- (NSAppleEventDescriptor *)executeAppleScript;
*/

@end

/*

 @interface NSAttributedString (TWXNSAttributedString)
 
 + (id)hyperlinkFromString:(NSString*)inString withURL:(NSURL*)aURL;
 
 @end

 */
