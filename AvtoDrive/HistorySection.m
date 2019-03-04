//
//  HistorySection.m
//  AvtoDrive
//
//  Created by Admin on 24.09.18.
//  Copyright © 2018 Admin. All rights reserved.
//

#import "HistorySection.h"

@implementation HistorySection

-(instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if(self)
    {
        [[NSBundle mainBundle]loadNibNamed:@"HistorySect" owner:self options:nil ];
      /*  self.type.font = [UIFont fontWithName:@"Roboto-Regular" size:16];
        self.price.font = [UIFont fontWithName:@"Roboto-Regular" size:16];
        self.mileage.font = [UIFont fontWithName:@"Roboto-Regular" size:16];
        self.date.font = [UIFont fontWithName:@"Roboto-Regular" size:16];*/
        
        self.container.layer.shadowColor = [UIColor colorWithRed:24.f/255.f green:25.f/255.f blue:27.f/255.f alpha:1.f].CGColor;
        self.container.layer.shadowOffset = CGSizeMake(0.0f,4.0f);
        self.container.layer.masksToBounds = NO;
        self.container.layer.shadowRadius = 2.5f;
        self.container.layer.shadowOpacity = 0.2;
        [self addSubview:self.container];
    }
    return self;
}
-(void)setBackgroundColor:(UIColor *)backgroundColor
{
    [self.viewType setBackgroundColor:backgroundColor];
}
-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if(self)
    {
        [[NSBundle mainBundle]loadNibNamed:@"HistorySect" owner:self options:nil ];
        self.container.frame = self.bounds;
     /*   self.type.font = [UIFont fontWithName:@"Roboto-Light" size:14];
        self.price.font = [UIFont fontWithName:@"Roboto-Light" size:14];
        self.mileage.font = [UIFont fontWithName:@"Roboto-Light" size:14];
        self.date.font = [UIFont fontWithName:@"Roboto-Light" size:14];*/
        /*self.container.layer.shadowColor = [UIColor colorWithRed:24.f/255.f green:25.f/255.f blue:27.f/255.f alpha:1.f].CGColor;
        self.container.layer.shadowOffset = CGSizeMake(0.0f,4.0f);
        self.container.layer.masksToBounds = NO;
        self.container.layer.shadowRadius = 2.5f;
        self.container.layer.shadowOpacity = 0.2;*/
        
        [self addSubview:self.container];
    }
    return self;
}
@end
