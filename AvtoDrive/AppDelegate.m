//
//  AppDelegate.m
//  AvtoDrive
//
//  Created by Admin on 22.08.18.
//  Copyright © 2018 Admin. All rights reserved.
//

#import "AppDelegate.h"
#import "FMDB.h"

@interface AppDelegate ()

@end

@implementation AppDelegate
//Копируем базу в документы при первом запуске
- (void) FMDBInitializer{
    
    NSArray *documentPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentDir = [documentPaths objectAtIndex:0];
   NSString *databasePath = [documentDir stringByAppendingPathComponent:@"db.sqlite3"];
   
    NSLog(@"%@",databasePath);
    
    BOOL success;
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    success = [fileManager fileExistsAtPath:databasePath];
     self.databasePath = databasePath;
   
    
    if(!success){
        NSString *databasePathFromApp = @"/Users/admin/Desktop/AvtoDrive/AvtoDrive/db.sqlite3";
        NSLog(@"%@", databasePathFromApp);
        [fileManager copyItemAtPath:databasePathFromApp toPath:databasePath error:nil];
        
    }
    else {
    }
}
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [self FMDBInitializer];
    UINavigationBar *bar = [UINavigationBar appearance];
    [bar setTintColor:[UIColor whiteColor]];
    [bar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                 [UIFont fontWithName:@"Helvetica-Light" size:15.0], NSFontAttributeName, nil]];
    bar.backItem.title = @"";
    
    NSString * query = [NSString stringWithFormat:@"select id,model,marka,type,year,name from auto where state = 1"];
    FMDatabase *database;
    database = [FMDatabase databaseWithPath:self.databasePath];
    if([database open])
    {
        FMResultSet *result = [database executeQuery:query];
        while([result next])
        {
            int id_car = [result intForColumn:@"id"];
            NSString* model = [result stringForColumn:@"model"];
            NSString* marka = [result stringForColumn:@"marka"];
            NSString* type = [result stringForColumn:@"type"];
            NSString* year = [result stringForColumn:@"year"];
            NSString* name = [result stringForColumn:@"name"];
            self.car = [[CurrentCar alloc] initAutoName:name Icon:@"" Model:model Marka:marka Year:year Id:id_car Type:type];
        }
    }
    return YES;
}
- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
