//
//  BahamutAPI.h
//  Bahamut_KyoMa
//
//  Created by Athena on 13/10/26.
//  Copyright (c) 2013年 Athena. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BahamutAPI : NSObject

-(NSString *)predicateData:(NSString *)data From:(NSString *)former to:(NSString *)latter;
-(NSMutableURLRequest *)setURLRequest;
@end
