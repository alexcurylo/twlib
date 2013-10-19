//
//  TWXAnalytics.h
//
//  Copyright (c) 2013 Trollwerks Inc. All rights reserved.
//

@interface TWXAnalytics : NSObject

@property (nonatomic, copy) NSString *appleIDFA;
@property (nonatomic, copy) NSString *appleIDFV;

+ (TWXAnalytics *)sharedInstance;

- (void)startSession;
- (void)activateSession;

+ (void)logEvent:(NSString *)event;
+ (void)logEvent:(NSString *)event withParameters:(NSMutableDictionary *)parameters;
+ (void)logEvent:(NSString *)event timed:(BOOL)timed;
+ (void)endTimedEvent:(NSString *)event;
+ (void)logException:(NSString *)errorID message:(NSString *)message exception:(NSException *)exception;
+ (void)logError:(NSString *)errorID message:(NSString *)message error:(NSError *)error;

- (void)trackIAP:(NSString *)product withPrice:(NSString *)price;

@end
