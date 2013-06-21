//
//  OCFileController.m
//  Ratchet
//
//  Created by Philip Regan on 5/17/13.
//  Copyright (c) 2013 Philip Regan. All rights reserved.
//

/*
 Support class for handling file operations
 */

#import "OCFileController.h"

@implementation OCFileController

#pragma mark - File Selection Stack -

- (NSURL *) selectFolder:(NSString *)message {
    // Create and configure the panel.
    NSOpenPanel* panel = [NSOpenPanel openPanel];
    [panel setDelegate:self];
    [panel setCanChooseDirectories:YES];
    [panel setCanChooseFiles:NO];
    [panel setCanCreateDirectories:YES];
    [panel setAllowsMultipleSelection:NO];
    if (message) {
        [panel setMessage:message];
    }
    
    NSInteger result = [panel runModal];
    NSURL *folder;
    
    if ( result == NSFileHandlingPanelOKButton ) {
        folder = [[panel URLs] objectAtIndex:0];
    }
    
    return folder;
    
}

- (NSURL *) selectFile:(NSString *)message {
    // Create and configure the panel.
    NSOpenPanel* panel = [NSOpenPanel openPanel];
    [panel setDelegate:self];
    [panel setCanChooseDirectories:NO];
    [panel setCanChooseFiles:YES];
    [panel setCanCreateDirectories:NO];
    [panel setAllowsMultipleSelection:NO];
    if (message) {
        [panel setMessage:message];
    } 
    
    NSInteger result = [panel runModal];
    NSURL *file;
    
    if ( result == NSFileHandlingPanelOKButton ) {
        file = [[panel URLs] objectAtIndex:0];
    }
    
    return file;
    
}

- (NSArray *) getFilesInFolder:(NSURL *)folder {
    
    if (!folder) {
        return nil;
    }
    
    NSFileManager *fm = [NSFileManager defaultManager];
    
    NSError *readError;
    NSArray *fileUrls = [fm contentsOfDirectoryAtURL:folder 
                          includingPropertiesForKeys:[NSArray array] 
                                             options:(NSDirectoryEnumerationSkipsSubdirectoryDescendants | NSDirectoryEnumerationSkipsPackageDescendants | NSDirectoryEnumerationSkipsHiddenFiles)
                                               error:&readError];
    
    NSMutableArray *files = [NSMutableArray array];
    
    for ( NSURL *url in fileUrls ) {
        [files addObject:[url path]];
    }
    
    return [NSArray arrayWithArray:files];
}

#pragma mark - File I/O Stack -

- (NSString *) stringFromFileInBundleWithName:(NSString *)fileName extension:(NSString *)fileExtension {
    
    NSURL *dataURL = [[NSBundle mainBundle] URLForResource:fileName withExtension:fileExtension];
    
    if (!dataURL) {
        return nil;
    }
    
	NSError *readError;
	NSString *dataString = [NSString stringWithContentsOfURL:dataURL encoding:NSUTF8StringEncoding error:&readError];
	if ( !dataString ) {
		return nil;
	}
    
	return dataString;
}

- (NSURL *) urlToFileInBundleWithName:(NSString *)fileName extension:(NSString *)fileExtension {
    return [[NSBundle mainBundle] URLForResource:fileName withExtension:fileExtension];
    
}

- (NSError *) writeString:(NSString *)content toURL:(NSURL *)url withName:(NSString *)name {
    
    if ( !content || !url || !name ) {
        return nil;
    }
    
    NSURL *fileWritePath = [url URLByAppendingPathComponent:name isDirectory:NO];
    
    if ( !fileWritePath ) {
        return nil;
    }
    
    NSError *fileWriteError;
    [content writeToURL:fileWritePath atomically:NO encoding:NSUTF8StringEncoding error:&fileWriteError];
    return fileWriteError;
}

- (NSURL *) makeFolder:(NSString *)folderName parentFolder:(NSURL *)parent {
    
    if ( !folderName || !parent ) {
        return nil;
    }
    
	NSURL *targetFolderURL = [parent URLByAppendingPathComponent:folderName];
	NSString *targetFolderPath = [targetFolderURL path];
    
	NSFileManager *fileManager = [NSFileManager defaultManager];
    
	BOOL isDirectory;
    
	if ( [fileManager fileExistsAtPath:targetFolderPath isDirectory:&isDirectory] ) {
        
		NSError *remError;
		BOOL folderRemoved = [fileManager removeItemAtPath:targetFolderPath error:&remError];
        
		if ( !folderRemoved ) {
			return nil;
		}
	}
    
	NSError *dirError;
	BOOL folderCreated = [fileManager createDirectoryAtPath:targetFolderPath withIntermediateDirectories:NO attributes:nil error:&dirError];
    
	if ( !folderCreated ) {
		return nil;
	}
    
	return targetFolderURL;
    
}

- (BOOL) populateFolder:(NSURL *)folder withInternalAsset:(NSString *)fileName extension:(NSString *)fileExtension {
    
    if ( !folder || !fileName || !fileExtension ) {
        return NO;
    }
    
    NSURL *assetUrl = [self urlToFileInBundleWithName:fileName 
                                            extension:fileExtension];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSData *assetData = [fileManager contentsAtPath:[assetUrl path]];
    NSURL *writeAssetUrl = [folder URLByAppendingPathComponent:[NSString stringWithFormat:@"%@.%@", fileName, fileExtension] 
                                                   isDirectory:NO];
    return [fileManager createFileAtPath:[writeAssetUrl path] 
                                contents:assetData 
                              attributes:nil];
}

- (NSError *) copyFile:(NSURL *)file toFolder:(NSURL *)folder {
    // target path requires the file name included
    NSURL *targetPath = [folder URLByAppendingPathComponent:[file lastPathComponent] isDirectory:NO];
    // perform the copy
    NSError *copyError;
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL fileCopied = [fileManager copyItemAtURL:file toURL:targetPath error:&copyError];
    if (fileCopied) {
        return nil;
    }
    return copyError;
}

#pragma mark - Path Management Stack -

- (NSString *) convertPosixPathtoHfsPath:(NSString *)posixPath isDirectory:(BOOL)isDirectory {
    
    NSString *firstChar = [posixPath substringToIndex:1];
    if ( ![firstChar isEqualToString:@"/"] ) {
        return posixPath;
    }
    
    CFURLRef myURL = CFURLCreateWithFileSystemPath(NULL, (__bridge CFStringRef)posixPath, kCFURLPOSIXPathStyle, isDirectory);
    NSString *hfsPath = (__bridge NSString *)CFURLCopyFileSystemPath(myURL, kCFURLHFSPathStyle);
    CFRelease(myURL);
    return hfsPath;
    
}

@end
