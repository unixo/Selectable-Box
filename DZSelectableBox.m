//
//  DZSelectableBox.m
//  SelectedBox
//
//  Created by unixo <unixo@devzero.it> on 13/12/09.
//  Copyright 2009 Ferruccio Vitale. All rights reserved.
//

#import "DZSelectableBox.h"


@implementation DZSelectableBox

@synthesize selectedBgColor;
@synthesize selectedBorderColor;
@synthesize radioGroup;

- (id) init
{
	if ((self = [super init])) {
		[self _setDefaultValues];
	}
	return self;
}

- (void) dealloc
{
	[[NSNotificationCenter defaultCenter] removeObserver:self];
	selectedBorderColor = nil;
	selectedBgColor = nil;
	[super dealloc];
}

- (void)awakeFromNib
{
    [self _setDefaultValues];
}

- (void) _setDefaultValues
{
	// By default, this box is not selected
	selected = NO;

	// Make border and background look like the box found in "iSync conflict"
	[self setFillColor:[NSColor colorWithCalibratedWhite:0.965 alpha:1.000]];	
	[self setBorderColor:[NSColor colorWithCalibratedRed:0.819 green:0.773 blue:0.813 alpha:1.000]];
	
	// Color of the inner border
	self.selectedBorderColor = [NSColor colorWithCalibratedRed:0.192 green:0.417 blue:0.884 alpha:1.000];
	// Color of the inner background
	self.selectedBgColor = [NSColor colorWithCalibratedRed:0.769 green:0.847 blue:0.950 alpha:1.000];
	// By default, this box is not part of any radio group
	self.radioGroup = [NSNumber numberWithInt:-1];
	
	_borderWidth = 10;
	_radius = 4.0;
	
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(_update:) 
												 name:DZSelectableBoxNotification 
											   object:nil];
}

- (void) _update:(NSNotification *)aNotification
{
	// If this notification was originated by this box or if this box is not
	// part of any radio group, ignore it!
	if (([aNotification object] == self) || ([self.radioGroup intValue] == -1))
		return;
	
	// Check if radio group contained in notification user info is equal to our
	NSNumber *num = [[aNotification userInfo] valueForKey:@"radioGroup"];
	if ([num intValue] != [self.radioGroup intValue])
		return;
	
	if (selected) {
		selected = NO;
		[self setNeedsDisplay:YES];
	}
}

- (void) _notifyRadioGroup
{
	NSDictionary *userInfo = [NSDictionary dictionaryWithObject:self.radioGroup forKey:@"radioGroup"];
	[[NSNotificationCenter defaultCenter] postNotificationName:DZSelectableBoxNotification
														object:self
													  userInfo:userInfo];
}

- (BOOL) selected
{
	return selected;
}

- (void) setSelected:(BOOL)aValue
{
	BOOL oldValue = selected;
	selected = aValue;
	if (oldValue != aValue) {
		[self setNeedsDisplay:YES];
		[self _notifyRadioGroup];
	}		
}

- (void)drawRect:(NSRect)dirtyRect
{	
	[super drawRect:dirtyRect];

	if (selected) {
		NSTitlePosition titlePos;
		NSRect bgRect = dirtyRect;
		
		if ((titlePos = [self titlePosition]) != NSNoTitle) {
			NSRect titleRect = [self titleRect];
			
			switch (titlePos) {
				case NSAtTop:
					bgRect.size.height -= titleRect.size.height - 2;
					break;
				case NSAboveTop:
					bgRect.size.height -= titleRect.size.height - 4;
					break;
				case NSBelowTop:
					bgRect.size.height -= titleRect.size.height - 3;
					break;
				case NSAtBottom:
					bgRect.origin.y += 6;
					bgRect.size.height -= 5;
					break;
				default:
					break;
			}
			bgRect = NSInsetRect(bgRect, 8, 8);
		} else {
			bgRect = NSInsetRect(bgRect, 4, 4);
		}
		
		NSBezierPath *bgPath = [NSBezierPath bezierPathWithRoundedRect:bgRect xRadius:_radius yRadius:_radius];
		[selectedBgColor set];
		[bgPath fill];		
		[selectedBorderColor set];
		[bgPath setLineWidth:2.0];
		[bgPath stroke];
	}
}

- (void) toggleState
{
	if ([radioGroup intValue] >= 0) {
		if (selected)
			return;
	}
	selected = !selected;
	[self setNeedsDisplay:YES];
	[self _notifyRadioGroup];
}

- (void)mouseDown:(NSEvent *)theEvent
{
	[self toggleState];
	[super mouseDown:theEvent];
}

@end
