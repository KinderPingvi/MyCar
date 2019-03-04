//
//  ComboBoxButton.m
//  AvtoDrive
//
//  Created by Admin on 30.09.18.
//  Copyright © 2018 Admin. All rights reserved.
//

#import "ComboBoxButton.h"

@implementation ComboBoxButton

-(instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if(self)
    {
        [self customInit];
    }
    return self;
}
-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if(self)
    {
       self.container.frame = self.bounds;
        [self customInit];
    }
    return self;
}
-(void)customInit
{
    [[NSBundle mainBundle]loadNibNamed:@"MyCombo" owner:self options:nil ];
    [self addSubview:self.container];
}

@end
