//
//  TWGestureView.h
//
//  Copyright Trollwerks Inc 2009. All rights reserved.
//

@class TWGestureView;
@class TWGestureImageView;

@protocol TWGestureDelegate <NSObject>

@optional

- (void)singleTapEnded:(TWGestureView *)view;
- (void)doubleTapEnded:(TWGestureView *)view;

- (void)swipedLeftUp:(TWGestureView *)view;
- (void)swipedRightDown:(TWGestureView *)view;

@end

@interface TWGestureView : UIView
{
   IBOutlet id<TWGestureDelegate> delegate;

   // to keep track of gestures
   int _activeTouchCount;
   CGPoint touchStart;
}

@property (nonatomic, assign) IBOutlet id<TWGestureDelegate> delegate;

- (void)convertTouch:(UITouch *)touch toLocation:(CGPoint *)where;

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event;
- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event;
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event;
- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event;

@end

@protocol TWGestureImageDelegate <NSObject>

@optional

- (void)singleTapEnded:(TWGestureImageView *)view;
- (void)doubleTapEnded:(TWGestureImageView *)view;

- (void)swipedLeftUp:(TWGestureImageView *)view;
- (void)swipedRightDown:(TWGestureImageView *)view;

@end


@interface TWGestureImageView : UIImageView <NSCopying>
{
   IBOutlet id<TWGestureImageDelegate> delegate;
   
   // to keep track of gestures
   int _activeTouchCount;
   CGPoint touchStart;
}

@property (nonatomic, assign) IBOutlet id<TWGestureImageDelegate> delegate;

- (void)convertTouch:(UITouch *)touch toLocation:(CGPoint *)where;

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event;
- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event;
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event;
- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event;

@end
