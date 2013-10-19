//
//  main.m
//  PosesPro2
//
//  Created by alex on 2013-10-15.
//  Copyright (c) 2013 Trollwerks Inc. All rights reserved.
//

@import UIKit;

#import "POSAppDelegate.h"
#import "TWXAnalytics.h"

static void uncaughtExceptionHandler(NSException *exception)
{
    NSLog(@"EPIC FAIL: uncaughtExceptionHandler triggered with %@!", exception);
    
    [TWXAnalytics logException:@"uncaughtExceptionHandler" message:@"Crash!" exception:exception];
}

int main(int argc, char * argv[])
{
    NSSetUncaughtExceptionHandler(&uncaughtExceptionHandler);
    
    //setenv("CLASSIC", "0", 1);
    
    //twmempoll(2);
    
    @autoreleasepool
    {
        return UIApplicationMain(argc, argv, nil, NSStringFromClass([POSAppDelegate class]));
    }
}
