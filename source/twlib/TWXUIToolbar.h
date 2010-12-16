//
//  TWXUIToolbar.h
//
//  Copyright 2010 Trollwerks Inc. All rights reserved.
//

@interface UIToolbar (TWXUIToolbar)

// setting tintColor to clearColor will noop out drawRect & drawLayer:inContext:
+ (void)load;

- (void)makeTransparent:(UIBarStyle)buttonStyle;

@end

