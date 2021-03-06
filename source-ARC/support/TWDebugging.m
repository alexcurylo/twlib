//
//  TWDebugging.m
//
//  Copyright (c) 2011 Trollwerks Inc. All rights reserved.
//

// some more comments;
// http://www.karlkraft.com/index.php/2009/03/23/114/
// http://blog.coriolis.ch/2009/01/09/redirect-nslog-to-a-file-on-the-iphone/

#import "TWDebugging.h"

//#define BONJOUR_LOGGING 1
#if BONJOUR_LOGGING
#import "BonjourDebugLogger.h"
#endif //BONJOUR_LOGGING

#pragma mark *** Trollwerks universal NSLogging

void TWLog(const char* format, ...)
{
   NSString* formatString = [[NSString alloc] initWithUTF8String:format];
   
   va_list argList; 
   va_start(argList, format);
   
   NSString* logString = [[NSString alloc] initWithFormat:formatString arguments:argList];
   
   va_end(argList);
   
   fprintf(stderr, "%s\n", logString.UTF8String);
 
#if BONJOUR_LOGGING
   static BonjourDebugLogger *sBonjourLogger = nil;
   if (!sBonjourLogger)
      sBonjourLogger = [[BonjourDebugLogger alloc] init];
   [sBonjourLogger log:logString];
#endif //BONJOUR_LOGGING
 
#if !__has_feature(objc_arc)
   [formatString release];
   [logString release];
#endif //!__has_feature(objc_arc)
}

void TWFail(const char* assertion, const char* function, const char* filePath, int lineNumber)
{
   NSString *fileName= [[NSString stringWithUTF8String:filePath] lastPathComponent];
   TWLog(
      "%s FAIL: %s (%@: line %d)",
      function,
      assertion,
      fileName,
      lineNumber
   );
}

#if TARGET_OS_IPHONE

void TWLogTouchSet(const char* action, NSSet* set, UIEvent* event)
{
   NSUInteger setCount = [set count];
   
   if (!setCount)
      fprintf(stderr, "%s with no touches?", action);
   else
   {
      int touchIndex = 1;
      for (UITouch* touch in set)
      {
         twcheck([touch isMemberOfClass:[UITouch class]]);
         CGPoint location = [touch locationInView:[touch view]];
         CGPoint previousLocation = [touch previousLocationInView:[touch view]];
         NSUInteger tapCount = [touch tapCount];

         UITouchPhase phase = [touch phase];
         const char* phaseTitle = nil;
         switch (phase) {
            case UITouchPhaseBegan: phaseTitle = "began"; break;
            case UITouchPhaseMoved: phaseTitle = "moved"; break;
            case UITouchPhaseStationary: phaseTitle = "still"; break;
            case UITouchPhaseEnded: phaseTitle = "ended"; break;
            case UITouchPhaseCancelled: phaseTitle = "cancelled"; break;
            default: phaseTitle = "???"; break;
         }

         fprintf(stderr,
            "%s (%i of %i [from %i] - %s): %i taps at { %.1f, %.1f } ( %.1f, %.1f )",
            action,
            touchIndex++,
            setCount,
            [[event allTouches] count],
            phaseTitle,
            tapCount,
            location.x,
            location.y,
            location.x - previousLocation.x,
            location.y - previousLocation.y
         );
      }
   }
}

#endif //TARGET_OS_IPHONE

// implements DEBUG_ASSERT_MESSAGE in AssertMacros.h

void TWAssertMessage(
   const char *componentNameString, 
   const char *assertionString, 
   const char *exceptionLabelString, 
   const char *errorString, 
   const char *fileName, 
   long lineNumber, 
   int errorCode
)
{
   NSMutableString* message = [NSMutableString string];
   
   if ( (componentNameString != NULL) && (*componentNameString != '\0') )
      [message appendFormat:@"%s: ", componentNameString];
   if ( (assertionString != NULL) && (*assertionString != '\0') )
      [message appendFormat:@"FAIL: %s ", assertionString];
   
   if ( exceptionLabelString != NULL )
      [message appendFormat:@"%s ", exceptionLabelString];
   if ( errorString != NULL )
      [message appendFormat:@"%s ", errorString];
   if ( fileName != NULL )
      [message appendFormat:@"(%@ ", [[NSString stringWithUTF8String:fileName] lastPathComponent]];
   if ( lineNumber != 0 )
      [message appendFormat:@"line %ld) ", lineNumber];
   if ( errorCode != 0 )
      [message appendFormat:@"error: %d\n", errorCode];
   
   fprintf(stderr, "%s\n", [message UTF8String]);
}

