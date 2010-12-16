//
//  TWXUIToolbar.m
//
//  Copyright 2010 Trollwerks Inc. All rights reserved.
//

#import "TWXUIToolbar.h"
#import <objc/runtime.h>

// keep track of default implementations

static void (*sOriginalDrawRect)(id, SEL, CGRect);
static void (*sOriginalDrawLayerInContext)(id, SEL, CALayer*, CGContextRef);

// override for drawRect:

static void OverrideDrawRect(UIToolbar *self, SEL _cmd, CGRect r)
{
   if ( [[self tintColor] isEqual:[UIColor clearColor]] )
   {
      // do nothing
   }
   else
   {
      // call default method
      sOriginalDrawRect(self, _cmd, r);
   }
}

// override for drawLayer:inContext:

static void OverrideDrawLayerInContext(UIToolbar *self, SEL _cmd, CALayer *layer, CGContextRef context)
{
   if ( [[self tintColor] isEqual:[UIColor clearColor]] )
   {
      // Do nothing
   }
   else
   {
      // Call default method
      sOriginalDrawLayerInContext(self, _cmd, layer, context);
   }
}

@implementation UIToolbar (TWXUIToolbar)

// setting tintColor to clearColor will noop out drawRect & drawLayer:inContext:

+ (void)load
{
   // replace methods, keeping originals
   Method originalMethod = class_getInstanceMethod(self, @selector(drawRect:));
   sOriginalDrawRect = (void *)method_getImplementation(originalMethod);
   
   if(!class_addMethod(self, @selector(drawRect:), (IMP)OverrideDrawRect, method_getTypeEncoding(originalMethod)))
      method_setImplementation(originalMethod, (IMP)OverrideDrawRect);
   
   originalMethod = class_getInstanceMethod(self, @selector(drawLayer:inContext:));
   sOriginalDrawLayerInContext = (void *)method_getImplementation(originalMethod);
   
   if(!class_addMethod(self, @selector(drawLayer:inContext:), (IMP)OverrideDrawLayerInContext, method_getTypeEncoding(originalMethod)))
      method_setImplementation(originalMethod, (IMP)OverrideDrawLayerInContext);
}

- (void)makeTransparent:(UIBarStyle)buttonStyle
{
   self.barStyle = buttonStyle;

   // our method swizzling makes it transparent with this
   self.tintColor = [UIColor clearColor];
   self.translucent = YES;

   // regular UIView transparency setup
   self.backgroundColor = [UIColor clearColor];
   self.opaque = NO;
}

@end