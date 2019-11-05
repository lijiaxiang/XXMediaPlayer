//
//  NSURL+UHiCloud.m
//  LGVideo
//
//  Created by Viper on 2019/1/10.
//  Copyright © 2019年 孙卫亮. All rights reserved.
//

#import "NSURL+UHiCloud.h"

@implementation NSURL (UHiCloud)
- (BOOL)skipiCloudBackup
{
    NSAssert(self.isFileURL, @"Excluded from iCloud backup needs a file URL.");
    
    BOOL fileExists = [[NSFileManager defaultManager] fileExistsAtPath: [self path]];
    if (fileExists == NO) {
        return NO;
    }
    
    NSError *error = nil;
    NSDictionary *resourceValues = [self resourceValuesForKeys:@[NSURLIsExcludedFromBackupKey] error:&error];
    BOOL isSkipped = [[resourceValues objectForKey:NSURLIsExcludedFromBackupKey] boolValue];
    if (isSkipped) {
        return YES;
    }
    
    BOOL success = [self setResourceValue: @(YES) forKey:NSURLIsExcludedFromBackupKey error: &error];
    if(!success){
        NSLog(@"Error excluding %@ from backup %@", [self lastPathComponent], error);
        NSLog(@"resourceValues = %@", [self resourceValuesForKeys:@[NSURLIsExcludedFromBackupKey] error:&error]);
    }
    
    return success;
}
@end
