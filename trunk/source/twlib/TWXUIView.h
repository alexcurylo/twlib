//
//  TWXUIView.h
//
//  Copyright 2010 Trollwerks Inc. All rights reserved.
//

@interface UIView (TWXUIView)

- (UIView *)findFirstResponder;

- (void)setSubviewsTextColor:(UIColor *)color;

- (void)doPopInAnimation;

- (void)doBounce1Animation;
- (void)bounce1AnimationStopped;
- (void)bounce2AnimationStopped;
- (CGAffineTransform)transformForOrientation;

- (void)doPopInAnimationWithDelegate:(id)animationDelegate;

- (void)doFadeInAnimation;
- (void)doFadeInAnimationWithDelegate:(id)animationDelegate;

@end

