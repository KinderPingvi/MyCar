//
//  HistoryTableViewController.h
//  AvtoDrive
//
//  Created by Admin on 23.09.18.
//  Copyright © 2018 Admin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ServiceViewController.h"
#import "CurrentCar.h"
@interface HistoryTableViewController : UITableViewController <Result>
@property int idAuto;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *sidebar;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *button_add;
@property CurrentCar *car;
-(void)loadEvents;
@end
