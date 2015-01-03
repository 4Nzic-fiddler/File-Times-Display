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
	
	// Get the last used (double-clicked) date
	NSDate *usedDate = [self getDateFromSpotlightForFile:self.current_file_url WithDateName:@"kMDItemLastUsedDate"];
	[self setCurrent_file_last_used_date:usedDate];
	
	// Get the attribute change time
	struct timespec changeTime = stat1.st_ctimespec;
	NSDate *changeDate = [NSDate dateWithTimeIntervalSince1970:changeTime.tv_sec];
	[self setCurrent_file_attribute_date:changeDate];
	
	// Get the attribute date from spotlight
	NSDate *attributeDate = [self getDateFromSpotlightForFile:self.current_file_url WithDateName:@"kMDItemAttributeChangeDate"];
	[self setCurrent_file_attribute_date:attributeDate];
	
	// Get the added (to folder) date
	NSDate *addedDate = [self dateAdded:self.current_file_url];
	[self setCurrent_file_added_date:addedDate];
	
	// Get other file attributes into attrs
	NSDictionary *attrs = [NSFileManager.defaultManager attributesOfItemAtPath: self.current_file_path error: NULL];
	
	// Get File Creation Date
	NSDate *birth_date = [attrs objectForKey:NSFileCreationDate];
	[self setCurrent_file_birth_date:birth_date];
	
	// Get Content creation date (not necessarily the same as file creation date)
	NSDate *content_date = [self getDateFromSpotlightForFile:self.current_file_url WithDateName:@"kMDItemContentCreationDate"];
	[self setCurrent_file_content_creation_date:content_date];
	
	//Get Modification Date
	NSDate *mod_date = [attrs objectForKey:NSFileModificationDate];
	[self setCurrent_file_mod_date:mod_date];
	
	// Get owner name
	NSString *owner = [attrs objectForKey:NSFileOwnerAccountName];
	[self setCurrent_file_owner_name:owner];
	
	// Get OwnerID
	NSString *owner_id = [attrs objectForKey:NSFileOwnerAccountID];
	[self setCurrent_file_owner_id:owner_id];
	// Format owner name as id:name
	//NSString *id_owner = [owner_id stringByAppendingFormat:@":%@", owner];
	//[self setCurrent_file_owner_name:id_owner];
	
	// Get Group name and ID
	NSString *group_name = [attrs objectForKey:NSFileGroupOwnerAccountName];
	[self setCurrent_file_group_name:group_name];
	
	NSString *group_id = [attrs objectForKey:NSFileGroupOwnerAccountID];
	[self setCurrent_file_group_id:group_id];
	
	// Format group name as id:name
	//NSString *id_group_name = [group_id stringByAppendingFormat:@":%@", group_name];
	//[self setCurrent_file_group_name:id_group_name];
	
	// Get File Permissions
	NSArray *permsArray = [NSArray arrayWithObjects:@"none", @"execute", @"write only", @"write,execute", @"read only", @"read,execute", @"read,write", @"read,write,execute", nil];
	
	NSUInteger perms = [attrs filePosixPermissions];
	NSMutableString *result = [NSMutableString string];
	
	if ([[attrs fileType] isEqualToString:NSFileTypeDirectory]) {
		[result appendString:@"(folder) "];
		[self setPermissions_read_label:@"List"];
		[self setPermissions_write_label:@"Add/Del/Rename"];
		[self setPermissions_execute_label:@"Traverse"];
		permsArray = [NSArray arrayWithObjects:@"none", @"traverse", @"modify folder", @"modify folder,traverse", @"list file names only", @"list files,traverse", @"list files,modify folder", @"all permissions", nil];
	}
	else {
		[result appendString:@"(file) "];
		[self setPermissions_read_label:@"Read"];
		[self setPermissions_write_label:@"Write"];
		[self setPermissions_execute_label:@"Execute"];
	}
	
	// loop through POSIX permissions, starting at user, then group, then other.
	for (int i = 2; i >= 0; i--)
	{
		// this creates an index from 0 to 7
		unsigned long thisPart = (perms >> (i * 3)) & 0x7;
		switch(i) {
			case 2:
				[result appendString:@"owner:"];
				// Check owner read permission
				if (thisPart & 0x4) [self setPermissions_owner_read:@"Y"];
				else [self setPermissions_owner_read:@"N"];
				// Check owner write permissions
				if (thisPart & 0x2) [self setPermissions_owner_write:@"Y"];
				else [self setPermissions_owner_write:@"N"];
				// Check owner execute permissions
				if (thisPart & 0x1) [self setPermissions_owner_execute:@"Y"];
				else [self setPermissions_owner_execute:@"N"];
				break;
			case 1:
				[result appendString:@" group:"];
				// Check group read permission
				if (thisPart & 0x4) [self setPermissions_group_read:@"Y"];
				else [self setPermissions_group_read:@"N"];
				// Check group write permissions
				if (thisPart & 0x2) [self setPermissions_group_write:@"Y"];
				else [self setPermissions_group_write:@"N"];
				// Check group execute permissions
				if (thisPart & 0x1) [self setPermissions_group_execute:@"Y"];
				else [self setPermissions_group_execute:@"N"];

				break;
			case 0:
				[result appendString:@" others:"];
				// Check other read permission
				if (thisPart & 0x4) [self setPermissions_other_read:@"Y"];
				else [self setPermissions_other_read:@"N"];
				// Check other write permissions
				if (thisPart & 0x2) [self setPermissions_other_write:@"Y"];
				else [self setPermissions_other_write:@"N"];
				// Check other execute permissions
				if (thisPart & 0x1) [self setPermissions_other_execute:@"Y"];
				else [self setPermissions_other_execute:@"N"];

				break;
		}
		
		
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
	[NSTimer scheduledTimerWithTimeInterval:0.03												target:self
					selector:@selector(displayFileAttributes)
					userInfo:nil
					repeats:YES];
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

- (NSDate *)getDateFromSpotlightForFile:(NSURL *)url WithDateName:(NSString *)attribute_name
{
	NSDate *rslt = nil;
    MDItemRef inspectedRef = nil;
	
    inspectedRef = MDItemCreateWithURL(kCFAllocatorDefault, (__bridge CFURLRef)url);
    if (inspectedRef){
        CFTypeRef cfRslt = MDItemCopyAttribute(inspectedRef, (__bridge CFStringRef)attribute_name);
        if (cfRslt) {
            rslt = (__bridge NSDate *)cfRslt;
        }
    }
    return rslt;

}

- (NSDate *)dateAdded:(NSURL *)url
{
    NSDate *rslt = nil;
    MDItemRef inspectedRef = nil;
	
    inspectedRef = MDItemCreateWithURL(kCFAllocatorDefault, (__bridge CFURLRef)url);
    if (inspectedRef){
        CFTypeRef cfRslt = MDItemCopyAttribute(inspectedRef, (CFStringRef)@"kMDItemDateAdded");
        if (cfRslt) {
            rslt = (__bridge NSDate *)cfRslt;
        }
    }
    return rslt;
}

- (NSDate *)dateLastUsed:(NSURL *)url
{
    NSDate *rslt = nil;
    MDItemRef inspectedRef = nil;
	
    inspectedRef = MDItemCreateWithURL(kCFAllocatorDefault, (__bridge CFURLRef)url);
    if (inspectedRef){
        CFTypeRef cfRslt = MDItemCopyAttribute(inspectedRef, (CFStringRef)@"kMDItemLastUsedDate");
        if (cfRslt) {
            rslt = (__bridge NSDate *)cfRslt;
        }
    }
    return rslt;
}

- (NSDate *)dateContentCreated:(NSURL *)url
{
    NSDate *rslt = nil;
    MDItemRef inspectedRef = nil;
	
    inspectedRef = MDItemCreateWithURL(kCFAllocatorDefault, (__bridge CFURLRef)url);
    if (inspectedRef){
        CFTypeRef cfRslt = MDItemCopyAttribute(inspectedRef, (CFStringRef)@"kMDItemContentCreationDate");
        if (cfRslt) {
            rslt = (__bridge NSDate *)cfRslt;
        }
    }
    return rslt;
}




@end
