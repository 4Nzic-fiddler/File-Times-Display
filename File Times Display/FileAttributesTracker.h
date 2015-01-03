//
//  FileAttributesTracker.h
//  File Times Display
//
//  Created by Randy Pargman on 12/6/14.
//  Copyright (c) 2014 Randy Pargman. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FileAttributesTracker : NSObject
@property NSString *current_file_path;
@property NSDate *current_file_birth_date;
@property NSDate *current_file_content_creation_date;
@property NSDate *current_file_mod_date;
@property NSDate *current_file_access_date;
@property NSDate *current_file_last_used_date;
@property NSDate *current_file_attribute_date;
@property NSDate *current_file_added_date;
@property NSDate *current_file_backup_date;
@property NSString *current_file_owner_name;
@property NSString *current_file_owner_id;
@property NSString *current_file_group_name;
@property NSString *current_file_group_id;
@property NSString *current_file_acl_text;
@property NSString *current_file_permissions;


@property NSString *permissions_read_label;
@property NSString *permissions_write_label;
@property NSString *permissions_execute_label;

@property NSString *permissions_owner_read;
@property NSString *permissions_owner_write;
@property NSString *permissions_owner_execute;
@property NSString *permissions_group_read;
@property NSString *permissions_group_write;
@property NSString *permissions_group_execute;
@property NSString *permissions_other_read;
@property NSString *permissions_other_write;
@property NSString *permissions_other_execute;

@property NSURL *current_file_url;

@property long long current_file_size;


- (void)showFileChooser;
- (void)newFileSelected:(NSURL *)url;

- (void)displayFileAttributes;

- (NSDate *)getDateFromSpotlightForFile:(NSURL *)url WithDateName:(NSString *)attribute_name;
- (NSDate *)dateAdded:(NSURL *)url;
- (NSDate *)dateLastUsed:(NSURL *)url;
- (NSDate *)dateContentCreated:(NSURL *)url;
@end
