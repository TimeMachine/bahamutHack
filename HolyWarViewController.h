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
    NSOperationQueue *operationQueue;
    BahamutAPI *api;
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
@property (strong, nonatomic) IBOutlet UILabel *holypowderQuantity;


@property (strong, nonatomic) IBOutlet UILabel *ListFirstName;
@property (strong, nonatomic) IBOutlet UILabel *ListFirstPosition;
@property (strong, nonatomic) IBOutlet UILabel *ListFirstDenfend;
@property (strong, nonatomic) IBOutlet UILabel *ListFirstPoint;
@property (strong, nonatomic) IBOutlet UILabel *ListSecondName;
@property (strong, nonatomic) IBOutlet UILabel *ListSecondPosition;
@property (strong, nonatomic) IBOutlet UILabel *ListSecondDenfend;
@property (strong, nonatomic) IBOutlet UILabel *ListSecondPoint;
@property (strong, nonatomic) IBOutlet UILabel *ListThirdName;
@property (strong, nonatomic) IBOutlet UILabel *ListThirdPosition;
@property (strong, nonatomic) IBOutlet UILabel *ListThirdDenfend;
@property (strong, nonatomic) IBOutlet UILabel *ListThirdPoint;
@property (strong, nonatomic) IBOutlet UILabel *ListFourthName;
@property (strong, nonatomic) IBOutlet UILabel *ListFourthPosition;
@property (strong, nonatomic) IBOutlet UILabel *ListFourthDenfend;
@property (strong, nonatomic) IBOutlet UILabel *ListFourthPoint;
@property (strong, nonatomic) IBOutlet UILabel *ListFivethName;
@property (strong, nonatomic) IBOutlet UILabel *ListFivethPosition;
@property (strong, nonatomic) IBOutlet UILabel *ListFivethDenfend;
@property (strong, nonatomic) IBOutlet UILabel *ListFivethPoint;

-(IBAction)updataSliderValue:(id)sender;
-(IBAction)switchValueChange:(id)sender;
-(IBAction)refreshPage;
-(IBAction)attack:(id)sender;
- (IBAction)segmentedControlIndexChanged:(id)sender;

@end
