//
//  TWXDebugging.m
//
//  Copyright (c) 2013 Trollwerks Inc. All rights reserved.
//  License: http://www.wtfpl.net/
//

#import "TWXDebugging.h"
@import Darwin.Mach;
#define BONJOUR_LOGGING 0
#if BONJOUR_LOGGING
#import "BonjourDebugLogger.h"
#endif //BONJOUR_LOGGING

//const char *__crashreporter_info__ = NULL;
//asm(".desc _crashreporter_info, 0x10");

#pragma mark - universal NSLogging

void TWLog(const char *format, ...)
{
    NSString *formatString = [NSString.alloc initWithUTF8String:format];
    
    va_list argList;
    va_start(argList, format);
    
    NSString *logString = [NSString.alloc initWithFormat:formatString arguments:argList];
    
    va_end(argList);
    
    fprintf(stderr, "%s\n", logString.UTF8String);
    
#if BONJOUR_LOGGING
    static BonjourDebugLogger *sBonjourLogger = nil;
    if (!sBonjourLogger)
        sBonjourLogger = BonjourDebugLogger.new;
    [sBonjourLogger log:logString];
#endif //BONJOUR_LOGGING
    
#if !__has_feature(objc_arc)
    [formatString release];
    [logString release];
#endif //!__has_feature(objc_arc)
}

void TWFail(const char *assertion, const char *function, const char *filePath, int lineNumber)
{
    NSString *fileName= @(filePath).lastPathComponent;
    TWLog(
          "%s FAIL: %s (%@: line %d)",
          function,
          assertion,
          fileName,
          lineNumber
          );
}

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
    NSMutableString *message = NSMutableString.string;
    
    if ( (componentNameString != NULL) && (*componentNameString != '\0') )
        [message appendFormat:@"%s: ", componentNameString];
    if ( (assertionString != NULL) && (*assertionString != '\0') )
        [message appendFormat:@"FAIL: %s ", assertionString];
    
    if ( exceptionLabelString != NULL )
        [message appendFormat:@"%s ", exceptionLabelString];
    if ( errorString != NULL )
        [message appendFormat:@"%s ", errorString];
    if ( fileName != NULL )
        [message appendFormat:@"(%@ ", @(fileName).lastPathComponent];
    if ( lineNumber != 0 )
        [message appendFormat:@"line %ld) ", lineNumber];
    if ( errorCode != 0 )
        [message appendFormat:@"error: %d\n", errorCode];
    
    fprintf(stderr, "%s\n", message.UTF8String);
}

// memory status

void TWLogMemoryUsageEvery(double seconds) // 0 to cancel
{
    static dispatch_source_t sTimer = 0;
    if (!seconds)
    {
        if (sTimer)
        {
            dispatch_source_cancel(sTimer);
#if !OS_OBJECT_USE_OBJC
            dispatch_release(sTimer);
#endif //!OS_OBJECT_USE_OBJC
        }
        sTimer = 0;
        return;
    }
    if (!sTimer)
        sTimer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0));

    dispatch_source_set_timer(sTimer,
        dispatch_time(DISPATCH_TIME_NOW, 0),
        (uint64_t)(seconds * NSEC_PER_SEC),
        0);
    dispatch_source_set_event_handler(sTimer, ^{
        @autoreleasepool { TWLogMemoryUsage(); }
    });
    dispatch_resume(sTimer);
}

vm_size_t resident_bytes(void);
vm_size_t resident_bytes(void)
{
    vm_size_t resident_bytes = 0;
    struct task_basic_info info;
    mach_msg_type_number_t size = sizeof(info);
    kern_return_t kerr = task_info(mach_task_self(), TASK_BASIC_INFO, (task_info_t)&info,  &size);
    if (kerr == KERN_SUCCESS)
        resident_bytes = info.resident_size;
    else
        TWLog("WTF: task_info() FAIL: %s", mach_error_string(kerr));
    return resident_bytes;
}

vm_size_t free_bytes(vm_size_t *used_bytes);
vm_size_t free_bytes(vm_size_t *used_bytes)
{
    vm_size_t free_bytes = 0;
    vm_statistics_data_t vm_stat;
    mach_msg_type_number_t infoCount = HOST_VM_INFO_COUNT;
    kern_return_t kerr = host_statistics(mach_host_self(), HOST_VM_INFO, (host_info_t)&vm_stat, &infoCount);
    if (kerr == KERN_SUCCESS)
    {
        free_bytes = vm_page_size * vm_stat.free_count;
        if (used_bytes)
            *used_bytes = vm_page_size * (vm_stat.active_count + vm_stat.inactive_count + vm_stat.wire_count);
    }
    else
        TWLog("WTF: host_statistics() FAIL: %s", mach_error_string(kerr));
    return free_bytes;
}

void TWLogMemoryUsage(void)
{
    double residentMB = (double)resident_bytes() / 1024. / 1024.;
    vm_size_t used_bytes = 0;
    double freeMB = (double)free_bytes(&used_bytes) / 1024. / 1024.;
    double usedMB = (double)used_bytes / 1024. / 1024.;
   
    TWLog("FYI: memory usage - resident %.02f MB - used %.02f MB - free %.02f MB", residentMB, usedMB, freeMB);
}

