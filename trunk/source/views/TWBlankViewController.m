//
//  TWBlankViewController.m
//
//  Copyright Trollwerks Inc 2010. All rights reserved.
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

- (void)viewDidUnload
{
	[self clearOutlets];
}

- (void)setView:(UIView *)toView
{
	if (!toView)
		[self clearOutlets];
	
	[super setView:toView];
}

- (void) clearOutlets
{
}

- (void)dealloc
{
   [[NSNotificationCenter defaultCenter] removeObserver:self];
   [self clearOutlets];
   
   [super dealloc];
}

@end
