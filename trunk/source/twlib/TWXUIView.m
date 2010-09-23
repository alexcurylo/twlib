//
//  TWXUIView.m
//
//  Copyright 2010 Trollwerks Inc. All rights reserved.
//

#import "TWXUIView.h"
#import "QMCommandButton.h"
#import <QuartzCore/QuartzCore.h>

#define kAnimationDuration  0.2555
static CGFloat kBounceTransitionDuration = 0.3;

@implementation UIView (TWXUIView)

- (UIView *)findFirstResponder
{
   if (self.isFirstResponder)        
      return self;
   
   for (UIView *subView in self.subviews)
   {
      UIView *firstResponder = [subView findFirstResponder];
      
      if (firstResponder != nil)
         return firstResponder;
   }
   
   return nil;
}

- (void)setSubviewsTextColor:(UIColor *)color
{
   for (UIView *view in self.subviews)
   {
      [view setSubviewsTextColor:color];
      
      if ([view isKindOfClass:[UILabel class]])
         [(UILabel *)view setTextColor:color];
      else if ([view isKindOfClass:[UITextView class]])
         [(UITextView *)view setTextColor:color];
      else if ([view isKindOfClass:[QMCommandButton class]])
         [(QMCommandButton *)view setTitleColor:color forState:UIControlStateNormal];
   }
}

- (void)doPopInAnimation
{
   //[self doPopInAnimationWithDelegate:nil];
   [self doBounce1Animation];
}

- (void)doBounce1Animation
{
	self.transform = CGAffineTransformScale([self transformForOrientation], 0.001, 0.001);
	[UIView beginAnimations:nil context:nil];
	[UIView setAnimationDuration:kBounceTransitionDuration/1.5];
	[UIView setAnimationDelegate:self];
	[UIView setAnimationDidStopSelector:@selector(bounce1AnimationStopped)];
	self.transform = CGAffineTransformScale([self transformForOrientation], 1.1, 1.1);
	[UIView commitAnimations];
}

- (void)bounce1AnimationStopped
{
	[UIView beginAnimations:nil context:nil];
	[UIView setAnimationDuration:kBounceTransitionDuration/2];
	[UIView setAnimationDelegate:self];
	[UIView setAnimationDidStopSelector:@selector(bounce2AnimationStopped)];
	self.transform = CGAffineTransformScale([self transformForOrientation], 0.9, 0.9);
	[UIView commitAnimations];
}

- (void)bounce2AnimationStopped
{
	[UIView beginAnimations:nil context:nil];
	[UIView setAnimationDuration:kBounceTransitionDuration/2];
	self.transform = [self transformForOrientation];
	[UIView commitAnimations];
}

- (CGAffineTransform)transformForOrientation
{	
	UIInterfaceOrientation orientation = [UIApplication sharedApplication].statusBarOrientation;
	if (orientation == UIInterfaceOrientationLandscapeLeft) {
		return CGAffineTransformMakeRotation(M_PI*1.5);
	} else if (orientation == UIInterfaceOrientationLandscapeRight) {
		return CGAffineTransformMakeRotation(M_PI/2);
	} else if (orientation == UIInterfaceOrientationPortraitUpsideDown) {
		return CGAffineTransformMakeRotation(-M_PI);
	} else {
		return CGAffineTransformIdentity;
	}
}

- (void)doPopInAnimationWithDelegate:(id)animationDelegate
{
   CALayer *viewLayer = self.layer;
   CAKeyframeAnimation* popInAnimation = [CAKeyframeAnimation animationWithKeyPath:@"transform.scale"];
   
   popInAnimation.duration = kAnimationDuration;
   popInAnimation.values = [NSArray arrayWithObjects:
      [NSNumber numberWithFloat:0.6],
      [NSNumber numberWithFloat:1.1],
      [NSNumber numberWithFloat:.9],
      [NSNumber numberWithFloat:1],
      nil
   ];
   popInAnimation.keyTimes = [NSArray arrayWithObjects:
      [NSNumber numberWithFloat:0.0],
      [NSNumber numberWithFloat:0.6],
      [NSNumber numberWithFloat:0.8],
      [NSNumber numberWithFloat:1.0], 
      nil
   ];    
   popInAnimation.delegate = animationDelegate;
   
   [viewLayer addAnimation:popInAnimation forKey:@"transform.scale"];  
}

- (void)doFadeInAnimation
{
   [self doFadeInAnimationWithDelegate:nil];
}

- (void)doFadeInAnimationWithDelegate:(id)animationDelegate
{
   CALayer *viewLayer = self.layer;
   CABasicAnimation *fadeInAnimation = [CABasicAnimation animationWithKeyPath:@"opacity"];
   fadeInAnimation.fromValue = [NSNumber numberWithFloat:0.0];
   fadeInAnimation.toValue = [NSNumber numberWithFloat:self.alpha];
   fadeInAnimation.duration = kAnimationDuration;
   fadeInAnimation.delegate = animationDelegate;
   [viewLayer addAnimation:fadeInAnimation forKey:@"opacity"];
}

@end
