//
//  TWViewAppDelegate.h
//
//  Copyright Trollwerks Inc 2009. All rights reserved.
//

@class TWBlankViewController;

@interface TWViewAppDelegate : NSObject <UIApplicationDelegate> {
    IBOutlet UIWindow *window;
    IBOutlet TWBlankViewController *viewController;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet TWBlankViewController *viewController;

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

TWViewAppDelegate *TWAppDelegate(void);
