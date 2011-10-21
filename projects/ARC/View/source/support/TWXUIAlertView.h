//
//  TWXUIAlertView.h
//
//  Copyright (c) 2011 Trollwerks Inc. All rights reserved.
//

@interface UIAlertView (TWXUIAlertView)

+ (UIAlertView *)twxUnimplementedAlert;

+ (UIAlertView *)twxNoInternetAlert;

+ (UIAlertView *)twxOKAlert:(NSString *)title withMessage:(NSString *)message;

+ (UIAlertView *)twxOKCancelAlert:(NSString *)title withMessage:(NSString *)message;

+ (UIAlertView *)twxYesNoAlert:(NSString *)title withMessage:(NSString *)message;

@end

