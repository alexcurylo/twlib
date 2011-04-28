//
//  TWXUIImage.h
//
//  Copyright Trollwerks Inc 2011. All rights reserved.
//

@interface UIImage (TWXUIImage) < NSCoding >

- (id)initWithCoder:(NSCoder *)decoder;
- (void)encodeWithCoder:(NSCoder *)encoder;

- (UIImage *)scaleAndRotateImage;

- (UIImage *)rotateRight;

// partial drawing
//- (void)drawInRect:(CGRect)drawRect fromRect:(CGRect)fromRect blendMode:(CGBlendMode)blendMode alpha:(CGFloat)alpha

// from AliSoftware UIImage+Resize
- (UIImage *)resizedImageToSize:(CGSize)dstSize;
- (UIImage *)resizedImageToFitInSize:(CGSize)boundingSize scaleIfSmaller:(BOOL)scale;

@end
