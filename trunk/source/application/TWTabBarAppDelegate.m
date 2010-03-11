//
//  TWTabBarAppDelegate.m
//
//  Copyright Trollwerks Inc 2009. All rights reserved.
//

#import "TWTabBarAppDelegate.h"

@implementation TWTabBarAppDelegate

@synthesize window;
@synthesize tabBarController;

#pragma mark -
#pragma mark Life cycle

- (void)applicationDidFinishLaunching:(UIApplication *)application
{
   twlog("launched %@ %@(%@)",
      [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleDisplayName"],
      [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"],
      [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleVersion"]
   );
   
   // status bar marked hidden UIStatusBarStyleBlackOpaque in Info.plist so Default.png comes up fullscreen
   [application setStatusBarHidden:NO animated:NO];
   
   [self.window addSubview:[self.tabBarController view]];
   [self.window makeKeyAndVisible];
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
	self.tabBarController = nil;
	self.window = nil;

	[super dealloc];
}

#pragma mark -
#pragma mark Application support


@end

#pragma mark -
#pragma mark Conveniences

TWTabBarAppDelegate *TWAppDelegate(void)
{
   return [[UIApplication sharedApplication] delegate];
}
