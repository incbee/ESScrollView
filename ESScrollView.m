//
//  ESScrollView.m
//  ScrollBar
//
//  Created by Jonathan on 16/04/2008.
//  Copyright 2008 EspressoSoft. All rights reserved.
//

#import "ESScrollView.h"
#import "ESiTunesScroller.h"

@implementation ESScrollView

- (void)awakeFromNib;
{
	// Revert to the default iPad-like scrollbars on Lion and later
	SInt32 majorVersion, minorVersion;
	Gestalt(gestaltSystemVersionMajor, &majorVersion);
	Gestalt(gestaltSystemVersionMinor, &minorVersion);
	if (majorVersion >= 10 && minorVersion >= 7) {
//		NSLog(@"On Lion or later, reverting to default scroll bar");   // DEBUG
		return;
	}

	NSRect horizontalScrollerFrame = [[self horizontalScroller] frame];
	NSRect verticalScrollerFrame = [[self verticalScroller] frame];
	NSString *scrollBarVariant = [[[NSUserDefaults standardUserDefaults] persistentDomainForName:NSGlobalDomain] valueForKey:@"AppleScrollBarVariant"];

	if (![scrollBarVariant isEqualToString:@"DoubleBoth"]) {
		[self setVerticalScroller:[[[ESiTunesScroller alloc] initWithFrame:verticalScrollerFrame] autorelease]];
		[self setHorizontalScroller:[[[ESiTunesScroller alloc] initWithFrame:horizontalScrollerFrame] autorelease]];
	}
}

@end
