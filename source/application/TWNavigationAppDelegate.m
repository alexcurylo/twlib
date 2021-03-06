//
//  TWNavigationAppDelegate.m
//
//  Copyright 2010 Trollwerks Inc. All rights reserved.
//

#import "TWNavigationAppDelegate.h"

@implementation TWNavigationAppDelegate

@synthesize window;
@synthesize navigationController;

#pragma mark -
#pragma mark Life cycle

+ (void)initialize
{
	if ( self == [TWNavigationAppDelegate class])
   {
      /* if you'd like some settings defaults
		NSDictionary *appDefaults = [NSDictionary dictionaryWithObjectsAndKeys:
         [NSNumber numberWithBool:NO], kXXPrefDefaultValue,
         nil
      ];
		[[NSUserDefaults standardUserDefaults] registerDefaults:appDefaults];
       */
	}
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
   (void)launchOptions;
   
   twlog("launched %@ %@(%@) with options %@",
      [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleDisplayName"],
      [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"],
      [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleVersion"],
      launchOptions
   );
   
   // status bar marked hidden UIStatusBarStyleBlackOpaque in Info.plist so Default.png comes up fullscreen
   application.statusBarHidden = NO;
   
   [window addSubview:navigationController.view];
   [window makeKeyAndVisible];
   
   // return NO if URL in launchOptions cannot be handled
   return YES;
}

// only on iOS 4
- (void)applicationWillEnterForeground:(UIApplication *)application
{
   (void)application;
   twlog("applicationWillEnterForeground");
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
   (void)application;
   twlog("applicationDidBecomeActive");
}

- (void)applicationWillResignActive:(UIApplication *)application
{
   (void)application;
   twlog("applicationWillResignActive");
}

// only on iOS 4; may be quit without further notification
- (void)applicationDidEnterBackground:(UIApplication *)application
{
   (void)application;
   twlog("applicationDidEnterBackground");

   [self cleanup];
}

- (void)applicationSignificantTimeChange:(UIApplication *)application;
// midnight, carrier time update, daylight savings time change
{
   (void)application;
   twlog("applicationSignificantTimeChange");
}

- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application
{
   (void)application;
   twlog("applicationDidReceiveMemoryWarning!! -- no action");
}

// only expected to be called on iOS 3, or iOS 4 on non-multitasking devices
- (void)applicationWillTerminate:(UIApplication *)application
{
   (void)application;
   twlog("applicationWillTerminate");
   
   [self cleanup];
}

- (void)cleanup
{
   [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)dealloc
{
	twrelease(navigationController);
	twrelease(window);

	[super dealloc];
}

#pragma mark -
#pragma mark Application support


@end

#pragma mark -
#pragma mark Conveniences

TWNavigationAppDelegate *TWAppDelegate(void)
{
   return [[UIApplication sharedApplication] delegate];
}
