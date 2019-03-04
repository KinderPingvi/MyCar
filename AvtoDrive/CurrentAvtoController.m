//
//  CurrentAvtoController.m
//  AvtoDrive
//
//  Created by Admin on 31.08.18.
//  Copyright © 2018 Admin. All rights reserved.
//

#import "CurrentAvtoController.h"
#import "SWRevealViewController.h"
#import "ServiceViewController.h"
@interface CurrentAvtoController ()

@end

@implementation CurrentAvtoController

- (void)viewDidLoad {
    [super viewDidLoad];
    SWRevealViewController *revealViewController = self.revealViewController;
    if ( revealViewController )
    {
        [self.sidebar setTarget: self.revealViewController];
        [self.sidebar setAction: @selector( revealToggle: )];
        [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    ServiceViewController *servic = [segue destinationViewController];;
    if ([segue.identifier isEqualToString:@"service"]) {
        servic.typeSeque= @"service";
    }
    
    if ([segue.identifier isEqualToString:@"tuning"]) {
        servic.typeSeque = @"tuning";
    }
    
}

@end
