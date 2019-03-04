//
//  ServiceNavi.m
//  AvtoDrive
//
//  Created by Admin on 05.10.18.
//  Copyright © 2018 Admin. All rights reserved.
//

#import "ServiceNavi.h"

@interface ServiceNavi ()

@end

@implementation ServiceNavi

- (void)viewDidLoad {
    [super viewDidLoad];
    _barService.text.text = @"Сервис";
    [_barService.image setImage:[UIImage imageNamed:@"service_back.png"]];
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
