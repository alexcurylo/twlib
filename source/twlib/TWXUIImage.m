//
//  TWXUIImage.m
//
//  Copyright Trollwerks Inc 2011. All rights reserved.
//

#import "TWXUIImage.h"

#define kUIImageEncodingKey		@"UIImage"

@implementation UIImage (TWXUIImage)

// http://iphonedevelopment.blogspot.com/2009/03/uiimage-and-nscoding.html

- (id)initWithCoder:(NSCoder *)decoder
{
	if ((self = [super init]))
	{
		NSData *data = [decoder decodeObjectForKey:kUIImageEncodingKey];
		self = [self initWithData:data];
	}
	
	return self;
}

- (void)encodeWithCoder:(NSCoder *)encoder
{
	NSData *data = UIImagePNGRepresentation(self);
	[encoder encodeObject:data forKey:kUIImageEncodingKey];
}

// http://blog.logichigh.com/2008/06/05/uiimage-fix/


- (UIImage *)scaleAndRotateImage
{
   int kMaxResolution = 480; // this means a 480x320 picture will rotate correctly  
   UIImageOrientation orient = self.imageOrientation;  
   // only calling if we want this rotated right
   //UIImageOrientation orient = UIImageOrientationRight;  

   CGImageRef imgRef = self.CGImage;  

   CGFloat width = CGImageGetWidth(imgRef);  
   CGFloat height = CGImageGetHeight(imgRef);  

   CGAffineTransform transform = CGAffineTransformIdentity;  
   CGRect bounds = CGRectMake(0, 0, width, height);  
   if (width > kMaxResolution || height > kMaxResolution) {  
     CGFloat ratio = width/height;  
     if (ratio > 1) {  
         bounds.size.width = kMaxResolution;  
         bounds.size.height = bounds.size.width / ratio;  
     }  
     else {  
         bounds.size.height = kMaxResolution;  
         bounds.size.width = bounds.size.height * ratio;  
     }  
   }  

   CGFloat scaleRatio = bounds.size.width / width;  
   CGSize imageSize = CGSizeMake(CGImageGetWidth(imgRef), CGImageGetHeight(imgRef));  
   CGFloat boundHeight;  
   switch(orient) {  

     case UIImageOrientationUp: //EXIF = 1  
         transform = CGAffineTransformIdentity;  
         break;  

     case UIImageOrientationUpMirrored: //EXIF = 2  
         transform = CGAffineTransformMakeTranslation(imageSize.width, 0.0f);  
         transform = CGAffineTransformScale(transform, -1.0f, 1.0f);  
         break;  

     case UIImageOrientationDown: //EXIF = 3  
         transform = CGAffineTransformMakeTranslation(imageSize.width, imageSize.height);  
         transform = CGAffineTransformRotate(transform, (float)M_PI);  
         break;  

     case UIImageOrientationDownMirrored: //EXIF = 4  
         transform = CGAffineTransformMakeTranslation(0.0f, imageSize.height);  
         transform = CGAffineTransformScale(transform, 1.0f, -1.0f);  
         break;  

     case UIImageOrientationLeftMirrored: //EXIF = 5  
         boundHeight = bounds.size.height;  
         bounds.size.height = bounds.size.width;  
         bounds.size.width = boundHeight;  
         transform = CGAffineTransformMakeTranslation(imageSize.height, imageSize.width);  
         transform = CGAffineTransformScale(transform, -1.0f, 1.0f);  
         transform = CGAffineTransformRotate(transform, 3.0f * (float)M_PI / 2.0f);  
         break;  

     case UIImageOrientationLeft: //EXIF = 6  
         boundHeight = bounds.size.height;  
         bounds.size.height = bounds.size.width;  
         bounds.size.width = boundHeight;  
         transform = CGAffineTransformMakeTranslation(0.0f, imageSize.width);  
         transform = CGAffineTransformRotate(transform, 3.0f * (float)M_PI / 2.0f);  
         break;  

     case UIImageOrientationRightMirrored: //EXIF = 7  
         boundHeight = bounds.size.height;  
         bounds.size.height = bounds.size.width;  
         bounds.size.width = boundHeight;  
         transform = CGAffineTransformMakeScale(-1.0f, 1.0f);  
         transform = CGAffineTransformRotate(transform, (float)M_PI / 2.0f);  
         break;  

     case UIImageOrientationRight: //EXIF = 8  
         boundHeight = bounds.size.height;  
         bounds.size.height = bounds.size.width;  
         bounds.size.width = boundHeight;  
         transform = CGAffineTransformMakeTranslation(imageSize.height, 0.0f);  
         transform = CGAffineTransformRotate(transform, (float)M_PI / 2.0f);  
         break;  

     default:  
         [NSException raise:NSInternalInconsistencyException format:@"Invalid image orientation"];  

   }  

   UIGraphicsBeginImageContext(bounds.size);  

   CGContextRef context = UIGraphicsGetCurrentContext();  

   if (orient == UIImageOrientationRight || orient == UIImageOrientationLeft) {  
     CGContextScaleCTM(context, -scaleRatio, scaleRatio);  
     CGContextTranslateCTM(context, -height, 0);  
   }  
   else {  
     CGContextScaleCTM(context, scaleRatio, -scaleRatio);  
     CGContextTranslateCTM(context, 0, -height);  
   }  

   CGContextConcatCTM(context, transform);  

   CGContextDrawImage(UIGraphicsGetCurrentContext(), CGRectMake(0, 0, width, height), imgRef);  
   UIImage *imageCopy = UIGraphicsGetImageFromCurrentImageContext();  
   UIGraphicsEndImageContext();  

   return imageCopy;  
}

- (UIImage *)rotateRight
{
   CGImageRef imgRef = self.CGImage;  

   CGFloat width = CGImageGetWidth(imgRef);  
   CGFloat height = CGImageGetHeight(imgRef);  

   CGAffineTransform transform = CGAffineTransformIdentity;  
   CGRect bounds = CGRectMake(0, 0, width, height);  

   CGFloat scaleRatio = bounds.size.width / width;  // always 1
   CGSize imageSize = CGSizeMake(CGImageGetWidth(imgRef), CGImageGetHeight(imgRef));  
   CGFloat boundHeight;  

   // rotate right
   boundHeight = bounds.size.height;  
   bounds.size.height = bounds.size.width;  
   bounds.size.width = boundHeight;  
   transform = CGAffineTransformMakeTranslation(imageSize.height, 0.0f);  
   transform = CGAffineTransformRotate(transform, (float)M_PI / 2.0f);  

   UIGraphicsBeginImageContext(bounds.size);  

   CGContextRef context = UIGraphicsGetCurrentContext();  

/*
   if (orient == UIImageOrientationRight || orient == UIImageOrientationLeft) {  
     CGContextScaleCTM(context, -scaleRatio, scaleRatio);  
     CGContextTranslateCTM(context, -height, 0);  
   }  
   else {  
     CGContextScaleCTM(context, scaleRatio, -scaleRatio);  
     CGContextTranslateCTM(context, 0, -height);  
   }  
*/
   // without this, it's upside down flipped
   CGContextScaleCTM(context, -scaleRatio, scaleRatio);  
   CGContextTranslateCTM(context, -height, 0);  

   CGContextConcatCTM(context, transform);  

   CGContextDrawImage(context, CGRectMake(0, 0, width, height), imgRef);  

   /* this doesn't seem to do anything???
   const float kRedColor[] = { 1.0, 0.0, 0.0, 1.0};
   CGContextSetFillColor(context, kRedColor);
   CGContextFillRect(context, CGRectMake(0, 0, width, height));
   */

   UIImage *imageCopy = UIGraphicsGetImageFromCurrentImageContext();

   UIGraphicsEndImageContext();  

   return imageCopy;  
}

/* http://iphonedevelopment.blogspot.com/2010/11/drawing-part-of-uiimage.html
 - (void)drawInRect:(CGRect)drawRect fromRect:(CGRect)fromRect blendMode:(CGBlendMode)blendMode alpha:(CGFloat)alpha
{
   CGImageRef drawImage = CGImageCreateWithImageInRect(self.CGImage, fromRect); 
   if (drawImage != NULL)
   {
      CGContextRef context = UIGraphicsGetCurrentContext();
      
      // Push current graphics state so we can restore later
      CGContextSaveGState(context);   
      
      // Set the alpha and blend based on passed in settings
      CGContextSetBlendMode(context, blendMode);
      CGContextSetAlpha(context, alpha);
      
      // Take care of Y-axis inversion problem by translating the context on the y axis
      CGContextTranslateCTM(context, 0, drawRect.origin.y + fromRect.size.height);  
      
      // Scaling -1.0 on y-axis to flip
      CGContextScaleCTM(context, 1.0, -1.0);
      
      // Then accommodate the translate by adjusting the draw rect
      drawRect.origin.y = 0.0f;
      
      // Draw the image
      CGContextDrawImage(context, drawRect, drawImage);
      
      // Clean up memory and restore previous state
      CGImageRelease(drawImage);
      
      // Restore previous graphics state to what it was before we tweaked it
      CGContextRestoreGState(context); 
   }
}
*/

// from AliSoftware UIImage+Resize

-(UIImage*)resizedImageToSize:(CGSize)dstSize
{
	CGImageRef imgRef = self.CGImage;
	// the below values are regardless of orientation : for UIImages from Camera, width>height (landscape)
	CGSize  srcSize = CGSizeMake(CGImageGetWidth(imgRef), CGImageGetHeight(imgRef)); // not equivalent to self.size (which is dependant on the imageOrientation)!
	
	CGFloat scaleRatio = dstSize.width / srcSize.width;
	UIImageOrientation orient = self.imageOrientation;
	CGAffineTransform transform = CGAffineTransformIdentity;
	switch(orient) {
			
		case UIImageOrientationUp: //EXIF = 1
			transform = CGAffineTransformIdentity;
			break;
			
		case UIImageOrientationUpMirrored: //EXIF = 2
			transform = CGAffineTransformMakeTranslation(srcSize.width, 0.0);
			transform = CGAffineTransformScale(transform, -1.0, 1.0);
			break;
			
		case UIImageOrientationDown: //EXIF = 3
			transform = CGAffineTransformMakeTranslation(srcSize.width, srcSize.height);
			transform = CGAffineTransformRotate(transform, M_PI);
			break;
			
		case UIImageOrientationDownMirrored: //EXIF = 4
			transform = CGAffineTransformMakeTranslation(0.0, srcSize.height);
			transform = CGAffineTransformScale(transform, 1.0, -1.0);
			break;
			
		case UIImageOrientationLeftMirrored: //EXIF = 5
			dstSize = CGSizeMake(dstSize.height, dstSize.width);
			transform = CGAffineTransformMakeTranslation(srcSize.height, srcSize.width);
			transform = CGAffineTransformScale(transform, -1.0, 1.0);
			transform = CGAffineTransformRotate(transform, 3.0 * M_PI_2);
			break;  
			
		case UIImageOrientationLeft: //EXIF = 6  
			dstSize = CGSizeMake(dstSize.height, dstSize.width);
			transform = CGAffineTransformMakeTranslation(0.0, srcSize.width);
			transform = CGAffineTransformRotate(transform, 3.0 * M_PI_2);
			break;  
			
		case UIImageOrientationRightMirrored: //EXIF = 7  
			dstSize = CGSizeMake(dstSize.height, dstSize.width);
			transform = CGAffineTransformMakeScale(-1.0, 1.0);
			transform = CGAffineTransformRotate(transform, M_PI_2);
			break;  
			
		case UIImageOrientationRight: //EXIF = 8  
			dstSize = CGSizeMake(dstSize.height, dstSize.width);
			transform = CGAffineTransformMakeTranslation(srcSize.height, 0.0);
			transform = CGAffineTransformRotate(transform, M_PI_2);
			break;  
			
		default:  
			[NSException raise:NSInternalInconsistencyException format:@"Invalid image orientation"];  
			
	}  
	
	/////////////////////////////////////////////////////////////////////////////
	// The actual resize: draw the image on a new context, applying a transform matrix
	UIGraphicsBeginImageContext(dstSize);
	
	CGContextRef context = UIGraphicsGetCurrentContext();
	
	if (orient == UIImageOrientationRight || orient == UIImageOrientationLeft) {
		CGContextScaleCTM(context, -scaleRatio, scaleRatio);
		CGContextTranslateCTM(context, -srcSize.height, 0);
	} else {  
		CGContextScaleCTM(context, scaleRatio, -scaleRatio);
		CGContextTranslateCTM(context, 0, -srcSize.height);
	}
	
	CGContextConcatCTM(context, transform);
	
	// we use srcSize (and not dstSize) as the size to specify is in user space (and we use the CTM to apply a scaleRatio)
	CGContextDrawImage(UIGraphicsGetCurrentContext(), CGRectMake(0, 0, srcSize.width, srcSize.height), imgRef);
	UIImage* resizedImage = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();
	
	return resizedImage;
}



/////////////////////////////////////////////////////////////////////////////



-(UIImage*)resizedImageToFitInSize:(CGSize)boundingSize scaleIfSmaller:(BOOL)scale
{
	// get the image size (independant of imageOrientation)
	CGImageRef imgRef = self.CGImage;
	CGSize srcSize = CGSizeMake(CGImageGetWidth(imgRef), CGImageGetHeight(imgRef)); // not equivalent to self.size (which depends on the imageOrientation)!
	
	// adjust boundingSize to make it independant on imageOrientation too for farther computations
	UIImageOrientation orient = self.imageOrientation;  
	switch (orient) {
		case UIImageOrientationLeft:          // 90 deg CCW
		case UIImageOrientationRight:         // 90 deg CW
		case UIImageOrientationLeftMirrored:  // vertical flip
		case UIImageOrientationRightMirrored:  // vertical flip
			boundingSize = CGSizeMake(boundingSize.height, boundingSize.width);
			break;

      default:
      case UIImageOrientationUp:            // default orientation
      case UIImageOrientationDown:          // 180 deg rotation
      case UIImageOrientationUpMirrored:    // as above but image mirrored along other axis. horizontal flip
      case UIImageOrientationDownMirrored:  // horizontal flip
			break;
   }
   
	// Compute the target CGRect in order to keep aspect-ratio
	CGSize dstSize;
	
	if ( !scale && (srcSize.width < boundingSize.width) && (srcSize.height < boundingSize.height) ) {
		//NSLog(@"Image is smaller, and we asked not to scale it in this case (scaleIfSmaller:NO)");
		dstSize = srcSize; // no resize (we could directly return 'self' here, but we draw the image anyway to take image orientation into account)
	} else {		
		CGFloat wRatio = boundingSize.width / srcSize.width;
		CGFloat hRatio = boundingSize.height / srcSize.height;
		
		if (wRatio < hRatio) {
			//NSLog(@"Width imposed, Height scaled ; ratio = %f",wRatio);
			dstSize = CGSizeMake(boundingSize.width, srcSize.height * wRatio);
		} else {
			//NSLog(@"Height imposed, Width scaled ; ratio = %f",hRatio);
			dstSize = CGSizeMake(srcSize.width * hRatio, boundingSize.height);
		}
	}
   
	return [self resizedImageToSize:dstSize];
}


@end




