//
//  HistoryTableViewController.m
//  AvtoDrive
//
//  Created by Admin on 23.09.18.
//  Copyright © 2018 Admin. All rights reserved.
//

#import "HistoryTableViewController.h"
#import "FMDB.h"
#import "AppDelegate.h"
#import "HistorySection.h"
#import "SWRevealViewController.h"
#import "HistoryCell.h"
#import "HistoryDeleteView.h"
#import "RNFrostedSidebar.h"
#import "ServiceViewController.h"
#import "AddPetrolViewController.h"
#import "MoykaViewController.h"
#import "ReminderViewViewController.h"

@interface HistoryTableViewController ()<RNFrostedSidebarDelegate>

@property NSMutableArray *allSection;
@property HistorySection *sectionCur;
@property (nonatomic, strong) NSMutableIndexSet *optionIndices;
@end

@implementation HistoryTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    AppDelegate *app = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    self.car = app.car;
    self.optionIndices = [NSMutableIndexSet indexSetWithIndex:1];
    
    UIColor *colour = [[UIColor alloc]initWithRed:99.0/255.0 green:101.0/255.0 blue:116.0/255.0 alpha:1.0];
    self.navigationController.navigationBar.barTintColor = colour;
    self.idAuto = 0;
    SWRevealViewController *revealViewController = self.revealViewController;
    if ( revealViewController )
    {
        [self.sidebar setTarget: self.revealViewController];
        [self.sidebar setAction: @selector( revealToggle: )];
        [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
    }
   /* [self.navigationController.navigationBar setTitleTextAttributes:
     @{NSForegroundColorAttributeName:[UIColor whiteColor],
       NSFontAttributeName:[UIFont fontWithName:@"mplus-1c-bold" size:21]}];*/
    [self loadEvents];
    UIButton * buttonR = [[UIButton alloc] initWithFrame:CGRectMake(0,0,40,40)];
    [buttonR setImage:[UIImage imageNamed:@"add.png"] forState:UIControlStateNormal];
    [buttonR addTarget:self action:@selector(onBurger:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *it = [[UIBarButtonItem alloc]initWithCustomView:buttonR];
    
    self.navigationItem.rightBarButtonItem = it;
   
}
-(void) setResult: (NSString*) str
{
    [self loadEvents];
   [self.tableView reloadData];
}
-(IBAction)deleteItem:(UIButton*)sender
{
    //Получение текущей секции
    NSMutableDictionary *currentSection = [self.allSection objectAtIndex:sender.tag];
    
    AppDelegate *app = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    //создаем подключение к базе
    NSString* path = app.databasePath;
    FMDatabase *database;
    database = [FMDatabase databaseWithPath:path];
    
    database.traceExecution = true; //выводит подробный лог запросов в консоль
    if(![database open])
    {
        NSLog(@"Error");
    }
    
    NSString * del = [NSString stringWithFormat:@"delete from events where id = '%@'",[currentSection objectForKey:@"idS"]];
     [database executeUpdate:del];
    if([[currentSection objectForKey:@"type"] isEqualToString:@"Сервис"]||[[currentSection objectForKey:@"type"] isEqualToString:@"Тюнинг"])
    {
        del = [NSString stringWithFormat:@"delete from event_item where id_main = '%@'",[currentSection objectForKey:@"idS"]];
         [database executeUpdate:del];
    }
   else if([[currentSection objectForKey:@"type"] isEqualToString:@"Заправка"])
    {
        del = [NSString stringWithFormat:@"delete from petrol where id_main = '%@'",[currentSection objectForKey:@"idS"]];
        [database executeUpdate:del];
    }
   else if([[currentSection objectForKey:@"type"] isEqualToString:@"Мойка"])
   {
       del = [NSString stringWithFormat:@"delete from car_wash where id_main = '%@'",[currentSection objectForKey:@"idS"]];
       [database executeUpdate:del];
   }
   else if([[currentSection objectForKey:@"type"] isEqualToString:@"Напоминание"])
   {
       del = [NSString stringWithFormat:@"delete from reminder where id_main = '%@'",[currentSection objectForKey:@"idS"]];
       [database executeUpdate:del];
   }
    [database close];
    [self.allSection removeObjectAtIndex:sender.tag];
    
    [self.tableView beginUpdates];
    
        // Section is now completely empty, so delete the entire section.
    [self.tableView deleteSections:[NSIndexSet indexSetWithIndex:sender.tag]
                 withRowAnimation:UITableViewRowAnimationFade];
    NSInteger sectionCount = [self.allSection count];
    NSIndexSet *indexes = [NSMutableIndexSet indexSetWithIndexesInRange:NSMakeRange(0, sectionCount)];
    [self.tableView reloadSections:indexes withRowAnimation:UITableViewRowAnimationNone];
    [self.tableView endUpdates];
}
-(void)loadEvents
{
    AppDelegate *app = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    //создаем подключение к базе
    NSString* path = app.databasePath;
    FMDatabase *database;
    database = [FMDatabase databaseWithPath:path];
    
    database.traceExecution = true; //выводит подробный лог запросов в консоль
    if(![database open])
    {
        NSLog(@"Error");
    }
    NSString * queryN = [NSString stringWithFormat:@"Select events.id as id,events.type_service as type,reminder.type_remi as datecreate,reminder.value_remi as mileage,reminder.id_main as id_main,reminder.type as summ from reminder join events on events.id = reminder.id_main where events.id_auto = '%1$d'",app.car.id_car];
    
    NSString * query =  [NSString stringWithFormat:@"Select events.id as id,events.type_service as type,substr(events.datecreate,0,11) as datecreate,events.mileage as mileage,event_item.id_main as id_main,sum(event_item.price) as summ from event_item join events on events.id = event_item.id_main where events.id_auto = '%1$d' Group by event_item.id_main union Select events.id as id,events.type_service as type,substr(events.datecreate,0,11) as datecreate,events.mileage as mileage,petrol.id_main as id_main,sum(petrol.summa) as summ from petrol join events on events.id = petrol.id_main where events.id_auto = '%1$d' Group by petrol.id_main union Select events.id as id,events.type_service as type,substr(events.datecreate,0,11) as datecreate,events.mileage as mileage,car_wash.id_main as id_main,sum(car_wash.price) as summ from car_wash join events on events.id = car_wash.id_main where events.id_auto = '%1$d' Group by car_wash.id_main",app.car.id_car];
    FMResultSet * resultN = [database executeQuery:queryN];
    
    NSMutableDictionary *item;
    FMResultSet * result = [database executeQuery:query];
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    self.allSection = [NSMutableArray array];
    NSMutableArray *itemArray = [NSMutableArray array];
    while([resultN next])
    {
        dict = [NSMutableDictionary dictionary];
        itemArray = [NSMutableArray array];
        int id_servic = [resultN intForColumn:@"id"];
        NSString *id_s = [NSString stringWithFormat:@"%d",id_servic];
        NSString *type = [resultN stringForColumn:@"type"];
        NSString * date = [resultN stringForColumn:@"datecreate"];
        NSString *mileage = [resultN stringForColumn:@"mileage"];
        NSString * price = [resultN stringForColumn:@"summ"];
        [dict setObject:id_s forKey:@"idS"];
        [dict setObject:type forKey:@"type"];
        [dict setObject:date forKey:@"date"];
        [dict setObject:mileage forKey:@"mileage"];
        [dict setObject:price forKey:@"price"];
        [self.allSection addObject:dict];
        [dict setObject:itemArray forKey:@"items"];
    }
    
    while([result next])
    {
        dict = [NSMutableDictionary dictionary];
        itemArray = [NSMutableArray array];
        int id_servic = [result intForColumn:@"id"];
        NSString *id_s = [NSString stringWithFormat:@"%d",id_servic];
        NSString *type = [result stringForColumn:@"type"];
        NSString * date = [result stringForColumn:@"datecreate"];
        NSString *mileage = [result stringForColumn:@"mileage"];
        NSString * price = [result stringForColumn:@"summ"];
        [dict setObject:id_s forKey:@"idS"];
        [dict setObject:type forKey:@"type"];
        [dict setObject:date forKey:@"date"];
        [dict setObject:mileage forKey:@"mileage"];
        [dict setObject:price forKey:@"price"];
        [self.allSection addObject:dict];
        
        
        NSString * query_item = [NSString stringWithFormat:@"select  type, price from event_item where id_main  = '%1$d' union select  type, summa as price from petrol where id_main  = '%1$d' union select type_wash as type ,price from car_wash where id_main  = '%1$d'",id_servic];
        FMResultSet * it = [database executeQuery:query_item];
        while([it next])
        {
            item = [NSMutableDictionary dictionary];
            NSString *item_type = [it stringForColumn:@"type"];
            NSString * item_price = [it stringForColumn:@"price"];
            [item setObject:item_type forKey:@"itemName"];
            [item setObject: item_price forKey:@"itemPrice"];
            [itemArray addObject:item];
        }
        [dict setObject:itemArray forKey:@"items"];
    }
    [database close];
}
//----------------------
- (IBAction)onBurger:(id)sender {
    NSArray *images = @[
                        [UIImage imageNamed:@"service_2.png"],
                        [UIImage imageNamed:@"tuning.png"],
                        [UIImage imageNamed:@"petrol2.png"],
                        [UIImage imageNamed:@"moyka.png"],
                        [UIImage imageNamed:@"napom2.png"]
                        ];
    NSArray *colors = @[
                        [UIColor colorWithRed:222/255.f green:79/255.f blue:85/255.f alpha:1],
                        [UIColor colorWithRed:138/255.f green:95/255.f blue:172/255.f alpha:1],
                        [UIColor colorWithRed:2/255.f green:166/255.f blue:142/255.f alpha:1],
                        [UIColor colorWithRed:42/255.f green:164/255.f blue:239/255.f alpha:1],
                        [UIColor colorWithRed:1/255.f green:146/255.f blue:193/255.f alpha:1]
                        ];
    
    RNFrostedSidebar *callout = [[RNFrostedSidebar alloc] initWithImages:images selectedIndices:self.optionIndices borderColors:colors];
    //    RNFrostedSidebar *callout = [[RNFrostedSidebar alloc] initWithImages:images];
    callout.delegate = self;
    callout.showFromRight = YES;
    callout.isSingleSelect = YES;
    [callout show];
}

#pragma mark - RNFrostedSidebarDelegate

- (void)sidebar:(RNFrostedSidebar *)sidebar didTapItemAtIndex:(NSUInteger)index {
      [sidebar dismissAnimated:YES completion:nil];
    switch(index)
    {
        case 0:
           [self performSegueWithIdentifier:@"hservice" sender:self];
            break;
        case 1:
             [self performSegueWithIdentifier:@"htuning" sender:self];
            break;
        case 2:
             [self performSegueWithIdentifier:@"hpetrol" sender:self];
            break;
        case 3:
             [self performSegueWithIdentifier:@"hmoyka" sender:self];
            break;
        case 4:
             [self performSegueWithIdentifier:@"hnapom" sender:self];
            break;
    }
    
}
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqual: @"hservice"]) {
        ServiceViewController * second = segue.destinationViewController;
        second.typeSeque = @"service";
        second.serviceItem.typeSeque = @"service";
        second.delegate = segue.sourceViewController;
        
    }
    else if([segue.identifier isEqual: @"htuning"])
    {
        ServiceViewController * second = segue.destinationViewController;
        second.typeSeque = @"tuning";
        second.serviceItem.typeSeque = @"tuning";
        second.delegate = segue.sourceViewController;
    }
    else if([segue.identifier isEqual: @"hpetrol"])
    {
       AddPetrolViewController * second = segue.destinationViewController;
       second.delegate = segue.sourceViewController;
    }
    else if([segue.identifier isEqual: @"hmoyka"])
    {
        MoykaViewController * second = segue.destinationViewController;
        second.delegate = segue.sourceViewController;
    }
    else if([segue.identifier isEqual: @"hnapom"])
    {
        ReminderViewViewController * second = segue.destinationViewController;
        second.delegate = segue.sourceViewController;
    }
    
}
- (void)sidebar:(RNFrostedSidebar *)sidebar didEnable:(BOOL)itemEnabled itemAtIndex:(NSUInteger)index {
    if (itemEnabled) {
        [self.optionIndices addIndex:index];
    }
    else {
        [self.optionIndices removeIndex:index];
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 87;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 30;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return _allSection.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSDictionary *currentSection = [self.allSection objectAtIndex:section];
    if ([[currentSection objectForKey:@"isOpen"] boolValue]) {
        NSDictionary *items = [currentSection objectForKey:@"items"];
        return items.count+1;
    }
    return 0;
}

- (void)didSelectSection:(UIButton*)sender {
     
    //Получение текущей секции
    NSMutableDictionary *currentSection = [self.allSection objectAtIndex:sender.tag];
    
    //Получение элементов секции
   NSDictionary *items = [currentSection objectForKey:@"items"];
    
    //Создание массива индексов
    NSMutableArray *indexPaths = [NSMutableArray array];
    for (int i=0; i<items.count+1; i++) {
        [indexPaths addObject:[NSIndexPath indexPathForRow:i inSection:sender.tag]];
    }
    
    //Получение состояния секции
    BOOL isOpen = [[currentSection objectForKey:@"isOpen"] boolValue];
    
    //Установка нового состояния
    [currentSection setObject:[NSNumber numberWithBool:!isOpen] forKey:@"isOpen"];
    
    //Анимированное добавление или удаление ячеек секции
    if (isOpen) {
        [self.tableView deleteRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationTop];
    } else {
        [self.tableView insertRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationTop];
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"MyCell";
    NSDictionary *currentSection = [self.allSection objectAtIndex:indexPath.section];
    NSArray *items = [currentSection objectForKey:@"items"];
   
    if(indexPath.row<items.count)
    {
         //NSDictionary *currentItem = [items objectAtIndex:indexPath.row];
        HistoryCell *cell = (HistoryCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    [cell setFrame:CGRectMake(0,0, tableView.bounds.size.width-60, 60)];
    //Если ячейка не найдена
    if (cell == nil) {
        //Создание ячейки
        cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        NSArray   *nib   =   [[ NSBundle   mainBundle]loadNibNamed:@"HistroyCell" owner :self  options :nil] ;
        cell = [nib objectAtIndex : 0] ;
        
    }
    NSDictionary *currentSection = [self.allSection objectAtIndex:indexPath.section];
    NSArray *items = [currentSection objectForKey:@"items"];
    NSDictionary *currentItem = [items objectAtIndex:indexPath.row];
        if(items.count==1)
        {
            cell.nameItem.frame = CGRectMake(cell.nameItem.frame.origin.x,5, cell.nameItem.frame.size.width, cell.nameItem.frame.size.height);
            cell.priceItem.frame = CGRectMake(cell.priceItem.frame.origin.x, 5, cell.priceItem.frame.size.width, cell.priceItem.frame.size.height);
        }
        if(indexPath.row == 0)
        {
            cell.nameItem.frame = CGRectMake(cell.nameItem.frame.origin.x, 10, cell.nameItem.frame.size.width, cell.nameItem.frame.size.height);
            cell.priceItem.frame = CGRectMake(cell.priceItem.frame.origin.x, 10, cell.priceItem.frame.size.width, cell.priceItem.frame.size.height);
        }
        else if(indexPath.row == items.count-1)
        {
            cell.nameItem.frame = CGRectMake(cell.nameItem.frame.origin.x, 3, cell.nameItem.frame.size.width, cell.nameItem.frame.size.height);
            cell.priceItem.frame = CGRectMake(cell.priceItem.frame.origin.x, 3, cell.priceItem.frame.size.width, cell.priceItem.frame.size.height);
        }
      
    NSString *name =[currentItem objectForKey:@"itemName"];
    NSString *price =[NSString stringWithFormat:@"%@ ₽",[currentItem objectForKey:@"itemPrice"]];
    cell.nameItem.text = name;
    cell.priceItem.text = price;
    if([[currentSection objectForKey:@"type"]isEqualToString:@"Сервис" ])
    {
         UIColor *colour = [[UIColor alloc]initWithRed:225.0/255.0 green:116.0/255.0 blue:122.0/255.0 alpha:0.5];
        [cell.content setBackgroundColor:colour];
    }
    else if([[currentSection objectForKey:@"type"]  isEqual: @"Тюнинг"])
    {
        
        UIColor *colour = [[UIColor alloc]initWithRed:197.0/255.0 green:137.0/255.0 blue:245.0/255.0 alpha:0.5];
        [cell.content  setBackgroundColor:colour];
    }
    else if([[currentSection objectForKey:@"type"]  isEqual: @"Заправка"])
    {
        UIColor *colour = [[UIColor alloc]initWithRed:2.0/255.0 green:166.0/255.0 blue:142.0/255.0 alpha:0.5];
        [cell.content  setBackgroundColor:colour];
    }
    else if([[currentSection objectForKey:@"type"]  isEqual: @"Мойка"])
    {
        UIColor *colour = [[UIColor alloc]initWithRed:42.0/255.0 green:163.0/255.0 blue:241.0/255.0 alpha:0.5];
        [cell.content  setBackgroundColor:colour];
    }
        else if([[currentSection objectForKey:@"type"]  isEqual: @"Напоминание"])
        {
            UIColor *colour = [[UIColor alloc]initWithRed:1.0/255.0 green:146.0/255.0 blue:193.0/255.0 alpha:0.0];
            [cell.content  setBackgroundColor:colour];
        }
         return cell;
    }
    else if (indexPath.row == items.count)
    {
        static NSString *CellIdentifier2 = @"MyCellDel";
        HistoryDeleteView *cell = (HistoryDeleteView *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier2];
       
        //Если ячейка не найдена
        if (cell == nil) {
            //Создание ячейки
            cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier2];
            NSArray   *nib2   =   [[ NSBundle mainBundle]loadNibNamed:@"HistoryCellDelete" owner :self  options :nil] ;
            cell = [nib2 objectAtIndex : 0] ;
            [cell setFrame:CGRectMake(12,0,cell.frame.size.width-13,cell.frame.size.height)];
            [cell.bt_dell addTarget:self action:@selector(deleteItem:)
                   forControlEvents:UIControlEventTouchUpInside];
            cell.bt_dell.tag = indexPath.section;
        }
        return cell;
    }
    return nil;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    CGFloat tableBorderLeft = 15;
    CGFloat tableBorderRight = 0;
    CGRect tableRect = self.view.frame;
    tableRect.origin.x += tableBorderLeft; // make the table begin a few pixels right from its origin
    tableRect.size.width -= tableBorderLeft + tableBorderRight; // reduce the width of the table
    self.tableView.frame = tableRect;
    HistorySection *sectionH;
     sectionH = [[HistorySection alloc]initWithFrame:CGRectMake(0,tableView.frame.origin.y,tableView.frame.size.width-60,113)];
    sectionH.click.tag = section;
    [sectionH.click addTarget:self action:@selector(didSelectSection:)
     forControlEvents:UIControlEventTouchUpInside];
    if(section > 0)
    {
        [sectionH.arrow_start setImage:[UIImage imageNamed:@"center_arrow.png"]];
        sectionH.arrow_end.hidden = YES;
        
    }
    if(section == 0)
        sectionH.arrow_end.hidden = YES;
    if(section == _allSection.count-1)
        sectionH.arrow_end.hidden = NO;
    if(_allSection.count == 1)
    {
         sectionH.arrow_end.hidden = YES;
    }
   NSDictionary *currentSection = [self.allSection objectAtIndex:section];
    sectionH.type.text = [currentSection objectForKey:@"type"];
    if([[currentSection objectForKey:@"type"] isEqualToString:@"Напоминание"])
    sectionH.price.text =[NSString stringWithFormat:@"%@", [currentSection objectForKey:@"price"]];
    else
        sectionH.price.text =[NSString stringWithFormat:@"%@ ₽", [currentSection objectForKey:@"price"]];
    sectionH.date.text = [currentSection objectForKey:@"date"];
    sectionH.mileage.text =[NSString stringWithFormat:@"%@ км", [currentSection objectForKey:@"mileage"]];
   
    if([[currentSection objectForKey:@"type"]  isEqual: @"Сервис"])
    {
        [sectionH.imgType setImage:[UIImage imageNamed:@"service_2.png"]];
        UIColor *colour = [[UIColor alloc]initWithRed:229.0/255.0 green:122.0/255.0 blue:126.0/255.0 alpha:1.0];
        UIColor *colour2 = [[UIColor alloc]initWithRed:229.0/255.0 green:122.0/255.0 blue:126.0/255.0 alpha:0.5];
        [sectionH.colorLine setBackgroundColor:colour2];
        [sectionH setBackgroundColor:colour];
        
    }
    else if([[currentSection objectForKey:@"type"]  isEqual: @"Тюнинг"])
    {
        [sectionH.imgType setImage:[UIImage imageNamed:@"tuning.png"]];
        UIColor *colour = [[UIColor alloc]initWithRed:197.0/255.0 green:137.0/255.0 blue:245.0/255.0 alpha:1.0];
        UIColor *colour2 = [[UIColor alloc]initWithRed:197.0/255.0 green:137.0/255.0 blue:245.0/255.0 alpha:0.5];
        [sectionH.colorLine setBackgroundColor:colour2];
        [sectionH setBackgroundColor:colour];
        
    }
    else if([[currentSection objectForKey:@"type"]  isEqual: @"Заправка"])
    {
        [sectionH.imgType setImage:[UIImage imageNamed:@"petrol.png"]];
        UIColor *colour = [[UIColor alloc]initWithRed:2.0/255.0 green:166.0/255.0 blue:142.0/255.0 alpha:1.0];
        UIColor *colour2 = [[UIColor alloc]initWithRed:2.0/255.0 green:166.0/255.0 blue:142.0/255.0 alpha:0.5];
        [sectionH.colorLine setBackgroundColor:colour2];
        [sectionH setBackgroundColor:colour];
    }
    else if([[currentSection objectForKey:@"type"]  isEqual: @"Мойка"])
    {
        [sectionH.imgType setImage:[UIImage imageNamed:@"moyka.png"]];
        UIColor *colour = [[UIColor alloc]initWithRed:42.0/255.0 green:164.0/255.0 blue:239.0/255.0 alpha:1.0];
        UIColor *colour2 = [[UIColor alloc]initWithRed:42.0/255.0 green:164.0/255.0 blue:239.0/255.0 alpha:0.5];
        [sectionH.colorLine setBackgroundColor:colour2];
        [sectionH setBackgroundColor:colour];
    }
    else if([[currentSection objectForKey:@"type"]  isEqual: @"Напоминание"])
    {
        [sectionH.imgType setImage:[UIImage imageNamed:@"napom.png"]];
        UIColor *colour = [[UIColor alloc]initWithRed:1.0/255.0 green:146.0/255.0 blue:193.0/255.0 alpha:1.0];
        UIColor *colour2 = [[UIColor alloc]initWithRed:1.0/255.0 green:146.0/255.0 blue:193.0/255.0 alpha:0.5];
        sectionH.date_img.hidden = YES;
        sectionH.dateText.hidden = YES;
        if([[currentSection objectForKey:@"datecreate"] isEqualToString:@"0"])
        {
            [sectionH.mileageImg setImage:[UIImage imageNamed:@"calendar1.png"]];
        }
        else
        {
            [sectionH.mileageImg setImage:[UIImage imageNamed:@"mileage_w.png"]];
        }
        [sectionH.colorLine setBackgroundColor:colour2];
        [sectionH setBackgroundColor:colour];
    }
   
    _sectionCur =sectionH;
    return sectionH;
}
@end
