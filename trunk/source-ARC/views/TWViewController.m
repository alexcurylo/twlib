//
//  TWViewController.m
//
//  Copyright (c) 2011 Trollwerks Inc. All rights reserved.
//

#import "TWViewController.h"

@interface TWViewController()
{
}

#pragma mark - Life cycle

- (void)viewDidLoad;
- (void)viewDidUnload;
- (void)viewWillAppear:(BOOL)animated;
- (void)viewDidAppear:(BOOL)animated;
- (void)viewWillDisappear:(BOOL)animated;
- (void)viewDidDisappear:(BOOL)animated;
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation;
- (void)didReceiveMemoryWarning;
- (void)dealloc;

#pragma mark - Actions

#pragma mark - Support

@end

@implementation TWViewController

#pragma mark - Life cycle

+ (TWViewController *)controller
{
   NSMutableString *nib = [NSMutableString stringWithString:@"TWViewController"];
   [nib appendString:TWRUNNING_IPAD ? @"_iPad" : @"_iPhone"];
   TWViewController *controller = [[TWViewController alloc] initWithNibName:nib bundle:nil];
   return controller;
}

- (void)didReceiveMemoryWarning
{
   [super didReceiveMemoryWarning];
   twlog("TWViewController didReceiveMemoryWarning -- no action");
}

- (void)viewDidLoad
{
   [super viewDidLoad];
   twlog("TWViewController viewDidLoad");
}

- (void)viewDidUnload
{
    [super viewDidUnload];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
   //[TWAppDelegate() showIntroAlert:@"INTROBLANK"];
   twlog("TWViewController viewDidAppear");
}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
	[super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
   if (TWRUNNING_IPAD)
      return YES;
   else
      return UIInterfaceOrientationIsPortrait(interfaceOrientation);
}

- (void)dealloc
{
   [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - Actions

#pragma mark - Support

@end
