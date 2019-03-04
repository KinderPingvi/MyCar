//
//  MoykaViewController.h
//  AvtoDrive
//
//  Created by Admin on 09.10.18.
//  Copyright © 2018 Admin. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol Result <NSObject>
- (void) setResult: (NSString*) str;
@end

@interface MoykaViewController : UIViewController

@property(nonatomic,assign)id delegate;
@property (weak, nonatomic) IBOutlet UIView *viewMileage;
@property (weak, nonatomic) IBOutlet UITextField *mileage;
@property (weak, nonatomic) IBOutlet UIView *viewDate;
@property (weak, nonatomic) IBOutlet UILabel *dateText;
@property (weak, nonatomic) IBOutlet UIView *viewTime;
@property (weak, nonatomic) IBOutlet UILabel *timeText;
@property (weak, nonatomic) IBOutlet UIView *typeMoyka;
@property (weak, nonatomic) IBOutlet UILabel *moykaText;
@property (weak, nonatomic) IBOutlet UIView *viewPrice;
@property (weak, nonatomic) IBOutlet UITextField *priceText;
@property (nonatomic) int currentId;
@end
