//
//  HistoryCell.m
//  AvtoDrive
//
//  Created by Admin on 25.09.18.
//  Copyright © 2018 Admin. All rights reserved.
//

#import "HistoryCell.h"

@implementation HistoryCell

- (void)awakeFromNib {
    [super awakeFromNib];
  /*  self.nameItem.font = [UIFont fontWithName:@"Roboto-Light" size:10];
    self.priceItem.font = [UIFont fontWithName:@"Roboto-Light" size:10];*/
    // Initialization code
}
- (void)setFrame:(CGRect)frame {
    {
      /*  self.nameItem.font = [UIFont fontWithName:@"Roboto-Light" size:10];
        self.priceItem.font = [UIFont fontWithName:@"Roboto-Light" size:10];*/
        [super setFrame:frame];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
/* self.nameItem.font = [UIFont fontWithName:@"Roboto-Light" size:10];
     self.priceItem.font = [UIFont fontWithName:@"Roboto-Light" size:10];*/
    // Configure the view for the selected state
}

@end
