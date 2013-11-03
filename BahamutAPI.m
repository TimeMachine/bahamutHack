//
//  BahamutAPI.m
//  Bahamut_KyoMa
//
//  Created by Athena on 13/10/26.
//  Copyright (c) 2013年 Athena. All rights reserved.
//

#import "BahamutAPI.h"

@implementation BahamutAPI

- (id) init {
    self = [super init];
    if (self != nil) {
        
    }
    return self;
}


-(NSString *)predicateData:(NSString *)data From:(NSString *)former to:(NSString *)latter{

    NSRange range;
    range = [data rangeOfString:former];
    data = [data substringFromIndex:range.location+range.length];
    range = [data rangeOfString:latter];
    return [data substringToIndex:range.location];
}

-(NSString *)predicateFromTheBackToFrontData:(NSString *)data From:(NSString *)former to:(NSString *)latter{
    
    NSRange range;
    range = [data rangeOfString:latter];
    data = [data substringToIndex:range.location];
    range = [data rangeOfString:former];
    data = [data substringFromIndex:range.location+range.length];
    return data;
}


-(NSMutableURLRequest *)setURLRequest
{
    NSMutableURLRequest* jsonQuest = [NSMutableURLRequest new];
    [jsonQuest addValue:@"bahamut-t-i.cygames.jp" forHTTPHeaderField:@"Host"];
    [jsonQuest addValue:@"gzip, deflate" forHTTPHeaderField:@"Accept-Encoding"];
    [jsonQuest addValue:@"text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8" forHTTPHeaderField:@"Accept"];
    [jsonQuest addValue:@"zh-tw" forHTTPHeaderField:@"Accept-Language"];
    [jsonQuest addValue:@"no-cache" forHTTPHeaderField:@"Pragma"];
    [jsonQuest addValue:@"keep-alive" forHTTPHeaderField:@"Connection"];
    [jsonQuest addValue:@"Mozilla/5.0 (iPhone; CPU iPhone OS 6_1 like Mac OS X) AppleWebKit/536.26 (KHTML, like Gecko) Mobile/10B143" forHTTPHeaderField:@"User-Agent"];
    return jsonQuest;
}

-(NSString *)sendPacket:(NSMutableURLRequest *)jsonQuest
{
    NSData * responseData;
    NSHTTPURLResponse *urlResponse = nil;
    NSString * data;
    NSRange range;
   do {
        responseData = [NSURLConnection sendSynchronousRequest:jsonQuest
                                             returningResponse:&urlResponse
                                                         error:nil];
        data = [NSString stringWithUTF8String:[responseData bytes]];
        range = [data rangeOfString:@"網路管制"];
        if (data != nil &&range.location != NSNotFound) {
            [[NSRunLoop mainRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:1]];
        }
    } while (data != nil && range.location != NSNotFound);
    return data;
}
@end
