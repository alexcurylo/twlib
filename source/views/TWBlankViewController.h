//
//  TWBlankViewController.h
//
//  Copyright Trollwerks Inc 2010. All rights reserved.
//

@interface TWBlankViewController : UIViewController
{
}

#pragma mark -
#pragma mark Life cycle

- (void)viewDidLoad;
- (void)viewWillAppear:(BOOL)animated;
- (void)didReceiveMemoryWarning;
- (void)viewDidUnload;
- (void)setView:(UIView *)toView;
- (void)clearOutlets;
- (void)dealloc;

@end
