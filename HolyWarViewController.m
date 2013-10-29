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
    [self refreshPage];
}

-(IBAction)switchValueChange:(id)sender
{
    if ([counter isValid]) {
        [counter invalidate];
        [refreshButton setTitle:refresh forState:UIControlStateNormal];
    }
    else
    {
        [refreshButton setTitle:@"20" forState:UIControlStateNormal];
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
    [refreshButton setTitle:refreshing forState:UIControlStateNormal];
    [self catchInformation];

}

-(void)catchInformation
{
    
}

@end
