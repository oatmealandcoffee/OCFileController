//
//  OCFileController.h
//  Ratchet
//
//  Created by Philip Regan on 5/17/13.
//  Copyright (c) 2013 Jones & Bartlett Learning. All rights reserved.
//

/*
 Support class for handling common file operations
 
 This class takes a number of common file operations requiring lots of code and 
 streamlining them down to a single line. Many assumptions are made about needs, 
 requirements, and error handling, but there are always compromises when doing 
 this sort of thing.
 
 Some of these are very basic, high-level actions, but some stem from fairly specific
 scenarios I have needed many times.
 
 About error handling:
 * Nil will always be returned on any error unless otherwise noted.
 * Functions assume values being passed are valid. Unless a passed value is nil, 
 Xcode will take over during debugging.
 */

#import <Foundation/Foundation.h>

@interface OCFileController : NSObject <NSOpenSavePanelDelegate>

#pragma mark - File Selection Stack -

/*
 Allows the user to select a folder using a standard folder selection dialog.
 This function assumes that only one (1) folder can be selected at a time. Will 
 return nil if the user clicks the 'Cancel' button.
 */

- (NSURL *) selectFolder:(NSString *)message;

/*
 Allows the user to select a file using a standard file selection dialog.
 This function assumes that only one (1) file can be selected at a time. Will 
 return nil if the user clicks the 'Cancel' button.
 */

- (NSURL *) selectFile:(NSString *)message;

/*
 Captures all of the files contained within a given folder. This function 
 will subdirectories and packages but not their contents, nor will it capture any 
 hidden files. Can return nil upon any error, but that error is not captured.
 */

- (NSArray *) getFilesInFolder:(NSURL *)folder;

#pragma mark - File I/O Stack -

/*
 Returns the string contained in a target file found within the application bundle. 
 Can return nil upon any error, but that error is not captured.
 */

- (NSString *) stringFromFileInBundleWithName:(NSString *)fileName extension:(NSString *)fileExtension;

/*
 Returns the url for a target file found within the application bundle. 
 Can return nil upon any error, but that error is not captured.
 */

- (NSURL *) urlToFileInBundleWithName:(NSString *)fileName extension:(NSString *)fileExtension;

/*
 Writes a string to a given url.
 Can return nil upon simple errors, but that error is not captured. The specific write
 error is returned if found, but can be nil as well.
 */

- (NSError *) writeString:(NSString *)content toURL:(NSURL *)url withName:(NSString *)name;

/*
 Creates a folder with a given name within a target folder. If a folder with the 
 same name is found, the existing folder is deleted and the new folder is created
 in its place. Files contained within the previous folder are not saved. 
 Can return nil on any error, but that error is not captured.
 */

- (NSURL *) makeFolder:(NSString *)folderName parentFolder:(NSURL *)parent;

/*
 Copies a file contained within the application bundle (internal asset; not the best
 name, but there it is) to a given folder. 
 
 Returns YES on a successful copy, and NO on any other error.
 */

- (BOOL) populateFolder:(NSURL *)folder withInternalAsset:(NSString *)fileName extension:(NSString *)fileExtension;

/*
 Copies a file outside the application bundle to a target folder. 
 N.B.: Returns nil on *success*.
 */

- (NSError *) copyFile:(NSURL *)file toFolder:(NSURL *)folder;

#pragma mark - Path Management Stack -

/*
 Helper method to convert POSIX (Unix) Paths into HFS, which is required by Applescript.
 As of this version, there is no error checking.
 */

- (NSString *) convertPosixPathtoHfsPath:(NSString *)posixPath isDirectory:(BOOL)isDirectory;

@end
