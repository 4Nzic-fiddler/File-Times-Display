//
//  ftimeAppDelegate.h
//  File Times Display
//
//  Created by Randy Pargman on 12/6/14.
//  Copyright (c) 2014 Randy Pargman. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "FileAttributesTracker.h"

@interface ftimeAppDelegate : NSObject <NSApplicationDelegate>

@property (assign) IBOutlet NSWindow *window;
@property FileAttributesTracker *tracker;
@property (weak) NSTimer *repeatingTimer;
@property NSDictionary *userInfo;

- (IBAction)OpenFileChooser:(id)sender;
- (IBAction)startRepeatingTimer:sender;
- (void)controlTextDidChange:(NSNotification *)notification;
//- (void)updateUserInterface;


@end
