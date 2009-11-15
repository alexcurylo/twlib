//
//  TWXNSObject.m
//
//  Copyright 2009 Trollwerks Inc. All rights reserved.
//

#import "TWXNSObject.h"
#import <objc/runtime.h> // for class_getName introspection

@implementation NSObject (TWXNSObject)

// checks if is not nil or [NSNull null]
- (BOOL)exists
{
   if (!self)
      return NO;
   
   if ([[NSNull null] isEqual:self])
      return NO;
 
   return YES;
}

// available on desktop but not iPhone for some reason
- (NSString *)className
{
   return [NSString stringWithUTF8String:class_getName([self class])];
}

@end
