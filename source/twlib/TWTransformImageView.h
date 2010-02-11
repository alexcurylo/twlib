//
//  TWTransformImageView.h
//
//  Copyright 2009 Trollwerks Inc. All rights reserved.
//

@interface TWTransformImageView : UIView
{
   CGImageRef maskedPose;

   CGAffineTransform originalTransform;
   CFMutableDictionaryRef touchBeginPoints;
}

- (id)initWithFrame:(CGRect)frame;
- (void)awakeFromNib;
- (void)setup;
- (void)dealloc;

- (void)setImage:(UIImage *)image;

- (void)drawRect:(CGRect)rect;

- (void)resetTransform;

- (CGAffineTransform)incrementalTransformWithTouches:(NSSet *)touches;
- (void)updateOriginalTransformForTouches:(NSSet *)touches;
- (void)cacheBeginPointForTouches:(NSSet *)touches;
- (void)removeTouchesFromCache:(NSSet *)touches;

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event;
- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event;
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event;
- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event;

@end
