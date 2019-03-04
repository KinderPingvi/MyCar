//
//  MainMenu.h
//  AvtoDrive
//
//  Created by Admin on 11.10.18.
//  Copyright © 2018 Admin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MainMenu : UITableViewController
@property (weak, nonatomic) IBOutlet UILabel *nameAuto;
@property (weak, nonatomic) IBOutlet UILabel *model;
@property (weak, nonatomic) IBOutlet UILabel *markaYear;
@property (weak, nonatomic) IBOutlet UIImageView *iconAuto;

@end
