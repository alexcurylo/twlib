//
//  TWGestureView.m
//
//  Copyright Trollwerks Inc 2009. All rights reserved.
//

#import "TWGestureView.h"

const int kMinimumSwipe = 25;

@implementation TWGestureView

@synthesize delegate;

- (void)convertTouch:(UITouch *)touch toLocation:(CGPoint *)where
{
	CGPoint viewLocation = [touch locationInView:self]; // NB transform does appear applied here
   *where = CGPointMake(
      viewLocation.x,
      viewLocation.y
   );
}

// http://iphonedevelopertips.com/cocoa/single-double-and-triple-taps.html

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
   (void)event;

   _activeTouchCount = 0;
   int touchCount = [[event allTouches] count];
   switch (touchCount)
   {
      case 1:
         _activeTouchCount = touchCount;
         [self convertTouch:[touches anyObject] toLocation:&touchStart];
         break;
      default:
         break;
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
   
   BOOL acceptsSwipes = [delegate respondsToSelector:@selector(swipedLeftUp:)]
   || [delegate respondsToSelector:@selector(swipedRightDown:)];

   int touchCount = [[event allTouches] count];
   if (touchCount != 1)
      return;
   int tapCount = [[touches anyObject] tapCount];
   
   switch (tapCount)
   {
      case 1:
         if (acceptsSwipes)
         {
            CGPoint touchEnd = CGPointZero;
            [self convertTouch:[touches anyObject] toLocation:&touchEnd];
            int hDifference = touchEnd.x - touchStart.x;
            int vDifference = touchEnd.y - touchStart.y;
            if ( (kMinimumSwipe < abs(hDifference)) && (abs(hDifference) > abs(vDifference)) )
            {
               if (0 > hDifference)
               {
                  if ([delegate respondsToSelector:@selector(swipedLeftUp:)])
                     [delegate swipedLeftUp:self];
               }
               else
               {
                  if ([delegate respondsToSelector:@selector(swipedRightDown:)])
                     [delegate swipedRightDown:self];
               }
            }
            else if (kMinimumSwipe < abs(vDifference))
            {
               if (0 > vDifference)
               {
                  if ([delegate respondsToSelector:@selector(swipedLeftUp:)])
                     [delegate swipedLeftUp:self];
               }
               else
               {
                  if ([delegate respondsToSelector:@selector(swipedRightDown:)])
                     [delegate swipedRightDown:self];
               }
            }
            else
            {
               if ([delegate respondsToSelector:@selector(singleTapEnded:)])
                  [delegate singleTapEnded:self];
            }
         }
         else if ([delegate respondsToSelector:@selector(singleTapEnded:)])
            [delegate singleTapEnded:self];
        break;
      case 2:
         if ([delegate respondsToSelector:@selector(doubleTapEnded:)])
            [delegate doubleTapEnded:self];
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

@implementation TWGestureImageView

@synthesize delegate;

// implement this so we can be recreated with -copy inside scroll views after programmatic zoom
- (id)copyWithZone:(NSZone *)zone
{
   TWGestureImageView *copy = [[[self class] allocWithZone:zone] init];
   // UIImageView
   copy.image = self.image;
   copy.userInteractionEnabled = self.userInteractionEnabled;
   // UIView
   copy.frame = self.frame;
   copy.bounds = self.bounds;
   copy.center = self.center;
   copy.transform = self.transform;
   copy.multipleTouchEnabled = self.multipleTouchEnabled;
   copy.exclusiveTouch = self.exclusiveTouch;
   copy.clipsToBounds = self.clipsToBounds;
   copy.backgroundColor = self.backgroundColor;
   copy.alpha = self.alpha;
   copy.opaque = self.opaque;
   copy.clearsContextBeforeDrawing = self.clearsContextBeforeDrawing;
   copy.hidden = self.hidden;
   copy.contentMode = self.contentMode;
   
   copy.delegate = self.delegate;
   // never mind touch tracking
   
   return copy;
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
   
   if (1 < [[touches anyObject] tapCount])
   {
      [delegate doubleTapEnded:self];
      return;
   }
   
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
               [delegate swipedLeftUp:self];
            else
               [delegate swipedRightDown:self];
         }
         else if (kMinimumSwipe < abs(vDifference))
         {
            if (0 > vDifference)
               [delegate swipedLeftUp:self];
            else
               [delegate swipedRightDown:self];
         }
         else
            [delegate singleTapEnded:self];
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

