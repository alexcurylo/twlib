//
//  TWEntitiesConverter.m
//
//  Copyright Trollwerks Inc 2009. All rights reserved.
//

#import "TWEntitiesConverter.h"

@implementation TWEntitiesConverter

@synthesize resultString;

- (id)init
{
	if ( (self = [super init]) )
   {
		self.resultString = [NSMutableString string];
	}
	return self;
}

- (void)dealloc
{
	twrelease(resultString);
   
	[super dealloc];
}

- (NSString*)convertEntitiesInString:(NSString*)s
{
	// special cases it apparently misses
   s = [s stringByReplacingOccurrencesOfString:@"&reg;" withString:@"®"];

   NSString* xmlStr = [NSString stringWithFormat:@"<d>%@</d>", s];
	NSData *data = [xmlStr dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
	NSXMLParser* xmlParse = [[[NSXMLParser alloc] initWithData:data] autorelease];
	[xmlParse setDelegate:self];
	[xmlParse parse];

	NSString* returnStr = [[[NSString alloc] initWithFormat:@"%@", self.resultString] autorelease];
 	self.resultString = nil;
	return returnStr;
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)s
{
   (void)parser;
   
   [self.resultString appendString:s];
}

@end
