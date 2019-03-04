//
//  StatistViewController.m
//  AvtoDrive
//
//  Created by Admin on 12.10.18.
//  Copyright © 2018 Admin. All rights reserved.
//

#import "StatistViewController.h"
#import "SWRevealViewController.h"
#import "UIColor+HexColor.h"
#import "IGLDropDownMenu.h"
#import "IGLDropDownItem.h"
#import "AppDelegate.h"
#import "FMDB.h"
#import "Bar.h"
@interface StatistViewController ()<IGLDropDownMenuDelegate>
@property (nonatomic, retain) NSArray *chartValues;
@property (nonatomic, strong) IGLDropDownMenu *menuAvto;
@property NSMutableArray * dataAuto;
@property NSString* cur_id;

@end

@implementation StatistViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.cur_id = @"";
    Bar *navBar = [[Bar alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 80)];
    navBar.text.text = @"Статистика";
    [navBar.backButton setImage:[UIImage imageNamed:@"menu2.png"] forState:UIControlStateNormal];
    SWRevealViewController *revealViewController = self.revealViewController;
    if ( revealViewController )
    {
        [navBar.backButton addTarget:self.revealViewController action:@selector(revealToggle:)
                    forControlEvents:UIControlEventTouchUpInside];
        [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
    }
    navBar.buttonOk.hidden = YES;
    UIColor *cl = [[UIColor alloc]initWithRed:5.0/255.0 green:8.0/255.0 blue:18.0/255.0 alpha:1.0];
    [navBar.container setBackgroundColor:cl];
    [navBar.image setImage:[UIImage imageNamed:@"state2.png"]];
    [self.view addSubview:navBar];
    
    [self chartInit];
    [self initShadow];
    [self initMenu];
    
}
-(void)loadCars
{
    AppDelegate *app = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    FMDatabase* database;
    database = [FMDatabase databaseWithPath:app.databasePath];
    [database open];
    
    NSString* query =[NSString stringWithFormat:@"select id, marka,model,year,name from auto;"];
    FMResultSet* res = [database executeQuery:query];
    self.dataAuto = [NSMutableArray array];
    NSMutableDictionary*dict = [NSMutableDictionary dictionary];
    [dict setObject:@"Все авто" forKey:@"title"];
    [dict setObject:@"" forKey:@"id"];
    [_dataAuto addObject:dict];
    while([res next])
    {
        NSMutableDictionary*dict = [NSMutableDictionary dictionary];
        NSString* marka = [res stringForColumn:@"marka"];
        NSString* model = [res stringForColumn:@"model"];
        NSString* year = [res stringForColumn:@"maryearka"];
        NSString* name = [res stringForColumn:@"name"];
        NSString* id_car = [res stringForColumn:@"id"];
        
        if([name isEqualToString:@""]||[name isEqualToString:@"null"])
        {
            NSString* naim = [NSString stringWithFormat:@"%@ %@",marka,model];
            [dict setObject:naim forKey:@"title"];
        }
        else
            [dict setObject:name forKey:@"title"];
        [dict setObject:id_car forKey:@"id"];
        [self.dataAuto addObject:dict];
    }
    
}
- (void)dropDownMenu:(IGLDropDownMenu *)dropDownMenu selectedItemAtIndex:(NSInteger)index
{
    //Получаем выбранный пункт меню
    if(dropDownMenu == self.menuAvto)
    {
        IGLDropDownItem *item = self.menuAvto.dropDownItems[index];
        self.cars_text.text = item.text;
        
        NSDictionary* dict = [self.dataAuto objectAtIndex:index];
        self.cur_id = [dict objectForKey:@"id"];
        [self chartInit];
        
    }
   
}
-(void)initMenu
{
    [self loadCars];
    //Заполнение комбобокса сервиса
    NSMutableArray *dropdownItems = [[NSMutableArray alloc] init];
    for (int i = 0; i < self.dataAuto.count; i++) {
        NSDictionary *dict = self.dataAuto[i];
        IGLDropDownItem *item = [[IGLDropDownItem alloc] init];
        [item setText:dict[@"title"]];
        [dropdownItems addObject:item];
    }
    
   
    self.menuAvto = [[IGLDropDownMenu alloc] initWithMenuButtonCustomView:self.cars];
    self.cars_text.text = @"Все авто";
    
    self.menuAvto.dropDownItems = dropdownItems;
    self.menuAvto.paddingLeft = 15;
    [self.menuAvto setFrame:[self.cars frame]];
    // self.viewS.hidden= YES;
    self.menuAvto.delegate = self;
    self.menuAvto.gutterY = 0;
    self.menuAvto.type = IGLDropDownMenuTypeSlidingInBoth;
    self.menuAvto.itemAnimationDelay = 0.1;
    self.menuAvto.flipWhenToggleView = YES;
    
    self.menuAvto.layer.shadowColor = [UIColor colorWithRed:24.f/255.f green:25.f/255.f blue:27.f/255.f alpha:1.f].CGColor;
    self.menuAvto.layer.shadowOffset = CGSizeMake(0.0f,4.0f);
    self.menuAvto.layer.masksToBounds = NO;
    self.menuAvto.layer.shadowRadius = 2.5f;
    self.menuAvto.layer.shadowOpacity = 0.2;
    
    
    [self.view addSubview:self.menuAvto];
    [self.menuAvto reloadView];
}
-(void)initShadow
{
    self.viewP.layer.shadowColor = [UIColor colorWithRed:24.f/255.f green:25.f/255.f blue:27.f/255.f alpha:1.f].CGColor;
    self.viewP.layer.shadowOffset = CGSizeMake(0.0f,4.0f);
    self.viewP.layer.masksToBounds = NO;
    self.viewP.layer.shadowRadius = 2.5f;
    self.viewP.layer.shadowOpacity = 0.2;
    
    self.viewP.layer.shadowColor = [UIColor colorWithRed:24.f/255.f green:25.f/255.f blue:27.f/255.f alpha:1.f].CGColor;
    self.viewM.layer.shadowOffset = CGSizeMake(0.0f,4.0f);
    self.viewM.layer.masksToBounds = NO;
    self.viewM.layer.shadowRadius = 2.5f;
    self.viewM.layer.shadowOpacity = 0.2;
    
    self.viewT.layer.shadowColor = [UIColor colorWithRed:24.f/255.f green:25.f/255.f blue:27.f/255.f alpha:1.f].CGColor;
    self.viewT.layer.shadowOffset = CGSizeMake(0.0f,4.0f);
    self.viewT.layer.masksToBounds = NO;
    self.viewT.layer.shadowRadius = 2.5f;
    self.viewT.layer.shadowOpacity = 0.2;
    
    self.viewS.layer.shadowColor = [UIColor colorWithRed:24.f/255.f green:25.f/255.f blue:27.f/255.f alpha:1.f].CGColor;
    self.viewS.layer.shadowOffset = CGSizeMake(0.0f,4.0f);
    self.viewS.layer.masksToBounds = NO;
    self.viewS.layer.shadowRadius = 2.5f;
    self.viewS.layer.shadowOpacity = 0.2;
    
    self.viewAll.layer.shadowColor = [UIColor colorWithRed:24.f/255.f green:25.f/255.f blue:27.f/255.f alpha:1.f].CGColor;
    self.viewAll.layer.shadowOffset = CGSizeMake(0.0f,4.0f);
    self.viewAll.layer.masksToBounds = NO;
    self.viewAll.layer.shadowRadius = 2.5f;
    self.viewAll.layer.shadowOpacity = 0.2;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void) chartInit {
    self.priceS.text = @"0 ₽";
    self.priceP.text = @"0 ₽";
    self.priceT.text = @"0 ₽";
    self.priceM.text = @"0 ₽";
    self.priceAll.text = @"0 ₽";
    
    _chart.startAngle = M_PI+M_PI_2;
    [_chart setHoleRadiusPrecent:0.5];
    
     AppDelegate *app = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    FMDatabase* database;
    database = [FMDatabase databaseWithPath:app.databasePath];
    [database open];
    NSString* queryS =[NSString stringWithFormat:@"Select sum(event_item.price) as summ from event_item join events on events.id = event_item.id_main where events.type_service = 'Сервис';"];
    NSString* queryT = [NSString stringWithFormat:@"Select sum(event_item.price) as summ from event_item join events on events.id = event_item.id_main where events.type_service = 'Тюнинг';"];
    NSString* queryP = [NSString stringWithFormat:@"Select sum(petrol.summa) as summ from petrol join events on events.id = petrol.id_main where events.type_service = 'Заправка';"];
     NSString* queryM= [NSString stringWithFormat:@"Select sum(car_wash.price) as summ from car_wash join events on events.id = car_wash.id_main where events.type_service = 'Мойка';"];
    if(![self.cur_id isEqualToString:@""])
    {
        queryS =[NSString stringWithFormat:@"Select sum(event_item.price) as summ from event_item join events on events.id = event_item.id_main where events.type_service = 'Сервис' and events.id_auto = '%@';",self.cur_id];
        queryT = [NSString stringWithFormat:@"Select sum(event_item.price) as summ from event_item join events on events.id = event_item.id_main where events.type_service = 'Тюнинг' and events.id_auto = '%@';",self.cur_id];
        queryP = [NSString stringWithFormat:@"Select sum(petrol.summa) as summ from petrol join events on events.id = petrol.id_main where events.type_service = 'Заправка' and events.id_auto = '%@';",self.cur_id];
        queryM= [NSString stringWithFormat:@"Select sum(car_wash.price) as summ from car_wash join events on events.id = car_wash.id_main where events.type_service = 'Мойка' and events.id_auto = '%@';",self.cur_id];
    }
   FMResultSet* result  = [database executeQuery:queryS];
    double sPrice = 0;
    double tPrice = 0;
    double pPrice = 0;
    double mPrice = 0;
  
    while([result next])
    {
        sPrice = [result doubleForColumn:@"summ"];
        self.priceS.text = [NSString stringWithFormat:@"%.2f ₽",sPrice];
    }
    result = [database executeQuery:queryT];
    while([result next])
    {
        tPrice = [result doubleForColumn:@"summ"];
        self.priceT.text = [NSString stringWithFormat:@"%.2f ₽",tPrice];
    }
    result = [database executeQuery:queryP];
    while([result next])
    {
        pPrice = [result doubleForColumn:@"summ"];
        self.priceP.text = [NSString stringWithFormat:@"%.2f ₽",pPrice];
    }
    result = [database executeQuery:queryM];
    while([result next])
    {
        mPrice = [result doubleForColumn:@"summ"];
        self.priceM.text = [NSString stringWithFormat:@"%.2f ₽",mPrice];
    }
    [database close];
    double summa = mPrice+tPrice+pPrice +sPrice;
    self.priceAll.text = [NSString stringWithFormat:@"%.2f ₽",summa];
    NSMutableArray* chartArray = [NSMutableArray array];
    
    NSMutableDictionary* dict = [NSMutableDictionary dictionary];
    [dict setObject:@"Сервис" forKey:@"name"];
    [dict setObject:[NSNumber numberWithDouble:sPrice] forKey:@"value"];
    [dict setObject:[[UIColor alloc]initWithRed:222.0/255.0 green:79.0/255.0 blue:85.0/255.0 alpha:1.0] forKey:@"color"];
    [chartArray addObject:dict];
    dict = [NSMutableDictionary dictionary];
    [dict setObject:@"Тюнинг" forKey:@"name"];
    [dict setObject:[NSNumber numberWithDouble:tPrice] forKey:@"value"];
    [dict setObject:[[UIColor alloc]initWithRed:138.0/255.0 green:95.0/255.0 blue:172.0/255.0 alpha:1.0] forKey:@"color"];
    [chartArray addObject:dict];
    dict = [NSMutableDictionary dictionary];
    [dict setObject:@"Заправка" forKey:@"name"];
    [dict setObject:[NSNumber numberWithDouble:pPrice] forKey:@"value"];
    [dict setObject:[[UIColor alloc]initWithRed:2.0/255.0 green:166.0/255.0 blue:142.0/255.0 alpha:1.0] forKey:@"color"];
    [chartArray addObject:dict];
    
    dict = [NSMutableDictionary dictionary];
    [dict setObject:@"Мойка" forKey:@"name"];
    [dict setObject:[NSNumber numberWithDouble:mPrice] forKey:@"value"];
    [dict setObject:[[UIColor alloc]initWithRed:42.0/255.0 green:164.0/255.0 blue:239.0/255.0 alpha:1.0] forKey:@"color"];
    [chartArray addObject:dict];
    
        [_chart setChartValues:chartArray animation:YES duration:0.5 options:VBPieChartAnimationFan];
    
}


@end
