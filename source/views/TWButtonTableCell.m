//
//  TWButtonTableCell.m
//
//  Copyright Trollwerks Inc 2009. All rights reserved.
//

#import "TWButtonTableCell.h"
#import "TWXUIColor.h"
#import "TWRoundedView.h"

@implementation TWButtonTableCell

@synthesize label;
@synthesize button;

#pragma mark -
#pragma mark Life cycle

- (id)initWithFrame:(CGRect)frame reuseIdentifier:(NSString *)reuseIdentifier
{
   if ( (self = [super initWithFrame:frame reuseIdentifier:reuseIdentifier]) )
   {
      UIColor *backgroundColor = [UIColor colorFromHexString:@"662C91"];
      //self.contentView.backgroundColor = backgroundColor;
      self.backgroundView = [[[TWRoundedView alloc] initWithFrame:self.frame andColor:backgroundColor] autorelease];
      
		self.label = [[[UILabel alloc] initWithFrame:CGRectMake(10, 2, 280 - 35, 33)] autorelease];
		[self.label setFont:[UIFont boldSystemFontOfSize:17]];
		self.label.numberOfLines = 2;
		self.label.textColor = [UIColor yellowColor]; 
		self.label.lineBreakMode = UILineBreakModeWordWrap; 
		self.label.textAlignment = UITextAlignmentCenter; 
		//self.label.backgroundColor = [UIColor redColor];
		self.label.backgroundColor = backgroundColor;
		[self.contentView addSubview:self.label];

      self.button = [[[UIButton alloc] initWithFrame:CGRectMake(280 - 25, 6, 25, 25)] autorelease];
		[self.button setBackgroundImage:[UIImage imageNamed:@"cell_disclosure.png"] forState:UIControlStateNormal];
		//self.button.backgroundColor = [UIColor greenColor];
		self.button.backgroundColor = backgroundColor;
		[self.contentView addSubview:self.button];
   }

   return self;
}

- (void)setTitle:(NSString *)title
{
   //self.contentView.backgroundColor = cellBackground; // don't need this
   //self.backgroundView = [[[UIView alloc] initWithFrame:self.frame] autorelease];
   //self.backgroundView.backgroundColor = cellBackground;

   self.label.text = title;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
   [super setSelected:selected animated:animated];

   if (selected)
   {
		self.label.textColor = [UIColor whiteColor]; 
   }
   else
   {
		self.label.textColor = [UIColor yellowColor]; 
   }
}

- (void)dealloc
{
	self.label = nil;
	self.button = nil;
   [super dealloc];
}

@end
