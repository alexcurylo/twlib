//
//  TWMain.m
//
//  Copyright (c) 2011 Trollwerks Inc. All rights reserved.
//

#import "TWAppDelegate.h"

static void uncaughtExceptionHandler(NSException *exception)
{
   NSLog(@"EPIC FAIL: uncaughtExceptionHandler triggered with %@!", exception);
}

int main(int argc, char *argv[])
{
   // note that using PLCrashReporter or such will most likely override this;
   // TestFlight alleges that it will call a handler installed before -takeOff
   NSSetUncaughtExceptionHandler(&uncaughtExceptionHandler);
   // and it would also call existing signal handlers, did we install any here
   
   @autoreleasepool
   {
      return UIApplicationMain(argc, argv, nil, NSStringFromClass([TWAppDelegate class]));
   }
}

#if __IPHONE_OS_VERSION_MIN_REQUIRED < __IPHONE_4_3
// declared in stdlib.h
u_int32_t arc4random_uniform(u_int32_t upper_bound)
{
   return arc4random() % upper_bound;
}
#endif // __IPHONE_OS_VERSION_MIN_REQUIRED < __IPHONE_4_3