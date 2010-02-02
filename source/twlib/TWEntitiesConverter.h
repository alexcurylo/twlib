//
//  TWEntitiesConverter.h
//
//  Copyright Trollwerks Inc 2009. All rights reserved.
//

@interface TWEntitiesConverter : NSObject
{
	NSMutableString *resultString;
}

@property (nonatomic, retain) NSMutableString* resultString;

- (id)init;
- (void)dealloc;

- (NSString*)convertEntitiesInString:(NSString*)s;

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)s;

@end
