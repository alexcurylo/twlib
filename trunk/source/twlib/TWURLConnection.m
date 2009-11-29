/*
File: TWURLConnection.m

Abstract: A Class encapsulating the asynchronous loading functionality of NSURLConnection.

Version: 1.0

Disclaimer: IMPORTANT:  This Apple software is supplied to you by Apple, 
Inc. ("Apple") in consideration of your agreement to the
following terms, and your use, installation, modification or
redistribution of this Apple software constitutes acceptance of these
terms.  If you do not agree with these terms, please do not use,
install, modify or redistribute this Apple software.

In consideration of your agreement to abide by the following terms, and
subject to these terms, Apple grants you a personal, non-exclusive
license, under Apple's copyrights in this original Apple software (the
"Apple Software"), to use, reproduce, modify and redistribute the Apple
Software, with or without modifications, in source and/or binary forms;
provided that if you redistribute the Apple Software in its entirety and
without modifications, you must retain this notice and the following
text and disclaimers in all such redistributions of the Apple Software. 
Neither the name, trademarks, service marks or logos of Apple,
Inc. may be used to endorse or promote products derived from the Apple
Software without specific prior written permission from Apple.  Except
as expressly stated in this notice, no other rights or licenses, express
or implied, are granted by Apple herein, including but not limited to
any patent rights that may be infringed by your derivative works or by
other works in which the Apple Software may be incorporated.

The Apple Software is provided by Apple on an "AS IS" basis.  APPLE
MAKES NO WARRANTIES, EXPRESS OR IMPLIED, INCLUDING WITHOUT LIMITATION
THE IMPLIED WARRANTIES OF NON-INFRINGEMENT, MERCHANTABILITY AND FITNESS
FOR A PARTICULAR PURPOSE, REGARDING THE APPLE SOFTWARE OR ITS USE AND
OPERATION ALONE OR IN COMBINATION WITH YOUR PRODUCTS.

IN NO EVENT SHALL APPLE BE LIABLE FOR ANY SPECIAL, INDIRECT, INCIDENTAL
OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
INTERRUPTION) ARISING IN ANY WAY OUT OF THE USE, REPRODUCTION,
MODIFICATION AND/OR DISTRIBUTION OF THE APPLE SOFTWARE, HOWEVER CAUSED
AND WHETHER UNDER THEORY OF CONTRACT, TORT (INCLUDING NEGLIGENCE),
STRICT LIABILITY OR OTHERWISE, EVEN IF APPLE HAS BEEN ADVISED OF THE
POSSIBILITY OF SUCH DAMAGE.

Copyright ¬© 2007 Apple Inc., All Rights Reserved

*/

#import "TWURLConnection.h"

/*!
 * @abstract Status of TWURLConnection.
 */
enum
{
	DRInit = 1,
	DRLoading,
	DRFinished,
	DRCancelled
};

// helpers for form creation
static NSString* kFormBoundary = @"0xKhTmLbOuNdArY";
static NSString* kFormContentDisposition = @"Content-Disposition: form-data; ";
static NSString* kFormContentData = @"Content-Type: application/octet-stream\r\n\r\n";

/*!
 * @abstract Private routines.
 */
@interface TWURLConnection(Private)
- (void)notifyDidFinish;
- (void)setError:(NSError*)error;
@end

@implementation TWURLConnection

- (id)initWithURL:(NSURL*)aURL delegate:(id)delegate
{
	self = [super init];
	
	if (self == nil) return nil;
	
	fStatus = DRLoading;
	fURL = [aURL copy];
   fURLRequest = [[NSMutableURLRequest requestWithURL:fURL 
                                         cachePolicy:NSURLRequestReloadIgnoringCacheData  
                                     timeoutInterval:30.0] retain];
	fReceived = [NSMutableData new];
	fError = nil;
	fDelegate = delegate;
	fLock = [NSRecursiveLock new];
	fConnection = nil;
	
	return self;
}

- (void) dealloc
{
	//cancel it if we are loading.
	[fLock lock];
	if (fStatus == DRLoading) [self cancel];
	[fLock unlock];
	
	if (fURL) [fURL release];
	if (fURLRequest) [fURLRequest release];
	if (fMultipartData) [fMultipartData release];
	if (fReceived) [fReceived release];
	if (fError) [fError release];
	if (fLock) [fLock release];
	if (fConnection) [fConnection release];
	
	[super dealloc];
}

- (void)startLoading
{
	[fLock lock];
	
	fStatus = DRLoading;
	fConnection = [[NSURLConnection alloc] 
					initWithRequest:fURLRequest
					delegate:self];
	[fLock unlock];
}

- (void)cancel
{
	[fLock lock];
	
	//return right away if we are not loading.
	if (fStatus != DRLoading) {
		[fLock unlock];
		return;
	}
	
	fStatus = DRCancelled;
	
	if (fConnection) [fConnection cancel];
	[fReceived setLength:0];
	
	[fLock unlock];
}

- (NSData*)receivedData
{
	return fReceived;
}

- (NSURL*)url
{
	return fURL;
}


- (NSMutableURLRequest*)urlRequest
{
   return fURLRequest;
}

- (NSError*)lastError
{
	return fError;
}

// additions for manipulating URLRequest ...alex

- (void)startFormPOST
{
   [fURLRequest setHTTPMethod: @"POST"];

	NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@", kFormBoundary];
	[fURLRequest addValue:contentType forHTTPHeaderField: @"Content-Type"];

	fMultipartData = [[NSMutableData data] retain];
}

- (void)appendFormFieldString:(NSString*)field string:(NSString*)value
{
   [self appendFormBreak];

   NSString* formText = [NSString stringWithFormat:@"%@name=\"%@\"\r\n\r\n%@",
      kFormContentDisposition,
      field,
      value
   ];
	[fMultipartData appendData:[formText dataUsingEncoding:NSUTF8StringEncoding]];
   // we could use NSISOLatin1StringEncoding here
   // if for some reason postemail.php breaks when replacing
   //"Content-Type: text/plain; charset=\"iso-8859-1\"\n" .
   // with
   //"Content-Type: text/plain; charset=utf-8\n" .

   [self appendLineBreak];
}

- (void)appendFormFieldFile:(NSString*)field filename:(NSString*)name data:(NSData*)value
{
   [self appendFormBreak];

   NSString* formText = [NSString stringWithFormat:@"%@name=\"%@\"; filename=\"%@\"\r\n%@",
      kFormContentDisposition,
      field,
      name,
      kFormContentData
   ];
	[fMultipartData appendData:[formText dataUsingEncoding:NSUTF8StringEncoding]];
	[fMultipartData appendData:value];

   [self appendLineBreak];
}

- (void)completeFormPOST
{
   [self appendFormBreak];
   [fMultipartData appendData:[@"--" dataUsingEncoding:NSUTF8StringEncoding]];
   [self appendLineBreak];

	[fURLRequest setHTTPBody:fMultipartData];
}

- (void)appendFormBreak // should be called by appendFormFieldXXX:
{
   NSString* formBreak = [NSString stringWithFormat:@"--%@", kFormBoundary];
	[fMultipartData appendData:[formBreak dataUsingEncoding:NSUTF8StringEncoding]];
   [self appendLineBreak];
}

- (void)appendLineBreak // should be called by appendFormFieldXXX: and appendFormBreak:
{
   [fMultipartData appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
}

/////////// NSURLConnection delegate functions //////////////////////////

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
   (void)connection;

	[fLock lock];
	
	NSAssert(fStatus == DRLoading, @"I should be loadiing.");
	[fReceived appendData:data];
	[fLock unlock];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
   (void)connection;

	[fLock lock];
	NSAssert(fStatus != DRFinished, @"Why am I here if I already finished.");
	fStatus = DRFinished;
	[fReceived setLength:0];
	[self setError:error];
	[self notifyDidFinish];
	[fLock unlock];
}

- (void)connection:(NSURLConnection *)connection 
   didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge
{
   (void)connection;
   (void)challenge;

	[fLock lock];
	NSAssert(fStatus != DRFinished, @"Why am I here if I already finished.");
	[fConnection cancel];
	fStatus = DRFinished;
	[fReceived setLength:0];
	[self setError:nil];
	[self notifyDidFinish];
	[fLock unlock];
}

- (NSURLRequest *)connection:(NSURLConnection *)connection 
             willSendRequest:(NSURLRequest *)request
            redirectResponse:(NSURLResponse *)redirectResponse
{
   (void)connection;
   (void)redirectResponse;
	return request;
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
   (void)connection;
   
	[fLock lock];
	NSAssert(fStatus != DRFinished, @"Why am I here if I already finished.");
	fStatus = DRFinished;
	[self setError:nil];
	[self notifyDidFinish];
	[fLock unlock];
}

/////////////// Private Routines //////////////////

- (void)notifyDidFinish {
	//notify the delegate.
	if (fDelegate && [fDelegate respondsToSelector:@selector(TWURLConnectionDidFinish:)])
		[fDelegate performSelector:@selector(TWURLConnectionDidFinish:) withObject:self];
 }


- (void)setError:(NSError*)error {
	if (fError) [fError release];
	if (error) 
		fError = [error retain];
	else
		fError = nil;
}

@end
