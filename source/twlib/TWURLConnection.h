/*
File: TWURLConnection.h

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

Copyright URLDataReceiver.h ¬© 2007 Apple Inc., All Rights Reserved

*/ 

//#import <Cocoa/Cocoa.h>

/*!
 * @abstract Load data from a URL.
 *
 * This class asynchronously load data from a URL using NSURLConnection.
 */
@interface TWURLConnection : NSObject 
{
	int fStatus;
	NSURL* fURL;

   // for POSTing forms
   NSMutableURLRequest* fURLRequest;
	NSMutableData* fMultipartData; /**< Sent data */

	NSMutableData* fReceived; /**< Received data */
	NSError* fError; /**< Last error if an error occurs during loading.*/
	id fDelegate;
	NSRecursiveLock* fLock;
	NSURLConnection* fConnection;
}

/*!
 * delegate must conform to TWURLConnectionDelegate protocol.
 */
- (id)initWithURL:(NSURL*)aURL delegate:(id)delegate;

/*!
 * @abstract Start loading data.
 */
- (void)startLoading;

/*!
 * @abstract Cancel data loading.
 *
 * It does nothing, if it is not currently loading.
 * Cacelling will reset the data that has been received.
 */
- (void)cancel;

/*!
 * @abstract return received data.
 *
 * Return nil if the loading failed or encountered any errors.
 */
- (NSData*)receivedData;


- (NSURL*)url;
- (NSMutableURLRequest*)urlRequest;

/*!
 * @abstract Return last error.
 *
 * @note The return value can be nil, which indicates a successful load.
 */
- (NSError*)lastError;

// additions for manipulating URLRequest ...alex

- (void)startFormPOST; // must call before adding pieces
- (void)appendFormFieldString:(NSString*)field string:(NSString*)value;
- (void)appendFormFieldFile:(NSString*)field filename:(NSString*)name data:(NSData*)value;
- (void)completeFormPOST; // must call to set body

- (void)appendFormBreak; // should be called by appendFormFieldXXX:
- (void)appendLineBreak; // should be called by appendFormFieldXXX: and appendFormBreak:

@end


/*!
 * @abstract TWURLConnectionDelegate protocol.
 */
@interface NSObject(TWURLConnectionDelegate)
/*!
 * @abstract Notify delegate that loading has finished.
 *
 * The delegate can use lastError to query if there is any error.
 */
- (void)TWURLConnectionDidFinish:(TWURLConnection*)dataReceiver;
@end
