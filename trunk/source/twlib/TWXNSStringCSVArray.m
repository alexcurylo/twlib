//
//  TWXNSStringCSVArray.m
//
//  Copyright Trollwerks Inc 2011. All rights reserved.
//
//  from NSString+CSVUtils.m
//

#import "TWXNSStringCSVArray.h"

@implementation NSString (TWXNSStringCSVArray)

- (NSMutableArray *)arrayByImportingCSV_line:(NSString*)theLine removeWhitespace:(BOOL)isRemoveWhitespace
{
  NSMutableArray* theArray = [NSMutableArray array];
  NSArray* theFields = [theLine componentsSeparatedByString:@","];
  NSCharacterSet* quotedCharacterSet = [NSCharacterSet characterSetWithCharactersInString:@"\""];
  BOOL inField = NO;
  NSMutableString* theConcatenatedField = [NSMutableString string];
  for (unsigned int i = 0; i < [theFields count]; i++)
  {
     NSString* theField = [theFields objectAtIndex:i];
     switch (inField)
     {
      case NO:
        if([theField hasPrefix:@"\""] == YES && [theField hasSuffix:@"\""] == NO)
        { 
          inField = YES;
          [theConcatenatedField appendString:theField];
          [theConcatenatedField appendString:@","];
        } else
        {
          if (isRemoveWhitespace)
            [theArray addObject:[theField stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]];
          else
            [theArray addObject:theField];            
        }
        break;
      case YES:
        [theConcatenatedField appendString:theField];
        if([theField hasSuffix:@"\""] == YES)
        {
          NSString* theTrimmedField = [theConcatenatedField stringByTrimmingCharactersInSet:quotedCharacterSet];
          if(isRemoveWhitespace)
            [theArray addObject:[theTrimmedField stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]];
          else
            [theArray addObject:theTrimmedField];            
          [theConcatenatedField setString:@""];
          inField = NO;
        } else
        {
          [theConcatenatedField appendString:@","];   
        }
        break;
     }
  }
  return theArray;
}

- (NSMutableArray *)arrayByImportingCSV
{
   NSMutableArray *resultArray = [NSMutableArray array];
   NSMutableArray *fieldsArray = nil;
   NSCharacterSet *lineCharacterSet = [NSCharacterSet characterSetWithCharactersInString:@"\r\n"];
   NSString *theLine = nil;
   NSScanner *theScanner = [NSScanner scannerWithString:self];

   while (NO == [theScanner isAtEnd])
   {
      [theScanner scanUpToCharactersFromSet:lineCharacterSet intoString:&theLine];
      
      // note: we're extending CSV format to put // comment lines in it
      if ([theLine hasPrefix:@"// "])
      {
         twlog("skipping line: %@", theLine);
         continue;
      }
      
      NSMutableArray *lineArray = [self arrayByImportingCSV_line:theLine removeWhitespace:YES];
      if (!fieldsArray)
         fieldsArray = lineArray; // first lineArray will presumably be the headings
      else
      {
         NSMutableDictionary *lineDictionary = [NSMutableDictionary dictionaryWithCapacity:fieldsArray.count];
         //twcheck(lineArray.count == fieldsArray.count);
         //for (unsigned int i = 0; i < fieldsArray.count; i++)
         // we'll account for lines with trimmed trailing commas ...alex
         NSUInteger lineMax = MIN(fieldsArray.count, lineArray.count);
         for (unsigned int i = 0; i < lineMax; i++)
         {
            NSString *key = [fieldsArray objectAtIndex:i];
            NSString *value = [lineArray objectAtIndex:i];
            [lineDictionary setObject:value forKey:key];
         }
         [resultArray addObject:lineDictionary];
      }
      //twlog("line %d: %@", resultArray.count, resultArray.lastObject);
   }
      
   return resultArray;
}

@end
