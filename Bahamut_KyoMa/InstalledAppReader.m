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

-(NSString *)getSid
{
    NSString * path = [[[self installedApp] objectForKey:@"tw.mobage.h23000047"] objectForKey:@"Path"];
    path = [[path substringToIndex:[path rangeOfString:@"Bahamut-tw"].location] stringByAppendingString:@"Library/Cookies/Cookies.binarycookies"];
    NSFileManager *filemgr;
    NSData *databuffer = nil;
    filemgr = [NSFileManager defaultManager];
    if ([filemgr fileExistsAtPath:path] == YES)
        databuffer = [filemgr contentsAtPath:path];
    else
        NSLog (@"File not found");
    NSString *cookieData = [[NSString alloc] initWithBytes:[databuffer bytes] length:[databuffer length] encoding:NSASCIIStringEncoding];
    NSRange range = [cookieData rangeOfString:@"sid"];
    cookieData = [cookieData substringFromIndex:range.location+range.length+3];
    return [cookieData substringToIndex:42];
}

@end
