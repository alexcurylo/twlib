//
//  TWTabBarAppDelegate.h
//
//  Copyright 2010 Trollwerks Inc. All rights reserved.
//

@interface TWTabBarAppDelegate : NSObject <UIApplicationDelegate>
{
   IBOutlet UIWindow *window;
   IBOutlet UITabBarController *tabBarController;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet UITabBarController *tabBarController;

#pragma mark -
#pragma mark Life cycle

+ (void)initialize;
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions;
- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application;
- (void)applicationDidBecomeActive:(UIApplication *)application;
- (void)applicationWillResignActive:(UIApplication *)application;
- (void)applicationDidEnterBackground:(UIApplication *)application;
- (void)applicationWillEnterForeground:(UIApplication *)application;
- (void)applicationWillTerminate:(UIApplication *)application;
- (void)cleanup;
- (void)dealloc;

#pragma mark -
#pragma mark Application support


@end

#pragma mark -
#pragma mark Conveniences

TWTabBarAppDelegate *TWAppDelegate(void);
