//
//  TWAppDelegate.m
//
//  Copyright (c) 2011 Trollwerks Inc. All rights reserved.
//

#import "TWAppDelegate.h"
#import "TWViewController.h"

@interface TWAppDelegate()

@end

@implementation TWAppDelegate

+ (TWAppDelegate *) appDelegate
{
   return UIApplication.sharedApplication.delegate;
}

#pragma mark - Life cycle

+ (void)initialize
{
	if (self == TWAppDelegate.class)
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

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *) __unused launchOptions
{
   twlog("launched %@ %@(%@) with options %@",
      [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleDisplayName"],
      [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"],
      [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleVersion"],
      launchOptions
   );
   
   self.window = [[UIWindow alloc] initWithFrame:UIScreen.mainScreen.bounds];
   self.viewController = TWViewController.controller;
   
   application.statusBarHidden = NO;
   self.window.rootViewController = self.viewController;
   [self.window makeKeyAndVisible];
   [self animateSplash];
   
   // return NO if URL in launchOptions cannot be handled
   return YES;
}

- (void)animateSplash
{
   NSString *splashFile = [[NSBundle mainBundle] pathForResource:TWRUNNING_IPAD ? @"Default-Portrait" : @"Default" ofType:@"png"];
   UIImage *splashImage = [UIImage imageWithContentsOfFile:splashFile];
   UIImageView *splashView = [[UIImageView alloc] initWithImage:splashImage];
   [self.window addSubview:splashView];
   
   [UIView animateWithDuration:1.5
      animations:^{ 
         splashView.alpha = 0.0f;
         CGRect screen = [UIScreen mainScreen].bounds;
         splashView.frame = CGRectInset(screen, -screen.size.width, -screen.size.height);
      } 
      completion:^(BOOL __unused finished){
         [splashView removeFromSuperview];
      }
   ];
}

- (void)applicationDidReceiveMemoryWarning:(UIApplication *) __unused application
{
   twlog("applicationDidReceiveMemoryWarning!! -- no action");
}

- (void)applicationDidBecomeActive:(UIApplication *) __unused application
{
}

- (void)applicationWillResignActive:(UIApplication *) __unused application
{
}

- (void)applicationDidEnterBackground:(UIApplication *) __unused application
{
   [self cleanup];
}

- (void)applicationWillEnterForeground:(UIApplication *) __unused application
{
}

- (void)applicationWillTerminate:(UIApplication *) __unused application
{
   [self cleanup];
}

- (void)cleanup
{
   [[NSUserDefaults standardUserDefaults] synchronize];
}

#pragma mark - Actions

#pragma mark - Support

@end
