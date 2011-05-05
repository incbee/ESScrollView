//
//  ESiTunesScroller.m
//  ScrollBar
//
//  Created by Jonathan on 06/06/2008.
//  Copyright 2008 EspressoSoft. All rights reserved.
//

#import "ESiTunesScroller.h"

enum {
	ESScrollerArrowsTogether = 0,
	ESScrollerArrowsApart = 1,
};
typedef NSUInteger ESScrollerArrowsSetting;

@interface ESiTunesScroller ()
@property(retain) NSGradient *knobSlotGradient;
@property(retain) NSGradient *activeKnobGradient;
@property(retain) NSGradient *inactiveKnobGradient;
@property(retain) NSGradient *activeButtonGradient;
@property(retain) NSGradient *highlightButtonGradient;
@property(retain) NSGradient *inactiveButtonGradient;
@property(retain) NSGradient *activeArrowGradient;
@property(retain) NSGradient *inactiveArrowGradient;
@property(retain) NSColor *activeKnobOutlineColor;
@property(retain) NSColor *inactiveKnobOutlineColor;
@property(retain) NSColor *activeLineColor;
@property(retain) NSColor *highlightLineColor;
@property(retain) NSColor *inactiveLineColor;
@property(readonly) BOOL isActive;
@property(readonly) BOOL isVertical;
@property(readonly) CGFloat fillAngle;
@property(readonly) ESScrollerArrowsSetting arrowsSetting;
- (void)drawTopSection;
- (void)drawButtonSeparatorWithHighlight:(BOOL)highlight;
@end

@implementation ESiTunesScroller
@synthesize knobSlotGradient = _knobSlotGradient;
@synthesize activeKnobGradient = _activeKnobGradient;
@synthesize inactiveKnobGradient = _inactiveKnobGradient;
@synthesize activeButtonGradient = _activeButtonGradient;
@synthesize highlightButtonGradient = _highlightButtonGradient;
@synthesize inactiveButtonGradient = _inactiveButtonGradient;
@synthesize activeArrowGradient = _activeArrowGradient;
@synthesize inactiveArrowGradient = _inactiveArrowGradient;
@synthesize activeKnobOutlineColor = _activeKnobOutlineColor;
@synthesize inactiveKnobOutlineColor = _inactiveKnobOutlineColor;
@synthesize activeLineColor = _activeLineColor;
@synthesize highlightLineColor = _highlightLineColor;
@synthesize inactiveLineColor = _inactiveLineColor;
@dynamic isActive;
@dynamic isVertical;
@dynamic fillAngle;
@dynamic arrowsSetting;

- (id)initWithFrame:(NSRect)frame;
{
	if (![super initWithFrame:frame])
		return nil;
	self.knobSlotGradient = [[[NSGradient alloc] initWithColorsAndLocations:[NSColor colorWithCalibratedWhite:0.6 alpha:1.0],0.0,[NSColor colorWithCalibratedWhite:0.8 alpha:1.0],0.1,[NSColor colorWithCalibratedWhite:0.92 alpha:1.0],0.25,[NSColor colorWithCalibratedWhite:0.95 alpha:1.0],0.67,[NSColor colorWithCalibratedWhite:0.92 alpha:1.0],0.85,[NSColor colorWithCalibratedWhite:0.88 alpha:1.0],1.0,nil] autorelease];
	self.activeKnobGradient = [[[NSGradient alloc] initWithColorsAndLocations:[NSColor colorWithCalibratedRed:0.604 green:0.663 blue:0.745 alpha:1.0],0.0,[NSColor colorWithCalibratedRed:0.373 green:0.447 blue:0.569 alpha:1.0],1.0,nil] autorelease];
	self.inactiveKnobGradient = [[[NSGradient alloc] initWithColorsAndLocations:[NSColor colorWithCalibratedRed:0.89 green:0.89 blue:0.89 alpha:1.0],0.0,[NSColor colorWithCalibratedRed:0.684 green:0.688 blue:0.688 alpha:1.0],1.0,nil] autorelease];
	self.activeButtonGradient = [[[NSGradient alloc] initWithColorsAndLocations:[NSColor colorWithCalibratedRed:0.93 green:0.93 blue:0.93 alpha:1.0],0.0,[NSColor colorWithCalibratedRed:0.671 green:0.671 blue:0.671 alpha:1.0],1.0,nil] autorelease];
	self.highlightButtonGradient = self.activeKnobGradient;
	self.inactiveButtonGradient = [[[NSGradient alloc] initWithColorsAndLocations:[NSColor colorWithCalibratedRed:0.90 green:0.90 blue:0.90 alpha:1.0],0.0,[NSColor colorWithCalibratedRed:0.64 green:0.64 blue:0.64 alpha:1.0],1.0,nil] autorelease];
	self.activeArrowGradient = [[[NSGradient alloc] initWithColorsAndLocations:[NSColor colorWithCalibratedWhite:0.3 alpha:1.0],0.0,[NSColor colorWithCalibratedWhite:0.2 alpha:1.0],1.0,nil] autorelease];
	self.inactiveArrowGradient = [[[NSGradient alloc] initWithColorsAndLocations:[NSColor colorWithCalibratedWhite:0.47 alpha:1.0],0.0,[NSColor colorWithCalibratedWhite:0.45 alpha:1.0],1.0,nil] autorelease];
	self.activeKnobOutlineColor = [NSColor colorWithCalibratedWhite:0.4 alpha:1.0];
	self.inactiveKnobOutlineColor = [NSColor colorWithCalibratedWhite:0.6 alpha:1.0];
	self.activeLineColor = [NSColor colorWithCalibratedRed:0.663 green:0.663 blue:0.663 alpha:1.0];
	self.highlightLineColor = [NSColor colorWithCalibratedRed:0.51 green:0.576 blue:0.675 alpha:1.0];
	self.inactiveLineColor = self.inactiveKnobOutlineColor;
	return self;
}

- (void)dealloc;
{
	[self.knobSlotGradient release];
	[self.activeKnobGradient release];
	[self.inactiveKnobGradient release];
	[self.activeButtonGradient release];
	[self.highlightButtonGradient release];
	[self.inactiveButtonGradient release];
	[self.activeArrowGradient release];
	[self.inactiveArrowGradient release];
	[self.activeKnobOutlineColor release];
	[self.inactiveKnobOutlineColor release];
	[self.activeLineColor release];
	[self.highlightLineColor release];
	[self.inactiveLineColor release];
	[super dealloc];
}

- (void)drawRect:(NSRect)frame;
{	
	NSDisableScreenUpdates(); 
	[self drawKnobSlotInRect:[self rectForPart:NSScrollerKnobSlot] highlight:NO];
	if ([self usableParts] == NSNoScrollerParts) {
		NSEnableScreenUpdates();
		return;
	}
	
	if ([self usableParts] == NSAllScrollerParts)
		[self drawKnob];
	
	[self drawArrow:NSScrollerIncrementArrow highlight:([self hitPart] == NSScrollerIncrementLine)];
	[self drawArrow:NSScrollerDecrementArrow highlight:([self hitPart] == NSScrollerDecrementLine)];
	
	if (self.arrowsSetting == ESScrollerArrowsTogether) {
		[self drawTopSection];
		[self drawButtonSeparatorWithHighlight:([self hitPart] == NSScrollerIncrementLine)];
	}
	
	
	[[self window] invalidateShadow];
	NSEnableScreenUpdates();
}

- (BOOL)isVertical;
{
	return (NSWidth([self frame]) < NSHeight([self frame]));
}

- (CGFloat)fillAngle;
{
	return self.isVertical ? 0.0 : 90.0;
}

- (BOOL)isActive;
{
	return [NSApp isActive];
}

- (ESScrollerArrowsSetting)arrowsSetting;
{
	NSString *defaultsSetting = [[[NSUserDefaults standardUserDefaults] persistentDomainForName:NSGlobalDomain] valueForKey:@"AppleScrollBarVariant"];
	if ([defaultsSetting isEqualToString:@"Single"])
		return ESScrollerArrowsApart;
	else if ([defaultsSetting isEqualToString:@"DoubleMax"])
		return ESScrollerArrowsTogether;

	ESScrollerArrowsSetting setting;
	if (NSMaxY([self rectForPart:NSScrollerDecrementLine]) == NSMinY([self rectForPart:NSScrollerIncrementLine]))
		setting = ESScrollerArrowsTogether;
	else
		setting = ESScrollerArrowsApart;
	return setting;
}

- (NSRect)rectForPart:(NSScrollerPart)part;
{
	NSRect partRect = [super rectForPart:part];
	if (part == NSScrollerKnob) {
		partRect.origin.y += self.isVertical ? 3.5: 1.0;
		partRect.origin.x += self.isVertical ? 1.0 : 3.5;
		if (self.arrowsSetting == ESScrollerArrowsTogether) {
			partRect.size.width -= self.isVertical ? 2.0 : 4.5;			
			partRect.size.height -= self.isVertical ? 4.0 : 2.0;
		} else {
			partRect.size.width -= self.isVertical ? 2.0 : 7.0;
			partRect.size.height -= self.isVertical ? 7.0 : 2.0;
		}
	}
	return partRect;
}

- (void)drawKnobSlotInRect:(NSRect)knobRect highlight:(BOOL)highlight;
{
	[self.knobSlotGradient drawInRect:[self rectForPart:NSScrollerKnobSlot] angle:self.fillAngle];
}

- (void)drawKnob;
{
	NSBezierPath *knobPath = [NSBezierPath bezierPathWithRoundedRect:[self rectForPart:NSScrollerKnob] xRadius:7.0 yRadius:7.0];
//	[NSGraphicsContext saveGraphicsState];
//	[[NSShadow shadowWithColor:[NSColor blackColor] offset:NSMakeSize(0,-1) blurRadius:2.0] set];
//	[knobPath fill]; // drawing gradients does not cause the shadow to draw, so we fill the knob with whatever color is currentlt set first.
//	[NSGraphicsContext restoreGraphicsState];
	[(self.isActive ? self.activeKnobGradient : self.inactiveKnobGradient) drawInBezierPath:knobPath angle:self.fillAngle];
	[(self.isActive ? self.activeKnobOutlineColor : self.inactiveKnobOutlineColor) setStroke];
	[knobPath stroke];
}

- (void)drawIncrementButtonWithHighight:(BOOL)highlight;
{
	NSRect buttonRect = [self rectForPart:NSScrollerIncrementLine];
	
	// draw the button
	NSBezierPath *buttonPath = nil;
	if (self.arrowsSetting == ESScrollerArrowsTogether)
		buttonPath = [NSBezierPath bezierPathWithRect:buttonRect];
	else {
		buttonPath = [[[NSBezierPath alloc] init] autorelease];
		NSPoint buttonCorners[4];
		if (self.isVertical) {
			buttonCorners[0] = NSMakePoint(NSMaxX(buttonRect), NSMinY(buttonRect));
			buttonCorners[1] = NSMakePoint(NSMaxX(buttonRect), NSMaxY(buttonRect));
			buttonCorners[2] = NSMakePoint(NSMinX(buttonRect), NSMaxY(buttonRect));
			buttonCorners[3] = NSMakePoint(NSMinX(buttonRect), NSMinY(buttonRect));
			[buttonPath appendBezierPathWithPoints:buttonCorners count:4];
			[buttonPath appendBezierPathWithArcWithCenter:NSMakePoint(NSMidX(buttonRect), NSMinY(buttonRect) - NSHeight(buttonRect)/2) radius:NSWidth(buttonRect)/2 startAngle:180 endAngle:0 clockwise:YES];
		} else {
			buttonCorners[0] = NSMakePoint(NSMinX(buttonRect), NSMaxY(buttonRect));
			buttonCorners[1] = NSMakePoint(NSMaxX(buttonRect), NSMaxY(buttonRect));
			buttonCorners[2] = NSMakePoint(NSMaxX(buttonRect), NSMinY(buttonRect));
			buttonCorners[3] = NSMakePoint(NSMinX(buttonRect), NSMinY(buttonRect));
			[buttonPath appendBezierPathWithPoints:buttonCorners count:4];
			[buttonPath appendBezierPathWithArcWithCenter:NSMakePoint(NSMinX(buttonRect) - NSWidth(buttonRect)/2, NSMidY(buttonRect)) radius:NSHeight(buttonRect)/2 startAngle:270 endAngle:90];			
		}
		[buttonPath closePath];
	}
	[(highlight ? self.highlightButtonGradient : (self.isActive ? self.activeButtonGradient : self.inactiveButtonGradient)) drawInBezierPath:buttonPath angle:self.fillAngle];

	// draw the outline
	NSBezierPath *outline = [[[NSBezierPath alloc] init] autorelease];
	if (self.arrowsSetting == ESScrollerArrowsTogether) {
		if (self.isVertical) {
			[outline moveToPoint:NSMakePoint(NSMinX(buttonRect) + 0.5, NSMaxY(buttonRect))];		
			[outline lineToPoint:NSMakePoint(NSMinX(buttonRect) + 0.5, NSMinY(buttonRect))];
		} else {
			[outline moveToPoint:NSMakePoint(NSMaxX(buttonRect), NSMinY(buttonRect) + 0.5)];
			[outline lineToPoint:NSMakePoint(NSMinX(buttonRect), NSMinY(buttonRect) + 0.5)];
		}
	} else {
		if (self.isVertical) {
			[outline moveToPoint:NSMakePoint(NSMinX(buttonRect) + 0.5, NSMaxY(buttonRect))];
			[outline appendBezierPathWithArcWithCenter:NSMakePoint(NSMidX(buttonRect), NSMinY(buttonRect) - NSHeight(buttonRect)/2) radius:NSWidth(buttonRect)/2 startAngle:180 endAngle:0 clockwise:YES];
		} else {
			[outline moveToPoint:NSMakePoint(NSMaxX(buttonRect), NSMinY(buttonRect) + 0.5)];
			[outline appendBezierPathWithArcWithCenter:NSMakePoint(NSMinX(buttonRect) - NSWidth(buttonRect)/2, NSMidY(buttonRect)) radius:NSHeight(buttonRect)/2 startAngle:270 endAngle:90];
		}
	}
	[self.isActive ? (highlight ? self.highlightLineColor : self.activeLineColor) : self.inactiveLineColor setStroke];
	[outline stroke];	
	
	// draw the arrow
	NSBezierPath *arrowGlyph = [[[NSBezierPath alloc] init] autorelease];
	NSPoint points[3];
	points[0] = self.isVertical ? NSMakePoint(NSMidX(buttonRect), NSMidY(buttonRect) + 2.5) : NSMakePoint(NSMidX(buttonRect) + 2.5, NSMidY(buttonRect));
	points[1] = self.isVertical ? NSMakePoint(NSMidX(buttonRect) + 3.5, NSMidY(buttonRect) - 3) : NSMakePoint(NSMidX(buttonRect) - 3, NSMidY(buttonRect) + 3.5);
	points[2] = self.isVertical ? NSMakePoint(NSMidX(buttonRect) - 3.5, NSMidY(buttonRect) - 3) : NSMakePoint(NSMidX(buttonRect) - 3, NSMidY(buttonRect) - 3.5);
	[arrowGlyph appendBezierPathWithPoints:points count:3];
	[(self.isActive ? self.activeArrowGradient : self.inactiveArrowGradient) drawInBezierPath:arrowGlyph angle:self.fillAngle];
}

- (void)drawDecrementButtonWithHighlight:(BOOL)highlight;
{
	NSRect buttonRect = [self rectForPart:NSScrollerDecrementLine];
	
	// draw the button
	NSBezierPath *buttonPath = [[[NSBezierPath alloc] init] autorelease];
	NSPoint buttonCorners[4];
	if (self.arrowsSetting == ESScrollerArrowsTogether) {
		if (self.isVertical) {
			buttonCorners[0] = NSMakePoint(NSMaxX(buttonRect), NSMinY(buttonRect));
			buttonCorners[1] = NSMakePoint(NSMaxX(buttonRect), NSMaxY(buttonRect));
			buttonCorners[2] = NSMakePoint(NSMinX(buttonRect), NSMaxY(buttonRect));
			buttonCorners[3] = NSMakePoint(NSMinX(buttonRect), NSMinY(buttonRect));
			[buttonPath appendBezierPathWithPoints:buttonCorners count:4];
			[buttonPath appendBezierPathWithArcWithCenter:NSMakePoint(NSMidX(buttonRect), NSMinY(buttonRect) - NSHeight(buttonRect)/2) radius:NSWidth(buttonRect)/2 startAngle:180 endAngle:0 clockwise:YES];
		} else {
			buttonCorners[0] = NSMakePoint(NSMinX(buttonRect), NSMaxY(buttonRect));
			buttonCorners[1] = NSMakePoint(NSMaxX(buttonRect), NSMaxY(buttonRect));
			buttonCorners[2] = NSMakePoint(NSMaxX(buttonRect), NSMinY(buttonRect));
			buttonCorners[3] = NSMakePoint(NSMinX(buttonRect), NSMinY(buttonRect));
			[buttonPath appendBezierPathWithPoints:buttonCorners count:4];
			[buttonPath appendBezierPathWithArcWithCenter:NSMakePoint(NSMinX(buttonRect) - NSWidth(buttonRect)/2, NSMidY(buttonRect)) radius:NSHeight(buttonRect)/2 startAngle:270 endAngle:90];			
		}
	} else {
		if (self.isVertical) {
			buttonCorners[0] = NSMakePoint(NSMaxX(buttonRect), NSMaxY(buttonRect));
			buttonCorners[1] = NSMakePoint(NSMaxX(buttonRect), NSMinY(buttonRect));
			buttonCorners[2] = NSMakePoint(NSMinX(buttonRect), NSMinY(buttonRect));
			buttonCorners[3] = NSMakePoint(NSMinX(buttonRect), NSMaxY(buttonRect));
			[buttonPath appendBezierPathWithPoints:buttonCorners count:4];
			[buttonPath appendBezierPathWithArcWithCenter:NSMakePoint(NSMidX(buttonRect), NSMaxY(buttonRect) + NSHeight(buttonRect)/2) radius:NSWidth(buttonRect)/2 startAngle:180 endAngle:0];
		} else {
			buttonCorners[0] = NSMakePoint(NSMaxX(buttonRect), NSMaxY(buttonRect));
			buttonCorners[1] = NSMakePoint(NSMinX(buttonRect), NSMaxY(buttonRect));
			buttonCorners[2] = NSMakePoint(NSMinX(buttonRect), NSMinY(buttonRect));
			buttonCorners[3] = NSMakePoint(NSMaxX(buttonRect), NSMinY(buttonRect));
			[buttonPath appendBezierPathWithPoints:buttonCorners count:4];
			[buttonPath appendBezierPathWithArcWithCenter:NSMakePoint(NSMaxX(buttonRect) + NSWidth(buttonRect)/2,NSMidY(buttonRect)) radius:NSHeight(buttonRect)/2 startAngle:270 endAngle:90 clockwise:YES];		
		}
	}
	[buttonPath closePath];
	[(highlight ? self.highlightButtonGradient : (self.isActive ? self.activeButtonGradient : self.inactiveButtonGradient)) drawInBezierPath:buttonPath angle:self.fillAngle];
	
	// draw the outline
	NSBezierPath *outline = [[[NSBezierPath alloc] init] autorelease];
	if (self.arrowsSetting == ESScrollerArrowsTogether) {
		if (self.isVertical) {
			[outline moveToPoint:NSMakePoint(NSMinX(buttonRect) + 0.5, NSMaxY(buttonRect))];
			[outline appendBezierPathWithArcWithCenter:NSMakePoint(NSMidX(buttonRect), NSMinY(buttonRect) - NSHeight(buttonRect)/2) radius:NSWidth(buttonRect)/2 startAngle:180 endAngle:0 clockwise:YES];
		} else {
			[outline moveToPoint:NSMakePoint(NSMaxX(buttonRect), NSMinY(buttonRect) + 0.5)];
			[outline appendBezierPathWithArcWithCenter:NSMakePoint(NSMinX(buttonRect) - NSHeight(buttonRect)/2, NSMidY(buttonRect)) radius:NSHeight(buttonRect)/2 startAngle:270 endAngle:90];
		}
	} else {
		if (self.isVertical) {
			[outline moveToPoint:NSMakePoint(NSMinX(buttonRect) + 0.5, NSMinY(buttonRect))];
			[outline appendBezierPathWithArcWithCenter:NSMakePoint(NSMidX(buttonRect), NSMaxY(buttonRect) + NSHeight(buttonRect)/2) radius:NSWidth(buttonRect)/2 startAngle:180 endAngle:0];
		} else {
			[outline moveToPoint:NSMakePoint(NSMinX(buttonRect), NSMinY(buttonRect) + 0.5)];
			[outline appendBezierPathWithArcWithCenter:NSMakePoint(NSMaxX(buttonRect) + NSWidth(buttonRect)/2, NSMidY(buttonRect)) radius:NSHeight(buttonRect)/2 startAngle:270 endAngle:90 clockwise:YES];
		}
	}
	[self.isActive ? (highlight ? self.highlightLineColor : self.activeLineColor) : self.inactiveLineColor setStroke];
	[outline stroke];
	
	// draw the arrow
	NSBezierPath *arrowGlyph = [[[NSBezierPath alloc] init] autorelease];
	NSPoint points[3];
	points[0] = self.isVertical ? NSMakePoint(NSMidX(buttonRect), NSMidY(buttonRect) - 2.5) : NSMakePoint(NSMidX(buttonRect) - 2.5, NSMidY(buttonRect));
	points[1] = self.isVertical ? NSMakePoint(NSMidX(buttonRect) + 3.5, NSMidY(buttonRect) + 3) : NSMakePoint(NSMidX(buttonRect) + 3, NSMidY(buttonRect) + 3.5);
	points[2] = self.isVertical ? NSMakePoint(NSMidX(buttonRect) - 3.5, NSMidY(buttonRect) + 3) : NSMakePoint(NSMidX(buttonRect) + 3, NSMidY(buttonRect) - 3.5);
	[arrowGlyph appendBezierPathWithPoints:points count:3];
	[(self.isActive ? self.activeArrowGradient : self.inactiveArrowGradient) drawInBezierPath:arrowGlyph angle:self.fillAngle];	
}

- (void)drawArrow:(NSScrollerArrow)whichArrow highlight:(BOOL)highlight;
{
	if (whichArrow == NSScrollerIncrementArrow)
		[self drawIncrementButtonWithHighight:highlight];
	else
		[self drawDecrementButtonWithHighlight:highlight];
}

- (void)drawTopSection;
{
	NSBezierPath *buttonPath = [[[NSBezierPath alloc] init] autorelease];
	NSRect buttonRect;
	NSPoint buttonCorners[4];
	if (self.isVertical) {
		buttonRect = NSMakeRect(0.0, 0.0, NSWidth([self frame]),6.0);
		buttonCorners[0] = NSMakePoint(NSMaxX(buttonRect), NSMaxY(buttonRect));
		buttonCorners[1] = NSMakePoint(NSMaxX(buttonRect), NSMinY(buttonRect));
		buttonCorners[2] = NSMakePoint(NSMinX(buttonRect), NSMinY(buttonRect));
		buttonCorners[3] = NSMakePoint(NSMinX(buttonRect), NSMaxY(buttonRect));
		[buttonPath appendBezierPathWithPoints:buttonCorners count:4];
		[buttonPath appendBezierPathWithArcWithCenter:NSMakePoint(NSMidX(buttonRect),NSMaxY(buttonRect) + NSHeight(buttonRect)/2 + 5) radius:NSWidth(buttonRect)/2 startAngle:180 endAngle:0];
	} else {
		buttonRect = NSMakeRect(0.0, 0.0, 6.0, NSHeight([self frame]));
		buttonCorners[0] = NSMakePoint(NSMaxX(buttonRect), NSMaxY(buttonRect));
		buttonCorners[1] = NSMakePoint(NSMinX(buttonRect), NSMaxY(buttonRect));
		buttonCorners[2] = NSMakePoint(NSMinX(buttonRect), NSMinY(buttonRect));
		buttonCorners[3] = NSMakePoint(NSMaxX(buttonRect), NSMinY(buttonRect));
		[buttonPath appendBezierPathWithPoints:buttonCorners count:4];
		[buttonPath appendBezierPathWithArcWithCenter:NSMakePoint(NSMaxX(buttonRect) + NSWidth(buttonRect)/2 + 5,NSMidY(buttonRect)) radius:NSHeight(buttonRect)/2 startAngle:270 endAngle:90 clockwise:YES];		
	}
	[buttonPath closePath];
	[self.isActive ? self.activeButtonGradient : self.inactiveButtonGradient drawInBezierPath:buttonPath angle:self.fillAngle];
	
	NSBezierPath *outline = [[[NSBezierPath alloc] init] autorelease];
	if (self.isVertical) {
		[outline moveToPoint:NSMakePoint(NSMinX(buttonRect) + 0.5, NSMinY(buttonRect))];
		[outline appendBezierPathWithArcWithCenter:NSMakePoint(NSMidX(buttonRect), NSMaxY(buttonRect) + NSHeight(buttonRect)/2 + 5) radius:NSWidth(buttonRect)/2 startAngle:180 endAngle:0];
	} else {
		[outline moveToPoint:NSMakePoint(NSMinX(buttonRect), NSMinY(buttonRect) + 0.5)];
		[outline appendBezierPathWithArcWithCenter:NSMakePoint(NSMaxX(buttonRect) + NSWidth(buttonRect)/2 + 5,NSMidY(buttonRect)) radius:NSHeight(buttonRect)/2 startAngle:270 endAngle:90 clockwise:YES];		
	}
	[self.activeLineColor setStroke];
	[outline stroke];
}

- (void)drawButtonSeparatorWithHighlight:(BOOL)highlight;
{
	NSRect lineRect = [self rectForPart:NSScrollerIncrementLine];
	if (self.isVertical) {
		lineRect.size.height = 0.0;
		lineRect.origin.y += 0.5;
	} else {
		lineRect.size.width = 0.0;
		lineRect.origin.x += 0.5;
	}
	[self.isActive ? (highlight ? self.highlightLineColor : self.activeLineColor) : self.inactiveLineColor setStroke];
	[[NSBezierPath bezierPathWithRect:lineRect] stroke];	
}

@end
