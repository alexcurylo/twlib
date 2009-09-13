//
//  TWCarbonUtilities.cpp
//
//  Copyright 2009 Trollwerks Inc. All rights reserved.
//

#include "TWCarbonUtilities.h"
/*
#include "TCFString.h"
#include "CQTAtomContainer.h"
*/

#pragma mark *** Useful constants from PP::UDrawingState

const RGBColor	kRGBColor_White	= { 65535, 65535, 65535 };
const RGBColor	kRGBColor_Black = { 0, 0, 0 };
const RGBColor kRGBColor_Yellow	= { 65535, 65535, 0 };
const RGBColor kRGBColor_Red	= { 65535, 0, 0 };
const RGBColor kRGBColor_TextDefault = kRGBColor_Yellow;
const RGBColor kRGBColor_ObjectDefault = kRGBColor_Red;

const unsigned char	kStr_Empty[]	= { 0 };
const unsigned char	kStr_Dummy[]	= { 0x01, 0x58 }; // One character string "X"

const Point kPoint_00		= { 0, 0 };
const Rect kRect_0000		= { 0, 0, 0, 0 };
const Rect kImageSourceRect = { 0, 0, 50, 50 }; // size of fake sprite rect

extern const FSSpec kFSSpec_Empty = { 0 };

/*
#pragma mark *** local helpers

struct FSDeleteContainerGlobals
{
	OSErr							result;			// result
	ItemCount						actualObjects;	// number of objects returned
	FSCatalogInfo					catalogInfo;	// FSCatalogInfo
};
typedef struct FSDeleteContainerGlobals FSDeleteContainerGlobals;

namespace {

void
FSDeleteContainerLevel(
	const FSRef& container,
	FSDeleteContainerGlobals *theGlobals)
{
	// level locals
	FSIterator					iterator;
	FSRef						itemToDelete;
	UInt16						nodeFlags;
	
	// Open FSIterator for flat access and give delete optimization hint
	theGlobals->result = FSOpenIterator(&container, kFSIterateFlat + kFSIterateDelete, &iterator);
	require_noerr(theGlobals->result, FSOpenIterator);
	
	// delete the contents of the directory
	do
	{
		// get 1 item to delete
		theGlobals->result = FSGetCatalogInfoBulk(iterator, 1, &theGlobals->actualObjects,
								NULL, kFSCatInfoNodeFlags, &theGlobals->catalogInfo,
								&itemToDelete, NULL, NULL);
		if ( (noErr == theGlobals->result) && (1 == theGlobals->actualObjects) )
		{
			// save node flags in local in case we have to recurse
			nodeFlags = theGlobals->catalogInfo.nodeFlags;
			
			// is it a file or directory?
			if ( 0 != (nodeFlags & kFSNodeIsDirectoryMask) )
			{
				// it's a directory -- delete its contents before attempting to delete it
				FSDeleteContainerLevel(itemToDelete, theGlobals);
			}
			// are we still OK to delete?
			if ( noErr == theGlobals->result )
			{
				// is item locked?
				if ( 0 != (nodeFlags & kFSNodeLockedMask) )
				{
					// then attempt to unlock it (ignore result since FSDeleteObject will set it correctly)
					theGlobals->catalogInfo.nodeFlags = nodeFlags & ~kFSNodeLockedMask;
					(void) FSSetCatalogInfo(&itemToDelete, kFSCatInfoNodeFlags, &theGlobals->catalogInfo);
				}
				// delete the item
				theGlobals->result = FSDeleteObject(&itemToDelete);
			}
		}
	} while ( noErr == theGlobals->result );
	
	// we found the end of the items normally, so return noErr
	if ( errFSNoMoreItems == theGlobals->result )
	{
		theGlobals->result = noErr;
	}
	
	// close the FSIterator (closing an open iterator should never fail)
	verify_noerr(FSCloseIterator(iterator));

FSOpenIterator:

	return;
}

} // anonymous namespace

*/

#pragma mark *** Pascal string utilities from PP::LString

void C2Pstrcpy(Str255 dst, const char *src)
{
   /*
    const	unsigned char * p = (unsigned char *) src - 1;
   unsigned char * q = (unsigned char *) dst - 1;
   unsigned char * copied = dst;
   *copied = 0;
   while ((*++q = *++p))
      *copied++;
   /*/
   
   NSString *asCFString = [NSString stringWithUTF8String:src];
   ::CFStringGetPascalString((CFStringRef)asCFString, dst, 255, kCFStringEncodingUTF8);
}

/*
 
void P2Cstrcpy(char* dst, ConstStr255Param src)
{
   sprintf(dst, "%.*s", src[0], &src[1]);
}
 
 Boolean EqualPStr(
 ConstStr255Param str1,
 ConstStr255Param str2
 )
 {
 bool caseSensitive = true;
 TCFString lhs(str1);
 TCFString rhs(str2);
 return lhs.EqualTo(rhs, caseSensitive);
 }
 

#pragma mark *** QuickDraw dependent utilities

void Rect2CGRect(
   const Rect& inRect,
   CGRect& outCGRect
)
{
   outCGRect = CGRectMake(
      inRect.left,
      inRect.top,
      inRect.right - inRect.left,
      inRect.bottom - inRect.top
   );
}

void CGRect2Rect(
   const CGRect& inCGRect,
   Rect& outRect
)
{
	outRect.top = lrintf(inCGRect.origin.y);
	outRect.left = lrintf(inCGRect.origin.x);
	outRect.right = lrintf(inCGRect.origin.x + inCGRect.size.width);
	outRect.bottom = lrintf(inCGRect.origin.y + inCGRect.size.height);
}

// Center a ratio-maintained shrunk Rect inside another Rect
void ScaleCenterRectInRect(const Rect& inDestRect, Rect& ioSourceRect)
{
	short sourceWidth = ioSourceRect.right - ioSourceRect.left;
	short sourceHeight = ioSourceRect.bottom - ioSourceRect.top;
	short destWidth = inDestRect.right - inDestRect.left;
	short destHeight = inDestRect.bottom - inDestRect.top;

	if ((destWidth < sourceWidth) || (destHeight < sourceHeight))
	{
		// need to map from a square
		Rect mapFromRect = ioSourceRect;
		if (sourceWidth > sourceHeight)
			mapFromRect.bottom = mapFromRect.top + sourceWidth;
		else if (sourceWidth < sourceHeight)
			mapFromRect.right = mapFromRect.left + sourceHeight;
		
		Rect mapToRect = inDestRect;
		// to a square 
		if (destWidth > destHeight)
			mapToRect.right = mapToRect.left + destHeight;
		else if (destWidth < destHeight)
			mapToRect.bottom = mapToRect.top + destWidth;
		
      {
#if 0
      CGRect cgFromRect, cgToRect, cgSourceRect;
      Rect2CGRect(mapFromRect, cgFromRect);
      Rect2CGRect(mapToRect, cgToRect);
      Rect2CGRect(ioSourceRect, cgSourceRect);
      
      CGAffineTransform translate = CGAffineTransformMakeTranslation(
         cgToRect.origin.x - cgFromRect.origin.x,
         cgToRect.origin.y - cgFromRect.origin.y
      );
      CGAffineTransform scale = CGAffineTransformMakeScale(
         cgToRect.size.width / cgFromRect.size.width,
         cgToRect.size.height / cgFromRect.size.height
      );
      CGAffineTransform transform = CGAffineTransformConcat(translate, scale);
      
      CGRect cgResult = CGRectApplyAffineTransform(cgSourceRect, transform);
      Rect result;
      CGRect2Rect(cgResult, result);
      
      #warning these are not always actually identical, it seems 
#endif 0
      // contents of this block should, in theory, replace the deprecated QuickDraw function
      // ::MapRect(&ioSourceRect, &mapFromRect, &mapToRect);
      // but we don't have a test handy, we just want to shut up the compile warning.
      ::MapRect(&ioSourceRect, &mapFromRect, &mapToRect);

      //check(result == mapToRect);
      }

 #if NOTES
 See 

  CGRectApplyAffineTransform()

in CGAffineTransform.h.
http://developer.apple.com/documentation/GraphicsImaging/Reference/CGAffineTransform/Reference/reference.html

Well, yes, it's not hard to construct a transform based on the relative size and placement of two CGRect's,
and then apply that transform to a third CGRect. I was just wondering if everyone had to write their own, 
if there was a standard function to use, or if there was another preferred method in the Quartz world to 
do a similar thing.

The MapRect procedure takes a rectangle within one rectangle and maps and scales it to another rectangle. 
In the r parameter, you specify a rectangle that lies within the rectangle that you specify in the 
srcRect parameter. By calling the MapPt procedure to map the upper-left and lower-right corners of the 
rectangle in the r parameter, MapRect maps and scales it to the rectangle that you specify in the dstRect 
parameter. The MapRect procedure returns the newly mapped rectangle in the r parameter.

MapRect maps the corner points of a rectangle, converting them by a size ratio and offset of the other 
rectangles. Use this to scale and reposition an object that is being to a larger or smaller rectangle.
#endif NOTES
 }
	
	CenterRectInRect(inDestRect, ioSourceRect);
}

void CenterRectInRect(const Rect& outerRect, Rect& innerRect)
{
	PositionRectInRect(outerRect, innerRect, FixRatio(1, 2), FixRatio(1, 2));
}

// Given two rectangles, this function positions the second within the first
// one so that it maintains the spacing specified by the horzRatio and
// vertRatio parameters.  In other words, to center an inner rectangle
// hoizontally, but have its center be 1/3 from the top of the outer rectangle,
// call this function with horzRatio = FixRatio(1, 2), vertRatio =
// FixRatio(1, 3).  We use Fixed rather than floating point to avoid
// complications when mixing MC68881/non-MC68881 versions of Utilities.

void PositionRectInRect(const Rect& outerRect, Rect& innerRect, Fixed horzRatio, Fixed vertRatio)
{
	short	outerRectHeight;
	short	outerRectWidth;
	short	innerRectHeight;
	short	innerRectWidth;
	short	yLocation;
	short	xLocation;

	outerRectHeight = outerRect.bottom - outerRect.top;
	outerRectWidth = outerRect.right - outerRect.left;

	innerRectHeight = innerRect.bottom - innerRect.top;
	innerRectWidth = innerRect.right - innerRect.left;
		yLocation = Fix2Long(FixMul(Long2Fix(outerRectHeight - innerRectHeight), vertRatio))
			+ outerRect.top;
		xLocation = Fix2Long(FixMul(Long2Fix(outerRectWidth - innerRectWidth), horzRatio))
			+ outerRect.left;

	innerRect.top = yLocation;
	innerRect.left = xLocation;
	innerRect.bottom = yLocation + innerRectHeight;
	innerRect.right = xLocation + innerRectWidth;
}

Rect CalcFixedBoundingRect(const FixedPoint inCorners[kCornerCount])
{
	Rect sFixedBounds;
	sFixedBounds.top = FixedToInt(inCorners[0].y);
	sFixedBounds.left = FixedToInt(inCorners[0].x);
	sFixedBounds.right = FixedToInt(inCorners[0].x);
	sFixedBounds.bottom = FixedToInt(inCorners[0].y);
	for (int i = 1; i < kCornerCount; i++)
   {
		sFixedBounds.left = std::min<short>(sFixedBounds.left, FixedToInt(inCorners[i].x));
		sFixedBounds.right = std::max<short>(sFixedBounds.right, FixedToInt(inCorners[i].x));
		sFixedBounds.top = std::min<short>(sFixedBounds.top, FixedToInt(inCorners[i].y));
		sFixedBounds.bottom = std::max<short>(sFixedBounds.bottom, FixedToInt(inCorners[i].y));
   }
	return sFixedBounds;
}

Rect CalcBoundingRect(const Point inCorners[kCornerCount])
{
	Rect sBounds;
	sBounds.top = inCorners[0].v;
	sBounds.left = inCorners[0].h;
	sBounds.right = inCorners[0].h;
	sBounds.bottom = inCorners[0].v;
	for (int i = 1; i < kCornerCount; i++)
   {
		sBounds.left = std::min<short>(sBounds.left, inCorners[i].h);
		sBounds.right = std::max<short>(sBounds.right, inCorners[i].h);
		sBounds.top = std::min<short>(sBounds.top, inCorners[i].v);
		sBounds.bottom = std::max<short>(sBounds.bottom, inCorners[i].v);
   }
	return sBounds;
}

void CalcComponentPoints(
   Rect inBounds,
   Point outCorners[kCornerCount]
)
{
	outCorners[0] = topLeft(inBounds);
	outCorners[1].h = inBounds.right;
	outCorners[1].v = inBounds.top;
	outCorners[2] = botRight(inBounds);
	outCorners[3].h = inBounds.left;
	outCorners[3].v = inBounds.bottom;
}

bool CornersAreEqual(
   const Point lhs[kCornerCount],
   const Point rhs[kCornerCount]
)
{
	for (int i = 0; i < kCornerCount; i++)
		if (lhs[i] != rhs[i])
			return false;
	return true;
}

bool MakeAndCheckPolygonMatrix(
   MatrixRecord& outMatrix,
   const Point inCorners[kCornerCount]
)
{
   bool identicalPoints = true;
	::SetIdentityMatrix(&outMatrix);
   
	FixedPoint fromQuad[kCornerCount] = { 0 };
	fromQuad[0].x = 0;
	fromQuad[0].y = 0;
	fromQuad[1].x = IntToFixed(kImageSourceRect.right);
	fromQuad[1].y = 0;
	fromQuad[2].x = IntToFixed(kImageSourceRect.right);
	fromQuad[2].y = IntToFixed(kImageSourceRect.bottom);
	fromQuad[3].x = 0;
	fromQuad[3].y = IntToFixed(kImageSourceRect.bottom);
	
	FixedPoint toQuad[kCornerCount] = { 0 };
	toQuad[0].x = IntToFixed(inCorners[0].h);
	toQuad[0].y = IntToFixed(inCorners[0].v);
	toQuad[1].x = IntToFixed(inCorners[1].h);
	toQuad[1].y = IntToFixed(inCorners[1].v);
	toQuad[2].x = IntToFixed(inCorners[2].h);
	toQuad[2].y = IntToFixed(inCorners[2].v);
	toQuad[3].x = IntToFixed(inCorners[3].h);
	toQuad[3].y = IntToFixed(inCorners[3].v);
	
	OSErr err = ::QuadToQuadMatrix( (Fixed*)fromQuad, (Fixed*)toQuad, &outMatrix );
   check_noerr(err);
   
   // now see if applying that to the standard sprite dimensions reproduces output
  	Point defaultPoints[kCornerCount] = { { 0, 0 }, { 0, 50 }, { 50, 50 }, { 50, 0 } };
  	Point checkerPoints[kCornerCount] = { { 0, 0 }, { 0, 50 }, { 50, 50 }, { 50, 0 } };
   Point originalPoints[kCornerCount] = { 0 };
   memcpy(originalPoints, inCorners, size_corners);
   err = ::TransformPoints(&outMatrix, checkerPoints, kCornerCount);
   //check_noerr(err);
	for (int i = 0; i < kCornerCount; ++i)
   {
		if (checkerPoints[i] != originalPoints[i])
      {
         //identicalPoints = false;
         // that seems to happen fairly regularly. Let's see if transformation completely failed perhaps?
         if (checkerPoints[i] == defaultPoints[i])
         {
            identicalPoints = false;
            break;
         }
      }
   }
   
   return identicalPoints;
}

void MakeShapeMatrix(MatrixRecord& outMatrix, const Rect& inRect, Fixed inRotation)
{
	MakeScaleRotateMatrix(outMatrix, kImageSourceRect, inRect, inRotation);
}

void MakeScaleRotateMatrix(MatrixRecord& outMatrix, const Rect& fromRect, const Rect& toRect, Fixed inRotation)
{
	::SetIdentityMatrix(&outMatrix);

	::RectMatrix(&outMatrix, &fromRect, &toRect);
	
	Fixed aboutX = IntToFixed((toRect.left + toRect.right) / 2);
	Fixed aboutY = IntToFixed((toRect.top + toRect.bottom) / 2);
	::RotateMatrix(&outMatrix, inRotation, aboutX, aboutY);
}

void RotateRectBy(
   Rect& ioRect,
   int inDegrees
)
{
   MatrixRecord matrix = { 0 };
   MakeScaleRotateMatrix(matrix, ioRect, ioRect, IntToFixed(inDegrees));
   SafeTransformRect(&matrix, ioRect);
}


void SafeTransformRect(const MatrixRecord *m, Rect &ioRect)
{
	Point	thePoints[4];

	thePoints[0].h = ioRect.left;		// top left
	thePoints[0].v = ioRect.top;		// top left
	thePoints[1].h = ioRect.right;		// bot right
	thePoints[1].v = ioRect.bottom;		// bot right
	thePoints[2].h = ioRect.right;		// top right
	thePoints[2].v = ioRect.top;		// top right
	thePoints[3].h = ioRect.left;		// bot left
	thePoints[3].v = ioRect.bottom;		// bot left
	
	::TransformPoints(m, thePoints, 4);
	
	// now determine the bounding rect of these points
	short	minX = 32767;
	short	minY = 32767;
	short	maxX = -32767;
	short	maxY = -32767;
	for (int i = 0; i < 4; ++i)
   {
		if (thePoints[i].h < minX)
			minX = thePoints[i].h;
		if (thePoints[i].h > maxX)
			maxX = thePoints[i].h;
		if (thePoints[i].v < minY)
			minY = thePoints[i].v;
		if (thePoints[i].v > maxY)
			maxY = thePoints[i].v;
   }
	ioRect.left = minX;
	ioRect.right = maxX;
	ioRect.top = minY;
	ioRect.bottom = maxY;
}

#pragma mark for getting rid of DEPRECATED_IN_MAC_OS_X compile warnings

Boolean QDEmptyRect(const Rect& inRect)
{
   if (inRect.right <= inRect.left)
      return true;
   if (inRect.bottom <= inRect.top)
      return true;
   return false;
}

Boolean QDEqualRect(const Rect& inRect1, const Rect& inRect2)
{
   if (inRect1.left != inRect2.left)
      return false;
   if (inRect1.top != inRect2.top)
      return false;
   if (inRect1.right != inRect2.right)
      return false;
   if (inRect1.bottom != inRect2.bottom)
      return false;
   return true;
}

void QDOffsetRect(Rect& ioRect, short dh, short dv)
{
   ioRect.left += dh;
   ioRect.right += dh;
   ioRect.top += dv;
   ioRect.bottom += dv;
}

void QDInsetRect(Rect& ioRect, short dh, short dv)
{
   ioRect.left += dh;
   ioRect.right -= dh;
   ioRect.top += dv;
   ioRect.bottom -= dv;
}

Boolean QDSectRect(const Rect* src1, const Rect* src2, Rect* dstRect)
{
   Boolean result = false;
   Rect outRect = { 0 };

   outRect.left = std::max<short>(src1->left, src2->left);
   outRect.right = std::min<short>(src1->right, src2->right);
   outRect.top = std::max<short>(src1->top, src2->top);
   outRect.bottom = std::min<short>(src1->bottom, src2->bottom);
   result = !QDEmptyRect(outRect);
   if (!result)
      outRect.left = outRect.right = outRect.top = outRect.bottom = 0;

//#if VCXPOWERPLANT
//   Rect checker = { 0 };
//   Boolean checkResult = ::SectRect(src1, src2, &checker);
//   check(checkResult == result);
//   check(checker == outRect);
//#endif VCXPOWERPLANT
   
   if (dstRect)
      *dstRect = outRect;
   return result;
}


#pragma mark *** endian utilities

void EndianPoint_BtoN(Point& ioPoint)
{
#pragma unused (ioPoint)
#if TARGET_RT_LITTLE_ENDIAN
   ioPoint.v = EndianS16_BtoN(ioPoint.v);
   ioPoint.h = EndianS16_BtoN(ioPoint.h);
#endif TARGET_RT_LITTLE_ENDIAN
}
void EndianRect_BtoN(Rect& ioRect)
{
#pragma unused (ioRect)
#if __LITTLE_ENDIAN__
   ioRect.top = EndianS16_BtoN(ioRect.top);
   ioRect.left = EndianS16_BtoN(ioRect.left);
   ioRect.bottom = EndianS16_BtoN(ioRect.bottom);
   ioRect.right = EndianS16_BtoN(ioRect.right);
#endif __LITTLE_ENDIAN__
}

void EndianRGBColor_BtoN(RGBColor& ioRGBColor)
{
#pragma unused (ioRGBColor)
#if TARGET_RT_LITTLE_ENDIAN
   ioRGBColor.red = EndianS16_BtoN(ioRGBColor.red);
   ioRGBColor.green = EndianS16_BtoN(ioRGBColor.green);
   ioRGBColor.blue = EndianS16_BtoN(ioRGBColor.blue);
#endif TARGET_RT_LITTLE_ENDIAN
}

void EndianDouble_BtoN(double& ioDouble)
{
#pragma unused (ioDouble)
#if TARGET_RT_LITTLE_ENDIAN
   UInt64* myLongPtr = (UInt64*)&ioDouble;
   *myLongPtr = EndianU64_BtoN(*myLongPtr);
#endif TARGET_RT_LITTLE_ENDIAN
}

void EndianPoint_NtoB(Point& ioPoint)
{
#pragma unused (ioPoint)
#if TARGET_RT_LITTLE_ENDIAN
   ioPoint.v = EndianS16_NtoB(ioPoint.v);
   ioPoint.h = EndianS16_NtoB(ioPoint.h);
#endif TARGET_RT_LITTLE_ENDIAN
}

void EndianRect_NtoB(Rect& ioRect)
{
#pragma unused (ioRect)
#if TARGET_RT_LITTLE_ENDIAN
   ioRect.top = EndianS16_NtoB(ioRect.top);
   ioRect.left = EndianS16_NtoB(ioRect.left);
   ioRect.bottom = EndianS16_NtoB(ioRect.bottom);
   ioRect.right = EndianS16_NtoB(ioRect.right);
#endif TARGET_RT_LITTLE_ENDIAN
}

void EndianRGBColor_NtoB(RGBColor& ioRGBColor)
{
#pragma unused (ioRGBColor)
#if TARGET_RT_LITTLE_ENDIAN
   ioRGBColor.red = EndianS16_NtoB(ioRGBColor.red);
   ioRGBColor.green = EndianS16_NtoB(ioRGBColor.green);
   ioRGBColor.blue = EndianS16_NtoB(ioRGBColor.blue);
#endif TARGET_RT_LITTLE_ENDIAN
}

void EndianDouble_NtoB(double& ioDouble)
{
#pragma unused (ioDouble)
#if TARGET_RT_LITTLE_ENDIAN
   UInt64* myLongPtr = (UInt64*)&ioDouble;
   *myLongPtr = EndianU64_NtoB(*myLongPtr);
#endif TARGET_RT_LITTLE_ENDIAN
}

#pragma mark *** CFURLRef [file] utilities

bool DeleteURLRef(CFURLRef inURL)
{
   if (!inURL)
      return true;
   FSRef tempRef = { 0 };
   bool gotRef = ::CFURLGetFSRef(inURL, &tempRef);
   if (!gotRef)
      return true;
   OSStatus deleteErr = ::FSDeleteObject(&tempRef);
   bool deleted = noErr == deleteErr;
   check(deleted);
   return deleted;
}

void SetURLRefFileType(CFURLRef inURL, OSType inType)
{
   FSRef fsRef = { 0 };
   Boolean gotRef = ::CFURLGetFSRef(inURL, &fsRef);
   
   if (gotRef)
   {
      FSCatalogInfo info = { 0 };
      OSStatus err = ::FSGetCatalogInfo(&fsRef, kFSCatInfoFinderInfo, &info, 0, 0, 0);
      check_noerr(err);
      
      FInfo* finderInfo = (FInfo*)&info.finderInfo;
      if (inType != finderInfo->fdType)
      {
         finderInfo->fdType = MovieFileType;
         err = ::FSSetCatalogInfo(&fsRef, kFSCatInfoFinderInfo, &info);
         check_noerr(err);
      }
   }
}

#pragma mark *** FSRef file utilities

OSStatus DeleteContainerContentsFSRef(const FSRef& inContainer)
{
	FSDeleteContainerGlobals	theGlobals;
	
	// delete container's contents
	FSDeleteContainerLevel(inContainer, &theGlobals);
	
	return ( theGlobals.result );
}

OSStatus DeleteContainerFSRef(const FSRef& inContainer)
{
	OSErr			result;
	FSCatalogInfo	catalogInfo;
	
	// get nodeFlags for container
	result = FSGetCatalogInfo(&inContainer, kFSCatInfoNodeFlags, &catalogInfo, NULL, NULL,NULL);
	require_noerr(result, FSGetCatalogInfo);
	
	// make sure container is a directory
	require_action(0 != (catalogInfo.nodeFlags & kFSNodeIsDirectoryMask), ContainerNotDirectory, result = dirNFErr);
	
	// delete container's contents
	result = DeleteContainerContentsFSRef(inContainer);
	require_noerr(result, DeleteContainerContentsFSRef);
	
	// is container locked?
	if ( 0 != (catalogInfo.nodeFlags & kFSNodeLockedMask) )
	{
		// then attempt to unlock container (ignore result since FSDeleteObject will set it correctly)
		catalogInfo.nodeFlags &= ~kFSNodeLockedMask;
		(void) FSSetCatalogInfo(&inContainer, kFSCatInfoNodeFlags, &catalogInfo);
	}
	
	// delete the container
	result = FSDeleteObject(&inContainer);
	
DeleteContainerContentsFSRef:
ContainerNotDirectory:
FSGetCatalogInfo:

	return ( result );
}

OSStatus FSGetParentRef(
	const FSRef *ref,
	FSRef *parentRef)
{
	OSStatus	result;
	FSCatalogInfo	catalogInfo;
	
	//check parameters 
	require_action(NULL != parentRef, BadParameter, result = paramErr);
	
	result = FSGetCatalogInfo(ref, kFSCatInfoNodeID, &catalogInfo, NULL, NULL, parentRef);
	require_noerr(result, FSGetCatalogInfo);
	
	//
	// Note: FSRefs always point to real file system objects. So, there cannot
	// be a FSRef to the parent of volume root directories. Early versions of
   // Mac OS X do not handle this case correctly and incorrectly return a
   // FSRef for the parent of volume root directories instead of returning an
   // invalid FSRef (a cleared FSRef is invalid). The next three lines of code
   // ensure that you won't run into this bug. WW9D!
	//
    
	if ( fsRtDirID == catalogInfo.nodeID )
	{
		// clear parentRef and return noErr which is the proper behavior
		memset(parentRef, 0, sizeof(FSRef));
	}

FSGetCatalogInfo:
BadParameter:

	return ( result );
}
*/

#pragma mark *** Obsolete FSSpec file utilities

void TemporaryFSSpec(
   FSSpec& outSpec,
   const char* inTag
)
{
   bzero(&outSpec, sizeof(FSSpec));
	OSStatus err = ::FindFolder(
      kOnAppropriateDisk,
      kTemporaryFolderType,
      kCreateFolder,
      &outSpec.vRefNum,
      &outSpec.parID
   );
   verify_noerr(err);
   
   char tempName[256] = { 0 };
   int ticks = (long)::TickCount();
   sprintf(tempName, "%d%s", ticks, inTag);
   tempName[30] = 0;
   C2Pstrcpy(outSpec.name, tempName);
}

/*
OSStatus FSRefMakeFSSpec(
	const FSRef *inRef,
	FSSpec& outSpec
)
{
	OSStatus	result = FSGetCatalogInfo(inRef, kFSCatInfoNone, NULL, NULL, &outSpec, NULL);
	return ( result );
}

#if VCXPOWERPLANT
CFURLRef FSSpecMakeURLRef(const FSSpec& inSpec)
{
   CFURLRef result = NULL;
   bool needDelete = false;
   FSRef tempRef = { 0 };

   OSStatus	err = ::FSpMakeFSRef(
      &inSpec,
      &tempRef
   );
   if (err)
   {
      needDelete = true;
      ::FSpCreate(&inSpec, 0, 0, 0);
      err = ::FSpMakeFSRef(
         &inSpec,
         &tempRef
      );
      check_noerr(err);
   }

   result = ::CFURLCreateFromFSRef(NULL, &tempRef);
   check(result);
   
   if (needDelete)
      ::FSpDelete(&inSpec);
   
   return result;
}

OSStatus FSPathMakeFSSpec(
	const char *inPath,
	FSSpec& outSpec,
   bool& outFileExists,
   FSSpec* relativeToSpec, // may be NULL; for finding movie in project folder
   TCFString* outFilename // may be NULL; for displaying "can't find XXX" message
)
{
	OSStatus	result = paramErr;
   bzero(&outSpec, sizeof(outSpec));
   outFileExists = false;
   
#if 0
	// convert the POSIX path to an FSRef
	FSRef		ref;
	result = FSPathMakeRef(path, &ref, isDirectory);
	require_noerr(result, FSPathMakeRef);
	
	// and then convert the FSRef to an FSSpec
	result = FSGetCatalogInfo(&ref, kFSCatInfoNone, NULL, NULL, spec, NULL);
	require_noerr(result, FSGetCatalogInfo);
	
FSGetCatalogInfo:
FSPathMakeRef:
#endif 0
 
   TCFString utf8Name = inPath;
   //CFURLRef url = ::CFURLCreateWithString(NULL, utf8Name, NULL);
   CFURLRef url = ::CFURLCreateWithFileSystemPath(
      NULL,
      utf8Name,
      kCFURLPOSIXPathStyle,
      false
   );
   if (url)
   {
      result = FSURLMakeFSSpec(
         url,
         outSpec,
         outFileExists,
         relativeToSpec,
         outFilename
      );
      
      SafeCFRelease(url);
   }

	return result;
}

OSStatus FSURLMakeFSSpec(
	CFURLRef inRef,
	FSSpec& outSpec,
   bool& outFileExists,
   FSSpec* relativeToSpec, // may be NULL; for finding movie in project folder
   TCFString* outFilename // may be NULL; for displaying "can't find XXX" message
)
{
	OSStatus	result = paramErr;
   FSRef tempRef = { 0 };

   bool gotRef = ::CFURLGetFSRef(inRef, &tempRef);
   if (gotRef)
   {
      outFileExists = true;
      result = FSRefMakeFSSpec(&tempRef, outSpec); // to get name properly
      if (relativeToSpec)
         result = ::FSMakeFSSpec(relativeToSpec->vRefNum, relativeToSpec->parID, outSpec.name, &outSpec);
      if (result)
         result = FSRefMakeFSSpec(&tempRef, outSpec);
   }
   else if (relativeToSpec)
   {
      TCFString nameString = ::CFURLCopyLastPathComponent(inRef);
      if (outFilename)
         *outFilename = nameString.GetChars();
      HFSUniStr255 uniName = { 0 };
      nameString.CopyHFSUniStr255(uniName);

      FSRef docFSRef = { 0 };
      result = ::FSpMakeFSRef(relativeToSpec, &docFSRef);
      check_noerr(result);
      FSRef parentFSRef = { 0 };
      result = FSGetParentRef(&docFSRef, &parentFSRef);
      check_noerr(result);

      result = ::FSMakeFSRefUnicode(
         &parentFSRef,
         uniName.length,
         uniName.unicode,
         kTextEncodingUnknown,
         &tempRef
      );
      if (!result)
      {
         result = FSRefMakeFSSpec(&tempRef, outSpec);
         if (!result)
            outFileExists = true;
      }
   }
   
   return result;
}
#endif VCXPOWERPLANT

OSStatus
FSMakePath(
	SInt16 volRefNum,
	SInt32 dirID,
	ConstStr255Param name,
	UInt8 *path,
	UInt32 maxPathSize)
{
	OSStatus	result;
	FSRef		ref;
	
	// check parameters
	require_action(NULL != path, BadParameter, result = paramErr);
	
	// convert the inputs to an FSRef
	//result = FSMakeFSRef(volRefNum, dirID, name, &ref);
#define CONST_CAST(type, const_var) (*(type*)((void *)&(const_var)))
   {
	FSRefParam	pb;
	pb.ioVRefNum = volRefNum;
	pb.ioDirID = dirID;
	pb.ioNamePtr = CONST_CAST(StringPtr, name);
	pb.newRef = &ref;
	result = PBMakeFSRefSync(&pb);
   }
	require_noerr(result, FSMakeFSRef);
	
	// and then convert the FSRef to a path
	result = FSRefMakePath(&ref, path, maxPathSize);
	require_noerr(result, FSRefMakePath);
	
FSRefMakePath:
FSMakeFSRef:
BadParameter:

	return ( result );
}

#pragma mark *** Memory utilities from UMemoryMgr.h

// ===========================================================================
//	‚Äö√Ñ¬¢ StVCHandleLocker Class
// ===========================================================================
//	Constructor Locks the Handle
//	Destructor restores the Handle's original locked/unlocked state

StVCHandleLocker::StVCHandleLocker(Handle inHandle) :
   mHandle(NULL),
   mWasUnlocked(false)
{
	Adopt(inHandle);
}


StVCHandleLocker::~StVCHandleLocker()
{
	RestoreLockState();
}


void
StVCHandleLocker::RestoreLockState()
{
	if (mWasUnlocked && (mHandle != nil)) {
		::HUnlock(mHandle);
	}
}


void
StVCHandleLocker::Adopt(				// Take control over locking
	Handle	inHandle)				//   and unlocking this Handle
{
	RestoreLockState();				// Restore state of current Handle

	mHandle		 = inHandle;		// Store new Handle
	mWasUnlocked = false;

	if (inHandle != nil) {			// Lock new Handle

		SInt8	theState = ::HGetState(inHandle);
      
			// Bit 7 of state is set if Handle is locked. We want to
			// know if the Handle is currently locked or unlocked.
			// If it is unlocked, we lock it now and unlock it the
			// destructor. If it is already locked, we do nothing
			// here and nothing in the destructor.

		mWasUnlocked = (theState & 0x80) == 0;	// Unlocked if bit 7 is clear

		if (mWasUnlocked) {
			::HLock(inHandle);
		}
	}
}


Handle								// Relinquish control of Handle
StVCHandleLocker::Release()
{
	RestoreLockState();

	Handle	outHandle = mHandle;

	mHandle		 = nil;				// We now have no Handle
	mWasUnlocked = false;

	return outHandle;
}


#pragma mark *** std::string utilities

std::string operator+=(
   const std::string& inString,
   ConstStringPtr inPascalString
)
{
   char asCString[256] = { 0 };
   P2Cstrcpy(asCString, inPascalString);
   return inString + asCString;
}

std::string AppendFourCharCode(
   const std::string& inString,
   FourCharCode inCode
)
{
   char asCString[5] = { 0 };
   sprintf(
      asCString,
      "%c%c%c%c",
      (unsigned char)(inCode >> 24),
      (unsigned char)(inCode >> 16),
      (unsigned char)(inCode >> 8),
      (unsigned char)inCode
   );
   return inString + asCString;
}

#pragma mark *** tweening utilities

void DoATween(TimeValue tweenTime, TimeValue duration, void* inData, long inSize, void* outData, QTAtomType inType)
{
	//StHandleBlock result(inSize);
	Handle result = ::NewHandle(inSize);
   check(result);
   
	CQTAtomContainer container;
	QTAtom tweenAtom = container.AddParent(kTweenEntry, kParentAtomIsContainer, 1, 1);
   container.AddChildLongNtoBData(kTweenType, tweenAtom, 1, 0, inType);
   container.AddChildLongNtoBData(kTweenDuration, tweenAtom, 1, 0, duration);
   switch (inType)
   {
      case kTweenTypePoint:
         EndianPoint_NtoB(((Point*)inData)[0]);
         EndianPoint_NtoB(((Point*)inData)[1]);
         check(inSize == 2 * sizeof(Point));
         break;
      case kTweenTypeFixed:
         check(inSize == 2 * sizeof(Fixed));
	      ((Fixed*)inData)[0] = EndianS32_NtoB(((Fixed*)inData)[0]);
	      ((Fixed*)inData)[1] = EndianS32_NtoB(((Fixed*)inData)[1]);
         break;
      default:
         debug_string("unknown tween type in DoATween");
         break;
   }
   container.AddChildRawData(kTweenData, tweenAtom, 1, 0, inSize, inData);
   	
	QTTweener tween = NULL;
	verify_noerr(::QTNewTween( &tween, container.GetContainer(), tweenAtom, duration ));
	long resultSize = 0;
	verify_noerr( ::QTDoTween( tween, tweenTime, result, &resultSize, nil, nil ));
	verify_noerr(::QTDisposeTween( tween ));

	//BlockMoveData(*result.Get(), outData, resultSize);
   BlockMoveData(*result, outData, resultSize);
   ::DisposeHandle(result);
}

#pragma mark *** image buffer utilities

// return value must be disposed with free()
char* CreateBGR24BufferFromARGB32Buffer(
   char* inBaseAddress,
   int inRowBytes,
   int inWidth,
   int inHeight
)
{
   if (!inBaseAddress)
      return NULL;
      
   char* result = (char*)calloc(sizeof(char), inWidth * inHeight * 3);
   
   FillInBGR24BufferFromARGB32Buffer(
      inBaseAddress,
      inRowBytes,
      inWidth,
      inHeight,
      result
   );
   
   return result;
}

void FillInBGR24BufferFromARGB32Buffer(
   char* inBaseAddress,
   int inRowBytes,
   int inWidth,
   int inHeight,
   char* inExistingBuffer
)
{   
   if (!inBaseAddress or !inExistingBuffer)
      return;

   char* destPtr = inExistingBuffer;
   // note that code seems to expect bottom to top
   //for (int y = bounds.top; y < bounds.bottom; y++)
   inBaseAddress += (inHeight * inRowBytes);
   
   //for (int y = bounds.bottom - 1; y >= bounds.top; y--)
   for (; inHeight > 0; inHeight--)
   {
      inBaseAddress -= inRowBytes;

      unsigned char* sourcePtr = (unsigned char*)inBaseAddress;
      for (int x = 0; x < inWidth; x++)
      { 
         // from ARGB
         sourcePtr++; // A
         unsigned char red = *sourcePtr++; // R
         unsigned char green = *sourcePtr++; // G
         *destPtr++ = *sourcePtr++; // B
         *destPtr++ = green;
         *destPtr++ = red;
      }
      //inBaseAddress += inRowBytes;
   }
}
*/

