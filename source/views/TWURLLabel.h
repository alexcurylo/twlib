//
//  TWURLLabel.h
//
//  Copyright 2010 Trollwerks Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TWURLLabel : UILabel
{
   BOOL underlined;
}

@property (nonatomic, assign) BOOL underlined; 

- (id)initWithFrame:(CGRect)frame;
- (void)awakeFromNib;
- (void)configureDefaults;
- (void)dealloc;

- (void)drawTextInRect:(CGRect)rect;

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event;

@end
