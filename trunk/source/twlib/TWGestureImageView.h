//
//  TWGestureImageView.h
//
//  Copyright Trollwerks Inc 2009. All rights reserved.
//

@protocol TWGestureDelegate <NSObject>

@required

- (void)singleTapEnded;
- (void)swipedLeftUp;
- (void)swipedRightDown;

@optional

@end

@interface TWGestureImageView : UIImageView
{
   IBOutlet id<TWGestureDelegate> delegate;

   // to keep track of gestures
   int _activeTouchCount;
   CGPoint touchStart;
}

@property (nonatomic, assign) id<TWGestureDelegate> delegate;

- (id)initWithFrame:(CGRect)frame;
- (void)dealloc;

- (void)convertTouch:(UITouch *)touch toLocation:(CGPoint *)where;

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event;
- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event;
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event;
- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event;

@end
