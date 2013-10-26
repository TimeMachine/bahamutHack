//
//  InstalledAppReader.h
//  Bahamut_KyoMa
//
//  Created by Athena on 13/9/26.
//  Copyright (c) 2013年 Athena. All rights reserved.
//

#import <Foundation/Foundation.h>
static NSString* const installedAppListPath = @"/private/var/mobile/Library/Caches/com.apple.mobile.installation.plist";

@interface InstalledAppReader : NSObject 

-(NSDictionary *)installedApp;
-(NSMutableDictionary *)appDescriptionFromDictionary:(NSDictionary *)dictionary;
-(NSString *)getSid;

@end