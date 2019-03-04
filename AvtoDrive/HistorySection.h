//
//  HistorySection.h
//  AvtoDrive
//
//  Created by Admin on 24.09.18.
//  Copyright © 2018 Admin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HistorySection : UIView
@property (weak, nonatomic) IBOutlet UIImageView *arrow_end;
@property (weak, nonatomic) IBOutlet UIImageView *arrow_start;
@property (weak, nonatomic) IBOutlet UIImageView *imgType;
@property (weak, nonatomic) IBOutlet UIView *viewType;
@property (weak, nonatomic) IBOutlet UIView *colorLine;
@property (weak, nonatomic) IBOutlet UIImageView *date_img;
@property (weak, nonatomic) IBOutlet UILabel *dateText;
@property (weak, nonatomic) IBOutlet UIImageView *mileageImg;

@property (weak, nonatomic) IBOutlet UILabel *price;
@property (weak, nonatomic) IBOutlet UILabel *date;
@property (weak, nonatomic) IBOutlet UILabel *mileage;
@property (strong, nonatomic) IBOutlet UIView *container;
@property (weak, nonatomic) IBOutlet UILabel *type;
@property (weak, nonatomic) IBOutlet UIButton *click;
@property int id_main;
@end
