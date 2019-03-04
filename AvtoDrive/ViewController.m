//
//  ViewController.m
//  AvtoDrive
//
//  Created by Admin on 22.08.18.
//  Copyright © 2018 Admin. All rights reserved.
//

#import "ViewController.h"
#import "SWRevealViewController.h"
#import "IGLDropDownItem.h"
#import "IGLDropDownMenu.h"
#import "FMDatabase.h"
#import "AppDelegate.h"
#import "CurrentAvtoController.h"
#import "Bar.h"

@interface ViewController () <IGLDropDownMenuDelegate>
@property (nonatomic, strong) IGLDropDownMenu *menuMarka;
@property (nonatomic, strong) IGLDropDownMenu *menuType;
@property (nonatomic, copy) NSMutableDictionary *dictMarks;
@property (nonatomic, copy) NSMutableDictionary *dictType;
@property (nonatomic, copy) NSMutableArray *dataMarks;
@property (nonatomic, copy) NSMutableArray *dataType;
@property (nonatomic,strong) NSString *curr_marka;
@property (nonatomic,strong) NSString *curr_type;
@property NSString * current_icon;
@property int id_car;
@property Boolean positionType;
@property Boolean positionMark;

@end

@implementation ViewController

- (void)viewDidLoad {
    _positionType = NO;
    _positionMark = NO;
    [super viewDidLoad];
    Bar *navBar = [[Bar alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 80)];
    navBar.text.text = @"Добавить авто";
    [navBar.backButton setImage:[UIImage imageNamed:@"menu2.png"] forState:UIControlStateNormal];
    SWRevealViewController *revealViewController = self.revealViewController;
    if ( revealViewController )
    {
        [navBar.backButton addTarget:self.revealViewController action:@selector(revealToggle:)
                    forControlEvents:UIControlEventTouchUpInside];
        [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
    }
    navBar.buttonOk.hidden  = YES;
    UIColor *cl = [[UIColor alloc]initWithRed:5.0/255.0 green:8.0/255.0 blue:18.0/255.0 alpha:1.0];
    [navBar.container setBackgroundColor:cl];
    [self.view addSubview:navBar];
    if(self.edit)
    {
        [self.addAuto setTitle:@"Редактировать" forState: UIControlStateNormal];
        // Получить указатель на делегат приложения
        AppDelegate *app = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        //создаем подключение к базе
        NSString* path = app.databasePath;
        FMDatabase *database;
        database = [FMDatabase databaseWithPath:path];
        
        database.traceExecution = true; //выводит подробный лог запросов в консоль
        [database open];
        NSString* query = [NSString stringWithFormat:@"select model,marka,type,name,count(events.mileage) as mileage from auto,events where id = '%@' and auto.id = events.id_auto",self.carId];
        FMResultSet* result = [database executeQuery:query];
        while([result next])
        {
            self.markaText.text = [result stringForColumn:@"marka"];
            self.model.text = [result stringForColumn:@"model"];
            self.year.text = [result stringForColumn:@"year"];
            self.name_avto.text = [result stringForColumn:@"type"];
            self.mileage.text = [result stringForColumn:@"mileage"];
        }
        [database close];
        
    }
    [self LoadMarks];
    [self LoadType];
    [self initMarksMenu];
    [self initTypeMenu];
    
    [self InitShadow];
   
   
}
-(void)LoadMarks:(NSString*)type
{
    // Получить указатель на делегат приложения
    AppDelegate *app = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    //создаем подключение к базе
    NSString* path = app.databasePath;
    FMDatabase *database;
    database = [FMDatabase databaseWithPath:path];
    
    database.traceExecution = true; //выводит подробный лог запросов в консоль
    [database open];
    NSString* query = [NSString stringWithFormat:@"select brands_transport.name_brand as brand,transport.name_transport as name,brands_transport.name_icon as icon from brands_transport,transport where brands_transport.id_transport = transport.id and transport.name_transport = '%@'",type];
    FMResultSet* result = [database executeQuery:query];
    
    _dataMarks = [NSMutableArray array];
    while([result next])
    {
        _dictMarks = [NSMutableDictionary dictionary];
        [self.dictMarks setObject:[result stringForColumn:@"brand"] forKey:@"title"];
        [self.dictMarks setObject:[result stringForColumn:@"icon"] forKey:@"image"];
        [_dataMarks addObject:self.dictMarks];
    }
}
-(void)LoadType
{
    // Получить указатель на делегат приложения
    AppDelegate *app = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    //создаем подключение к базе
    NSString* path = app.databasePath;
    FMDatabase *database;
    database = [FMDatabase databaseWithPath:path];
    
    database.traceExecution = true; //выводит подробный лог запросов в консоль
    [database open];
    
    NSString* query = [NSString stringWithFormat:@"select name_transport as nameT, icon_name as iconN from transport;"];
    FMResultSet* result = [database executeQuery:query];
    _dataType = [NSMutableArray array];
    while([result next])
    {
        _dictType = [NSMutableDictionary dictionary];
        NSString* name = [result stringForColumn:@"nameT"];
        NSString* icon = [result stringForColumn:@"iconN"];
        [_dictType setObject:name forKey:@"title"];
        [_dictType setObject:icon forKey:@"image"];
        [self.dataType addObject:_dictType];
    }
    
}
-(void)LoadMarks
{
    // Получить указатель на делегат приложения
    AppDelegate *app = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    //создаем подключение к базе
    NSString* path = app.databasePath;
    FMDatabase *database;
    database = [FMDatabase databaseWithPath:path];
    
    database.traceExecution = true; //выводит подробный лог запросов в консоль
    [database open];
    NSString* query = [NSString stringWithFormat:@"select brands_transport.name_brand as brand,brands_transport.name_icon as icon from brands_transport limit 15"];
    FMResultSet* result = [database executeQuery:query];
    _dataMarks = [NSMutableArray array];
    while([result next])
    {
        _dictMarks = [NSMutableDictionary dictionary];
        [self.dictMarks setObject:[result stringForColumn:@"brand"] forKey:@"title"];
        [self.dictMarks setObject:[result stringForColumn:@"icon"] forKey:@"image"];
        [_dataMarks addObject:self.dictMarks];
    }
}
-(void)InitShadow
{
     self.viewName.layer.shadowColor = [UIColor colorWithRed:24.f/255.f green:25.f/255.f blue:27.f/255.f alpha:1.f].CGColor;
     self.viewName.layer.shadowOffset = CGSizeMake(0.0f,4.0f);
     self.viewName.layer.masksToBounds = NO;
     self.viewName.layer.shadowRadius = 2.5f;
     self.viewName.layer.shadowOpacity = 0.2;
    
    self.viewMileage.layer.shadowColor = [UIColor colorWithRed:24.f/255.f green:25.f/255.f blue:27.f/255.f alpha:1.f].CGColor;
    self.viewMileage.layer.shadowOffset = CGSizeMake(0.0f,4.0f);
    self.viewMileage.layer.masksToBounds = NO;
    self.viewMileage.layer.shadowRadius = 2.5f;
    self.viewMileage.layer.shadowOpacity = 0.2;
    
    self.viewModel.layer.shadowColor = [UIColor colorWithRed:24.f/255.f green:25.f/255.f blue:27.f/255.f alpha:1.f].CGColor;
    self.viewModel.layer.shadowOffset = CGSizeMake(0.0f,4.0f);
    self.viewModel.layer.masksToBounds = NO;
    self.viewModel.layer.shadowRadius = 2.5f;
    self.viewModel.layer.shadowOpacity = 0.2;
    
    self.addAuto.layer.shadowColor = [UIColor colorWithRed:24.f/255.f green:25.f/255.f blue:27.f/255.f alpha:1.f].CGColor;
    self.addAuto.layer.shadowOffset = CGSizeMake(0.0f,4.0f);
    self.addAuto.layer.masksToBounds = NO;
    self.addAuto.layer.shadowRadius = 2.5f;
    self.addAuto.layer.shadowOpacity = 0.2;
    
    self.year.layer.shadowColor = [UIColor colorWithRed:24.f/255.f green:25.f/255.f blue:27.f/255.f alpha:1.f].CGColor;
    self.viewYear.layer.shadowOffset = CGSizeMake(0.0f,4.0f);
    self.viewYear.layer.masksToBounds = NO;
    self.viewYear.layer.shadowRadius = 2.5f;
    self.viewYear.layer.shadowOpacity = 0.2;
    
    self.viewImgA.layer.shadowColor = [UIColor colorWithRed:24.f/255.f green:25.f/255.f blue:27.f/255.f alpha:1.f].CGColor;
    self.viewImgA.layer.shadowOffset = CGSizeMake(0.0f,4.0f);
    self.viewImgA.layer.masksToBounds = NO;
    self.viewImgA.layer.shadowRadius = 2.5f;
    self.viewImgA.layer.shadowOpacity = 0.2;
    
    
}
- (IBAction)addAuto:(UIButton *)sender {
    if(![_model.text isEqualToString:@""]&& ![_mileage.text isEqualToString:@""]&& ![_year.text isEqualToString:@""]&&![_curr_marka isEqualToString:@""]&&![_curr_type isEqualToString:@""])
    {
        // Получить указатель на делегат приложения
        AppDelegate *app = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        
        //создаем подключение к базе
        NSString* path = app.databasePath;
        FMDatabase *database;
        database = [FMDatabase databaseWithPath:path];
    
        database.traceExecution = true; //выводит подробный лог запросов в консоль
        [database open];
        if(![database open])
        {
            NSLog(@"Error");
        }
        NSString *query;
        if(!self.edit)
        query =[NSString stringWithFormat:@"INSERT INTO Auto (marka, model,mileage,name,type, year,icon) VALUES('%@','%@',%@,'%@','%@',%@,'%@');",_curr_marka,_model.text,_mileage.text,_name_avto.text,_curr_type,_year.text,self.current_icon];
        else
            query =[NSString stringWithFormat:@"update auto set marka ='%@', model ='%@',mileage = %@,name ='%@',type '%@',year = '%@',icon = '%@');",_curr_marka,_model.text,_mileage.text,_name_avto.text,_curr_type,_year.text,self.current_icon];
        
        [database executeUpdate:query];
        FMResultSet* res =[database executeQuery:@"SELECT LAST_INSERT_ROWID();"];
        
        while([res next])
        {
            _id_car = [res intForColumn:@"LAST_INSERT_ROWID()"];
        }
        [database close];
        NSString * title ;
        if([_name_avto.text isEqual:@""])
        {
            title = [NSString stringWithFormat:@"%@ %@ %@",_curr_marka,_model.text,_year.text];
        }
        else
            title = _name_avto.text;
       
        
    }
    
    
}
/*- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"service"]) {
        CurrentAvtoController *current = segue.destinationViewController;
        current.currentId = _id_car;
    }
    
}*/
-(void)initTypeMenu
{
    NSMutableArray *itemsType = [[NSMutableArray alloc]init];
    for(int i = 0; i<self.dataType.count;i++)
    {
        NSDictionary *dict = self.dataType[i];
        IGLDropDownItem *item = [[IGLDropDownItem alloc] init];
        NSString* title =dict[@"title"];
        
        [item setText:title];
        [itemsType addObject:item];
            }
    self.menuType = [[IGLDropDownMenu alloc] initWithMenuButtonCustomView:self.type];
    self.typeText.text = @"Выберите тип";
    self.menuType.dropDownItems = itemsType;
    self.menuType.paddingLeft = 15;
    [self.menuType setFrame:[_type frame]];
    
    self.menuType.delegate = self;
    self.menuType.gutterY = 0;
    self.menuType.type = IGLDropDownMenuTypeSlidingInBoth;
    self.menuType.itemAnimationDelay = 0.1;
    self.menuType.flipWhenToggleView = YES;
    
    
    self.menuType.layer.shadowColor = [UIColor colorWithRed:24.f/255.f green:25.f/255.f blue:27.f/255.f alpha:1.f].CGColor;
    self.menuType.layer.shadowOffset = CGSizeMake(0.0f,4.0f);
    self.menuType.layer.masksToBounds = NO;
    self.menuType.layer.shadowRadius = 2.5f;
    self.menuType.layer.shadowOpacity = 0.2;
    [self.view addSubview:self.menuType];
    [self.menuType reloadView];
}
- (void)initMarksMenu
{
    //Заполнение комбобокса
    NSMutableArray *dropdownItems = [[NSMutableArray alloc] init];
    for (int i = 0; i < self.dataMarks.count; i++) {
        NSDictionary *dict = self.dataMarks[i];
        IGLDropDownItem *item = [[IGLDropDownItem alloc] init];
        [item setIconImage:[UIImage imageNamed: dict[@"image"]]];
        [item setText:dict[@"title"]];
        [dropdownItems addObject:item];
    }
    self.menuMarka = [[IGLDropDownMenu alloc] initWithMenuButtonCustomView:self.marka];
    self.markaText.text = @"Выберите марку";
    self.menuMarka.dropDownItems = dropdownItems;
    self.menuMarka.paddingLeft = 15;
    [self.menuMarka setFrame:[_marka frame]];
    
    self.menuMarka.delegate = self;
    self.menuMarka.gutterY = 0;
    self.menuMarka.type = IGLDropDownMenuTypeSlidingInBoth;
    self.menuMarka.itemAnimationDelay = 0.1;
    self.menuMarka.flipWhenToggleView = YES;
    
    self.menuMarka.layer.shadowColor = [UIColor colorWithRed:24.f/255.f green:25.f/255.f blue:27.f/255.f alpha:1.f].CGColor;
    self.menuMarka.layer.shadowOffset = CGSizeMake(0.0f,4.0f);
    self.menuMarka.layer.masksToBounds = NO;
    self.menuMarka.layer.shadowRadius = 2.5f;
    self.menuMarka.layer.shadowOpacity = 0.2;
   
    [self.view addSubview:self.menuMarka];
    [self.menuMarka reloadView];
}
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
    //self.mileage.text = [NSString stringWithFormat:@"%@ км",self.mileage.text];
}
- (IBAction)changeText:(id)sender {
    if(![self.name_avto.text isEqualToString:@""]&&![self.year.text isEqualToString:@""]&& ![self.mileage.text isEqualToString:@""]&&![self.model.text isEqualToString:@""]&&![self.curr_type isEqualToString:@""]&&![self.curr_marka isEqualToString:@""])
    {
        self.addAuto.backgroundColor = [UIColor whiteColor];
        [self.addAuto setTitleColor:self.view.backgroundColor forState:UIControlStateNormal];
    }
}

- (void)dropDownMenu:(IGLDropDownMenu *)dropDownMenu selectedItemAtIndex:(NSInteger)index
{
    //Получаем выбранную марку
   if(dropDownMenu == self.menuMarka)
   {
       IGLDropDownItem *item = _menuMarka.dropDownItems[index];
        self.curr_marka = item.text;
       NSDictionary * dict = [self.dataMarks objectAtIndex:index];
       self.current_icon = [dict objectForKey:@"image"];
       [self.avtoImg setImage:item.iconImage];
       self.avtoImg.hidden = NO;
       self.viewImgA.hidden = YES;
       self.markaText.text = item.text;
       [self.markaImg setImage:item.iconImage];
       if(!self.positionMark)
       { self.markaText.frame = CGRectMake(self.markaText.frame.origin.x+_markaImg.frame.size.width + _markaImg.frame.origin.x,self.markaText.frame.origin.y ,self.markaText.frame.size.width, self.markaText.frame.size.height);
           self.positionMark = YES;
       }
      
   }
    else if(dropDownMenu == self.menuType)
    {
        IGLDropDownItem *item = _menuType.dropDownItems[index];
        self.curr_type = item.text;
        self.typeText.text = item.text;
        [self.typeImg setImage:item.iconImage];
        [self LoadMarks:item.text];
        //[self initMarksMenu];
        NSMutableArray *dropdownItems = [[NSMutableArray alloc] init];
        for (int i = 0; i < self.dataMarks.count; i++) {
            NSDictionary *dict = self.dataMarks[i];
            IGLDropDownItem *item = [[IGLDropDownItem alloc] init];
            [item setIconImage:[UIImage imageNamed: dict[@"image"]]];
            [item setText:dict[@"title"]];
            [dropdownItems addObject:item];
        }
        self.menuMarka.dropDownItems = dropdownItems;
        [self.menuMarka reloadView];
    }
    if(![self.name_avto.text isEqualToString:@""]&&![self.year.text isEqualToString:@""]&& ![self.mileage.text isEqualToString:@""]&&![self.model.text isEqualToString:@""]&&![self.curr_type isEqualToString:@""]&&![self.curr_marka isEqualToString:@""])
    {
        self.addAuto.backgroundColor = [UIColor whiteColor];
        [self.addAuto setTitleColor:self.view.backgroundColor forState:UIControlStateNormal];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
