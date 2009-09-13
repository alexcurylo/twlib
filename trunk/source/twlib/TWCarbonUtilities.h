//
//  TWCarbonUtilities.h
//
//  Copyright 2009 Trollwerks Inc. All rights reserved.
//

#pragma once


//#include <Carbon/Carbon.h>
//#include <ApplicationServices/ApplicationServices.h>

/*
 #include <CoreServices/CoreServices.h>
#include <ApplicationServices/ApplicationServices.h>
#include <QuickTime/Movies.h>
#include "VCProjectDefinitions.h"
*/

#ifdef __cplusplus
extern "C"
{
#endif __cplusplus

#pragma mark *** Useful constants from PP::UDrawingState

extern const RGBColor kRGBColor_White;
extern const RGBColor kRGBColor_Black;
extern const RGBColor kRGBColor_Yellow;
extern const RGBColor kRGBColor_Red;
extern const RGBColor kRGBColor_TextDefault; // yellow
extern const RGBColor kRGBColor_ObjectDefault; // red

extern const unsigned char	kStr_Empty[]; // Pascal string with zero length byte
extern const unsigned char	kStr_Dummy[]; // Pascal string with 1 character

extern const Point kPoint_00;
extern const Rect kRect_0000;
extern const Rect kImageSourceRect;

extern const FSSpec kFSSpec_Empty;

 #pragma mark *** Pascal string utilities (from PP::LString, Toolbox)

void C2Pstrcpy(Str255 dst, const char *src);
   
/*
 void P2Cstrcpy(char* dst, ConstStr255Param src);
 
 Boolean EqualPStr(
 ConstStr255Param str1,
 ConstStr255Param str2
 );
*/
   
#pragma mark *** QuickDraw dependent C utilities

/*
 #ifndef topLeft
#define topLeft(r)	(((Point *) &(r))[0])
#endif
#ifndef botRight
#define botRight(r)	(((Point *) &(r))[1])
#endif

Rect CalcBoundingRect(const Point inCorners[kCornerCount]);
Rect CalcFixedBoundingRect(const FixedPoint inCorners[kCornerCount]);
void CalcComponentPoints(Rect inBounds, Point outCorners[kCornerCount]);
bool CornersAreEqual(const Point lhs[kCornerCount], const Point rhs[kCornerCount]);

Boolean QDSectRect(const Rect* src1, const Rect* src2, Rect* dstRect);

#pragma mark *** CFURLRef [file] utilities

bool DeleteURLRef(CFURLRef inURL);
void SetURLRefFileType(CFURLRef inURL, OSType inType);

#if VCXPOWERPLANT

class TCFString;

CFURLRef FSSpecMakeURLRef(const FSSpec& inSpec);

OSStatus FSPathMakeFSSpec(
	const char *inPath,
	FSSpec& outSpec,
   bool& outFileExists,
   FSSpec* relativeToSpec, // may be NULL; for finding movie in project folder
   TCFString* outFilename // may be NULL; for displaying "can't find XXX" message
);


OSStatus FSURLMakeFSSpec(
	CFURLRef inRef,
	FSSpec& outSpec,
   bool& outFileExists,
   FSSpec* relativeToSpec, // may be NULL; for finding movie in project folder
   TCFString* outFilename // may be NULL; for displaying "can't find XXX" message
);

#endif VCXPOWERPLANT

#pragma mark *** tweening utilities

void DoATween(
   TimeValue tweenTime,
   TimeValue duration,
   void* inData,
   long inSize,
   void* outData,
   QTAtomType inType
);

#pragma mark *** image buffer utilities

// return value must be disposed with free()
char* CreateBGR24BufferFromARGB32Buffer(
   char* inBaseAddress,
   int inRowBytes,
   int inWidth,
   int inHeight
);

void FillInBGR24BufferFromARGB32Buffer(
   char* inBaseAddress,
   int inRowBytes,
   int inWidth,
   int inHeight,
   char* inExistingBuffer
);
*/

#ifdef __cplusplus
}

/*
 #include <string>

#pragma mark *** Point comparison

inline bool operator == (
		Point	inPointOne,
		Point	inPointTwo)
	{								// Point is two 16-bit integers. With some
									//   creative typecasting, we can do a
									//   single 32-bit comparison
		return ( *(SInt32*)&inPointOne == *(SInt32*)&inPointTwo );
	}

inline bool operator != (
		Point	inPointOne,
		Point	inPointTwo)
	{
		return !(inPointOne == inPointTwo);
	}

#pragma mark *** RGBColor comparison

inline bool	operator == (
		const RGBColor&		inColorOne,
		const RGBColor&		inColorTwo)
	{
		return (inColorOne.red   == inColorTwo.red)    &&
			   (inColorOne.green == inColorTwo.green)  &&
			   (inColorOne.blue  == inColorTwo.blue);
	}

inline bool operator != (
		const RGBColor&		inColorOne,
		const RGBColor&		inColorTwo)
	{
		return !(inColorOne == inColorTwo);
	}

#pragma mark *** Rect comparison

inline bool operator == (
		const Rect&		inRectOne,
		const Rect&		inRectTwo)
	{								// Rect is four 16-bit integers. With some
									//   creative typecasting, we can do a
									//   two 32-bit comparisons
		return (((SInt32 *) &inRectOne)[0] == ((SInt32 *) &inRectTwo)[0]) &&
			   (((SInt32 *) &inRectOne)[1] == ((SInt32 *) &inRectTwo)[1]);
	}

inline bool operator != (
		const Rect&		inRectOne,
		const Rect&		inRectTwo)
	{
		return !(inRectOne == inRectTwo);
	}

#pragma mark *** Memory utilities from UMemoryMgr.h

class	StVCHandleLocker {
public:
	StVCHandleLocker(Handle inHandle);
	~StVCHandleLocker();

	void	Adopt(Handle inHandle);
	Handle	Release();

protected:
	Handle	mHandle;
	bool	mWasUnlocked;

	void	RestoreLockState();

private:
   // disallow
   StVCHandleLocker(const StVCHandleLocker&) : mHandle(NULL), mWasUnlocked(false) { assert(false); }
   StVCHandleLocker& operator=(const StVCHandleLocker&) { assert(false); return *this; }
};

#pragma mark *** std::string utilities

std::string operator+=(
   const std::string& inString,
   ConstStringPtr inPascalString
); 

std::string AppendFourCharCode(
   const std::string& inString,
   FourCharCode inCode
); 

#pragma mark *** QuickDraw dependent C++ utilities

void Rect2CGRect(
   const Rect& inRect,
   CGRect& outCGRect
);
void CGRect2Rect(
   const CGRect& inCGRect,
   Rect& outRect
);

inline short RectWidth(const Rect& x) { return x.right - x.left; }
inline short RectHeight(const Rect& x) { return x.bottom - x.top; }

void	ScaleCenterRectInRect(const Rect& inDestRect, Rect& ioSourceRect);
void	CenterRectInRect(const Rect& outerRect, Rect& innerRect);
void	PositionRectInRect(const Rect& outerRect, Rect& innerRect, Fixed horzRatio, Fixed vertRatio);

// returns false if the matrix does not reproduce input from  { { 0, 0 } { 50, 50 } } square
// apparently that's a reasonable way to check for matrix which crashes QuickTime at runtime
bool MakeAndCheckPolygonMatrix(MatrixRecord& outMatrix, const Point inCorners[kCornerCount]);
void MakeShapeMatrix(MatrixRecord& outMatrix, const Rect& inRect, Fixed inRotation);
void MakeScaleRotateMatrix(MatrixRecord& outMatrix, const Rect& fromRect, const Rect& toRect, Fixed inRotation);
void RotateRectBy(
   Rect& ioRect,
   int inDegrees
);
void SafeTransformRect(const MatrixRecord *m, Rect &ioRect);

// for getting rid of DEPRECATED_IN_MAC_OS_X compile warnings
Boolean QDEmptyRect(const Rect& inRect);
Boolean QDEqualRect(const Rect& inRect1, const Rect& inRect2);
void QDOffsetRect(Rect& ioRect, short dh, short dv);
void QDInsetRect(Rect& ioRect, short dh, short dv);

#pragma mark *** endian utilities

void EndianPoint_BtoN(Point& ioPoint);
void EndianRect_BtoN(Rect& ioRect);
void EndianRGBColor_BtoN(RGBColor& ioRGBColor);
void EndianDouble_BtoN(double& ioDouble);

void EndianPoint_NtoB(Point& ioPoint);
void EndianRect_NtoB(Rect& ioRect);
void EndianRGBColor_NtoB(RGBColor& ioRGBColor);
void EndianDouble_NtoB(double& ioDouble);

#pragma mark *** FSRef file utilities

OSStatus DeleteContainerContentsFSRef(const FSRef& inContainer);
OSStatus DeleteContainerFSRef(const FSRef& inContainer);

OSStatus FSGetParentRef(
	const FSRef *ref,
	FSRef *parentRef
);
*/
#pragma mark *** Obsolete FSSpec file utilities

void TemporaryFSSpec(
   FSSpec& outSpec,
   const char* inTag
);

/*
OSStatus FSRefMakeFSSpec(
	const FSRef *inRef,
	FSSpec& outSpec
);
OSStatus FSMakePath(
   SInt16 volRefNum,
   SInt32 dirID,
   ConstStr255Param name,
   UInt8 *path,
   UInt32 maxPathSize
);
*/
   
#endif __cplusplus
