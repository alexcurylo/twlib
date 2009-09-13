//
//  TWXNSWindow.m
//
//  Copyright 2009 Trollwerks Inc. All rights reserved.
//

#import "TWXNSWindow.h"

@implementation NSWindow (TWXNSWindow)

- (void)twxShowErrorSheet:(NSString *)message
{
   [self twxShowErrorSheet:message withInfo:nil];
}

- (void)twxShowErrorSheet:(NSString *)message withInfo:(NSString *)info
{
   NSAlert* alert = [[[NSAlert alloc] init] autorelease];
   [alert setAlertStyle:NSCriticalAlertStyle];
   [alert setMessageText:NSLocalizedString(message, nil)];
   if (info)
      [alert setInformativeText:NSLocalizedString(info, nil)];
   [alert beginSheetModalForWindow:self
      modalDelegate:self
      didEndSelector:@selector(twxErrorAlertDidEnd:returnCode:contextInfo:)
      contextInfo:nil
    ];
}

- (void)twxErrorAlertDidEnd:(NSAlert*)alert returnCode:(int)returnCode contextInfo:(void*)info
{
   (void)returnCode;
   (void)info;
   
	[[alert window] orderOut:self];
}

@end
