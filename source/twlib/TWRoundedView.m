//
//  TWRoundedView.m
//
//  Copyright 2009 Trollwerks Inc. All rights reserved.
//

// borrowed from
// http://iphonedevelopment.blogspot.com/2008/11/creating-transparent-uiviews-rounded.html

#import "TWRoundedView.h"

@implementation TWRoundedView

@synthesize foregroundColor;
@synthesize strokeColor;

- (id)initWithFrame:(CGRect)frame andColor:(UIColor *)color
{
   if ( (self = [super initWithFrame:frame]) )
   {
      self.backgroundColor = [UIColor clearColor];
      self.foregroundColor = color;
      self.strokeColor = color;

      self.contentMode = UIViewContentModeRedraw; // so corners fix themselves
      self.opaque = NO;
   }
   return self;
}

- (void)awakeFromNib
{
   [super awakeFromNib];
   
   self.foregroundColor = self.backgroundColor;
   self.strokeColor = self.backgroundColor;
   self.backgroundColor = [UIColor clearColor];
   
   self.contentMode = UIViewContentModeRedraw;
   self.opaque = NO;
}

- (void)drawRect:(CGRect)rect
{
   (void)rect;
   
   CGFloat strokeWidth = 2.f;
   CGFloat cornerRadius = 10.f;
   
   CGContextRef context = UIGraphicsGetCurrentContext();
   CGContextSetLineWidth(context, strokeWidth);
   CGContextSetStrokeColorWithColor(context, self.strokeColor.CGColor);
   CGContextSetFillColorWithColor(context, self.foregroundColor.CGColor);
   
   CGRect rrect = self.bounds;
   
   CGFloat radius = cornerRadius;
   CGFloat width = CGRectGetWidth(rrect);
   CGFloat height = CGRectGetHeight(rrect);
   
   // Make sure corner radius isn't larger than half the shorter side
   if (radius > width / 2.f)
      radius = width / 2.f;
   if (radius > height / 2.f)
      radius = height / 2.f;
   
   CGFloat minx = CGRectGetMinX(rrect);
   CGFloat midx = CGRectGetMidX(rrect);
   CGFloat maxx = CGRectGetMaxX(rrect);
   CGFloat miny = CGRectGetMinY(rrect);
   CGFloat midy = CGRectGetMidY(rrect);
   CGFloat maxy = CGRectGetMaxY(rrect);
   CGContextMoveToPoint(context, minx, midy);
   CGContextAddArcToPoint(context, minx, miny, midx, miny, radius);
   CGContextAddArcToPoint(context, maxx, miny, maxx, midy, radius);
   CGContextAddArcToPoint(context, maxx, maxy, midx, maxy, radius);
   CGContextAddArcToPoint(context, minx, maxy, minx, midy, radius);
   CGContextClosePath(context);
   CGContextDrawPath(context, kCGPathFillStroke);
}

- (void)dealloc
{
   self.foregroundColor = nil;
   self.strokeColor = nil;
  
   [super dealloc];
}

@end
