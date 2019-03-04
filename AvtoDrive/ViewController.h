//
//  ViewController.h
//  AvtoDrive
//
//  Created by Admin on 22.08.18.
//  Copyright © 2018 Admin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIButton *addAuto;
@property (weak, nonatomic) IBOutlet UIImageView *avtoImg;
@property (weak, nonatomic) IBOutlet UIView *viewImgA;
@property (weak, nonatomic) IBOutlet UITextField *year;
- (IBAction)addAuto:(UIButton *)sender;
@property BOOL edit;
@property NSString* carId;
@property (weak, nonatomic) IBOutlet UIView *viewName;
@property (weak, nonatomic) IBOutlet UIImageView *typeImg;
@property (weak, nonatomic) IBOutlet UITextField *model;
@property (weak, nonatomic) IBOutlet UIView *viewModel;
@property (weak, nonatomic) IBOutlet UITextField *mileage;
@property (weak, nonatomic) IBOutlet UIView *viewYear
;
@property (weak, nonatomic) IBOutlet UIView *viewMileage;
@property (weak, nonatomic) IBOutlet UIImageView *markaImg;
@property (weak, nonatomic) IBOutlet UILabel *markaText;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *sidebar;
@property (weak, nonatomic) IBOutlet UIView *type;
@property (weak, nonatomic) IBOutlet UIView *marka;
@property (weak, nonatomic) IBOutlet UITextField *name_avto;
@property (weak, nonatomic) IBOutlet UILabel *typeText;


@end

