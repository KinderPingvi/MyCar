//
//  Bar.m
//  AvtoDrive
//
//  Created by Admin on 05.10.18.
//  Copyright © 2018 Admin. All rights reserved.
//

#import "Bar.h"

@implementation Bar

-(instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if(self)
    {
        [[NSBundle mainBundle]loadNibNamed:@"NaviBar" owner:self options:nil ];
        [self addSubview:self.container];
    }
    return self;
}

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if(self)
    {
        [[NSBundle mainBundle]loadNibNamed:@"NaviBar" owner:self options:nil ];
        self.container.frame = self.bounds;
        [self addSubview:self.container];
    }
    return self;
}

@end
