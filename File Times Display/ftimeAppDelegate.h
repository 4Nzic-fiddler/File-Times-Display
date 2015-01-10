//
//  ftimeAppDelegate.h
//  File Times Display
//
//  Created by Randy Pargman on 12/6/14.
//  Copyright (c) 2014 Randy Pargman. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "ColorChangingTextField.h"
#import "FileAttributesTracker.h"

@interface ftimeAppDelegate : NSObject <NSApplicationDelegate>

@property (assign) IBOutlet NSWindow *window;
@property IBOutlet FileAttributesTracker *tracker;
@property (weak) NSTimer *repeatingTimer;
@property NSDictionary *userInfo;


@property IBOutlet ColorChangingTextField *textField_birth_date;
@property IBOutlet ColorChangingTextField *textField_content_creation_date;
@property IBOutlet ColorChangingTextField *textField_added_date;
@property IBOutlet ColorChangingTextField *textField_mod_date;
@property IBOutlet ColorChangingTextField *textField_access_date;
@property IBOutlet ColorChangingTextField *textField_last_used_date;
@property IBOutlet ColorChangingTextField *textField_ctime_date;
@property IBOutlet ColorChangingTextField *textField_attribute_date;

@property IBOutlet ColorChangingTextField *textFieldOwner;
@property IBOutlet ColorChangingTextField *textFieldGroup;
@property IBOutlet ColorChangingTextField *textField_acl_text;

- (IBAction)OpenFileChooser:(id)sender; // 
- (void)showFileChooser; // 
- (void)resetTextFieldColors;

@end
