//
//  TWEditTextTableViewCell.m
//
//  Copyright 2010 Trollwerks Inc. All rights reserved.
//

#import "TWEditTextTableViewCell.h"

// https://developer.apple.com/webapps/docs/documentation/AppleApplications/Reference/SafariWebContent/DesigningForms/DesigningForms.html
const int kPortraitKeyboardOffset = 216 - 49;

@implementation TWEditTextTableViewCell

@synthesize label;
@synthesize editable;
@synthesize previousText;
@synthesize delegate;

#pragma mark -
#pragma mark Life cycle

//- (id)initWithFrame:(CGRect)frame reuseIdentifier:(NSString *)reuseIdentifier
- (id)initWithStyle:(UITableViewCellStyle)style  reuseIdentifier:(NSString *)reuseIdentifier
{
    //if ( (self = [super initWithFrame:frame reuseIdentifier:reuseIdentifier]) )
    if ( (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) )
    {
       //self.selectionStyle = UITableViewCellSelectionStyleNone;

       self.label = [[[UITextField alloc] initWithFrame:CGRectMake(5, 10, 250, 28)] autorelease];
       self.label.font = [UIFont boldSystemFontOfSize:20];
       self.label.backgroundColor = [UIColor clearColor];
       //self.label.backgroundColor = [UIColor redColor];
       //self.label.textColor = [UIColor cyanColor];
       self.label.adjustsFontSizeToFitWidth = NO; //YES; 
       self.label.minimumFontSize = 8;
       self.label.clearButtonMode = UITextFieldViewModeWhileEditing;
       self.label.autocorrectionType = UITextAutocorrectionTypeDefault;
       self.label.autocapitalizationType = UITextAutocapitalizationTypeWords;
       self.label.keyboardType = UIKeyboardTypeASCIICapable;
       self.label.returnKeyType = UIReturnKeyDone;
       self.label.secureTextEntry = NO;
       self.label.delegate = self;

       [self.contentView addSubview:self.label];

       // no difference?
       //self.contentView.backgroundColor = [UIColor clearColor];
       // yikes, this turns them black?
       //self.backgroundColor = [UIColor clearColor];
       // no effect?
       //self.backgroundView.backgroundColor = [UIColor clearColor];
       //self.backgroundColor = [UIColor lightGrayColor];

       // Background Image
       // http://blog.urbanapps.com/post/366385398/how-to-make-custom-drawn-gradient-backgrounds-in-a
       self.backgroundView = [[[UACellBackgroundView alloc] initWithFrame:CGRectZero] autorelease];
}
   return self;
}

- (void)dealloc
{
	twrelease(label);
	twrelease(previousText);
   
   [super dealloc];
}

- (void)setPosition:(UACellBackgroundViewPosition)newPosition
{	
   [(UACellBackgroundView *)self.backgroundView setPosition:newPosition];
}

- (void)setHasNextField:(BOOL)hasNext
{
   if (hasNext)
      self.label.returnKeyType = UIReturnKeyNext;
   else
      self.label.returnKeyType = UIReturnKeyDone;
}

#pragma mark -
#pragma mark Editability management
   
- (void)setEditable:(BOOL)isEditable
{
   editable = isEditable;
   /*
   if (isEditable)
   {
   // editable color borrowed from nottoobadsoftware's mySettings project
      self.label.textColor = [UIColor colorWithRed:0.192157f green:0.309804f blue:0.521569f alpha:1.f];
   }
   else
    */
   {
      self.label.textColor = [UIColor blackColor];
   }
}

- (void)startEditing
{
   [self.label becomeFirstResponder];
}

#pragma mark -
#pragma mark Text field support

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
   (void)textField;
   return self.editable;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
   [textField resignFirstResponder];
   return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
   self.previousText = textField.text;

   if (!self.delegate)
      return;
   
   // we'll always scroll to editing cell at top of keyboard
   // by moving cell to table bottom and table to top of keyboard
   //UITableView *owner = (UITableView *)self.superview;
   UITableView *owner = [self.delegate editCellOwner];

   //CGRect smallFrame = owner.frame;
   CGRect smallFrame = [self.delegate editCellOwnerNormalFrame];
   smallFrame.size.height -= kPortraitKeyboardOffset;
   
   [UIView beginAnimations:nil context:NULL];
   [UIView setAnimationBeginsFromCurrentState:YES];
   [UIView setAnimationDuration:0.3];
   [owner setFrame:smallFrame];
   [UIView commitAnimations];

   NSIndexPath *ourPath = [owner indexPathForCell:self];
	[owner scrollToRowAtIndexPath:ourPath atScrollPosition:UITableViewScrollPositionBottom animated:NO];
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
   (void)textField;
 
   if (!self.delegate)
      return;

   // reset table size, which will scroll or not as needed
   //UITableView *owner = (UITableView *)self.superview;
   UITableView *owner = [self.delegate editCellOwner];

   //CGRect normalFrame = owner.frame;
   //normalFrame.size.height += kPortraitKeyboardOffset;
   CGRect normalFrame = [self.delegate editCellOwnerNormalFrame];
 
   [UIView beginAnimations:nil context:NULL];
   [UIView setAnimationBeginsFromCurrentState:YES];
   [UIView setAnimationDuration:0.3];
   [owner setFrame:normalFrame];
   [UIView commitAnimations];

   /* no, we'll always tell delegate so autoforward works
    if ([textField.text isEqual:self.previousText])
      return;
    */
   
   [self.delegate textCellEdited:self];
 }

@end
