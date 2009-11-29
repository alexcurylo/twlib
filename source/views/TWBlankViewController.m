//
//  TWBlankViewController.m
//
//  Copyright Trollwerks Inc 2009. All rights reserved.
//

#import "TWBlankViewController.h"

@implementation TWBlankViewController

#pragma mark -
#pragma mark Life cycle

- (void)viewDidLoad
{
   [super viewDidLoad];
   twlog("TWBlankViewController viewDidLoad");
}

- (void)viewWillAppear:(BOOL)animated
{
   [super viewWillAppear:animated];
}

- (void)didReceiveMemoryWarning
{
   [super didReceiveMemoryWarning];
   
   twlog("TWBlankViewController didReceiveMemoryWarning -- no action");
}

#if TWTARGET_SDKVERSION_3
- (void)viewDidUnload
{
	[self clearOutlets];
}

- (void)setView:(UIView*)toView
{
	if (!toView)
		[self clearOutlets];
	
	[super setView:toView];
}
#endif TWTARGET_SDKVERSION_3

- (void) clearOutlets
{
}

- (void)dealloc
{
   [self clearOutlets];
   
   [super dealloc];
}

@end
