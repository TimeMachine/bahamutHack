//
//  FirstViewController.m
//  Bahamut_KyoMa
//
//  Created by Athena on 13/9/17.
//  Copyright (c) 2013年 Athena. All rights reserved.
//

#import "FirstViewController.h"
@interface FirstViewController ()
{
    int pickerSection;
    UIPickerView *SpeakPickerView ;
}

@end

@implementation FirstViewController
@synthesize displaySlider,slider,inputField,run,missionRevenge1,missionRevenge2,missionRevenge3,sid,chapterLabel;
@synthesize cardNumber,physical_power,experience;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = NSLocalizedString(@"刷任務", @"刷任務");
        self.tabBarItem.image = [UIImage imageNamed:@"first"];
        api = [[BahamutAPI alloc] init];
    }
    return self;
}

-(void)setChapterLabel:(int) chapter Section:(int) section
{
    int new_chapter,new_section;
    NSArray *listItems = [chapterLabel.text componentsSeparatedByString:@"-"];
    if (chapter)
        new_chapter = chapter;
    else
        new_chapter =  [[listItems objectAtIndex:0] integerValue];
    if ( section )
        new_section = section;
    else
    {
        if (new_chapter < 33 && [[listItems objectAtIndex:1] integerValue] == 6 )
            new_section = 5;
        else 
            new_section =  [[listItems objectAtIndex:1] integerValue];
    }
        chapterLabel.text = [NSString stringWithFormat:@"%d-%d",new_chapter,new_section];
    [self loadMissionPicture:new_chapter section:new_section];

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
    [SpeakPickerView removeFromSuperview];
}

-(void)loadMissionPicture:(int)chapter section:(int)section
{
    NSMutableURLRequest* jsonQuest = [api setURLRequest];
    NSHTTPURLResponse *urlResponse = nil;
    NSError *error = nil;
    NSString * queryURL = [NSString stringWithFormat:@"http://bahamut-t-i.cygames.jp/bahamut_t/quest/mission_list/%d",chapter];
    [jsonQuest setURL:[NSURL URLWithString:queryURL]];
    [jsonQuest setHTTPMethod:@"GET"];
    [jsonQuest addValue:[NSString stringWithFormat:@"sid=%@",sid] forHTTPHeaderField:@"Cookie"];
    [jsonQuest addValue:@"http://bahamut-t-i.cygames.jp/bahamut_t/quest/quest_list" forHTTPHeaderField:@"Referer"];
    
    NSData *responseData = [NSURLConnection sendSynchronousRequest:jsonQuest
                                                 returningResponse:&urlResponse
                                                             error:&error];
    NSString *data = [NSString stringWithUTF8String:[responseData bytes]];
    NSRange range;
    range = [data rangeOfString:[NSString stringWithFormat:@"%d-%d",chapter,section]];
    data = [data substringFromIndex:range.location+range.length];
    range = [data rangeOfString:[NSString stringWithFormat:@"http://bahamut-t-i.cygames.jp/bahamut_t/image_sp/"]];
    data = [data substringFromIndex:range.location+range.length];
    
    
    for (int i = 0; i < 3 ; i++) {
        range = [data rangeOfString:[NSString stringWithFormat:@"http://bahamut-t-i.cygames.jp/bahamut_t/image_sp/"]];
        data = [data substringFromIndex:range.location+range.length];
        
        if ([[data substringToIndex:2] isEqualToString:@"ui"]) {
            range = [data rangeOfString:@"\" width=\"80px\""];

        } else {
            range = [data rangeOfString:@"' width=\"80px\""];

        }
        queryURL = [NSString stringWithFormat:@"http://bahamut-t-i.cygames.jp/bahamut_t/image_sp/%@",[data substringToIndex:range.location]];
        [jsonQuest setURL:[NSURL URLWithString:queryURL]];
        [jsonQuest setValue: [NSString stringWithFormat:@"http://bahamut-t-i.cygames.jp/bahamut_t/quest/mission_list/%d",chapter] forHTTPHeaderField:@"Referer"];
        NSData *responseData = [NSURLConnection sendSynchronousRequest:jsonQuest
                                                     returningResponse:&urlResponse
                                                                 error:&error];
        UIImage *image=[UIImage imageWithData:responseData];
        CGSize imgSize = missionRevenge1.frame.size;
        
        UIGraphicsBeginImageContext( imgSize );
        [image drawInRect:CGRectMake(0,0,imgSize.width,imgSize.height)];
        UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        switch (i) {
            case 0:
                missionRevenge1.backgroundColor = [UIColor colorWithPatternImage:newImage];
                break;
            case 1:
                missionRevenge2.backgroundColor = [UIColor colorWithPatternImage:newImage];
                break;
            case 2:
                missionRevenge3.backgroundColor = [UIColor colorWithPatternImage:newImage];
                break;
        }
    }
    
    

}

-(void)loadInformation
{
    NSMutableURLRequest* jsonQuest = [api setURLRequest];
    NSHTTPURLResponse *urlResponse = nil;
    NSError *error = nil;
    NSString * queryURL = [NSString stringWithFormat:@"http://bahamut-t-i.cygames.jp/bahamut_t/card_list"];
    [jsonQuest setURL:[NSURL URLWithString:queryURL]];
    [jsonQuest setHTTPMethod:@"GET"];
    [jsonQuest addValue:[NSString stringWithFormat:@"sid=%@",sid] forHTTPHeaderField:@"Cookie"];
    
    NSData *responseData = [NSURLConnection sendSynchronousRequest:jsonQuest
                                                 returningResponse:&urlResponse
                                                             error:&error];
    NSString *data = [NSString stringWithUTF8String:[responseData bytes]];
    cardNumber.text = [api predicateData:data From:@"持有卡牌一覽(" to:@")"];
    
    queryURL = [NSString stringWithFormat:@"http://bahamut-t-i.cygames.jp/bahamut_t/quest"];
    [jsonQuest setURL:[NSURL URLWithString:queryURL]];
    
    responseData = [NSURLConnection sendSynchronousRequest:jsonQuest
                                                 returningResponse:&urlResponse
                                                             error:&error];
    data = [NSString stringWithUTF8String:[responseData bytes]];
    
    NSString* search = [NSString stringWithString:data];
    physical_power.text = [[api predicateData:search From:@"體力:</span> " to:@"</th>"]  stringByReplacingOccurrencesOfString:@"\t" withString:@""];
    
    search = [NSString stringWithString:data];
    
    experience.text = [[api predicateData:search From:@"經驗值:</span> " to:@"</th>"]  stringByReplacingOccurrencesOfString:@"\t" withString:@""];
}

-(IBAction)showActionSheet
{
    if ([self.view viewWithTag:101]) {
        [SpeakPickerView removeFromSuperview];
    }
    else
        [self.view addSubview:SpeakPickerView];
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    UITapGestureRecognizer *actionSheet = [[UITapGestureRecognizer alloc]
                                   initWithTarget:self
                                   action:@selector(showActionSheet)];
    
    [self.chapterLabel addGestureRecognizer:actionSheet];
    //建立挑選器視圖
    SpeakPickerView = [[UIPickerView alloc]initWithFrame:CGRectMake(0, 290, 320, 220)];
    
    SpeakPickerView.tag=101;
    SpeakPickerView.delegate=self;
    SpeakPickerView.dataSource=self;
    SpeakPickerView.showsSelectionIndicator=YES;
    [SpeakPickerView selectRow:1 inComponent:0 animated:NO];
    [SpeakPickerView selectRow:4 inComponent:1 animated:NO];
 
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
                                   initWithTarget:self
                                   action:@selector(dismissKeyboard)];
    
    [self.view addGestureRecognizer:tap];
    //[SpeakSheet addGestureRecognizer:tap];

    inputField.delegate = self;
    self.view.backgroundColor = [[UIColor alloc] initWithPatternImage:[UIImage imageNamed:@"PUSHEEN.png"]];
	// Do any additional setup after loading the view, typically from a nib.
    sid  = [[[InstalledAppReader alloc] init] getSid];
    
    [self loadMissionPicture:2 section:5];
    [self loadInformation];
}


-(IBAction)run:(id)sender
{
    while ([displaySlider.text intValue]) {
        NSArray *listItems = [chapterLabel.text componentsSeparatedByString:@"-"];
        int chapter = [[listItems objectAtIndex:0] integerValue];
        int section = [[listItems objectAtIndex:1] integerValue];
        
        NSMutableURLRequest* jsonQuest = [api setURLRequest];
        NSHTTPURLResponse *urlResponse = nil;
        NSError *error = nil;
        NSString * queryURL = [NSString stringWithFormat:@"http://bahamut-t-i.cygames.jp/bahamut_t/smart_phone_flash/questConvert/%d/%d",chapter,section];
        [jsonQuest setURL:[NSURL URLWithString:queryURL]];
        [jsonQuest setHTTPMethod:@"POST"];
        [jsonQuest addValue:[NSString stringWithFormat:@"sid=%@",sid] forHTTPHeaderField:@"Cookie"];
        [jsonQuest addValue:[NSString stringWithFormat:@"http://bahamut-t-i.cygames.jp/bahamut_t/quest/mission_list/%d",chapter] forHTTPHeaderField:@"Referer"];
        
        NSData *responseData = [NSURLConnection sendSynchronousRequest:jsonQuest
                                                     returningResponse:&urlResponse
                                                                 error:&error];
        NSString *data = [NSString stringWithUTF8String:[responseData bytes]];
        data = [api predicateData:data From:@"flashParam=" to:@"\""];
        
        NSMutableURLRequest* flashQuest = [api setURLRequest];
        queryURL = [NSString stringWithFormat:@"http://bahamut-t-i.cygames.jp/bahamut_t/quest/play/%d/%d?flashParam=%@",chapter,section,data];
        [flashQuest setURL:[NSURL URLWithString:queryURL]];
        [flashQuest setHTTPMethod:@"GET"];
        [flashQuest addValue:[NSString stringWithFormat:@"sid=%@",sid] forHTTPHeaderField:@"Cookie"];
        [flashQuest addValue:[NSString stringWithFormat:@"http://bahamut-t-i.cygames.jp/bahamut_t/smart_phone_flash/questConvert/%d/%d",chapter,section] forHTTPHeaderField:@"Referer"];
        
        responseData = [NSURLConnection sendSynchronousRequest:flashQuest
                                                     returningResponse:&urlResponse
                                                                 error:&error];

        
        slider.value--;
        displaySlider.text = [NSString stringWithFormat:@"%d",(int)slider.value];
        [self loadInformation];
        [[NSRunLoop mainRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:0.5]];
    }
}


#pragma mark -
#pragma mark - SpeakPickerView methods
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 2;
}
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if (component == 0) {
        return  45;
    }
    else if (component == 1 && pickerSection > 32)
        return 6;
    
    return 5;
}
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return [NSString stringWithFormat:@"%d", row+1];
    
}
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    if (component == 0) {
        pickerSection = row;
        [pickerView reloadComponent:1];
        [self setChapterLabel:row+1 Section:0];
        
    }
    else
    {
        [self setChapterLabel:0 Section:row+1];
    }
    
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
