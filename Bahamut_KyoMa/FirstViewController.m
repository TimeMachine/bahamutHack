//
//  FirstViewController.m
//  Bahamut_KyoMa
//
//  Created by Athena on 13/9/17.
//  Copyright (c) 2013年 Athena. All rights reserved.
//

#import "FirstViewController.h"

@interface FirstViewController ()

@end

@implementation FirstViewController
@synthesize displaySlider,slider,inputField,run,missionRevenge1,missionRevenge2,missionRevenge3,sid;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = NSLocalizedString(@"First", @"First");
        self.tabBarItem.image = [UIImage imageNamed:@"first"];
    }
    return self;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    slider.value = [inputField.text intValue];
    displaySlider.text = [NSString stringWithFormat:@"%d",(int)slider.value];
    return NO;
}

-(IBAction)updataSliderValue:(id)sender
{
    displaySlider.text = [NSString stringWithFormat:@"%d",(int)slider.value];
}

-(void)dismissKeyboard {
    [inputField resignFirstResponder];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
                                   initWithTarget:self
                                   action:@selector(dismissKeyboard)];
    
    [self.view addGestureRecognizer:tap];
    inputField.delegate = self;
    self.view.backgroundColor = [[UIColor alloc] initWithPatternImage:[UIImage imageNamed:@"PUSHEEN.png"]];
	// Do any additional setup after loading the view, typically from a nib.
    InstalledAppReader * reader = [[InstalledAppReader alloc] init];
    NSString * path = [[[reader installedApp] objectForKey:@"tw.mobage.h23000047"] objectForKey:@"Path"];
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
    sid = [cookieData substringToIndex:42];
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


-(IBAction)run:(id)sender
{
    while ([displaySlider.text intValue]) {
        NSMutableURLRequest* jsonQuest = [self setURLRequest];
        NSHTTPURLResponse *urlResponse = nil;
        NSError *error = [[NSError alloc] init];
        NSString * queryURL = [NSString stringWithFormat:@"http://bahamut-t-i.cygames.jp/bahamut_t/smart_phone_flash/questConvert/2/5"];
        [jsonQuest setURL:[NSURL URLWithString:queryURL]];
        [jsonQuest setHTTPMethod:@"POST"];
        [jsonQuest addValue:[NSString stringWithFormat:@"sid=%@",sid] forHTTPHeaderField:@"Cookie"];
        [jsonQuest addValue:@"http://bahamut-t-i.cygames.jp/bahamut_t/quest/mission_list/2" forHTTPHeaderField:@"Referer"];
        
        NSData *responseData = [NSURLConnection sendSynchronousRequest:jsonQuest
                                                     returningResponse:&urlResponse
                                                                 error:&error];
        NSString *data = [NSString stringWithUTF8String:[responseData bytes]];
        NSRange range;
        
        range = [data rangeOfString:@"flashParam="];
        data = [data substringFromIndex:range.location+range.length];
        range = [data rangeOfString:@"\""];
        data = [data substringToIndex:range.location];
        
        
        NSMutableURLRequest* flashQuest = [self setURLRequest];
        queryURL = [NSString stringWithFormat:@"http://bahamut-t-i.cygames.jp/bahamut_t/quest/play/2/5?flashParam=%@",data];
        [flashQuest setURL:[NSURL URLWithString:queryURL]];
        [flashQuest setHTTPMethod:@"GET"];
        [flashQuest addValue:[NSString stringWithFormat:@"sid=%@",sid] forHTTPHeaderField:@"Cookie"];
        [flashQuest addValue:@"http://bahamut-t-i.cygames.jp/bahamut_t/smart_phone_flash/questConvert/2/5" forHTTPHeaderField:@"Referer"];
        
        responseData = [NSURLConnection sendSynchronousRequest:flashQuest
                                                     returningResponse:&urlResponse
                                                                 error:&error];

        
        slider.value--;
        displaySlider.text = [NSString stringWithFormat:@"%d",(int)slider.value];
        [[NSRunLoop mainRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:0.5]];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
