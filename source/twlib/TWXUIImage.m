//
//  TWXUIImage.m
//
//  Copyright Trollwerks Inc 2010. All rights reserved.
//

#import "TWXUIImage.h"

@implementation UIImage (TWXUIImage)

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

@end



