//
//  TWBlankViewController.h
//
//  Copyright Trollwerks Inc 2011. All rights reserved.
//

@interface TWBlankViewController : UIViewController
{
}

#pragma mark -
#pragma mark Life cycle

+ (TWBlankViewController *)controller;

- (void)viewDidLoad;
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation;
- (void)viewWillAppear:(BOOL)animated;
- (void)viewDidAppear:(BOOL)animated;
- (void)didReceiveMemoryWarning;
- (void)viewDidUnload;
- (void)setView:(UIView *)toView;
- (void)clearOutlets;
- (void)dealloc;

#pragma mark -
#pragma mark Actions


@end
