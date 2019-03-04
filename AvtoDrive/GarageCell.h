//
//  GarageCell.h
//  AvtoDrive
//
//  Created by Admin on 11.10.18.
//  Copyright © 2018 Admin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GarageCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *backImage;
@property (weak, nonatomic) IBOutlet UILabel *nameAuto;
@property (weak, nonatomic) IBOutlet UIImageView *imageMarka;
@property (weak, nonatomic) IBOutlet UILabel *marka;
@property (weak, nonatomic) IBOutlet UILabel *model;
@property (weak, nonatomic) IBOutlet UIButton *btSet;
@property (weak, nonatomic) IBOutlet UIButton *btEdit;
@property NSString* year;
@property NSString* icon;
@property int id_car;
@property NSString* type;
@property (weak, nonatomic) IBOutlet UIView *viewBt;
@property (weak, nonatomic) IBOutlet UIButton *megoBt;

@end
