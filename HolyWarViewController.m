//
//  HolyWarViewController.m
//  Bahamut_KyoMa
//
//  Created by Athena on 13/10/26.
//  Copyright (c) 2013年 Athena. All rights reserved.
//

#import "HolyWarViewController.h"

@interface HolyWarViewController ()

@end

@implementation HolyWarViewController
@synthesize sid,selfScore,autoRefresh,refreshButton;
@synthesize pageSlider,displayPageSlider,ownGroupScore,enemyGroupScore,buttonOfAutomaticity;
@synthesize ListFirstName,ListFirstPosition,ListFivethName,ListFivethPosition,ListFourthName,ListFourthPosition,ListSecondName,ListSecondPosition,ListThirdName,ListThirdPosition;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.title = @"聖戰";
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

@end
