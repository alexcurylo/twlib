//
//  TWURLLabel.m
//
//  Copyright 2010 Trollwerks Inc. All rights reserved.
//

#import "TWURLLabel.h"

@implementation TWURLLabel

@synthesize underlined;

- (id)initWithFrame:(CGRect)frame
{
    if ( (self = [super initWithFrame:frame]) )
    {
       [self configureDefaults];
    }
    return self;
}

- (void)awakeFromNib
{ 
   [super awakeFromNib]; 
   
   [self configureDefaults];
} 

- (void)configureDefaults
{
   self.userInteractionEnabled = YES;
   self.multipleTouchEnabled = NO;
   
   self.underlined = YES;
}

- (void)dealloc
{
    [super dealloc];
}

// http://blog.odynia.org/archives/40-Underlined-UILabel.html

- (void)drawTextInRect:(CGRect)rect
{
   [super drawTextInRect:rect];
   
   if (self.underlined)
   {
      // Get the size of the label
      CGSize dynamicSize = [self.text sizeWithFont:self.font constrainedToSize:CGSizeMake(99999, 99999)
                                     lineBreakMode:self.lineBreakMode];
      
      // Get the current graphics context
      CGContextRef context = UIGraphicsGetCurrentContext();
      
      // Make it a while line 1.0 pixels wide
      CGContextSetStrokeColorWithColor(context, [self.textColor CGColor]);
      CGContextSetLineWidth(context, 1.5);
      
      // find the origin point
      CGPoint origin = CGPointMake(0, 0);
      
      // horizontal alignment depends on the alignment of the text
      if (self.textAlignment == UITextAlignmentCenter)
         origin.x = (self.frame.size.width / 2) - (dynamicSize.width / 2);
      else if (self.textAlignment == UITextAlignmentRight)
         origin.x = self.frame.size.width - dynamicSize.width;
      
      // vertical alignment is always middle/centre plus half the height of the text
      origin.y = (self.frame.size.height / 2) + (dynamicSize.height / 2);
      
      // Draw the line
      CGContextMoveToPoint(context, origin.x, origin.y);
      CGContextAddLineToPoint(context, origin.x + dynamicSize.width, origin.y);
      CGContextStrokePath(context);
   }
} 

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
   (void)touches;
   (void)event;

   if ([self.text hasPrefix:@"http"])
   {
      [[UIApplication sharedApplication] openURL:[NSURL URLWithString:self.text]];
   }
   else if (0 < [self.text rangeOfString:@"@"].length)
   {
      // designed use case is a plain email address
      
      NSString* mailURLString = self.text;
      if (![self.text hasPrefix:@"mailto:"])
         mailURLString = [@"mailto:" stringByAppendingString:mailURLString];
      [[UIApplication sharedApplication] openURL:[NSURL URLWithString:mailURLString]];
   }
   else // assume for now something else would be fully qualified
   {
      [[UIApplication sharedApplication] openURL:[NSURL URLWithString:self.text]];
   }
}

@end
