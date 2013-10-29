//
//  BahamutAPI.h
//  Bahamut_KyoMa
//
//  Created by Athena on 13/10/26.
//  Copyright (c) 2013年 Athena. All rights reserved.
//

#import <Foundation/Foundation.h>

@class BahamutAPI;
@protocol BahamutAPI_API_Delegate <NSObject>
@required
- (void)parserDidStartDownloading:(BahamutAPI *)parser;
- (void)parserDidStartParsing:(BahamutAPI *)parser;
- (void)parser:(BahamutAPI *)parser didMakeProgress:(CGFloat)percentDone;
- (void)parser:(BahamutAPI *)parser didFailWithDownloadError:(NSError *)error;
- (void)parser:(BahamutAPI *)parser didFailWithParseError:(NSError *)error;
- (void)parserDidFinishParsing:(BahamutAPI *)parser;
@end

@interface BahamutAPI : NSObject<NSURLConnectionDelegate>
{
    id delegate;
    int mFileSize;
    int currentRieceved;
    NSMutableData * updatePackage;
    NSDictionary *content;
    NSURLConnection *connection;
    BOOL isConnected;
}

@property (assign) id delegate;
@property (retain,nonatomic) NSDictionary* content;

-(NSString *)predicateData:(NSString *)data From:(NSString *)former to:(NSString *)latter;
-(NSMutableURLRequest *)setURLRequest;
@end
