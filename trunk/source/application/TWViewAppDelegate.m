//
//  TWViewAppDelegate.m
//
//  Copyright Trollwerks Inc 2009. All rights reserved.
//

#import "TWViewAppDelegate.h"
#import "TWBlankViewController.h"

@implementation TWViewAppDelegate

@synthesize window;
@synthesize viewController;

- (void)applicationDidFinishLaunching:(UIApplication *)application
{    
   twlog("launched %@ %@(%@)",
         [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleDisplayName"],
         [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"],
         [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleVersion"]
         );
   
   // status bar marked hidden UIStatusBarStyleBlackOpaque in Info.plist so Default.png comes up fullscreen
   [application setStatusBarHidden:NO animated:NO];
   
    // Override point for customization after app launch    
    [self.window addSubview:self.viewController.view];
    [window makeKeyAndVisible];
}

- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application
{
   (void)application;
   twlog("applicationDidReceiveMemoryWarning!! -- no action");
}

- (void)applicationWillTerminate:(UIApplication *)application
{
   (void)application;
   [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)dealloc
{
	twrelease(viewController);
	twrelease(window);
   
   [super dealloc];
}

#pragma mark -
#pragma mark Application support


@end

#pragma mark -
#pragma mark Conveniences

TWViewAppDelegate *TWAppDelegate(void)
{
   return [[UIApplication sharedApplication] delegate];
}
