//
//  ftimeAppDelegate.m
//  File Times Display
//
//  Created by Randy Pargman on 12/6/14.
//  Copyright (c) 2014 Randy Pargman. All rights reserved.
//

#import "ftimeAppDelegate.h"
#import "FileAttributesTracker.h"

@implementation ftimeAppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
	// Create a file attributes tracker to handle reading file attributes
	FileAttributesTracker *faTracker = [[FileAttributesTracker alloc] init];
	self.tracker = faTracker;
	
	// Start timer to refresh UI
	//[self startRepeatingTimer:updateUserInterface];
}

- (void)updateUserInterface {
	// Instantiate a NSDateFormatter
	NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
	
	// Set the dateFormatter format
	[dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
	
	// Get the date time in NSString
	NSString *modDateInString = [dateFormatter stringFromDate:[self.tracker current_file_mod_date]];
	
	
}


// on press of the file chooser button, show file select dialog
- (IBAction)OpenFileChooser:(id)sender {
	[self.tracker showFileChooser];
}

- (IBAction)startRepeatingTimer:sender {
	
    // Cancel a preexisting timer.
    [self.repeatingTimer invalidate];
	
    NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:0.5
													  target:self selector:@selector(targetMethod:)
													userInfo:[self userInfo] repeats:YES];
    self.repeatingTimer = timer;
}
@end