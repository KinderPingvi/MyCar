//
//  GarageTableViewController.h
//  AvtoDrive
//
//  Created by Admin on 11.10.18.
//  Copyright © 2018 Admin. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol Result <NSObject>
- (void) setResult: (NSString*) str;
@end
@interface GarageTableViewController : UITableViewController
@property (weak, nonatomic) IBOutlet UIBarButtonItem *sidebar;
@property(nonatomic,assign)id delegate;
@end
