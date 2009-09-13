//
//  TWXNSWindow.h
//
//  Copyright 2009 Trollwerks Inc. All rights reserved.
//

@interface NSWindow (TWXNSWindow)

- (void)twxShowErrorSheet:(NSString *)message;
- (void)twxShowErrorSheet:(NSString *)message withInfo:(NSString *)info;

- (void)twxErrorAlertDidEnd:(NSAlert*)alert returnCode:(int)returnCode contextInfo:(void*)info;

@end
