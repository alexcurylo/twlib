//
//  TWRootTableViewController.m
//
//  Copyright Trollwerks Inc 2009. All rights reserved.
//

#import "TWRootTableViewController.h"

@implementation TWRootTableViewController

#pragma mark -
#pragma mark Life cycle

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning
{
   [super didReceiveMemoryWarning];

   twlog("TWRootTableViewController didReceiveMemoryWarning -- no action");
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

#pragma mark -
#pragma mark Table support


#pragma mark Table view methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
	(void)tableView;
    return 1;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
	(void)tableView;
	(void)section;
	
   return @"Untitled Section";
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
   (void)tableView;
 	(void)section;
   
   return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *kRootTableViewCellIdentifier = @"RootTableViewCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kRootTableViewCellIdentifier];
    if (cell == nil) {
#if TWTARGET_SDKVERSION_3
#error check current best practices here
       cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kRootTableViewCellIdentifier] autorelease];
#else
       cell = [[[UITableViewCell alloc] initWithFrame:CGRectZero reuseIdentifier:kRootTableViewCellIdentifier] autorelease];
#endif TWTARGET_SDKVERSION_3
    }
    
	cell.text = [NSString stringWithFormat:@"cell %i", indexPath.row];

   return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
 	(void)tableView;

   // Navigation logic may go here -- for example, create and push another view controller.
	// AnotherViewController *anotherViewController = [[AnotherViewController alloc] initWithNibName:@"AnotherView" bundle:nil];
	// [self.navigationController pushViewController:anotherViewController animated:YES];
	// [anotherViewController release];
   
   // or treat it as an accessory tap perhaps
   // [self tableView:tableView accessoryButtonTappedForRowWithIndexPath:indexPath];
   
   twlog("selected row %i", indexPath.row);
}

- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath
{
 	(void)tableView;

   twlog("accessory button tapped for row %i", indexPath.row);
}

@end

