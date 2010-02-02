//
//  TWURLFetcher.m
//
//  Copyright 2009 Trollwerks Inc. All rights reserved.
//

#import "TWURLFetcher.h"

@implementation TWURLFetcher

@synthesize requestString;
@synthesize request;
@synthesize connection;
@synthesize connectionData;
@synthesize succeeded;
//@synthesize resultDictionary;

#pragma mark -
#pragma mark Utilities


+ (TWURLFetcher *)urlFetcher:(NSString *)urlLink target:(id)target selector:(SEL)selector
{
   if (!urlLink || !urlLink.length)
      return nil;
   
	TWURLFetcher *fetcher = [[TWURLFetcher alloc] initWithRequestString:urlLink target:target selector:selector];
   twcheck(fetcher);
   return fetcher;
}

#pragma mark -
#pragma mark Life cycle

 - (id)initWithRequestString:(NSString *)urlLink target:(id)target selector:(SEL)selector
{
   if ( (self = [super init]) )
   {
      completionTarget = target;
      twcheck(completionTarget);
      completionSelector = selector;
      twcheck(completionSelector);

      self.requestString = urlLink;
      twcheck(self.requestString);
      //self.request = [NSURLRequest requestWithURL:[NSURL URLWithString:urlLink]];
      NSURL* theURL = [NSURL URLWithString:urlLink];
      self.request = [NSMutableURLRequest requestWithURL:theURL
         cachePolicy:NSURLRequestReloadIgnoringCacheData
         timeoutInterval:180
      ];
      twcheck(self.request);
      self.connection = [NSURLConnection connectionWithRequest:self.request delegate:self];
      twcheck(self.connection);
   }
   return self;
}

- (void)dealloc
{
   //twlog("TWURLFetcher dealloc");
   completionTarget = nil;
   completionSelector = nil;
   self.requestString = nil;
   self.request = nil;
   self.connection = nil;
   self.connectionData = nil;
   //self.resultDictionary = nil;
  
   [super dealloc];
}

#pragma mark -
#pragma mark NSURLConnectionDelegate

- (void)connection:(NSURLConnection *)connect didReceiveData:(NSData *)data
{
   (void)connect;
   
   if (nil == self.connectionData)
   {
      self.connectionData = [NSMutableData data];
      [self.connectionData setLength:0];
   }
   [self.connectionData appendData:data];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connect
{
   (void)connect;

   /*
   NSString *resultString = [[NSString alloc] initWithData:self.connectionData encoding:NSUTF8StringEncoding];
   NSData *jsonData = [resultString dataUsingEncoding:NSUTF32BigEndianStringEncoding];
   
	NSError *error = nil;
   self.resultDictionary = [[CJSONDeserializer deserializer] deserializeAsDictionary:jsonData error:&error];
   twlogif(nil != error, "TWURLFetcher deserialize FAIL for query: %@\ndeserializeAsDictionary error: %@", self.requestString, error);
   */
   
   succeeded = YES;
   
   [self completeAndRelease];
}

- (void)connection:(NSURLConnection *)connect didFailWithError:(NSError *)error
{
   (void)connect;
   (void)error;
   
   twlog("TWURLFetcher connection FAIL for query: %@", self.requestString);
   
   succeeded = NO;
   
   [self completeAndRelease];
}

- (void)completeAndRelease
{
   if (completionTarget)
      [completionTarget performSelector:completionSelector withObject:self];
   
   [self release];
}

@end
