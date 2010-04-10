//
//  TWXNSObject.m
//
//  Copyright 2010 Trollwerks Inc. All rights reserved.
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

- (NSString *)stringOrStringValue
{
   if ([self isString])
      return (id)self;
   
   if ([self respondsToSelector:@selector(stringValue)])
      return [(id)self stringValue];
   
   return [self description];
}

- (BOOL)isString
{
   if (!self)
      return NO;
   
   if ([self isKindOfClass:[NSString class]])
     return YES;
   
   //twlog("possible string classname is %@!", self.className);
        
   return NO;
}

// an empty JSON dictionary comes through as an array
- (BOOL)isDictionary
{
   if (!self.exists)
      return NO;

  // && [@"NSCFDictionary" isEqual:[studyCategoryDictionary className]]
   if (![self isKindOfClass:[NSDictionary class]])
      return NO;
        
   //if !([self count])
      //return NO;
 
   return YES;
}

// available on desktop but not iPhone for some reason
- (NSString *)className
{
   return [NSString stringWithUTF8String:class_getName([self class])];
}

@end
