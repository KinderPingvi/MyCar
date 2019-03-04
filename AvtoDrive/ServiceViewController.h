//
//  ServiceViewController.h
//  AvtoDrive
//
//  Created by Admin on 18.09.18.
//  Copyright © 2018 Admin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Services.h"
#import "ComboBoxButton.h"
#import "Bar.h"
#import "ServiceViewController.h"
@protocol Result <NSObject>
- (void) setResult: (NSString*) str;
@end

@interface ServiceViewController : UIViewController
@property(nonatomic,assign)id delegate;
@property (weak, nonatomic) IBOutlet UILabel *timeText;
@property (weak, nonatomic) IBOutlet UIView *viewTime;
@property (weak, nonatomic) IBOutlet UIView *viewDate;
@property (weak, nonatomic) IBOutlet UIButton *curr_time;
@property (weak, nonatomic) IBOutlet UIImageView *mileageImg;
@property (weak, nonatomic) IBOutlet UIButton *curr_date;
@property (weak, nonatomic) IBOutlet UIView *viewS;
@property (weak, nonatomic) IBOutlet UILabel *comboText;

@property (weak, nonatomic) IBOutlet UIButton *addService;
@property (weak, nonatomic) IBOutlet UILabel *dateText;
@property (weak, nonatomic) IBOutlet Services *serviceItem;
@property (nonatomic) int currentId;
@property (weak, nonatomic) IBOutlet UITextField *price;
@property (weak, nonatomic) IBOutlet UITextField *mileage;
@property (weak, nonatomic) IBOutlet UIView *viewPrice;
@property (weak, nonatomic) IBOutlet UIView *viewError;
@property NSString *typeSeque;
@property (weak, nonatomic) IBOutlet UIView *viewMileage;

@end
