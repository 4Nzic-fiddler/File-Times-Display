//
//  ftimeAppDelegate.m
//  File Times Display
//
//  Created by Randy Pargman on 12/6/14.
//  Copyright (c) 2014 Randy Pargman. All rights reserved.
//

#import "ftimeAppDelegate.h"
#import "FileAttributesTracker.h"
#import "NilDateTransformer.h"

@implementation ftimeAppDelegate

@synthesize textField_access_date;

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
	// Create a file attributes tracker to handle reading file attributes
	FileAttributesTracker *faTracker = [[FileAttributesTracker alloc] init];
	self.tracker = faTracker;
	
	// Add each of the time text fields as observers of self.tracker, to
	// receive notification whenever the file time they are displaying
	// changes.  This is just for the purpose of changing the color
	// of the textField backgrounds - the binding that updates their values
	// is set up in Interface Builder.
	
	// Birth Date
	[self.tracker addObserver:self.textField_birth_date forKeyPath:@"current_file_birth_date" options:0 context:nil];
	// Content creation Date
	[self.tracker addObserver:self.textField_content_creation_date forKeyPath:@"current_file_content_creation_date" options:0 context:nil];
	// Modification Time
	[self.tracker addObserver:self.textField_mod_date forKeyPath:@"current_file_mod_date" options:0 context:nil];
	// Access Date
	[self.tracker addObserver:self.textField_access_date forKeyPath:@"current_file_access_date" options:0 context:nil];
	// Last Used Date
	[self.tracker addObserver:self.textField_last_used_date forKeyPath:@"current_file_last_used_date" options:0 context:nil];
	// ctime change time
	[self.tracker addObserver:self.textField_ctime_date forKeyPath:@"current_file_ctime_date" options:0 context:nil];
	// metadata time
	[self.tracker addObserver:self.textField_attribute_date forKeyPath:@"current_file_attribute_date" options:0 context:nil];
	// Added to folder date
	[self.tracker addObserver:self.textField_added_date forKeyPath:@"current_file_added_date" options:0 context:nil];
	// ACL text
	[self.tracker addObserver:self.textField_acl_text forKeyPath:@"current_file_acl_text" options:0 context:nil];
}


// on press of the file chooser button, show file select dialog
- (IBAction)OpenFileChooser:(id)sender {
	[self showFileChooser];
}

- (void)showFileChooser {
	NSOpenPanel *panel = [NSOpenPanel openPanel];
	[panel setCanChooseFiles:YES];
	[panel setCanChooseDirectories:YES];
	[panel setAllowsMultipleSelection:NO]; // yes if more than one dir is allowed
	
	NSInteger clicked = [panel runModal];
	
	if (clicked == NSFileHandlingPanelOKButton) {
		for (NSURL *url in [panel URLs]) {
			[self resetTextFieldColors];
			[self.tracker newFileSelected:url];
		}
	}
}

- (void)resetTextFieldColors
{
	[self.textField_access_date resetColor];
	[self.textField_acl_text resetColor];
	[self.textField_added_date resetColor];
	[self.textField_attribute_date resetColor];
	[self.textField_birth_date resetColor];
	[self.textField_content_creation_date resetColor];
	[self.textField_ctime_date resetColor];
	[self.textField_last_used_date resetColor];
	[self.textField_mod_date resetColor];
	[self.textFieldGroup resetColor];
	[self.textFieldOwner resetColor];
	
}

@end