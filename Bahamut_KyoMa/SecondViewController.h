//
//  SecondViewController.h
//  Bahamut_KyoMa
//
//  Created by Athena on 13/9/17.
//  Copyright (c) 2013年 Athena. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SecondViewController : UIViewController
@property (strong, nonatomic) IBOutlet UIButton *button;
@property (strong, nonatomic) IBOutlet UILabel *damagePower;
@property (strong, nonatomic) IBOutlet UILabel *holyPowder;
@property (strong, nonatomic) IBOutlet UILabel *score;
@property (strong, nonatomic) IBOutlet UISegmentedControl *holyPowderControl;
@property (strong, nonatomic) NSString *sid;
@property bool holyPowderType;
-(IBAction)Go:(id)sender;
- (IBAction)segmentedControlIndexChanged:(id)sender;
@end
