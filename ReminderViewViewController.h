//
//  ReminderViewViewController.h
//  AvtoDrive
//
//  Created by Admin on 05.10.18.
//  Copyright © 2018 Admin. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol Result <NSObject>
- (void) setResult: (NSString*) str;
@end
@interface ReminderViewViewController : UIViewController
@property(nonatomic,assign)id delegate;
@property (weak, nonatomic) IBOutlet UILabel *date_text;
@property (weak, nonatomic) IBOutlet UILabel *time_text;
@property (weak, nonatomic) IBOutlet UIView *menu;
@property (weak, nonatomic) IBOutlet UIView *type;
@property (weak, nonatomic) IBOutlet UIView *date;
@property (weak, nonatomic) IBOutlet UIView *time;
@property (weak, nonatomic) IBOutlet UIImageView *mileageImg;
@property (weak, nonatomic) IBOutlet UILabel *menuText;
@property (weak, nonatomic) IBOutlet UIView *viewMileage;
@property (weak, nonatomic) IBOutlet UILabel *typeText;
@property (weak, nonatomic) IBOutlet UITextField *mileage;
@property (nonatomic) int currentId;

@end
