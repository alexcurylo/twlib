//
//  TWRootTableViewController.h
//
//  Copyright Trollwerks Inc 2009. All rights reserved.
//

@interface TWRootTableViewController : UITableViewController
{
}

#pragma mark -
#pragma mark Life cycle

- (void)viewDidLoad;
- (void)didReceiveMemoryWarning;
#if TWTARGET_SDKVERSION_3
- (void)viewDidUnload;
- (void)setView:(UIView*)toView;
#endif TWTARGET_SDKVERSION_3
- (void)clearOutlets;
- (void)dealloc;

#pragma mark -
#pragma mark Table support

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView;
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section;
- (NSInteger)tableView:(UITableView *)table numberOfRowsInSection:(NSInteger)section;
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath;
- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath;

@end
