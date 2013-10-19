//
//  POSAppDelegate.m
//  PosesPro2
//
//  Created by alex on 2013-10-15.
//  Copyright (c) 2013 Trollwerks Inc. All rights reserved.
//

#import "POSAppDelegate.h"
#import "TWXAnalytics.h"
// version 3.0.1a
#import "UAirship.h"
#import "UAPush.h"
#import "UAConfig.h"
@import AudioToolbox;

@interface POSAppDelegate()
<
    UAPushNotificationDelegate,
    UIApplicationDelegate
>

@end

@implementation POSAppDelegate

- (BOOL)application:(UIApplication __unused *)application didFinishLaunchingWithOptions:(NSDictionary __unused *)launchOptions
{
    twlog("FYI: launched %@ %@(%@) %@ -- options: %@",
          [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleDisplayName"],
          [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"],
          [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleVersion"],
          [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBuildDate"],
          launchOptions
          );
    
    //[self startReachabilityChecks];
    
    [TWXAnalytics.sharedInstance startSession];
    
    [self urbanAirshipSetup];

    return YES;
}

- (void)urbanAirshipSetup
{
    // This prevents the UA Library from registering with UIApplication by default. This will allow
    // you to prompt your users at a later time. This gives your app the opportunity to explain the
    // benefits of push or allows users to turn it on explicitly in a settings screen.
    //
    // If you just want everyone to immediately be prompted for push, you can
    // leave this line out.
    //[UAPush setDefaultPushEnabledValue:NO];
    
    // Set log level for debugging config loading (optional)
    // It will be set to the value in the loaded config upon takeOff
    [UAirship setLogLevel:UALogLevelTrace];
    
    // Populate AirshipConfig.plist with your app's info from https://go.urbanairship.com
    // or set runtime properties here.
    UAConfig *config = [UAConfig defaultConfig];
    
    // You can then programatically override the plist values:
    // config.developmentAppKey = @"YourKey";
    // etc.
#ifdef DEBUG
    config.inProduction = NO;
#else
    config.inProduction = YES;
#endif //DEBUG
   
    // Call takeOff (which creates the UAirship singleton)
    twassert(config.validate);
    [UAirship takeOff:config];
    UAPush.shared.pushNotificationDelegate = self;
    
    // Print out the application configuration for debugging (optional)
    twlog("FYI: Urban Airship config:\n%@", [config description]);
    
    // Set the icon badge to zero on startup (optional)
    [[UAPush shared] resetBadge];
    
    // Set the notification types required for the app (optional). With the default value of push set to no,
    // UAPush will record the desired remote notification types, but not register for
    // push notifications as mentioned above. When push is enabled at a later time, the registration
    // will occur normally. This value defaults to badge, alert and sound, so it's only necessary to
    // set it if you want to add or remove types.
    [UAPush shared].notificationTypes = (UIRemoteNotificationTypeBadge |
                                         UIRemoteNotificationTypeSound |
                                         UIRemoteNotificationTypeAlert);
}
							
- (void)applicationWillResignActive:(UIApplication __unused *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication __unused *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication __unused *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication __unused *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.

    [TWXAnalytics.sharedInstance activateSession];
    
    // Set the icon badge to zero on resume (optional)
    [[UAPush shared] resetBadge];
}

- (void)applicationWillTerminate:(UIApplication __unused *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (void)application:(UIApplication *) __unused application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    twlog("FYI: APNS device token: %@", deviceToken);
    [[UAPush shared] registerDeviceToken:deviceToken];
}

- (void)application:(UIApplication *) __unused application didFailToRegisterForRemoteNotificationsWithError:(NSError *) error
{
    twlog("WTF: didFailToRegisterForRemoteNotificationsWithError: %@", error);
}

- (void)application:(UIApplication *) __unused application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    twlog("FYI: didReceiveRemoteNotification: %@", userInfo);
    
    // Reset the badge after a push received (optional)
    [[UAPush shared] resetBadge];
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler
{
    twlog("FYI: didReceiveRemoteNotification:fetchCompletionHandler: %@", userInfo);
    
    // Reset the badge after a push is received in a active or inactive state
    if (application.applicationState != UIApplicationStateBackground)
        [[UAPush shared] resetBadge];
    
    completionHandler(UIBackgroundFetchResultNoData);
}

#pragma mark - UAPushNotificationDelegate

- (void)displayNotificationAlert:(NSString *)alertMessage
{
    twlog("FYI: displayNotificationAlert called: %@", alertMessage);
    
    NSString *alertTitle = nil; // UA_PU_TR(@"UA_Notification_Title")
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:alertTitle
                                                    message: alertMessage
                                                   delegate: nil
                                          cancelButtonTitle: NSLocalizedString(@"OK", nil)
                                          otherButtonTitles: nil];
    [alert show];
}

- (void)displayLocalizedNotificationAlert:(NSDictionary *)alertDict
{
    twlog("WTF: displayLocalizedNotificationAlert called: %@", alertDict);
    
    NSString *body = [alertDict valueForKey:@"body"];
    
    NSString *alertTitle = nil; // UA_PU_TR(@"UA_Notification_Title")
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:alertTitle
                                                    message: body
                                                   delegate: nil
                                          cancelButtonTitle: NSLocalizedString(@"OK", nil)
                                          otherButtonTitles: nil];
    [alert show];
}

- (void)playNotificationSound:(NSString *)sound
{
    twlog("WTF: playNotificationSound called: %@", sound);
    
    if (sound) {
        
        // Note: The default sound is not available in the app.
        //
        // From http://developer.apple.com/library/ios/#documentation/AudioToolbox/Reference/SystemSoundServicesReference/Reference/reference.html :
        // System-supplied alert sounds and system-supplied user-interface sound effects are not available to your iOS application.
        // For example, using the kSystemSoundID_UserPreferredAlert constant as a parameter to the AudioServicesPlayAlertSound
        // function will not play anything.
        
        SystemSoundID soundID;
        NSString *path = [[NSBundle mainBundle] pathForResource:[sound stringByDeletingPathExtension]
                                                         ofType:[sound pathExtension]];
        if (path) {
            //UALOG(@"Received a foreground alert with a sound: %@", sound);
            AudioServicesCreateSystemSoundID((__bridge CFURLRef)[NSURL fileURLWithPath:path], &soundID);
            AudioServicesPlayAlertSound(soundID);
        } else {
            //UALOG(@"Received an alert with a sound that cannot be found the application bundle: %@", sound);
        }
        
    } else {
        
        // Vibrates on supported devices, on others, does nothing
        AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
        
    }
}

- (void)handleBadgeUpdate:(NSInteger)badgeNumber
{
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:badgeNumber];
}

@end


#pragma mark - Conveniences

POSAppDelegate *AppDelegate(void)
{
    return (POSAppDelegate *)UIApplication.sharedApplication.delegate;
}

