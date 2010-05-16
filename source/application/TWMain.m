//
//  TWMain.m
//
//  Copyright Trollwerks Inc 2009. All rights reserved.
//

static void uncaughtExceptionHandler(NSException *exception)
{
   // tips on what to do in your exception handler
   // http://www.restoroot.com/Blog/2008/10/18/crash-reporter-for-iphone-applications/
   // http://rel.me/2008/12/30/getting-a-useful-stack-trace-from-nsexception-callstackreturnaddresses/
	// NSLog(@"%@", GTMStackTraceFromException(exception));
   NSLog(@"EPIC FAIL: uncaughtExceptionHandler triggered with %@!", exception);
}

int main(int argc, char *argv[])
{
   NSSetUncaughtExceptionHandler(&uncaughtExceptionHandler);

   NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
   int retVal = UIApplicationMain(argc, argv, nil, nil);
   [pool release];
   return retVal;
}