//
//  TWBlankViewController.h
//
//  Copyright Trollwerks Inc 2009. All rights reserved.
//

@interface TWBlankViewController : UIViewController
{
}

#pragma mark -
#pragma mark Life cycle

- (void)viewDidLoad;
- (void)viewWillAppear:(BOOL)animated;
- (void)didReceiveMemoryWarning;
#if TWTARGET_SDKVERSION_3
- (void)viewDidUnload;
- (void)setView:(UIView*)toView;
#endif TWTARGET_SDKVERSION_3
- (void)clearOutlets;
- (void)dealloc;

@end
