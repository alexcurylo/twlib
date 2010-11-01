//
//  TW2XSubtitleTableViewCell.h
//
//  Copyright Trollwerks Inc 2010. All rights reserved.
//

#import "TW2XSubtitleTableViewCell.h"

@implementation TW2XSubtitleTableViewCell

@synthesize textLabel;
@synthesize detailTextLabel;

- (id)initWithFrame:(CGRect)frame reuseIdentifier:(NSString *)reuseIdentifier
{
   if ( (self = [super initWithFrame:frame reuseIdentifier:reuseIdentifier]) )
   {
		self.textLabel = [[[UILabel alloc] initWithFrame:CGRectMake(10, 4, 240, 21)] autorelease];
		[self.textLabel setFont:[UIFont boldSystemFontOfSize:17]];
		self.textLabel.numberOfLines = 1;
		self.textLabel.backgroundColor = [UIColor clearColor];
		[self.contentView addSubview:self.textLabel];

		self.detailTextLabel = [[[UILabel alloc] initWithFrame:CGRectMake(10, 24, 240, 18)] autorelease];
		[self.detailTextLabel setFont:[UIFont systemFontOfSize:13]];
		self.detailTextLabel.textColor = [UIColor darkGrayColor]; 
		self.detailTextLabel.numberOfLines = 1;
		self.detailTextLabel.backgroundColor = [UIColor clearColor];
		[self.contentView addSubview:self.detailTextLabel];
   }

   return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
   [super setSelected:selected animated:animated];

   if (selected)
   {
		self.textLabel.textColor = [UIColor whiteColor]; 
		self.detailTextLabel.textColor = [UIColor whiteColor]; 
   }
   else
   {
		self.textLabel.textColor = [UIColor blackColor]; 
		self.detailTextLabel.textColor = [UIColor darkGrayColor]; 
   }
}

- (void)dealloc
{
	twrelease(textLabel);
	twrelease(detailTextLabel);

   [super dealloc];
}

@end
