//
//  FirstViewController.h
//  Bahamut_KyoMa
//
//  Created by Athena on 13/9/17.
//  Copyright (c) 2013年 Athena. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "InstalledAppReader.h"

@interface FirstViewController : UIViewController<UITextFieldDelegate,UIPickerViewDelegate,UIActionSheetDelegate,UIPickerViewDataSource>

@property (strong, nonatomic) IBOutlet UILabel *displaySlider;
@property (strong, nonatomic) IBOutlet UISlider *slider;
@property (strong, nonatomic) IBOutlet UITextField *inputField;
@property (strong, nonatomic) IBOutlet UIButton *run;
@property (strong, nonatomic) IBOutlet UILabel *missionRevenge1;
@property (strong, nonatomic) IBOutlet UILabel *missionRevenge2;
@property (strong, nonatomic) IBOutlet UILabel *missionRevenge3;
@property (strong, nonatomic) NSString *sid;
@property (strong, nonatomic) IBOutlet UILabel *chapterLabel;
@property (strong, nonatomic) IBOutlet UILabel *cardNumber;
@property (strong, nonatomic) IBOutlet UILabel *physical_power;
@property (strong, nonatomic) IBOutlet UILabel *experience;

-(IBAction)updataSliderValue:(id)sender;
- (BOOL)textFieldShouldReturn:(UITextField *)textField;
-(IBAction)run:(id)sender;
@end
