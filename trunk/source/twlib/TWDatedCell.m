//
//  TWDatedCell.m
//
//  Copyright Trollwerks Inc 2010. All rights reserved.
//

#import "TWDatedCell.h"
#import "NSDate+Helper.h"

enum
{
   kTWDatedCellHeight = 44,
   kTWDatedCellWidth = 320,

   kTitleLineHeight = 26, // 44 - 18, so includes any extra spacing pixels
   kTitleFontSize = 17, // like Messages.app, smaller than default which appears to be 17

   kDetailLineHeight = 18, // seems consistent for 1, 2, 6, 7, 10 lines
   kDetailLineWidth = 300, // by observation, for 6 line label 280 wrapped 7; for 10 line label 310 wrapped 9
   kDetailFontSize = 14, // by observation, 15 is too big

   kDateRightInset = 10,
   kDateWidth = 100,
   kDateHeight = 24,
   kDateFontSize = 15, // seems between detail and title in Messages.app
};

@implementation TWDatedCell

@synthesize dateLabel;

#pragma mark -
#pragma mark Life cycle

+ (NSString *)reuseIdentifier
{
   return @"TWDatedCell";
}

+ (TWDatedCell *)cellForView:(UITableView*)tableView
{
   id cell = [tableView dequeueReusableCellWithIdentifier:[[self class] reuseIdentifier]];
   if (!cell)
      cell = [[[[self class] alloc]
         initWithStyle:UITableViewCellStyleSubtitle
         reuseIdentifier:[[self class] reuseIdentifier]
      ] autorelease];
  
   return cell;
}

// http://groups.google.com/group/iphone-appdev-auditors/browse_thread/thread/06427f581ac8f827

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
   if ( (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) )
   {
      // smaller than default size to match Messages.app
      self.textLabel.font = [UIFont boldSystemFontOfSize:kTitleFontSize];
		self.textLabel.adjustsFontSizeToFitWidth = YES;

      // for multiline label cells
      self.detailTextLabel.font = [UIFont systemFontOfSize:kDetailFontSize];
      self.detailTextLabel.numberOfLines = 0;
      self.detailTextLabel.lineBreakMode = UILineBreakModeWordWrap;
      self.detailTextLabel.adjustsFontSizeToFitWidth = NO;
      
      // drawing date like Messages.app
      
      CGRect cellFrame = CGRectMake(0, 0, kTWDatedCellWidth, kTWDatedCellHeight);
 
      CGRect dateFrame = { .size = { .width = kDateWidth, .height = kDateHeight } };
      dateFrame.origin.x = CGRectGetMaxX(cellFrame) - kDateRightInset - dateFrame.size.width;
		self.dateLabel = [[[UILabel alloc] initWithFrame:dateFrame] autorelease];
		self.dateLabel.backgroundColor = [UIColor clearColor];
		[self.dateLabel setFont:[UIFont systemFontOfSize:kDateFontSize]];
      // from 'Developer Picker', recent calls date in Phone.app
      UIColor *aColor = [UIColor colorWithRed:0.101 green:0.336 blue:0.823 alpha:1.000];
      self.dateLabel.textColor = aColor;
      self.dateLabel.adjustsFontSizeToFitWidth = YES;
      self.dateLabel.textAlignment = UITextAlignmentRight;
		[self.contentView addSubview:self.dateLabel];
      
      /*
      CGRect cellFrame = CGRectMake(0, 0, kTWDatedCellWidth, kTWDatedCellHeight);
     
      CGRect rankFrame = cellFrame;
      rankFrame.size.width = kTWDatedCellRankWidth;
		self.rankLabel = [[[UILabel alloc] initWithFrame:rankFrame] autorelease];
		[self.rankLabel setFont:[UIFont fontWithName:@"Helvetica-Bold" size:17]];
		self.rankLabel.backgroundColor = [UIColor clearColor];
      self.rankLabel.textAlignment = UITextAlignmentCenter;
		[self.contentView addSubview:self.rankLabel];
      
      CGRect nameFrame = cellFrame;
      nameFrame.origin.x = CGRectGetMaxX(rankFrame);
      nameFrame.size.width = kTWDatedCellNameWidth;
		self.nameLabel = [[[UILabel alloc] initWithFrame:nameFrame] autorelease];
		[self.nameLabel setFont:[UIFont fontWithName:@"Helvetica-Bold" size:17]];
		self.nameLabel.backgroundColor = [UIColor clearColor];
      self.nameLabel.textAlignment = UITextAlignmentLeft;
      self.nameLabel.adjustsFontSizeToFitWidth = YES;
      self.nameLabel.minimumFontSize = 12;
		[self.contentView addSubview:self.nameLabel];
      
      CGRect difficultyFrame = cellFrame;
      difficultyFrame.origin.x = CGRectGetMaxX(nameFrame);
      difficultyFrame.size.width = kTWDatedCellDifficultyWidth;
		self.difficultyLabel = [[[UILabel alloc] initWithFrame:difficultyFrame] autorelease];
		[self.difficultyLabel setFont:[UIFont fontWithName:@"Helvetica-Oblique" size:15]];
		self.difficultyLabel.backgroundColor = [UIColor clearColor];
      self.difficultyLabel.textAlignment = UITextAlignmentCenter;
		[self.contentView addSubview:self.difficultyLabel];
      
      CGRect scoreFrame = cellFrame;
      scoreFrame.origin.x = CGRectGetMaxX(difficultyFrame);
      scoreFrame.size.width = kTWDatedCellScoreWidth;
		self.scoreLabel = [[[UILabel alloc] initWithFrame:scoreFrame] autorelease];
		[self.scoreLabel setFont:[UIFont fontWithName:@"Helvetica-Bold" size:17]];
		self.scoreLabel.backgroundColor = [UIColor clearColor];
      self.scoreLabel.textAlignment = UITextAlignmentCenter;
		[self.contentView addSubview:self.scoreLabel];
       */
   }
   
   return self;
}

- (void)dealloc
{
   /*
   self.rankLabel = nil;
   self.nameLabel = nil;
   self.difficultyLabel = nil;
   self.scoreLabel = nil;
   */
	twrelease(dateLabel);
   
   [super dealloc];
}

#pragma mark -
#pragma mark Measuring

+ (NSInteger)cellHeightForLabelString:(NSString *)string
{
   NSInteger lines = [[self class] linesForLabelString:string];
   
   return (lines * kDetailLineHeight) + kTitleLineHeight;
}

+ (NSInteger)linesForLabelString:(NSString *)string
{
   UIFont *labelFont = [UIFont systemFontOfSize:kDetailFontSize];
   CGSize constraint = { .width = kDetailLineWidth, .height = MAXFLOAT };
   CGSize size = [string sizeWithFont:labelFont
                    constrainedToSize:constraint
                        lineBreakMode:UILineBreakModeWordWrap
                  ];
   NSInteger lines = size.height / 18;
   
   return MAX(1, lines);
}

- (void)sizeLabelWith:(NSString *)string
{
   self.detailTextLabel.text = string;
   
   // this will stop it rewrapping on swipe to delete
   self.detailTextLabel.numberOfLines = [[self class] linesForLabelString:string];
   // however, it doesn't actually change the size, just cuts it off
   self.detailTextLabel.adjustsFontSizeToFitWidth = YES;
}

// http://blog.mugunthkumar.com/coding/formatting-dates-relative-to-now-objective-c-iphone/
- (void)setDate:(NSDate *)date
{
   /*
   NSDateFormatter *mdf = [[[NSDateFormatter alloc] init] autorelease];
   [mdf setDateFormat:@"yyyy-MM-dd"];
   NSDate *midnight = [mdf dateFromString:[mdf stringFromDate:date]];
   
   NSInteger dayDiff = [midnight timeIntervalSinceNow] / (60*60*24);
   NSDateFormatter *dateFormatter = [[[NSDateFormatter alloc] init] autorelease];
   
   if (dayDiff == 0)
    	[dateFormatter setDateFormat:@"h:mm a"];
   else if (dayDiff == -1)
    	[dateFormatter setDateFormat:@"'Yesterday'"];
   else if( dayDiff == 1)
    	[dateFormatter setDateFormat:@"'Tomorrow'"];
   else
      [dateFormatter setDateFormat:@"yy-MM-dd"];
   
   NSString *dateString = [dateFormatter stringFromDate:date];
    */
   NSString *dateString = [NSDate stringForDisplayFromDate:date prefixed:NO];
   
   self.dateLabel.text = dateString;
}

@end
