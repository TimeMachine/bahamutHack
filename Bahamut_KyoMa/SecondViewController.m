//
//  SecondViewController.m
//  Bahamut_KyoMa
//
//  Created by Athena on 13/9/17.
//  Copyright (c) 2013年 Athena. All rights reserved.
//

#import "SecondViewController.h"
#import "InstalledAppReader.h"
#define lastTabs 0
@interface SecondViewController ()

@end

@implementation SecondViewController
@synthesize damagePower,holyPowder,score,holyPowderControl,holyPowderType,sid;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = NSLocalizedString(@"小魔女煉金", @"小魔女煉金");
        self.tabBarItem.image = [UIImage imageNamed:@"second"];
    }
    return self;
}

- (IBAction)segmentedControlIndexChanged:(id)sender {
    switch ([sender selectedSegmentIndex]) {
        case 0:
            holyPowderType = 0;
            break;
            
        case 1:
            holyPowderType = 1;
            break;
    }
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

-(NSMutableArray *)getFiveEnemyIdForSID:(NSString *)sid{
    // get response
    NSHTTPURLResponse *urlResponse = nil;
    NSError *error = [[NSError alloc] init];
    NSMutableURLRequest* jsonQuest = [self setURLRequest];
    NSString * queryURL = [NSString stringWithFormat:@"http://bahamut-t-i.cygames.jp/bahamut_t/events/event_009/level"];
    [jsonQuest setURL:[NSURL URLWithString:queryURL]];
    [jsonQuest setHTTPMethod:@"GET"];
    [jsonQuest addValue:[NSString stringWithFormat:@"sid=%@",sid] forHTTPHeaderField:@"Cookie"];
    [jsonQuest addValue:@"http://bahamut-t-i.cygames.jp/bahamut_t/events/event_009" forHTTPHeaderField:@"Referer"];
    //[jsonQuest setHTTPBody:[finailPost dataUsingEncoding:NSUTF8StringEncoding]];
    NSData *responseData = [NSURLConnection sendSynchronousRequest:jsonQuest
                                                 returningResponse:&urlResponse
                                                             error:&error];
    NSString *data = [NSString stringWithUTF8String:[responseData bytes]];
    NSRange range;
    NSMutableArray*arr = [[NSMutableArray alloc] init];
    for (int i = 0; i<5; i++) {
        range = [data rangeOfString:@"http://bahamut-t-i.cygames.jp/bahamut_t/events/event_009/battle_check/"];
        data = [data substringFromIndex:range.location+range.length];
        [arr addObject:[data substringWithRange:NSMakeRange(0, 9)]];
        data = [data substringFromIndex:9];
    }
    
    return arr;
    
}


-(NSMutableArray *)getEnemyCheckForSID:(NSString *)sid EnemyId:(NSString *)enemyId{
    // get response
    NSHTTPURLResponse *urlResponse = nil;
    NSError *error = [[NSError alloc] init];
    NSMutableURLRequest* jsonQuest = [self setURLRequest];
    NSString * queryURL = [NSString stringWithFormat:@"http://bahamut-t-i.cygames.jp/bahamut_t/events/event_009/battle_check/%@/0/0/9",enemyId];
    [jsonQuest setURL:[NSURL URLWithString:queryURL]];
    [jsonQuest setHTTPMethod:@"GET"];
    [jsonQuest addValue:@"http://bahamut-t-i.cygames.jp/bahamut_t/events/event_009/level" forHTTPHeaderField:@"Referer"];
    [jsonQuest addValue:[NSString stringWithFormat:@"sid=%@",sid] forHTTPHeaderField:@"Cookie"];
    NSData *responseData = [NSURLConnection sendSynchronousRequest:jsonQuest
                                                 returningResponse:&urlResponse
                                                             error:&error];
    NSMutableArray*arr = [[NSMutableArray alloc] init];
    NSString *data = [NSString stringWithUTF8String:[responseData bytes]];
    NSRange range;
    
    range = [data rangeOfString:@"攻戰力:</span>"];
    data = [data substringFromIndex:range.location+range.length];
    range = [data rangeOfString:@"⇒"];
    [arr addObject:[NSNumber numberWithInt:[[data substringToIndex:range.location]intValue]]];
    
    range = [data rangeOfString:@"<td align=\"right\" valign=\"middle\" style=\"text-align:right;\" width=\"100%\">"];
    data = [data substringFromIndex:range.location+range.length];
    range = [data rangeOfString:@"<br />"];
    [arr addObject:[[[[data substringToIndex:range.location] stringByReplacingOccurrencesOfString:@"\r" withString:@""] stringByReplacingOccurrencesOfString:@"\n" withString:@""]stringByReplacingOccurrencesOfString:@"\t" withString:@""]];
    range = [data rangeOfString:@"防戰力:</span>"];
    data = [data substringFromIndex:range.location+range.length];
    range = [data rangeOfString:@"<br />"];
    int Def = [[data substringToIndex:range.location] intValue];
    [arr addObject:[NSNumber numberWithInt:Def]];
    
    range = [data rangeOfString:@"sleeve_str\" value=\""];
    data = [data substringFromIndex:range.location+range.length];
    range = [data rangeOfString:@"\" />"];
    [arr addObject:[data substringToIndex:range.location]];
    return arr;
    
}

-(void)postEnemyBattle_ProcessingForSID:(NSString *)sid EnemyId:(NSString *)enemyId PostData:(NSString *)finailPost{
    // get response
    NSHTTPURLResponse *urlResponse = nil;
    NSError *error = [[NSError alloc] init];
    NSMutableURLRequest* jsonQuest = [self setURLRequest];
    NSString * queryURL = @"http://bahamut-t-i.cygames.jp/bahamut_t/events/event_009/battle_processing";
    [jsonQuest setURL:[NSURL URLWithString:queryURL]];
    [jsonQuest addValue:[NSString stringWithFormat:@"http://bahamut-t-i.cygames.jp/bahamut_t/events/event_009/battle_check/%@/0/0/9",enemyId] forHTTPHeaderField:@"Referer"];
    [jsonQuest addValue:@"no-cache" forHTTPHeaderField:@"Pragma"];
    [jsonQuest addValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [jsonQuest addValue:@"http://bahamut-t-i.cygames.jp" forHTTPHeaderField:@"Origin"];
    [jsonQuest setHTTPMethod:@"POST"];
    [jsonQuest addValue:[NSString stringWithFormat:@"sid=%@",sid] forHTTPHeaderField:@"Cookie"];
    [jsonQuest setHTTPBody:[finailPost dataUsingEncoding:NSUTF8StringEncoding]];
    NSData *responseData = [NSURLConnection sendSynchronousRequest:jsonQuest
                                                 returningResponse:&urlResponse
                                                             error:&error];
    
    
}

-(void)postUsePolyPowerForSID:(NSString *)sid{
    // get response
    NSHTTPURLResponse *urlResponse = nil;
    NSError *error = [[NSError alloc] init];
    NSMutableURLRequest* jsonQuest = [self setURLRequest];
    NSString * queryURL = @"http://bahamut-t-i.cygames.jp/bahamut_t/item/result";
    [jsonQuest setURL:[NSURL URLWithString:queryURL]];
    [jsonQuest addValue:@"http://bahamut-t-i.cygames.jp/bahamut_t/item/check/2" forHTTPHeaderField:@"Referer"];
    [jsonQuest addValue:@"no-cache" forHTTPHeaderField:@"Pragma"];
    [jsonQuest addValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [jsonQuest addValue:@"http://bahamut-t-i.cygames.jp" forHTTPHeaderField:@"Origin"];
    [jsonQuest setHTTPMethod:@"POST"];
    [jsonQuest addValue:[NSString stringWithFormat:@"sid=%@",sid] forHTTPHeaderField:@"Cookie"];
    if (!holyPowderType) {
        [jsonQuest setHTTPBody:[@"item_id=18&event_id=" dataUsingEncoding:NSUTF8StringEncoding]];
    } else {
        [jsonQuest setHTTPBody:[@"item_id=2&event_id=" dataUsingEncoding:NSUTF8StringEncoding]];
    }
    NSData *responseData = [NSURLConnection sendSynchronousRequest:jsonQuest
                                                 returningResponse:&urlResponse
                                                             error:&error];
    NSString *data = [NSString stringWithUTF8String:[responseData bytes]];
    NSRange range;
    
    range = [data rangeOfString:@"<span style=\"color:#ff0033;\">"];
    data = [data substringFromIndex:range.location+range.length];
    range = [data rangeOfString:@"</span>"];
    holyPowder.text = [data substringToIndex:range.location];
    damagePower.text =@"496";
    [[NSRunLoop mainRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:0.5]];
    
}


-(IBAction)Go:(id)sender
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSMutableArray* weakEnemyId = [userDefaults valueForKey:@"weakEnemyId"];
    if (weakEnemyId == nil) {
        weakEnemyId = [[NSMutableArray alloc] init];
    }
    while (1) {
        NSMutableArray* enemyId;
        NSString* attackId;
        NSMutableArray *enemyData;
        do {
            enemyId = [self getFiveEnemyIdForSID:sid];
            NSLog(@"%@",enemyId);
            bool haveHistoryWeakEnemy = NO;
            for (NSString * selectId in enemyId) {
                for (NSString * object in weakEnemyId) {
                    if ([object isEqualToString:selectId]) {
                        haveHistoryWeakEnemy = YES;
                        attackId = object;
                    }
                }
            }
            if (!haveHistoryWeakEnemy) 
                attackId = [enemyId objectAtIndex:0];
            enemyData = [self getEnemyCheckForSID:sid EnemyId:attackId];
            NSLog(@"%@",enemyData);
        } while ([[enemyData objectAtIndex:2] intValue] > 130);
        if (![weakEnemyId containsObject:attackId]) {
            [weakEnemyId addObject:attackId];
            [userDefaults setObject:weakEnemyId forKey:@"weakEnemyId"];
            [userDefaults synchronize];
        }
        if ([[enemyData objectAtIndex:0] intValue] < 140) {
            [self postEnemyBattle_ProcessingForSID:sid EnemyId:attackId PostData:[NSString stringWithFormat:@"enemy_id=%@&kind=0&color=0&event_id=9&friend=&sleeve_str=13659_9606_12129_2661_15924&deck_id=454722",attackId]];
            damagePower.text = [NSString stringWithFormat:@"%d",[[enemyData objectAtIndex:0] intValue]-131];
            [[NSRunLoop mainRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:0.5]];
            [self postUsePolyPowerForSID:sid];
        }
        else
        {
            [self postEnemyBattle_ProcessingForSID:sid EnemyId:attackId PostData:[NSString stringWithFormat:@"enemy_id=%@&kind=0&color=0&event_id=9&friend=&sleeve_str=13659_9606_12129_2661_15488&deck_id=454717",attackId]];
            damagePower.text = [NSString stringWithFormat:@"%d",[[enemyData objectAtIndex:0] intValue]-121];
            [[NSRunLoop mainRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:0.5]];
        }
    }
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    sid  = [[[InstalledAppReader alloc] init] getSid];
    
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
