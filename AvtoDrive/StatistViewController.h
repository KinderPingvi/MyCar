//
//  StatistViewController.h
//  AvtoDrive
//
//  Created by Admin on 12.10.18.
//  Copyright © 2018 Admin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VBPieChart.h"
@interface StatistViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIBarButtonItem *sidebar;
@property (weak, nonatomic) IBOutlet UIView *cars;
@property (weak, nonatomic) IBOutlet UIView *viewAll;
@property (weak, nonatomic) IBOutlet UIView *viewM;
@property (weak, nonatomic) IBOutlet UIView *viewP;
@property (weak, nonatomic) IBOutlet UIView *viewS;
@property (weak, nonatomic) IBOutlet UILabel *cars_text;
@property (weak, nonatomic) IBOutlet UIView *viewT;
@property (weak, nonatomic) IBOutlet VBPieChart *chart;
@property (weak, nonatomic) IBOutlet UILabel *priceS;
@property (weak, nonatomic) IBOutlet UILabel *priceT;
@property (weak, nonatomic) IBOutlet UILabel *priceM;
@property (weak, nonatomic) IBOutlet UILabel *priceP;
@property (weak, nonatomic) IBOutlet UILabel *priceAll;


@end
