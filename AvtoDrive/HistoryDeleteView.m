//
//  HistoryDeleteView.m
//  AvtoDrive
//
//  Created by Admin on 08.10.18.
//  Copyright © 2018 Admin. All rights reserved.
//

#import "HistoryDeleteView.h"

@implementation HistoryDeleteView

- (void)awakeFromNib {
    [super awakeFromNib];
    self.container.layer.shadowColor = [UIColor colorWithRed:24.f/255.f green:25.f/255.f blue:27.f/255.f alpha:1.f].CGColor;
    self.container.layer.shadowOffset = CGSizeMake(0.0f,4.0f);
    self.container.layer.masksToBounds = NO;
    self.container.layer.shadowRadius = 2.5f;
    self.container.layer.shadowOpacity = 0.2;
    
    [self.viewDel setBackgroundColor:[[UIColor alloc]initWithRed:52.0/255.0 green:59.0/255.0 blue:69.0/255.0 alpha:1.0]];
}
- (void)setFrame:(CGRect)frame {
    
        [super setFrame:frame];
    }
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    self.container.layer.shadowColor = [UIColor colorWithRed:24.f/255.f green:25.f/255.f blue:27.f/255.f alpha:1.f].CGColor;
    self.container.layer.shadowOffset = CGSizeMake(0.0f,4.0f);
    self.container.layer.masksToBounds = NO;
    self.container.layer.shadowRadius = 2.5f;
    self.container.layer.shadowOpacity = 0.2;
    [self.viewDel setBackgroundColor:[[UIColor alloc]initWithRed:52.0/255.0 green:59.0/255.0 blue:69.0/255.0 alpha:1.0]];
}

@end
