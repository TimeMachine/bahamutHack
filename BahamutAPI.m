//
//  BahamutAPI.m
//  Bahamut_KyoMa
//
//  Created by Athena on 13/10/26.
//  Copyright (c) 2013年 Athena. All rights reserved.
//

#import "BahamutAPI.h"

@implementation BahamutAPI
@dynamic delegate;
@synthesize content;

- (id) init {
    self = [super init];
    if (self != nil) {
        updatePackage = [NSMutableData new];
        
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

-(NSMutableURLRequest *)setURLRequest
{
    NSMutableURLRequest* jsonQuest = [NSMutableURLRequest new];
    [jsonQuest addValue:@"bahamut-t-i.cygames.jp" forHTTPHeaderField:@"Host"];
    [jsonQuest addValue:@"gzip, deflate" forHTTPHeaderField:@"Accept-Encoding"];
    [jsonQuest addValue:@"text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8" forHTTPHeaderField:@"Accept"];
    [jsonQuest addValue:@"zh-tw" forHTTPHeaderField:@"Accept-Language"];
    [jsonQuest addValue:@"keep-alive" forHTTPHeaderField:@"Connection"];
    [jsonQuest addValue:@"Mozilla/5.0 (iPhone; CPU iPhone OS 6_1 like Mac OS X) AppleWebKit/536.26 (KHTML, like Gecko) Mobile/10B143" forHTTPHeaderField:@"User-Agent"];
    return jsonQuest;
}


- (void)getCotentOfURLRequest:(NSMutableURLRequest *)request
{
    updatePackage = [[NSMutableData alloc] init];
    NSError * error = nil;
    dispatch_sync(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^ {
        isConnected = true;
        connection = [[NSURLConnection alloc]
                      initWithRequest:request
                      delegate:self
                      startImmediately:YES];
        
        if(!connection) {
            NSLog(@"connection failed");
            [delegate parser:self didFailWithDownloadError:error];
        } else {
            NSLog(@"connection succeeded");
            [delegate parserDidStartParsing:self];
        }
        
    });    
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    [delegate parserDidStartDownloading:self];
    NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
    if(httpResponse && [httpResponse respondsToSelector:@selector(allHeaderFields)]){
        NSDictionary *httpResponseHeaderFields = [httpResponse allHeaderFields];
        mFileSize = [[httpResponseHeaderFields objectForKey:@"Content-Length"] longLongValue];
    }
}

- (void)connection:(NSURLConnection *)_connection didFailWithError:(NSError *)error{
    isConnected = false;
    [connection cancel];
    [delegate parser:self didFailWithDownloadError:error];
    NSLog(@"HTTP DownloadError");
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data{
    [updatePackage appendData:data];
    float t = [updatePackage length]/1024;
    float t2= mFileSize/1024;
    NSString *output = [NSString stringWithFormat:@"正在下载 進度:%.2fk/%.2fk .",t,t2];
    [delegate parser:self didMakeProgress:t/t2 ];
    NSLog(@"%@",output);
}



- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    isConnected = false;
    content = [NSDictionary new];
    NSString * XMLResponse = [[NSString alloc] initWithData:updatePackage encoding:NSUTF8StringEncoding];
    XMLResponse = [XMLResponse stringByReplacingOccurrencesOfString:@"<br />" withString:@"\n"];
    [delegate parserDidFinishParsing:self];
    
}

-(void)CancelConnection{
    if(isConnected){
        isConnected = false;
        [connection cancel];
    }
    else return;
}

@end
