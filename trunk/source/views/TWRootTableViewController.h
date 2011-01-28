//
//  TWRootTableViewController.h
//
//  Copyright Trollwerks Inc 2011. All rights reserved.
//

@interface TWRootTableViewController : UITableViewController
{
}

#pragma mark -
#pragma mark Life cycle

+ (TWRootTableViewController *)controller;

- (void)viewDidLoad;
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation;
- (void)viewWillAppear:(BOOL)animated;
- (void)viewDidAppear:(BOOL)animated;
- (void)didReceiveMemoryWarning;
- (void)viewDidUnload;
- (void)setView:(UIView*)toView;
- (void)clearOutlets;
- (void)dealloc;

#pragma mark -
#pragma mark Actions


#pragma mark -
#pragma mark Table support

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView;
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section;
- (NSInteger)tableView:(UITableView *)table numberOfRowsInSection:(NSInteger)section;
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath;
- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath;

@end
