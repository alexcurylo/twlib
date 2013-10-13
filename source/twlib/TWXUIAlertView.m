//
//  TWXUIAlertView.m
//
//  Copyright 2012 Trollwerks Inc. All rights reserved.
//

#import "TWXUIAlertView.h"

@implementation UIAlertView (TWXUIAlertView)

+ (UIAlertView *)twxUnimplementedAlert
{
   UIAlertView *alert = [UIAlertView
      twxOKAlert:@"UNDERCONSTRUCTION"
      withMessage:@"NOTIMPLEMENTEDYET"
   ];
   return alert;
}

+ (UIAlertView *)twxNoInternetAlert
{
   UIAlertView *alert = [UIAlertView
      twxOKAlert:@"NOINTERNETTITLE"
      withMessage:@"NOINTERNETMESSAGE"
   ];
   return alert;
}

+ (UIAlertView *)twxOKAlert:(NSString *)title withMessage:(NSString *)message
{
   UIAlertView *alert = [[UIAlertView alloc] 
      initWithTitle:NSLocalizedString(title, nil) 
      message:NSLocalizedString(message, nil) 
      delegate:nil 
      cancelButtonTitle:nil 
      otherButtonTitles:NSLocalizedString(@"OK", nil),
         nil
   ];
#if !__has_feature(objc_arc)
   [alert autorelease];
#endif //!__has_feature(objc_arc)
   [alert show];
   
   return alert;
}

+ (UIAlertView *)twxOKCancelAlert:(NSString *)title withMessage:(NSString *)message
{
   UIAlertView *alert = [[UIAlertView alloc] 
      initWithTitle:NSLocalizedString(title, nil) 
      message:NSLocalizedString(message, nil) 
      delegate:nil 
      cancelButtonTitle:NSLocalizedString(@"CANCEL", nil) 
      otherButtonTitles:NSLocalizedString(@"OK", nil),
         nil
   ];
#if !__has_feature(objc_arc)
   [alert autorelease];
#endif //!__has_feature(objc_arc)
   [alert show];
   
   return alert;
}

+ (UIAlertView *)twxYesNoAlert:(NSString *)title withMessage:(NSString *)message
{
   UIAlertView *alert = [[UIAlertView alloc] 
      initWithTitle:NSLocalizedString(title, nil) 
      message:NSLocalizedString(message, nil) 
      delegate:nil 
      cancelButtonTitle:NSLocalizedString(@"CANCEL", nil) 
      otherButtonTitles:NSLocalizedString(@"OK", nil),
         nil
   ];
#if !__has_feature(objc_arc)
   [alert autorelease];
#endif //!__has_feature(objc_arc)
   [alert show];

   return alert;
}

@end
