//
//  CurrentCar.m
//  AvtoDrive
//
//  Created by Admin on 11.10.18.
//  Copyright © 2018 Admin. All rights reserved.
//

#import "CurrentCar.h"

@implementation CurrentCar
-(id)initAutoName:(NSString*)name_auto Icon:(NSString *)icon_auto Model:(NSString *)model_auto Marka:(NSString *)marka_auto Year:(NSString *)year_auto Id:(int)id_car Type:(NSString *)type_auto
{
    if(self=[super init])
    {
        self.name =name_auto;
        self.icon = icon_auto;
        self.model = model_auto;
        self.marka = marka_auto;
        self.year = year_auto;
        self.id_car = id_car;
        self.type = type_auto;
    }
    return self;
}
-(id)initDefoult
{
    if(self=[super init])
    {
        self.name =@"";
        self.icon = @"";
        self.model = @"";
        self.marka = @"";
        self.year = @"";
        self.id_car = 0;
        self.type = @"";
    }
    return self;
}
@end

