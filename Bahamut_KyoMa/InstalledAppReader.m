//
//  InstalledAppReader.m
//  Bahamut_KyoMa
//
//  Created by Athena on 13/9/26.
//  Copyright (c) 2013年 Athena. All rights reserved.
//

#import "InstalledAppReader.h"

@implementation InstalledAppReader

#pragma mark - Init
-(NSMutableArray *)desktopAppsFromDictionary:(NSDictionary *)dictionary
{
    NSMutableArray *desktopApps = [NSMutableArray array];
    
    for (NSString *appKey in dictionary)
    {
        [desktopApps addObject:appKey];
    }
    return desktopApps;
}

-(NSDictionary *)installedApp
{
    BOOL isDir = NO;
    if([[NSFileManager defaultManager] fileExistsAtPath: installedAppListPath isDirectory: &isDir] && !isDir)
    {
        NSDictionary *cacheDict = [NSDictionary dictionaryWithContentsOfFile: installedAppListPath];
        NSDictionary *userApp = [cacheDict objectForKey:@"User"];
        return userApp;
    }
    
    //DLOG(@"can not find installed app plist");
    return nil;
}

@end
