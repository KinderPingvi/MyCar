//
//  CurrentCar.h
//  AvtoDrive
//
//  Created by Admin on 11.10.18.
//  Copyright © 2018 Admin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CurrentCar : NSObject
@property  int id_car;
@property NSString* name;
@property NSString* marka;
@property NSString* icon;
@property NSString* model;
@property NSString* year;
@property NSString* type;

-(void)setName:(NSString *)name;
-(void)setIcon:(NSString *)icon;
-(void)setType:(NSString *)type;
-(void)setMarka:(NSString *)marka;
-(void)setModel:(NSString *)model;
-(void)setYear:(NSString *)year;
-(void)setId_car:(int)id_car;

-(id)initAutoName:(NSString*)name_auto Icon:(NSString*)icon_auto Model:(NSString*)model_auto Marka:(NSString*)marka_auto Year:(NSString*)year_auto Id:(int)id_car Type:(NSString*)type_auto;
-(id)initDefoult;

@end
