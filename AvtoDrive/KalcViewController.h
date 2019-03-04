//
//  KalcViewController.h
//  AvtoDrive
//
//  Created by Admin on 12.10.18.
//  Copyright © 2018 Admin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface KalcViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIView *viewPetrol;
@property (weak, nonatomic) IBOutlet UIView *viewMileage;
@property (weak, nonatomic) IBOutlet UIView *viewPrice;
@property (weak, nonatomic) IBOutlet UITextField *priceText;
@property (weak, nonatomic) IBOutlet UITextField *mileageText;
@property (weak, nonatomic) IBOutlet UITextField *petrolText;
@property (weak, nonatomic) IBOutlet UIView *line;
@property (weak, nonatomic) IBOutlet UIButton *buttonCalc;
@property (weak, nonatomic) IBOutlet UIView *viewResPetrol;
@property (weak, nonatomic) IBOutlet UIView *viewResPrice;
@property (weak, nonatomic) IBOutlet UITextField *R_petrolText;
@property (weak, nonatomic) IBOutlet UITextField *R_priceText;

@end
