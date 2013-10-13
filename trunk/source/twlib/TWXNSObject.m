//
//  TWXNSObject.m
//
//  Copyright 2010 Trollwerks Inc. All rights reserved.
//

#import "TWXNSObject.h"
#import <objc/runtime.h> // for class_getName introspection

    @implementation NSObject (TWXNSObject)

    - (BOOL)exists
    {
       if ([[NSNull null] isEqual:self])
          return NO;
       return YES;
    }

    // an empty JSON dictionary comes through as an array
    - (BOOL)isDictionary
    {
       if (!self.exists)
          return NO;
       if (![self isKindOfClass:[NSDictionary class]])
          return NO;
       return YES;
    }

    @end
