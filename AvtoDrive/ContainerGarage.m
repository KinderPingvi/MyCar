//
//  ContainerGarage.m
//  AvtoDrive
//
//  Created by Admin on 12.10.18.
//  Copyright © 2018 Admin. All rights reserved.
//

#import "ContainerGarage.h"
#import "Bar.h"
#import "SWRevealViewController.h"
#import "GarageTableViewController.h"

@interface ContainerGarage ()
@property Bar *navBar;
@end

@implementation ContainerGarage

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navBar = [[Bar alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 80)];
    self.navBar.text.text = @"Гараж";
    [self.navBar.backButton setImage:[UIImage imageNamed:@"menu2.png"] forState:UIControlStateNormal];
    SWRevealViewController *revealViewController = self.revealViewController;
    if ( revealViewController )
    {
        [self.navBar.backButton addTarget:self.revealViewController action:@selector(revealToggle:)
                    forControlEvents:UIControlEventTouchUpInside];
        [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
    }
    [self.navBar.buttonOk addTarget:self action:@selector(addAuto:)
                   forControlEvents:UIControlEventTouchUpInside];
    
    [self.navBar.buttonOk setImage:[UIImage imageNamed:@"add.png"] forState:UIControlStateNormal];
    UIColor *cl = [[UIColor alloc]initWithRed:5.0/255.0 green:8.0/255.0 blue:18.0/255.0 alpha:1.0];
    [self.navBar.container setBackgroundColor:cl];
    [self.navBar.image setImage:[UIImage imageNamed:@"garage2.png"]];
    [self.view addSubview:self.navBar];
}

-(IBAction)addAuto:(id)sender
{
    [self performSegueWithIdentifier:@"addAuto" sender:self];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
