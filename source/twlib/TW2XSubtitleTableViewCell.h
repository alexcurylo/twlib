//
//  TW2XSubtitleTableViewCell.h
//
//  Copyright Trollwerks Inc 2010. All rights reserved.
//

/*
 use like
 
 UITableViewCell *cell = [[[UITableViewCell alloc] initWithFrame:CGRectZero reuseIdentifier:@"TEST"] autorelease];
 hasInitWithStyle = [cell respondsToSelector:@selector(initWithStyle:reuseIdentifier:)];
 
 if (hasInitWithStyle)
   cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:kShowCellIdentifier] autorelease];
 else
   cell = [[[TW2XSubtitleTableViewCell alloc] initWithFrame:CGRectZero reuseIdentifier:kShowCellIdentifier] autorelease];
 
 if (hasInitWithStyle)
 {
   cell.textLabel.text = title;
   cell.detailTextLabel.text = info;
 }
 else
 {
   ((TW2XSubtitleTableViewCell *)cell).textLabel.text = title;
   ((TW2XSubtitleTableViewCell *)cell).detailTextLabel.text = info;
 }

 */

@interface TW2XSubtitleTableViewCell : UITableViewCell
{
	UILabel *textLabel;
	UILabel *detailTextLabel;
}

@property (nonatomic, retain) UILabel *textLabel;
@property (nonatomic, retain) UILabel *detailTextLabel;

- (id)initWithFrame:(CGRect)frame reuseIdentifier:(NSString *)reuseIdentifier;
- (void)setSelected:(BOOL)selected animated:(BOOL)animated;
- (void)dealloc;

@end
