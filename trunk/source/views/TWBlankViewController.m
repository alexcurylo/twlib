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
   //self.title = NSLocalizedString(@"TITLEBLANK", nil);
   return controller;
}

- (void)viewDidLoad
{
   [super viewDidLoad];
   twlog("TWBlankViewController viewDidLoad");
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
   if (UIUserInterfaceIdiomPad == UI_USER_INTERFACE_IDIOM())
      return YES;
   else
      return UIDeviceOrientationPortrait == toInterfaceOrientation;
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
   [super viewDidUnload];
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
 	//twrelease(outlet);
  
   [super dealloc];
}

#pragma mark -
#pragma mark Actions


@end
