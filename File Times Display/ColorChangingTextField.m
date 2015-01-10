//
//  ColorChangingTextField.m
//  File Times Display
//
//  Created by Randy Pargman on 1/3/15.
//  Copyright (c) 2015 Randy Pargman. All rights reserved.
//

#import "ColorChangingTextField.h"

@implementation ColorChangingTextField

@synthesize colorWasReset;

- (id)initWithFrame:(NSRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code here.
		[self setColorWasReset:FALSE];
    }
    
    return self;
}

- (void)drawRect:(NSRect)dirtyRect
{
    // Drawing code here.
	//NSLog(@"ColorChangingTextField drawRect called");
	[super drawRect:dirtyRect];
}

- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary *)change
                       context:(void *)context
{
	if (self.colorWasReset) {
		[self setColorWasReset:FALSE];
	}
	else {
		[self cycleColor];
	}
	
}

- (void)cycleColor
{
	if (self.backgroundColor == [NSColor yellowColor]) {
		[self setBackgroundColor:[NSColor redColor]];
	}
	else if (self.backgroundColor == [NSColor redColor]) {
		[self setBackgroundColor:[NSColor blueColor]];
	}
	else if (self.backgroundColor == [NSColor blueColor]) {
		[self setBackgroundColor:[NSColor greenColor]];
	}
	else {
		[self setBackgroundColor:[NSColor yellowColor]];
	}
}

- (void)resetColor
{
	[self setBackgroundColor:[NSColor whiteColor]];
	[self setColorWasReset:TRUE];
}

@end
