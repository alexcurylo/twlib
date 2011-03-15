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

// http://kwigbo.tumblr.com/post/3448069097/simplify-uiview-animation-with-categories

// Animate removing a view from its parent
- (void) removeWithTransition:(UIViewAnimationTransition) transition andDuration:(float) duration;
// Animate adding a subview
- (void) addSubview:(UIView *)view withTransition:(UIViewAnimationTransition) transition withDuration:(float) duration;
// Animate the changing of a views frame
- (void) setFrame:(CGRect) fr withDuration:(float) duration;
// Animate changing the alpha of a view
- (void) setAlpha:(float) a withDuration:(float) duration;

@end

