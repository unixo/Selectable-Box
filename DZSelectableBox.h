//
//  DZSelectableBox.h
//  SelectedBox
//
//  Created by unixo <unixo@devzero.it> on 13/12/09.
//  Copyright 2009 Ferruccio Vitale. All rights reserved.
//

#import <Cocoa/Cocoa.h>

#define	DZSelectableBoxNotification		@"DZSelectableBoxNotification"

@interface DZSelectableBox : NSBox {
	NSColor *selectedBorderColor;
	NSColor *selectedBgColor;
	NSNumber *radioGroup;
	BOOL selected;
@private
	float _borderWidth;
	float _radius;
}
@property (nonatomic, retain) NSColor *selectedBorderColor;
@property (nonatomic, retain) NSColor *selectedBgColor;
@property (nonatomic, retain) NSNumber *radioGroup;

- (BOOL) selected;
- (void) setSelected:(BOOL)aValue;
- (void) toggleState;

- (void) _setDefaultValues;
@end
