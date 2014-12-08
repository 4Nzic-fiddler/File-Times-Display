//
//  FileAttributesTracker.m
//  File Times Display
//
//  Created by Randy Pargman on 12/6/14.
//  Copyright (c) 2014 Randy Pargman. All rights reserved.
//

#import "FileAttributesTracker.h"
#import <sys/stat.h>



@implementation FileAttributesTracker

- (void)displayFileAttributes {
	// Get path to file
	[self setCurrent_file_path:self.current_file_url.path];
	
	// Get file size
	struct stat stat1;
	if( stat([self.current_file_path fileSystemRepresentation], &stat1) ) {
		// something is wrong
	}
	long long size = stat1.st_size;
	[self setCurrent_file_size:size];
	
	// Get last access date
	struct timespec accessTime = stat1.st_atimespec;
	
    NSDate *accessDate = [NSDate dateWithTimeIntervalSince1970:accessTime.tv_sec];
	[self setCurrent_file_access_date:accessDate];
	
	// Get the attribute change time
	struct timespec changeTime = stat1.st_ctimespec;
	NSDate *changeDate = [NSDate dateWithTimeIntervalSince1970:changeTime.tv_sec];
	[self setCurrent_file_attribute_date:changeDate];
	
	// Get other file attributes into attrs
	NSDictionary *attrs = [NSFileManager.defaultManager attributesOfItemAtPath: self.current_file_path error: NULL];
	
	// Get File Creation Date
	NSDate *birth_date = [attrs objectForKey:NSFileCreationDate];
	[self setCurrent_file_birth_date:birth_date];
	
	//Get Modification Date
	NSDate *mod_date = [attrs objectForKey:NSFileModificationDate];
	[self setCurrent_file_mod_date:mod_date];
	
	// Get owner name
	NSString *owner = [attrs objectForKey:NSFileOwnerAccountName];
	[self setCurrent_file_owner_name:owner];
	
	// Get OwnerID
	NSString *owner_id = [attrs objectForKey:NSFileOwnerAccountID];
	[self setCurrent_file_owner_id:owner_id];
	
	// Get Group
	NSString *group_name = [attrs objectForKey:NSFileGroupOwnerAccountName];
	[self setCurrent_file_group_name:group_name];
	
	NSString *group_id = [attrs objectForKey:NSFileGroupOwnerAccountID];
	[self setCurrent_file_group_id:group_id];
	
	
	// Get File Permissions
	NSArray *permsArray = [NSArray arrayWithObjects:@"none", @"execute", @"write only", @"write,execute", @"read only", @"read,execute", @"read,write", @"read,write,execute", nil];
	NSUInteger perms = [attrs filePosixPermissions];
	NSMutableString *result = [NSMutableString string];
	
	if ([[attrs fileType] isEqualToString:NSFileTypeDirectory]) {
		[result appendString:@"(folder) "];
		permsArray = [NSArray arrayWithObjects:@"none", @"traverse", @"modify folder", @"modify folder,traverse", @"list file names only", @"list files,traverse", @"list files,modify folder", @"all permissions", nil];
	}
	else {
		[result appendString:@"(file) "];
	}
	
	// loop through POSIX permissions, starting at user, then group, then other.
	for (int i = 2; i >= 0; i--)
	{
		switch(i) {
			case 2:
				[result appendString:@"owner:"];
				break;
			case 1:
				[result appendString:@" group:"];
				break;
			case 0:
				[result appendString:@" others:"];
				break;
		}
		// this creates an index from 0 to 7
		unsigned long thisPart = (perms >> (i * 3)) & 0x7;
		
		// we look up this index in our permissions array and append it.
		[result appendString:[permsArray objectAtIndex:thisPart]];
	}
	[self setCurrent_file_permissions:result];

	
	// Get more security details
	NSFileSecurity *fileKey = nil;
	acl_t aclValue = NULL;
	char *aclText = NULL;
	NSError *err = NULL;
	
	NSURL *fileRef = [self.current_file_url fileReferenceURL];
	
	// Get ACL text
	if ([fileRef getResourceValue:&fileKey forKey:NSURLFileSecurityKey error:&err]) {
		CFFileSecurityRef cfFileSecRef = (__bridge CFFileSecurityRef) fileKey;
		
		CFFileSecurityCopyAccessControlList(cfFileSecRef, &aclValue);
		
		aclText = acl_to_text(aclValue, NULL);
		NSString *aclString = [[NSString alloc]initWithUTF8String:aclText];
		[self setCurrent_file_acl_text:aclString];
		
	} ;
}

- (void)newFileSelected:(NSURL *)url {
	[self setCurrent_file_url:url];
	[self displayFileAttributes];
}

- (void)showFileChooser {
	NSOpenPanel *panel = [NSOpenPanel openPanel];
	[panel setCanChooseFiles:YES];
	[panel setCanChooseDirectories:YES];
	[panel setAllowsMultipleSelection:NO]; // yes if more than one dir is allowed
	
	NSInteger clicked = [panel runModal];
	
	if (clicked == NSFileHandlingPanelOKButton) {
		for (NSURL *url in [panel URLs]) {
			[self newFileSelected:url];
			
		}
	}
}


@end
