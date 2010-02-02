//
//  TWURLFetcher.h
//
//  Copyright 2009 Trollwerks Inc. All rights reserved.
//

/* use like
 
 NSMutableData *featuredFeedData;
 @property (nonatomic, retain) NSMutableData *featuredFeedData;
 - (void)fetchedFeaturedFeed:(TWURLFetcher *)fetcher;

 TWURLFetcher *featuredFetcher = [TWURLFetcher urlFetcher:featuredFeed target:self selector:@selector(fetchedFeaturedFeed:)];
 twcheck(featuredFetcher); (void)featuredFetcher;

 - (void)fetchedFeaturedFeed:(TWURLFetcher *)fetcher
 {
 if (!fetcher.succeeded)
 {
 twlog("loading featuredFeedData RSS FAIL!");
 self.featuredFeedData = nil;
 return;
 }
 
 self.featuredFeedData = fetcher.connectionData;
 //twlog("loading featuredFeedData RSS WIN %s!", self.featuredFeedData.bytes);
 
 [[NSNotificationCenter defaultCenter]
 postNotificationName:kFeaturedRSSFeedNotification
 object:self
 userInfo:nil
 ];
 }
 
 */

@interface TWURLFetcher : NSObject
{
   NSString *requestString;
   NSMutableURLRequest *request;
   NSURLConnection *connection;
   NSMutableData *connectionData;
   
   id completionTarget;
   SEL completionSelector;
   // - (void)completionMethod:(TWURLFetcher *)fetcher

   BOOL succeeded;
}

@property (nonatomic, copy) NSString *requestString;
@property (nonatomic, retain) NSMutableURLRequest *request;
@property (nonatomic, retain) NSURLConnection *connection;
@property (nonatomic, retain) NSMutableData *connectionData;
@property (nonatomic, assign) BOOL succeeded;

#pragma mark -
#pragma mark Utilities


+ (TWURLFetcher *)urlFetcher:(NSString *)urlLink target:(id)target selector:(SEL)selector;

#pragma mark -
#pragma mark Life cycle

- (id)initWithRequestString:(NSString *)urlLink target:(id)target selector:(SEL)selector;

- (void)dealloc;

#pragma mark -
#pragma mark NSURLConnectionDelegate

- (void)connection:(NSURLConnection *)connect didReceiveData:(NSData *)data;
- (void)connectionDidFinishLoading:(NSURLConnection *)connect;
- (void)connection:(NSURLConnection *)connect didFailWithError:(NSError *)error;

- (void)completeAndRelease;

@end
