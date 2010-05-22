//
//  TWEditTextTableViewCell.h
//
//  Copyright 2010 Trollwerks Inc. All rights reserved.
//

#import "UACellBackgroundView.h"

@class TWEditTextTableViewCell;

@protocol TWEditTextCellDelegate <NSObject>

@required

- (UITableView *)editCellOwner;
- (CGRect)editCellOwnerNormalFrame;
- (void)textCellEdited:(TWEditTextTableViewCell *)cell;

@end

@interface TWEditTextTableViewCell : UITableViewCell <UITextFieldDelegate>
{
	UITextField *label;
   
   BOOL editable;

	NSString *previousText;
   
   id <TWEditTextCellDelegate> delegate;
}

@property (nonatomic, retain) UITextField *label;
@property (nonatomic, assign) BOOL editable;
@property (nonatomic, copy) NSString *previousText;
@property (nonatomic, assign) id <TWEditTextCellDelegate> delegate;

#pragma mark -
#pragma mark Life cycle

- (id)initWithStyle:(UITableViewCellStyle)style  reuseIdentifier:(NSString *)reuseIdentifier;
- (void)dealloc;

- (void)setPosition:(UACellBackgroundViewPosition)newPosition;
- (void)setHasNextField:(BOOL)hasNext;

#pragma mark -
#pragma mark Editability management

- (void)setEditable:(BOOL)isEditable;

- (void)startEditing;

#pragma mark -
#pragma mark Text field support

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField;
- (BOOL)textFieldShouldReturn:(UITextField *)textField;
- (void)textFieldDidBeginEditing:(UITextField *)textField;
- (void)textFieldDidEndEditing:(UITextField *)textField;

@end
