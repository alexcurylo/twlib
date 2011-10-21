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
   // note that using PLCrashReporter or such will most likely override this
   NSSetUncaughtExceptionHandler(&uncaughtExceptionHandler);
   
   @autoreleasepool
   {
      return UIApplicationMain(argc, argv, nil, NSStringFromClass([TWAppDelegate class]));
   }
}
