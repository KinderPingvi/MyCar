//
//  MenuViewController.m
//  AvtoDrive
//
//  Created by Admin on 06.09.18.
//  Copyright © 2018 Admin. All rights reserved.
//

#import "MenuViewController.h"
#import "FMDatabase.h"
#import "AppDelegate.h"
#import "SWRevealViewController.h"
#import "CurrentAvtoController.h"
@interface MenuViewController ()

@end

@implementation MenuViewController
@synthesize cars;
- (void)viewDidLoad {
    [super viewDidLoad];
    //Загрузка автомобилей из базы данных
    // Получить указатель на делегат приложения
   /* AppDelegate *app = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    cars = [NSMutableArray array];
    
    //создаем подключение к базе
    NSString* path = app.databasePath;
    FMDatabase *database;
    database = [FMDatabase databaseWithPath:path];
    [database open];
    FMResultSet* res = [database executeQuery:@"select * from auto"];
    NSMutableDictionary *item = [NSMutableDictionary dictionary];
    [item setObject:@"plus-2.png" forKey:@"image"];
    [item setObject:@"Добавить машину" forKey:@"title"];
    [cars addObject:item];
    item = [NSMutableDictionary dictionary];
    [item setObject:@"pie_chart.png" forKey:@"image"];
    [item setObject:@"Статистика" forKey:@"title"];
    [cars addObject:item];
    while ([res next])
    {
        NSMutableString *fullname = [NSMutableString string];
        item = [NSMutableDictionary dictionary];
        [fullname appendString:[res stringForColumn:@"marka"]];
        [fullname appendString:@" "];
        [fullname appendString:[res stringForColumn:@"model"]];
        [fullname appendString:@" "];
        [fullname appendString:[res stringForColumn:@"year"]];
        [item setObject:fullname forKey:@"title"];
        [cars addObject:item];
       
    }
    [database close];*/
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return [cars count];
}

- (void) tableView: (UITableView *) tableView didSelectRowAtIndexPath: (NSIndexPath *) indexPath
{
    if(indexPath.row==0)
    {
        SWRevealViewController *revealController = self.revealViewController;
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        
        UINavigationController *goToCar = (UINavigationController *)[storyboard  instantiateViewControllerWithIdentifier:@"Addcar"];
        [revealController pushFrontViewController:goToCar animated: YES];
    }
    else if(indexPath.row == 1)
    {}
    else
    {
        SWRevealViewController *revealController = self.revealViewController;
        UINavigationController *goToCar = (UINavigationController *)[[UIStoryboard storyboardWithName:@"Main" bundle:nil]  instantiateViewControllerWithIdentifier:@"currentAvto"];
        CurrentAvtoController * current =(CurrentAvtoController *)[[UIStoryboard storyboardWithName:@"Main" bundle:nil]instantiateViewControllerWithIdentifier:@"current"];
        NSMutableDictionary *cur = [cars objectAtIndex:indexPath.row];
        [goToCar.navigationItem setTitle:[cur objectForKey:@"title"]];
        [revealController pushFrontViewController:goToCar animated: YES];
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
    
    //поиск ячейки
    MenuCellView *cell = (MenuCellView *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        //если ячейка не найдена - создаем новую
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"MenuCell"owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    NSMutableDictionary *current = [cars objectAtIndex:indexPath.row];
    cell.label.text = [current objectForKey:@"title"];
    switch(indexPath.row)
    {
        case 0:
            [cell.image setImage:[UIImage imageNamed:[current objectForKey:@"image"]]];
            cell.line.hidden = YES;
            break;
        case 1:
            [cell.image setImage:[UIImage imageNamed:[current objectForKey:@"image"]]];
            cell.line.hidden = NO;
            break;
            default:
            [ cell.label setFrame: CGRectMake(10, cell.label.frame.origin.y,cell.label.frame.size.width, cell.label.frame.size.height)];
            cell.line.hidden = YES;
            break;
    }
    return cell;
}
@end
