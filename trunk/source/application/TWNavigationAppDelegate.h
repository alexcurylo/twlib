//
//  TWNavigationAppDelegate.h
//
//  Copyright Trollwerks Inc 2009. All rights reserved.
//

@interface TWNavigationAppDelegate : NSObject <UIApplicationDelegate>
{
    UIWindow *window;
    UINavigationController *navigationController;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet UINavigationController *navigationController;

#pragma mark -
#pragma mark Life cycle

- (void)applicationDidFinishLaunching:(UIApplication *)application;
- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application;
- (void)applicationWillTerminate:(UIApplication *)application;
- (void)dealloc;

#pragma mark -
#pragma mark Application support


@end

#pragma mark -
#pragma mark Conveniences

TWNavigationAppDelegate *TWAppDelegate(void);
inline TWNavigationAppDelegate *TWAppDelegate(void) { return [[UIApplication sharedApplication] delegate]; }
