//
//  AppDelegate.h
//  AvtoDrive
//
//  Created by Admin on 22.08.18.
//  Copyright © 2018 Admin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CurrentCar.h"
@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong,nonatomic)NSString* databasePath;
@property CurrentCar* car;

@end

