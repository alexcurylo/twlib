//
//  TWBlankViewController.m
//
//  Copyright Trollwerks Inc 2010. All rights reserved.
//

#import "TWBlankViewController.h"

@implementation TWBlankViewController

#pragma mark -
#pragma mark Life cycle

+ (TWBlankViewController *)controller
{
   TWBlankViewController *controller = [[[TWBlankViewController alloc] initWithNibName:@"TWBlankView" bundle:nil] autorelease];
   return controller;
}

- (void)viewDidLoad
{
   [super viewDidLoad];
   twlog("TWBlankViewController viewDidLoad");
   
   //self.title = NSLocalizedString(@"BLANK", nil);
}

- (void)viewWillAppear:(BOOL)animated
{
   [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
   [super viewDidAppear:animated];
   //[TWAppDelegate() showIntroAlert:@"INTROBLANK"];
}

- (void)didReceiveMemoryWarning
{
   [super didReceiveMemoryWarning];
   
   twlog("TWBlankViewController didReceiveMemoryWarning -- no action");
}

- (void)viewDidUnload
{
   twlog("TWBlankViewController viewDidUnload");
	[self clearOutlets];
}

- (void)setView:(UIView *)toView
{
	if (!toView)
		[self clearOutlets];
	
	[super setView:toView];
}

- (void)clearOutlets
{
}

- (void)dealloc
{
   [[NSNotificationCenter defaultCenter] removeObserver:self];
   [self clearOutlets];
   
   [super dealloc];
}

#pragma mark -
#pragma mark Actions


@end
