//
//  HolyWarViewController.m
//  Bahamut_KyoMa
//
//  Created by Athena on 13/10/26.
//  Copyright (c) 2013年 Athena. All rights reserved.
//

#import "HolyWarViewController.h"
#define refreshing @"Refreshing"
#define refresh @"Refresh"
#define timerInit @"3"
@interface HolyWarViewController ()
{
    int checkInformation;
    dispatch_queue_t q;
    NSMutableDictionary* enemyID;
    NSString* myDeckId;
    int holyPowderType;
}

@end

@implementation HolyWarViewController
@synthesize sid,selfScore,autoRefresh,refreshButton,holypowderQuantity;
@synthesize pageSlider,displayPageSlider,ownGroupScore,enemyGroupScore,buttonOfAutomaticity;
@synthesize ListFirstName,ListFirstPosition,ListFivethName,ListFivethPosition,ListFourthName,ListFourthPosition,ListSecondName,ListSecondPosition,ListThirdName,ListThirdPosition;
@synthesize ListFirstDenfend,ListFirstPoint,ListFivethDenfend,ListFivethPoint,ListFourthDenfend,ListFourthPoint,ListSecondDenfend,ListSecondPoint,ListThirdDenfend,ListThirdPoint;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.title = @"聖戰";
        api = [[BahamutAPI alloc] init];
        operationQueue = [[NSOperationQueue alloc] init];
        [operationQueue setMaxConcurrentOperationCount:5];
        q = dispatch_queue_create("foo", NULL);
        enemyID = [[NSMutableDictionary alloc] init];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    sid  = [[[InstalledAppReader alloc] init] getSid];
    
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)updataSliderValue:(id)sender
{
    displayPageSlider.text = [NSString stringWithFormat:@"%d",(int)pageSlider.value];
}

-(IBAction)switchValueChange:(id)sender
{
    if ([counter isValid]) {
        [counter invalidate];
        [refreshButton setTitle:refresh forState:UIControlStateNormal];
    }
    else
    {
        checkInformation = 0;
        [refreshButton setTitle:timerInit forState:UIControlStateNormal];
        counter = [NSTimer scheduledTimerWithTimeInterval:1.0f  target:self selector:@selector(runLoopForRefresh:) userInfo:nil repeats:YES];
    }
}

-(void)runLoopForRefresh:(NSTimer *) sender
{
    if (![refreshButton.titleLabel.text isEqualToString:refreshing]) {
        int count = [refreshButton.titleLabel.text integerValue];
        count--;
        if (count==0) {
            [self refreshPage];
            return;
        }
        [refreshButton setTitle:[NSString stringWithFormat:@"%d",count] forState:UIControlStateNormal];        
    }
    
}

-(IBAction)refreshPage
{
    if (![refreshButton.titleLabel.text isEqualToString:refreshing])
    {
        [refreshButton setTitle:refreshing forState:UIControlStateNormal];
        [self catchInformation];
    }
}

-(void)catchInformation
{
    NSInvocationOperation *operation = [[NSInvocationOperation alloc]
                                        initWithTarget:self selector:@selector(getInformation) object:nil];
    [operationQueue addOperation:operation];
    NSInvocationOperation *operation2 = [[NSInvocationOperation alloc]
                                        initWithTarget:self selector:@selector(getBattleList) object:nil];
    [operationQueue addOperation:operation2];
}

-(void)getInformation
{
    
    NSMutableURLRequest* jsonQuest = [api setURLRequest];
    NSString * queryURL = [NSString stringWithFormat:@"http://bahamut-t-i.cygames.jp/bahamut_t/holywar/holywar_top"];
    [jsonQuest setURL:[NSURL URLWithString:queryURL]];
    [jsonQuest setHTTPMethod:@"GET"];
    [jsonQuest setValue:@"http://bahamut-t-i.cygames.jp/bahamut_t/holywar/index" forHTTPHeaderField:@"Referer"];
    [jsonQuest addValue:[NSString stringWithFormat:@"sid=%@",sid] forHTTPHeaderField:@"Cookie"];
    NSString* data = [NSString stringWithString:[api sendPacket:jsonQuest]];
    
    if (![NSThread isMainThread])
        [self performSelectorOnMainThread:@selector(processDisplayInformation:) withObject:data waitUntilDone:YES];

}

-(void)processDisplayInformation:(id)data
{
    NSString* search = [NSString stringWithString:data];
    ownGroupScore.text = [api predicateData:search From:@"所屬騎士團聖戰點數:</span>" to:@"<br />"];
    enemyGroupScore.text = [api predicateData:search From:@"敵對騎士團聖戰點數:</span>" to:@"<br />"];
    selfScore.text = [api predicateData:search From:@"獲得聖戰點數:</span>" to:@"<br />"];
    [self checkGetInfotmationFinish];
}

-(void)getBattleList
{
    
    NSMutableURLRequest* jsonQuest = [api setURLRequest];
    NSString * queryURL;
    if ((int)pageSlider.value-1==0) {
        queryURL = [NSString stringWithFormat:@"http://bahamut-t-i.cygames.jp/bahamut_t/holywar/search_battle"];
        [jsonQuest setValue:@"http://bahamut-t-i.cygames.jp/bahamut_t/holywar/holywar_top" forHTTPHeaderField:@"Referer"];
    }
    else
    {
        queryURL = [NSString stringWithFormat:@"http://bahamut-t-i.cygames.jp/bahamut_t/holywar/search_battle/0/%d?from_type=0",((int)pageSlider.value-1)*5];
        [jsonQuest setValue:[NSString stringWithFormat:@"http://bahamut-t-i.cygames.jp/bahamut_t/holywar/search_battle/0/%d?from_type=0",((int)pageSlider.value-2)*5] forHTTPHeaderField:@"Referer"];
    }
    
    [jsonQuest setURL:[NSURL URLWithString:queryURL]];
    [jsonQuest setHTTPMethod:@"GET"];
    [jsonQuest addValue:[NSString stringWithFormat:@"sid=%@",sid] forHTTPHeaderField:@"Cookie"];
    NSString* data = [NSString stringWithString:[api sendPacket:jsonQuest]];
    
    if (![NSThread isMainThread])
        [self performSelectorOnMainThread:@selector(processBattleList:) withObject:data waitUntilDone:YES];
    
}

#define ListSectionFormer @"<td align=\"left\" valign=\"middle\" width=\"100%\" style=\"padding-left:5px;\">"
#define ListSectionLatter @"</div>"
-(void)processBattleList:(id)data
{
    NSString* search = [NSString stringWithString:data];
    NSRange range;
    NSString* section;
    NSString* name;
    NSString* detail;
    for (int i = 1; i < 6; i++) {
        range = [search rangeOfString:ListSectionFormer];
        search = [search substringFromIndex:range.location-1];
        section = [api predicateData:search From:ListSectionFormer to:ListSectionLatter];
        name = [api predicateData:section From:@"<span style=\"color:#FFBF00;\">" to:@"</span><br />"];
        
        range = [search rangeOfString:ListSectionLatter];
        search = [search substringFromIndex:range.location-1];
        
        range = [section rangeOfString:@"已100敗"];
        if (range.location != NSNotFound) {
            detail = @"已100敗";
            [enemyID setValue:@"已100敗" forKey:[NSString stringWithFormat:@"%d",i]];
        }
        else
        {
            range = [section rangeOfString:@"防禦隊長"];
            if (range.location != NSNotFound) {
                detail = @"防禦隊長";
                [enemyID setValue:@"防禦隊長" forKey:[NSString stringWithFormat:@"%d",i]];
            }
            else
            {
                detail = [api predicateData:[api predicateData:section From:@"<span style=\"padding:1px;" to:@"<img"] From:@";\">" to:@"</span>"];
                NSString * thisSectionEnemyID =[api predicateData:section From:@"deck_id=&other_id=" to:@"\">"];
                [enemyID setValue:thisSectionEnemyID forKey:[NSString stringWithFormat:@"%d",i]];
                NSInvocationOperation *operation = [[NSInvocationOperation alloc]
                                                    initWithTarget:self selector:@selector(getAttackConfirmForId:) object:@[thisSectionEnemyID,[NSNumber numberWithInt:i]]];
                [operationQueue addOperation:operation];
            }
        }
        switch (i) {
            case 1:
                ListFirstName.text = name;
                ListFirstPosition.text = detail;
                break;
            case 2:
                ListSecondName.text = name;
                ListSecondPosition.text = detail;
                break;
            case 3:
                ListThirdName.text = name;
                ListThirdPosition.text = detail;
                break;
            case 4:
                ListFourthName.text = name;
                ListFourthPosition.text = detail;
                break;
            case 5:
                ListFivethName.text = name;
                ListFivethPosition.text = detail;
                break;
            default:
                break;
        }
    }
    [self checkGetInfotmationFinish];
}

-(void)checkGetInfotmationFinish
{
    dispatch_sync(q, ^{
        checkInformation++;
        if (checkInformation > 1) {
            if ([counter isValid]) {
                [refreshButton setTitle:timerInit forState:UIControlStateNormal];
            }
            else
            {
                [refreshButton setTitle:refresh forState:UIControlStateNormal];
            }
            checkInformation = 0;
        }
    });
}

-(IBAction)attack:(id)sender
{
    UIButton* button = (UIButton*)sender;
    if (![[enemyID objectForKey:[NSString stringWithFormat:@"%d",button.tag]] isEqualToString:@"已100敗"]&&![[enemyID objectForKey:[NSString stringWithFormat:@"%d",button.tag]] isEqualToString:@"防禦隊長"]  ) {
        NSInvocationOperation *operation = [[NSInvocationOperation alloc]
                                            initWithTarget:self selector:@selector(postAttackRequest:) object:[enemyID objectForKey:[NSString stringWithFormat:@"%d",button.tag]]];
        [operationQueue addOperation:operation];
    }
}

-(void)getAttackConfirmForId:(id)data
{
    NSString* attackId = [data objectAtIndex:0];
    NSMutableURLRequest* confirmQuest = [api setURLRequest];
    NSString * queryURL = [NSString stringWithFormat:@"http://bahamut-t-i.cygames.jp/bahamut_t/holywar/battle_vs_other_confirm?deck_id=&other_id=%@",attackId];
    [confirmQuest setURL:[NSURL URLWithString:queryURL]];
    [confirmQuest setHTTPMethod:@"GET"];
    [confirmQuest setValue:[NSString stringWithFormat:@"http://bahamut-t-i.cygames.jp/bahamut_t/holywar/search_battle"] forHTTPHeaderField:@"Referer"];
    [confirmQuest addValue:[NSString stringWithFormat:@"sid=%@",sid] forHTTPHeaderField:@"Cookie"];
    NSString* response = [NSString stringWithString:[api sendPacket:confirmQuest]];
    
    if ([[data objectAtIndex:1] intValue]) {
        if (![NSThread isMainThread])
            [self performSelectorOnMainThread:@selector(processAttackConfirm:) withObject:@[response,[data objectAtIndex:1]] waitUntilDone:YES];
    }
}

-(void)processAttackConfirm:(id)data
{
    NSString* response = [data objectAtIndex:0];
    int i = [[data objectAtIndex:1] intValue];
    NSString* defend = [api predicateData:response From:@"防戰力:</span>" to:@"<br />"];
    NSString* point = [api predicateData:response From:@"預計獲得聖戰點數:</span>" to:@"<br />"];
    if (![point intValue]) {
        point = [api predicateData:response From:@"預計獲得聖戰點數:</span><span style=\"font-size:medium;\">" to:@"</span>"];
    }
    NSString* holyPowderSection = [api predicateData:response From:@"<tr class=\"_target_stock\">" to:@"</tr>"];
    NSString* holyPowder = nil;
    NSRange range;
   do {
        holyPowder = [api predicateData:holyPowderSection From:@"<td><div style=\"color:#FFBF00;\">" to:@"個</div></td>"];
        range = [holyPowderSection rangeOfString:@"<td><div style=\"color:#FFBF00;\">"];
        holyPowderSection = [holyPowderSection substringFromIndex:range.location-1];
        range = [holyPowderSection rangeOfString:@"<td><div style=\"color:#FFBF00;\">"];
    } while (range.location != NSNotFound);
    holypowderQuantity.text = holyPowder;
    myDeckId = [api predicateFromTheBackToFrontData:response From:@"<option value=\"" to:@"\" selected"];
    switch (i) {
        case 1:
            ListFirstDenfend.text = defend;
            ListFirstPoint.text = point;
            break;
        case 2:
            ListSecondDenfend.text = defend;
            ListSecondPoint.text = point;
            break;
        case 3:
            ListThirdDenfend.text = defend;
            ListThirdPoint.text = point;
            break;
        case 4:
            ListFourthDenfend.text = defend;
            ListFourthPoint.text = point;
            break;
        case 5:
            ListFivethDenfend.text = defend;
            ListFivethPoint.text = point;
            break;
        default:
            break;
    }
}


-(void)postAttackRequest:(id)data
{
    int localHolyPowderType = holyPowderType;
    NSRange range,range1;
    NSString* attackId = (NSString *)data;
    NSString* response;
    do {
        [self getAttackConfirmForId:@[attackId,[NSNumber numberWithInt:0]]];
        
        NSMutableURLRequest* jsonQuest = [api setURLRequest];
        NSString * queryURL = [NSString stringWithFormat:@"http://bahamut-t-i.cygames.jp/bahamut_t/holywar/battle_vs_other_check"];
        [jsonQuest setURL:[NSURL URLWithString:queryURL]];
        [jsonQuest setHTTPMethod:@"POST"];
        [jsonQuest setValue:[NSString stringWithFormat:@"http://bahamut-t-i.cygames.jp/bahamut_t/holywar/battle_vs_other_confirm?deck_id=&other_id=%@",attackId] forHTTPHeaderField:@"Referer"];
        [jsonQuest setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
        [jsonQuest addValue:[NSString stringWithFormat:@"sid=%@",sid] forHTTPHeaderField:@"Cookie"];
        [jsonQuest addValue:@" http://bahamut-t-i.cygames.jp" forHTTPHeaderField:@"Origin"];
        if (localHolyPowderType == 1)
        {
                    [jsonQuest setHTTPBody:[[NSString stringWithFormat:@"other_id=%@&deck_id=%@&pawder=1&pawder_id=18",attackId,myDeckId] dataUsingEncoding:NSUTF8StringEncoding]];
        }
        else if (localHolyPowderType == 2)
        {
            [jsonQuest setHTTPBody:[[NSString stringWithFormat:@"other_id=%@&deck_id=%@&pawder=1&pawder_id=2",attackId,myDeckId] dataUsingEncoding:NSUTF8StringEncoding]];
        }
        else
        {
            [jsonQuest setHTTPBody:[[NSString stringWithFormat:@"other_id=%@&deck_id=%@",attackId,myDeckId] dataUsingEncoding:NSUTF8StringEncoding]];
        }
        response = [api sendPacket:jsonQuest];
        range = [response rangeOfString:@"抱歉，發生錯誤。"];
        range1 = [response rangeOfString:@"勇者之心"];
        
        NSInvocationOperation *operation = [[NSInvocationOperation alloc]
                                            initWithTarget:self selector:@selector(getInformation) object:nil];
        [operationQueue addOperation:operation];
        
    } while (response==nil||(range.location == NSNotFound && range1.location == NSNotFound));
    
    NSInvocationOperation *operation2 = [[NSInvocationOperation alloc]
                                         initWithTarget:self selector:@selector(getBattleList) object:nil];
    [operationQueue addOperation:operation2];
    
}

- (IBAction)segmentedControlIndexChanged:(id)sender {
    switch ([sender selectedSegmentIndex]) {
        case 0:
            holyPowderType = 0;
            break;
        case 1:
            holyPowderType = 1;
            break;
        case 2:
            holyPowderType = 2;
            break;
    }
}

@end
