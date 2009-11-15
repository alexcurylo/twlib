//
//  TWXNSObject.h
//
//  Copyright 2009 Trollwerks Inc. All rights reserved.
//

@interface NSObject (TWXNSObject)

// checks if is not nil or [NSNull null]
- (BOOL)exists;

// available on desktop but not iPhone for some reason
- (NSString *)className;

@end

