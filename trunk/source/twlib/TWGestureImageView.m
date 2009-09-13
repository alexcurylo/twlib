//
//  TWGestureImageView.m
//
//  Copyright Trollwerks Inc 2009. All rights reserved.
//

#import "TWGestureImageView.h"

const int kMinimumSwipe = 25;

@implementation TWGestureImageView

@synthesize delegate;

- (id)initWithFrame:(CGRect)frame
{
   if ( (self = [super initWithFrame:frame]) )
   {
      self.userInteractionEnabled = YES;
      self.multipleTouchEnabled = YES;
      //self.exclusiveTouch = NO;
      self.contentMode = UIViewContentModeCenter;

      _activeTouchCount = 0;
    }
    return self;
}

- (void)dealloc
{
   [super dealloc];
}

- (void)convertTouch:(UITouch *)touch toLocation:(CGPoint *)where
{
	CGPoint viewLocation = [touch locationInView:self]; // NB transform does appear applied here
   *where = CGPointMake(
      viewLocation.x,
      viewLocation.y
   );
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
   (void)event;

   _activeTouchCount = 0;
   int touchCount = [[event allTouches] count];
   if (1 == touchCount)
   {
      _activeTouchCount = 1;
      [self convertTouch:[touches anyObject] toLocation:&touchStart];
   }
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
   (void)touches;
   (void)event;
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
   if (!_activeTouchCount)
      return;
  _activeTouchCount = 0;

  if (!delegate)
      return;
   
   int touchCount = [[event allTouches] count];
   switch (touchCount) {
      case 1:
         {
         CGPoint touchEnd = CGPointZero;
         [self convertTouch:[touches anyObject] toLocation:&touchEnd];
         int hDifference = touchEnd.x - touchStart.x;
         int vDifference = touchEnd.y - touchStart.y;
         if ( (kMinimumSwipe < abs(hDifference)) && (abs(hDifference) > abs(vDifference)) )
         {
            if (0 > hDifference)
               [delegate swipedLeftUp];
            else
               [delegate swipedRightDown];
         }
         else if (kMinimumSwipe < abs(vDifference))
         {
            if (0 > vDifference)
               [delegate swipedLeftUp];
            else
               [delegate swipedRightDown];
         }
         else
            [delegate singleTapEnded];
         }
         break;
      default:
         // do nothing, began cancelled
         break;
   }
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
   (void)touches;
   (void)event;

   _activeTouchCount = 0;
}

@end
