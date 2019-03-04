//
//  AddPetrolViewController.h
//  AvtoDrive
//
//  Created by Admin on 13.09.18.
//  Copyright © 2018 Admin. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol Result <NSObject>
- (void) setResult: (NSString*) str;
@end
@interface AddPetrolViewController : UIViewController
@property(nonatomic,assign)id delegate;
@property (weak, nonatomic) IBOutlet UILabel *dateText;
@property (weak, nonatomic) IBOutlet UIView *viewDate;
@property (weak, nonatomic) IBOutlet UIView *viewMileage;
@property (weak, nonatomic) IBOutlet UITextField *mileageText;
@property (weak, nonatomic) IBOutlet UIView *viewTime;
@property (weak, nonatomic) IBOutlet UILabel *timeText;
@property (weak, nonatomic) IBOutlet UIView *viewPetrol;
@property (weak, nonatomic) IBOutlet UILabel *petrolText;
@property (weak, nonatomic) IBOutlet UIView *viewPrice;
@property (weak, nonatomic) IBOutlet UITextField *priceText;
@property (weak, nonatomic) IBOutlet UIView *viewKolvo;
@property (weak, nonatomic) IBOutlet UITextField *kolvoText;
@property (weak, nonatomic) IBOutlet UITextField *summText;
@property (weak, nonatomic) IBOutlet UIView *viewSumm;
@property (nonatomic) int currentId;
@end
