//
//  TWXDebugging.h
//
//  Copyright (c) 2013 Trollwerks Inc. All rights reserved.
//  License: http://www.wtfpl.net/
//

#pragma mark - Useful compiler macros

#define twlikely(x)  __builtin_expect((x),1)
#define twunlikely(x) __builtin_expect((x),0)

#pragma mark - Compile time asserts

// example: twcompileassert(sizeof(wchar_t) == 4, wchar_t_is_4_bytes_on_OS_X)
#define twcompileassertsymbolinner(line, msg) _twcompileassert ## line ## __ ## msg
#define twcompileassertsymbol(line, msg) twcompileassertsymbolinner(line, msg)
#define twcompileassert(test, msg) \
typedef char twcompileassertsymbol(__LINE__, msg) [ ((test) ? 1 : -1) ]

#pragma mark - Runtime debugging

#ifdef DEBUG

#undef DEBUG_ASSERT_PRODUCTION_CODE
#define DEBUG_ASSERT_PRODUCTION_CODE 0

#define twrelease(x) do { [x release]; if (!getenv("NSZombieEnabled")) x = (id)0xDEADBEEF; } while (0)

#define twlog TWLog
#define twlogif(assertion, ...) do { if (twunlikely(assertion)) TWLog(__VA_ARGS__); } while (0)
#define twwin(x) ((x) ? "WIN" : "FAIL")
#define twyes(x) ((x) ? "YES" : "NO")
#define twmark	TWLog("MARK: %s", __PRETTY_FUNCTION__);
#define twunimplemented	TWLog("IMPLEMENT: %s", __PRETTY_FUNCTION__);
#define twtimerstart NSTimeInterval start = [NSDate timeIntervalSinceReferenceDate]
#define twtimerend(msg) NSTimeInterval stop = [NSDate timeIntervalSinceReferenceDate]; if (msg) TWLog("%s -- time: %f", msg, stop-start)
#define twtimerduration (stop - start)

#define twverify(assertion, stop)     \
   do                                 \
   {                                  \
       if (twunlikely(!(assertion)))  \
       {                              \
           TWFail(                    \
               #assertion,            \
               __PRETTY_FUNCTION__,   \
               __FILE__,              \
               __LINE__               \
           );                         \
           if (stop)                  \
             abort();                 \
       }                              \
   } while (0)
#define twassert(x) twverify((x), 1)
#define twcheck(x) twverify((x), 0)
#define twcheckmain twcheck(NSThread.isMainThread)

#define twmemory TWLogMemoryUsage()
#define twmempoll(x) TWLogMemoryUsageEvery(x)

#else

#define twrelease(x) [x release], x = nil

#define twlog(...)
#define twlogif(...)
#define twwin(...)
#define twyes(...)
#define twlogtouchset(...)
#define twmark
#define twunimplemented
#define twtimerstart
#define twtimerend(...)
#define twtimerduration 0

#define twverify(...)
#define twassert(...)
#define twcheck(...)
#define twcheckmain

#define twmemory
#define twmempoll(...)

#endif //DEBUG

#undef DEBUG_ASSERT_MESSAGE
#define DEBUG_ASSERT_MESSAGE TWAssertMessage
@import Darwin.AssertMacros;

#pragma mark - universal stderr logging

// see string format specifiers here
// http://developer.apple.com/DOCUMENTATION/Cocoa/Conceptual/Strings/Articles/formatSpecifiers.html

#ifdef __cplusplus
extern "C" {
#endif //__cplusplus

// can be called transparently from .c/.cpp/.m/.mm files
void TWLog(const char *format, ...);
void TWFail(const char *assertion, const char *function, const char *filePath, int lineNumber);

// implements DEBUG_ASSERT_MESSAGE in AssertMacros.h
void TWAssertMessage(
   const char *componentNameString, 
   const char *assertionString, 
   const char *exceptionLabelString, 
   const char *errorString, 
   const char *fileName, 
   long lineNumber, 
   int errorCode
);
    
// memory status

void TWLogMemoryUsageEvery(double seconds); // 0 to cancel
void TWLogMemoryUsage(void);

#ifdef __cplusplus
}
#endif //__cplusplus
