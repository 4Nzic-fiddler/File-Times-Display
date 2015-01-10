//
//  ColorChangingTextField.h
//  File Times Display
//
//  Created by Randy Pargman on 1/3/15.
//  Copyright (c) 2015 Randy Pargman. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface ColorChangingTextField : NSTextField
@property (nonatomic) Boolean colorWasReset;
- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary *)change
                       context:(void *)context;

- (void)cycleColor;
- (void)resetColor;
@end
