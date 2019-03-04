//
//  GarageTableViewController.m
//  AvtoDrive
//
//  Created by Admin on 11.10.18.
//  Copyright © 2018 Admin. All rights reserved.
//

#import "GarageTableViewController.h"
#import "SWRevealViewController.h"
#import "FMDB.h"
#import "AppDelegate.h"
#import "GarageCell.h"
#import "AppDelegate.h"
#import "ViewController.h"

@interface GarageTableViewController ()
@property NSMutableArray *allData;
@end

@implementation GarageTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    SWRevealViewController *revealViewController = self.revealViewController;
    if ( revealViewController )
    {
        [self.sidebar setTarget: self.revealViewController];
        [self.sidebar setAction: @selector( revealToggle: )];
        [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
    }
    UIButton * buttonR = [[UIButton alloc] initWithFrame:CGRectMake(0,0,40,40)];
    [buttonR setImage:[UIImage imageNamed:@"add.png"] forState:UIControlStateNormal];
    [buttonR addTarget:self action:@selector(addAuto:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *it = [[UIBarButtonItem alloc]initWithCustomView:buttonR];
   /* [self.navigationController.navigationBar setTitleTextAttributes:
     @{NSForegroundColorAttributeName:[UIColor whiteColor],
       NSFontAttributeName:[UIFont fontWithName:@"mplus-1c-bold" size:21]}];*/
    self.navigationItem.rightBarButtonItem = it;
    [self loadGarage];
}
-(IBAction)addAuto:(id)sender
{
     [self performSegueWithIdentifier:@"addAuto" sender:self];
}
-(IBAction)setAvto:(UIButton*)sender
{
     AppDelegate *app = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    GarageCell * cell = (GarageCell*)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:sender.tag inSection:0]];
    CurrentCar * newCar = [[CurrentCar alloc] initAutoName:cell.nameAuto.text Icon:@"" Model:cell.model.text Marka:cell.marka.text Year:cell.year Id:cell.id_car Type:cell.type];
    app.car = newCar;
    NSString * query = [NSString stringWithFormat:@"update auto set state = 0;"];
    NSString* path = app.databasePath;
    FMDatabase *database;
    database = [FMDatabase databaseWithPath:path];
    if([database open]){
        
        [database executeUpdate:query];
        query = [NSString stringWithFormat:@"update auto set state = 1 where id = '%d';",cell.id_car];
        [database executeUpdate:query];
    }
    [self.delegate setResult:@"OK!"];
    [self performSegueWithIdentifier:@"historyG" sender:self];
    
}
-(IBAction)editAvto:(UIButton*)sender
{
     [self performSegueWithIdentifier:@"editAuto" sender:self];
}
-(IBAction)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{if ([segue.identifier isEqual: @"editAuto"]) {
    ViewController * second = segue.destinationViewController;
    second.edit = YES;
}
}
-(void)loadGarage
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
    NSString * query = [NSString stringWithFormat:@"select id,marka,model,name,year,type,icon from auto"];
    FMResultSet *result = [database executeQuery:query];
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    self.allData = [NSMutableArray array];
    while([result next])
    {
        dict = [NSMutableDictionary dictionary];
        int id_auto = [result intForColumn:@"id"];
        NSString *id_a = [NSString stringWithFormat:@"%d",id_auto];
        NSString *type = [result stringForColumn:@"type"];
        NSString * marka = [result stringForColumn:@"marka"];
        NSString *model = [result stringForColumn:@"model"];
        NSString * name = [result stringForColumn:@"name"];
        NSString * year = [result stringForColumn:@"year"];
        NSString* icon = [result stringForColumn:@"icon"];
        [dict setObject:id_a forKey:@"id"];
        [dict setObject:type forKey:@"type"];
        [dict setObject:marka forKey:@"marka"];
        [dict setObject:model forKey:@"model"];
        [dict setObject:name forKey:@"name"];
        [dict setObject:year forKey:@"year"];
        [dict setObject:icon forKey:@"icon"];
        [self.allData addObject:dict];
    }
    [database close];
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.allData.count;
}

-(IBAction)selectedCell:(UIButton*)sender
{
   /* GarageCell * current = (GarageCell)[self.tableView cellForRowAtIndexPath:1];*/
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"GarageCell";
        GarageCell *cell = (GarageCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        //Если ячейка не найдена
        if (cell == nil) {
            //Создание ячейки
            cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            NSArray *nib   = [[ NSBundle   mainBundle]loadNibNamed:@"GarageCell" owner :self  options :nil] ;
            cell = [nib objectAtIndex : 0] ;
        }
    NSDictionary * currAuto =[self.allData objectAtIndex:indexPath.row];
    if([[currAuto objectForKey:@"name"] isEqualToString:@""])
        cell.nameAuto.text = @"Автомобиль";
    else
        cell.nameAuto.text = [currAuto objectForKey:@"name"];
    cell.model.text = [NSString stringWithFormat:@"%@ %@",[currAuto objectForKey:@"model"],[currAuto objectForKey:@"year"]];
    cell.marka.text = [currAuto objectForKey:@"marka"];
    cell.backImage.layer.shadowColor = [UIColor colorWithRed:24.f/255.f green:25.f/255.f blue:27.f/255.f alpha:1.f].CGColor;
    cell.backImage.layer.shadowOffset = CGSizeMake(0.0f,4.0f);
    cell.backImage.layer.masksToBounds = NO;
    cell.backImage.layer.shadowRadius = 2.5f;
    cell.backImage.layer.shadowOpacity = 0.2;
    cell.id_car = [[currAuto objectForKey:@"id"] intValue];
    cell.type = [currAuto objectForKey:@"type"];
    cell.year = [currAuto objectForKey:@"year"];
    [cell.btSet addTarget:self action:@selector(setAvto:)
         forControlEvents:UIControlEventTouchUpInside];
    cell.btSet.tag = indexPath.row;
    [cell.btEdit addTarget:self action:@selector(editAvto:)
          forControlEvents:UIControlEventTouchUpInside];
    if([currAuto objectForKey:@"icon"]!=@"")
    [cell.imageMarka setImage:[UIImage imageNamed:[currAuto objectForKey:@"icon"]]];
    [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 190;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
