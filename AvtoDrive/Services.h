//
//  Services.h
//  AvtoDrive
//
//  Created by Admin on 18.09.18.
//  Copyright © 2018 Admin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface Services : UIView
@property (strong, nonatomic) IBOutlet UIView *container;
@property (weak, nonatomic) IBOutlet UIView *viewPrice;
@property (weak, nonatomic) IBOutlet UITextField *price;
@property (weak, nonatomic) IBOutlet UIButton *add_service;
@property (weak, nonatomic) IBOutlet UIButton *del_service;
@property (weak, nonatomic) IBOutlet UILabel *typeText;
@property (nonatomic,copy) NSString *currService;
@property NSString *typeSeque;
- (IBAction)add:(id)sender;
@property (weak, nonatomic) IBOutlet UIView *viewType;
- (void)initDefaultMenu;

@end
