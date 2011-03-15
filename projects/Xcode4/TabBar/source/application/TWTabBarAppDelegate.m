//
//  TWTabBarAppDelegate.m
//
//  Copyright 2011 Trollwerks Inc. All rights reserved.
//

#import "TWTabBarAppDelegate.h"

@implementation TWTabBarAppDelegate

@synthesize window=_window;
@synthesize tabBarController=_tabBarController;

#pragma mark -
#pragma mark Life cycle

+ (void)initialize
{
	if ( self == [TWTabBarAppDelegate class])
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
   
   // only on iOS 4
   //self.window.rootViewController = self.tabBarController;
   [self.window addSubview:self.tabBarController.view];
   [self.window makeKeyAndVisible];

   /*
    // get views all created to do their initialization
    for (UIViewController *controller in self.tabBarController.viewControllers)
    {
    (void)controller.view;
    if ([controller isKindOfClass:[UINavigationController class]])
    {
    UINavigationController *navController = (UINavigationController *)controller;
    (void)navController.topViewController.view;
    }
    }
    */
   
   // return NO if URL in launchOptions cannot be handled
   return YES;
}

- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application
{
   (void)application;
   twlog("applicationDidReceiveMemoryWarning!! -- no action");
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
   (void)application;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
   (void)application;
}

// only on iOS 4; may be quit without further notification
- (void)applicationDidEnterBackground:(UIApplication *)application
{
   (void)application;

   [self cleanup];
}

// only on iOS 4
- (void)applicationWillEnterForeground:(UIApplication *)application
{
   (void)application;
}

// only expected to be called on iOS 3, or iOS 4 on non-multitasking devices
- (void)applicationWillTerminate:(UIApplication *)application
{
   (void)application;
   
   [self cleanup];
}

- (void)cleanup
{
   [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)dealloc
{
	twrelease(_tabBarController);
	twrelease(_window);

	[super dealloc];
}

#pragma mark -
#pragma mark Application support


#pragma mark -
#pragma mark UITabBarControllerDelegate

 - (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController
{
   (void)tabBarController;
   (void)viewController;
}

 - (void)tabBarController:(UITabBarController *)tabBarController didEndCustomizingViewControllers:(NSArray *)viewControllers changed:(BOOL)changed
{
   (void)tabBarController;
   (void)viewControllers;
   (void)changed;
}

@end

#pragma mark -
#pragma mark Conveniences

TWTabBarAppDelegate *TWAppDelegate(void)
{
   return [[UIApplication sharedApplication] delegate];
}
