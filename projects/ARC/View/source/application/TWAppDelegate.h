//
//  TWAppDelegate.h
//
//  Copyright (c) 2011 Trollwerks Inc. All rights reserved.
//

@class TWViewController;

@interface TWAppDelegate : UIResponder <
   UIApplicationDelegate
>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) TWViewController *viewController;

#pragma mark - Actions

#pragma mark - Support

@end

#pragma mark - Conveniences

TWAppDelegate *twAppDelegate(void);
