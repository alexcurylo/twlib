//
//  TWButtonTableCell.h
//
//  Copyright Trollwerks Inc 2009. All rights reserved.
//

@interface TWButtonTableCell : UITableViewCell
{
	UILabel *label;
	UIButton *button;
}

@property (nonatomic, retain) UILabel *label;
@property (nonatomic, retain) UIButton *button;

#pragma mark -
#pragma mark Life cycle

- (id)initWithFrame:(CGRect)frame reuseIdentifier:(NSString *)reuseIdentifier;
- (void)setTitle:(NSString *)title;
- (void)setSelected:(BOOL)selected animated:(BOOL)animated;
- (void)dealloc;

@end
