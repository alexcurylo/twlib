//
//  TWXNSObject.h
//
//  Copyright 2010 Trollwerks Inc. All rights reserved.
//

@interface NSObject (TWXNSObject)

// checks if is not nil or [NSNull null]
- (BOOL)exists;

- (NSString *)stringOrStringValue;
- (BOOL)isString;

// an empty JSON dictionary comes through as an array
- (BOOL)isDictionary;

// available on desktop but not iPhone for some reason
- (NSString *)className;

@end

