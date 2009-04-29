//
//  TWRoundedView.h
//
//  Copyright 2009 Trollwerks Inc. All rights reserved.
//

@interface TWRoundedView : UIView
{
   UIColor *foregroundColor;
}

@property (nonatomic, retain) UIColor *foregroundColor;

#pragma mark -
#pragma mark Life cycle

- (id)initWithFrame:(CGRect)frame andColor:(UIColor *)color;
- (void)drawRect:(CGRect)rect;
- (void)dealloc;

@end
