//
//  TWXAnalytics.m
//
//  Copyright (c) 2013 Trollwerks Inc. All rights reserved.
//

#define USE_APPSFLYER 0
#define USE_CRASHLYTICS 1
#define USE_FLURRY 1
#define USE_TAPSTREAM 0
#define USE_TESTFLIGHT 0

#import "TWXAnalytics.h"
@import AdSupport;

#if USE_APPSFLYER
// last integration: 2.5.3.2
#import "AppsFlyerTracker.h"
#endif //USE_APPSFLYER
#if USE_CRASHLYTICS
// version 2.1.2
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wauto-import"
#import <Crashlytics/Crashlytics.h>
#pragma clang diagnostic pop
#endif //USE_CRASHLYTICS
#if USE_FLURRY
// version 4.2.4a
#import "Flurry.h"
#endif //USE_FLURRY
#if USE_TAPSTREAM
// version 2.3
#import "TSTapstream.h"
#endif //USE_TAPSTREAM
#if USE_TESTFLIGHT
#import "TestFlight.h"
#endif //USE_TESTFLIGHT

@interface TWXAnalytics()
#if USE_CRASHLYTICS
< CrashlyticsDelegate >
#endif //USE_CRASHLYTICS

@property (nonatomic, strong) NSDictionary *eventParameters;

@end

@implementation TWXAnalytics

+ (TWXAnalytics *)sharedInstance
{
   static TWXAnalytics *sharedInstance = nil;
   static dispatch_once_t once;
   dispatch_once(&once, ^{ sharedInstance = TWXAnalytics.new; });
   return sharedInstance;
}

+ (void)logEvent:(NSString *)event
{
   if (!event.length)
      return;
#if USE_FLURRY
   [Flurry logEvent:event withParameters:TWXAnalytics.sharedInstance.eventParameters];
#endif //USE_FLURRY
}

+ (void)logEvent:(NSString *)event withParameters:(NSMutableDictionary *)parameters
{
   if (!event.length)
      return;
    if (!parameters)
        parameters = NSMutableDictionary.new;
   [parameters addEntriesFromDictionary:TWXAnalytics.sharedInstance.eventParameters];
#if USE_FLURRY
   [Flurry logEvent:event withParameters:parameters];
#endif //USE_FLURRY
}

+ (void)logEvent:(NSString *)event timed:(BOOL) __unused timed
{
   if (!event.length)
      return;
#if USE_FLURRY
   [Flurry logEvent:event withParameters:TWXAnalytics.sharedInstance.eventParameters timed:timed];
#endif //USE_FLURRY
}

+ (void)endTimedEvent:(NSString *)event
{
    if (!event.length)
        return;
#if USE_FLURRY
    [Flurry endTimedEvent:event withParameters:nil];
#endif //USE_FLURRY
}

+ (void)logException:(NSString *) __unused errorID message:(NSString *) __unused message exception:(NSException *) __unused exception
{
#if USE_FLURRY
   [Flurry logError:errorID message:message exception:exception];
#endif //USE_FLURRY
}

+ (void)logError:(NSString *) __unused errorID message:(NSString *) __unused message error:(NSError *) __unused error
{
#if USE_FLURRY
   [Flurry logError:errorID message:message error:error];
#endif //USE_FLURRY
}

- (void)trackIAP:(NSString __unused *)product withPrice:(NSString __unused *)price
{
#if USE_APPSFLYER
    twlog("AppsFlyer Event: %@ eventValue: %@", product, price);
    //[AppsFlyer notifyAppID:[self appsFlyerAppID] event:product eventValue:price];
    [AppsFlyerTracker.sharedTracker trackEvent:product withValue:price];
#endif //USE_APPSFLYER
}

- (id)init
{
	self = super.init;
	if (self)
    {
        NSString *langID = (NSLocale.preferredLanguages)[0];
        self.eventParameters = @{
            @"Device": UIDevice.currentDevice.model,
            @"OS": UIDevice.currentDevice.systemVersion,
            @"Language": langID};
    }
	return self;
}

- (void)startSession
{
#if POSESPRO
//NSString *testFlightApplicationToken = @"b5279e0d-fdc8-4d3a-9915-a8eb5644ee40";
    NSString *crashlyticsAPIKey = @"186ef2a41f30e2ce39a21f35b61600d3ae927290";
    NSString *flurryAPIKey = @"H9PNAMTQG6YGDRBCM5ZH";
#elif POSESSAMPLER
//NSString *testFlightApplicationToken = @"b74b7aa8-8d34-4249-a4d9-49d781090c6a";
//NSString *crashlyticsAPIKey = @"xxxxxxxx";
    NSString *flurryAPIKey = @"S22CH58IG7J2H2NF31FG";
#else
#error What application is this?
#endif //POSESPRO
    
    if (NSClassFromString(@"ASIdentifierManager"))
    {
        self.appleIDFA = ASIdentifierManager.sharedManager.advertisingIdentifier.UUIDString;
        //twlog("Your Apple IDFA: %@", self.appleIDFA);
    }
    
    if ([UIDevice.currentDevice respondsToSelector:@selector(identifierForVendor)])
    {
        self.appleIDFV = UIDevice.currentDevice.identifierForVendor.UUIDString;
        //twlog("Your Apple IDFV: %@", self.appleIDFV);
    }
    
#if USE_CRASHLYTICS
        [Crashlytics startWithAPIKey:crashlyticsAPIKey delegate:self];
#endif //USE_CRASHLYTICS
    
#if USE_TESTFLIGHT
    //[TestFlight setOptions:@{TFOptionAttachBacktraceToFeedback:@YES}];
    [TestFlight takeOff:testFlightApplicationToken];
#endif //USE_TESTFLIGHT

#if USE_FLURRY
    //#if DEBUG
    //#warning Flurry console logging is *very* verbosely annoying
    //[Flurry setDebugLogEnabled:YES];
    //[Flurry setShowErrorInLogEnabled:YES];
    //#endif //DEBUG
    [Flurry setSessionReportsOnCloseEnabled:YES];
    [Flurry setSessionReportsOnPauseEnabled:YES];
    [Flurry setCrashReportingEnabled:NO];
    [Flurry startSession:flurryAPIKey];
    //twlog("Flurry version %@ session started with api key %@", Flurry.getFlurryAgentVersion, flurryAPIKey);
#endif //USE_FLURRY

#if USE_TAPSTREAM
    TSConfig *config = [TSConfig configWithDefaults];
    config.collectWifiMac = NO; // deprecated in iOS 7
    //config.odin1 = @"<ODIN-1 value goes here>";
    //config.udid = [[UIDevice currentDevice] uniqueIdentifier]; // illegal in store
    config.idfa = [[[ASIdentifierManager sharedManager] advertisingIdentifier] UUIDString];
    //config.openUdid = @"<OpenUDID value goes here>";
    //config.secureUdid = @"<SecureUDID value goes here>";
    [TSTapstream createWithAccountName:@"trollwerks" developerSecret:@"l9PDGbzOSCmBZWakiI9vKQ" config:config];
#endif //USE_TAPSTREAM

#if USE_APPSFLYER
    NSLocale *theLocale = [NSLocale currentLocale];
    NSString *currencyCode = [theLocale objectForKey:NSLocaleCurrencyCode];
    twlog("currency code: %@",currencyCode);
    //[AppsFlyerTracker setCurrencyCode:currencyCode];
    self.appsFlyerUID = [AppsFlyerTracker.sharedTracker getAppsFlyerUID];
    twlog("Your AppsFlyer UID: %@", self.appsFlyerUID);
    AppsFlyerTracker.sharedTracker.currencyCode = currencyCode;
    AppsFlyerTracker.sharedTracker.customerUserID = openUDID;
    AppsFlyerTracker.sharedTracker.appsFlyerDevKey = self.appFlyerDevKey;
    AppsFlyerTracker.sharedTracker.appleAppID = AppDelegate().stringForAppID;
    // other settings: isHTTPS, isDebug, deviceTrackingDisabled
#endif //USE_APPSFLYER
}

- (void)activateSession
{
    [TWXAnalytics logEvent:@"activateSession"];
}

#pragma mark - CrashlyticsDelegate

#if USE_CRASHLYTICS

/**
 *
 * Just like crashlyticsDidDetectCrashDuringPreviousExecution this delegate method is
 * called once a Crashlytics instance has determined that the last execution of the
 * application ended in a crash. A CLSCrashReport is passed back that contains data about
 * the last crash report that was generated. See the CLSCrashReport protocol for method details.
 * This method is called after crashlyticsDidDetectCrashDuringPreviousExecution.
 *
 **/
- (void)crashlytics:(Crashlytics *)crashlytics didDetectCrashDuringPreviousExecution:(id <CLSCrashReport>)crash
{
    twlog("Crashlytics %@ didDetectCrashDuringPreviousExecution:\n%@", crashlytics, crash);
}

#endif //USE_CRASHLYTICS

@end
