//
//  HolyWarViewController.h
//  Bahamut_KyoMa
//
//  Created by Athena on 13/10/26.
//  Copyright (c) 2013年 Athena. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "InstalledAppReader.h"
#import "BahamutAPI.h"
@interface HolyWarViewController : UIViewController
{
    NSTimer* counter;
}

@property (strong, nonatomic) IBOutlet UISwitch *autoRefresh;
@property (strong, nonatomic) NSString *sid;
@property (strong, nonatomic) IBOutlet UIButton *refreshButton;
@property (strong, nonatomic) IBOutlet UISlider *pageSlider;
@property (strong, nonatomic) IBOutlet UIButton *buttonOfAutomaticity;
@property (strong, nonatomic) IBOutlet UILabel *displayPageSlider;

@property (strong, nonatomic) IBOutlet UILabel *ownGroupScore;
@property (strong, nonatomic) IBOutlet UILabel *enemyGroupScore;
@property (strong, nonatomic) IBOutlet UILabel *selfScore;


@property (strong, nonatomic) IBOutlet UILabel *ListFirstName;
@property (strong, nonatomic) IBOutlet UILabel *ListFirstPosition;
@property (strong, nonatomic) IBOutlet UILabel *ListSecondName;
@property (strong, nonatomic) IBOutlet UILabel *ListSecondPosition;
@property (strong, nonatomic) IBOutlet UILabel *ListThirdName;
@property (strong, nonatomic) IBOutlet UILabel *ListThirdPosition;
@property (strong, nonatomic) IBOutlet UILabel *ListFourthName;
@property (strong, nonatomic) IBOutlet UILabel *ListFourthPosition;
@property (strong, nonatomic) IBOutlet UILabel *ListFivethName;
@property (strong, nonatomic) IBOutlet UILabel *ListFivethPosition;

-(IBAction)updataSliderValue:(id)sender;
-(IBAction)switchValueChange:(id)sender;
-(IBAction)refreshPage;

@end
