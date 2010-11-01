//
//  TWTransformImageView.m
//
//  Copyright 2009 Trollwerks Inc. All rights reserved.
//

#import "TWTransformImageView.h"
#import "TWXUIImage.h"

// Courtesy of Apple Sample Code
@interface UITouch (TouchSorting)
- (NSComparisonResult)compareAddress:(id)obj;
@end

@implementation UITouch (TouchSorting)
- (NSComparisonResult)compareAddress:(id)obj {
    if ((void *)self < (void *)obj) return NSOrderedAscending;
    else if ((void *)self == (void *)obj) return NSOrderedSame;
    else return NSOrderedDescending;
}
@end


@implementation TWTransformImageView


// called when created programmatically
- (id)initWithFrame:(CGRect)frame
{
   if ( (self = [super initWithFrame:frame]) )
   {
      [self setup];
   }
   return self;
}

// called when loaded from nib
- (void)awakeFromNib
{
   [self setup];

   [super awakeFromNib];
}

- (void)setup
{
   self.userInteractionEnabled = YES;
   self.multipleTouchEnabled = YES;
   self.contentMode = UIViewContentModeCenter;
   self.opaque = NO;
   self.backgroundColor = [UIColor clearColor];

   maskedPose = NULL;
   originalTransform = CGAffineTransformIdentity;
   touchBeginPoints = CFDictionaryCreateMutable(NULL, 0, NULL, NULL);
}

- (void)dealloc
{
   if (maskedPose)
      CGImageRelease(maskedPose);

   if (touchBeginPoints)
      CFRelease(touchBeginPoints);

   [super dealloc];
}

- (void)setImage:(UIImage *)image
{
   [self resetTransform];
   CGImageRelease(maskedPose);

   /* this sequence makes rotated image disappear?????
   UIImage *uprightImage = nil;

   if (image.size.width > image.size.height)
      uprightImage = [image rotateRight];
   else
      uprightImage = image;

   //maskedPose = CGImageCreateCopy(uprightImage.CGImage);

   // looks like image passed in gets released somewhere???
   CGImageRef tempImageRef = CGImageCreateCopy(uprightImage.CGImage);

   float maskWhiteComponents[6] = {0xF0, 0xFF, 0xF0, 0xFF, 0xF0, 0xFF};
   maskedPose = CGImageCreateWithMaskingColors(tempImageRef, maskWhiteComponents);

   CGImageRelease(tempImageRef);
   */

   // however, rotating after masking appears to work ... odd.
   float maskWhiteComponents[6] = {0xF0, 0xFF, 0xF0, 0xFF, 0xF0, 0xFF};
   maskedPose = CGImageCreateWithMaskingColors(image.CGImage, maskWhiteComponents);

   if (image.size.width > image.size.height)
   {
      UIImage *uprightImage = [[UIImage imageWithCGImage:maskedPose] rotateRight];
      CGImageRelease(maskedPose);
      maskedPose = CGImageCreateCopy(uprightImage.CGImage);
   }

   [self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect
{
   CGContextRef context = UIGraphicsGetCurrentContext();
   CGContextClearRect(context, rect);
   
   const float kClearColor[] = { 1.0f, 1.0f, 1.0f, 0.0f};
   CGContextSetFillColor(context, kClearColor);

   // flip the image
   CGContextSaveGState(context);
   CGContextTranslateCTM(context, 0, 480);
   CGContextScaleCTM(context, 1.0f, -1.0f);
	//CGContextSetBlendMode(context, kCGBlendModeMultiply);
	CGContextDrawImage(context, rect, maskedPose);
   CGContextRestoreGState(context);
}

- (void)resetTransform
{
   self.transform = CGAffineTransformIdentity;
   originalTransform = self.transform;
   CFDictionaryRemoveAllValues(touchBeginPoints);
}

- (CGAffineTransform)incrementalTransformWithTouches:(NSSet *)touches
{
    NSArray *sortedTouches = [[touches allObjects] sortedArrayUsingSelector:@selector(compareAddress:)];
    NSInteger numTouches = [sortedTouches count];

    // If there are no touches, simply return identify transform.
    if (numTouches == 0) return CGAffineTransformIdentity;

    // Single touch
    if (numTouches == 1) {
        UITouch *touch = [sortedTouches objectAtIndex:0];
        CGPoint beginPoint = *(CGPoint*)CFDictionaryGetValue(touchBeginPoints, touch);
        CGPoint currentPoint = [touch locationInView:self.superview];
        return CGAffineTransformMakeTranslation(currentPoint.x - beginPoint.x, currentPoint.y - beginPoint.y);
    }

    // If two or more touches, go with the first two (sorted by address)
    UITouch *touch1 = [sortedTouches objectAtIndex:0];
    UITouch *touch2 = [sortedTouches objectAtIndex:1];

    CGPoint beginPoint1 = *(CGPoint*)CFDictionaryGetValue(touchBeginPoints, touch1);
    CGPoint currentPoint1 = [touch1 locationInView:self.superview];
    CGPoint beginPoint2 = *(CGPoint*)CFDictionaryGetValue(touchBeginPoints, touch2);
    CGPoint currentPoint2 = [touch2 locationInView:self.superview];
 
    double layerX = self.center.x;
    double layerY = self.center.y;

    double x_1 = beginPoint1.x - layerX;
    double y_1 = beginPoint1.y - layerY;
    double x2 = beginPoint2.x - layerX;
    double y2 = beginPoint2.y - layerY;
    double x3 = currentPoint1.x - layerX;
    double y3 = currentPoint1.y - layerY;
    double x4 = currentPoint2.x - layerX;
    double y4 = currentPoint2.y - layerY;

    // Solve the system:
    //   [a b t1, -b a t2, 0 0 1] * [x1, y1, 1] = [x3, y3, 1]
    //   [a b t1, -b a t2, 0 0 1] * [x2, y2, 1] = [x4, y4, 1]

    double D = (y_1-y2)*(y_1-y2) + (x_1-x2)*(x_1-x2);
    if (D < 0.1) {
        return CGAffineTransformMakeTranslation((float)(x3-x_1), (float)(y3-y_1));
    }

    double a = (y_1-y2)*(y3-y4) + (x_1-x2)*(x3-x4);
    double b = (y_1-y2)*(x3-x4) - (x_1-x2)*(y3-y4);
    double tx = (y_1*x2 - x_1*y2)*(y4-y3) - (x_1*x2 + y_1*y2)*(x3+x4) + x3*(y2*y2 + x2*x2) + x4*(y_1*y_1 + x_1*x_1);
    double ty = (x_1*x2 + y_1*y2)*(-y4-y3) + (y_1*x2 - x_1*y2)*(x3-x4) + y3*(y2*y2 + x2*x2) + y4*(y_1*y_1 + x_1*x_1);

    return CGAffineTransformMake((float)(a/D), (float)(-b/D), (float)(b/D), (float)(a/D), (float)(tx/D), (float)(ty/D));
}

- (void)updateOriginalTransformForTouches:(NSSet *)touches {
    if ([touches count] > 0) {
        CGAffineTransform incrementalTransform = [self incrementalTransformWithTouches:touches];
        self.transform = CGAffineTransformConcat(originalTransform, incrementalTransform);
        originalTransform = self.transform;
    }
}

- (void)cacheBeginPointForTouches:(NSSet *)touches {
   for (UITouch *touch in touches) {
      CGPoint *point = (CGPoint*)CFDictionaryGetValue(touchBeginPoints, touch);
      if (point == NULL) {
         point = (CGPoint *)malloc(sizeof(CGPoint));
         CFDictionarySetValue(touchBeginPoints, touch, point);
      }
   *point = [touch locationInView:self.superview];
   }
}

- (void)removeTouchesFromCache:(NSSet *)touches {
    for (UITouch *touch in touches) {
        CGPoint *point = (CGPoint *)CFDictionaryGetValue(touchBeginPoints, touch);
        if (point != NULL) {
            free((void *)CFDictionaryGetValue(touchBeginPoints, touch));
            CFDictionaryRemoveValue(touchBeginPoints, touch);
        }
    }
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
   twlog("TWTransformImageView touchesBegan!");
   NSMutableSet *currentTouches = [[[event touchesForView:self] mutableCopy] autorelease];
   [currentTouches minusSet:touches];
   if ([currentTouches count] > 0)
   {
      [self updateOriginalTransformForTouches:currentTouches];
      [self cacheBeginPointForTouches:currentTouches];
   }
   [self cacheBeginPointForTouches:touches];
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
   (void)touches;

   CGAffineTransform incrementalTransform = [self incrementalTransformWithTouches:[event touchesForView:self]];
   self.transform = CGAffineTransformConcat(originalTransform, incrementalTransform);
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
   [self updateOriginalTransformForTouches:[event touchesForView:self]];
   [self removeTouchesFromCache:touches];

   for (UITouch *touch in touches)
        if (touch.tapCount >= 2)
            [self.superview bringSubviewToFront:self];

   NSMutableSet *remainingTouches = [[[event touchesForView:self] mutableCopy] autorelease];
   [remainingTouches minusSet:touches];
   [self cacheBeginPointForTouches:remainingTouches];
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
   (void)touches;
   (void)event;

   [self touchesEnded:touches withEvent:event];
}

@end
