//
//  TWDatedCell.h
//
//  Copyright Trollwerks Inc 2010. All rights reserved.
//

@interface TWDatedCell : UITableViewCell
{
   /*
	UILabel *rankLabel;
	UILabel *nameLabel;
	UILabel *difficultyLabel;
	UILabel *scoreLabel;
    */
	UILabel *dateLabel;
}

/*
@property (nonatomic, retain) IBOutlet UILabel *rankLabel;
@property (nonatomic, retain) IBOutlet UILabel *nameLabel;
@property (nonatomic, retain) IBOutlet UILabel *difficultyLabel;
@property (nonatomic, retain) IBOutlet UILabel *scoreLabel;
*/
@property (nonatomic, retain) IBOutlet UILabel *dateLabel;

#pragma mark -
#pragma mark Life cycle

+ (NSString *)reuseIdentifier;
+ (TWDatedCell *)cellForView:(UITableView*)tableView;

- (id)initWithStyle:(UITableViewCellStyle)style  reuseIdentifier:(NSString *)reuseIdentifier;
- (void)dealloc;

#pragma mark -
#pragma mark Measuring

+ (NSInteger)cellHeightForLabelString:(NSString *)string;
+ (NSInteger)linesForLabelString:(NSString *)string;

- (void)sizeLabelWith:(NSString *)string;

- (void)setDate:(NSDate *)date;

@end
