//
//  TWMain.m
//
//  Copyright 2011 Trollwerks Inc. All rights reserved.
//

//#import "FlurryAPI.h"
#include <sys/time.h>

static void uncaughtExceptionHandler(NSException *exception)
{
   // note that using PLCrashReporter will override this;
   // perhaps it could chain here with NSGetUncaughtExceptionHandler?
   
   // tips on what to do in your exception handler
   // http://www.restoroot.com/Blog/2008/10/18/crash-reporter-for-iphone-applications/
   // http://rel.me/2008/12/30/getting-a-useful-stack-trace-from-nsexception-callstackreturnaddresses/
	// NSLog(@"%@", GTMStackTraceFromException(exception));
   NSLog(@"EPIC FAIL: uncaughtExceptionHandler triggered with %@!", exception);
   
   //[FlurryAPI logError:@"Uncaught" message:@"EPIC FAIL" exception:exception];
}

int main(int argc, char *argv[])
{
   static struct timeval now = { 0, 0 };
   gettimeofday(&now, NULL);
	srand(now.tv_sec);
	srandom(now.tv_sec);
   
   // note that using PLCrashReporter will override this;
   NSSetUncaughtExceptionHandler(&uncaughtExceptionHandler);
   
   NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
   int retVal = UIApplicationMain(argc, argv, nil, nil);
   [pool release];
   return retVal;
}

#if __IPHONE_OS_VERSION_MIN_REQUIRED < __IPHONE_4_3
// declared in stdlib.h
u_int32_t arc4random_uniform(u_int32_t upper_bound)
{
   return arc4random() % upper_bound;
}
#endif // __IPHONE_OS_VERSION_MIN_REQUIRED < __IPHONE_4_3