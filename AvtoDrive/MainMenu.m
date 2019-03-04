//
//  MainMenu.m
//  AvtoDrive
//
//  Created by Admin on 11.10.18.
//  Copyright © 2018 Admin. All rights reserved.
//

#import "MainMenu.h"
#import "AppDelegate.h"
#import "GarageTableViewController.h"
@interface MainMenu ()

@end

@implementation MainMenu

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadCar];
   
}
-(void)loadCar
{
    AppDelegate *app = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    if([app.car.name isEqualToString:@""])
        self.nameAuto.text = app.car.type;
    else
        self.nameAuto.text = app.car.name;
    
    self.model.text = app.car.model;
    self.markaYear.text = [NSString stringWithFormat:@"%@ %@",app.car.marka,app.car.year];
}
-(IBAction)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    [self loadCar];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
