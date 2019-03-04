//
//  MoykaViewController.m
//  AvtoDrive
//
//  Created by Admin on 09.10.18.
//  Copyright © 2018 Admin. All rights reserved.
//

#import "MoykaViewController.h"
#import "Bar.h"
#import "HSDatePickerViewController.h"
#import "IGLDropDownMenu.h"
#import "AppDelegate.h"
#import "FMDB.h"

@interface MoykaViewController ()<HSDatePickerViewControllerDelegate,IGLDropDownMenuDelegate>
@property (nonatomic, strong) NSDate *selectedDate;
@property (nonatomic, strong) IGLDropDownMenu *menuType;
@property (nonatomic,copy) NSArray *dataMenu;
@end

@implementation MoykaViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    Bar *navBar = [[Bar alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 80)];
    navBar.text.text = @"Мойка";
    UIColor *cl = [[UIColor alloc]initWithRed:35.0/255.0 green:96.0/255.0 blue:140.0/255.0 alpha:1.0];
    [navBar.container setBackgroundColor:cl];
    [navBar.image setImage:[UIImage imageNamed:@"moyka_back.png"]];
    [navBar.buttonOk addTarget:self action:@selector(save:)
              forControlEvents:UIControlEventTouchUpInside];
    [navBar.backButton addTarget:self action:@selector(back:)
                forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:navBar];
    _selectedDate =[NSDate date];
    NSDateFormatter *format = [NSDateFormatter new];
    [format setDateFormat:@"HH:mm"];
    self.timeText.text = [format stringFromDate:self.selectedDate];
    [format setDateFormat:@"dd.MM.yyyy"];
    self.dateText.text = [format stringFromDate:self.selectedDate];
    self.dataMenu = @[@{@"title":@"Ручная мойка"},@{@"title":@"Щеточная мойка"},@{@"title": @"Бесконтактная мойка"},@{@"title":@"Сухая мойка"},@{@"title":@"Автоматическая мойка"},@{@"title":@"Мойка самообслуживания"},@{@"title":@"Другая"}];
    [self initDefaultMenu];
    [self initShadow];
}
-(IBAction)save:(id)sender
{
    NSMutableArray * errors = [NSMutableArray array];
    if([self.moykaText.text isEqualToString:@"Выберите вид мойки"])
        [errors addObject:@"moyka"];
    if([self.mileage.text isEqualToString:@""])
        [errors addObject:@"mileage"];
    if([self.priceText.text isEqualToString:@""])
        [errors addObject:@"price"];
    if(errors.count<=0)
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
        NSDateFormatter *dateFormatter = [NSDateFormatter new];
        
        dateFormatter.dateFormat = @"d.MM.yyyy h:m:s";
        
         NSString * query = [NSString stringWithFormat:@"INSERT INTO  events(datecreate,id_auto,type_service,mileage) VALUES('%@','%d','%@','%@');",[dateFormatter stringFromDate:(_selectedDate)],app.car.id_car,@"Мойка",self.mileage.text];
             [database executeUpdate:query];
            // NSLog([NSString stringWithFormat:@"%@"],sugess);
            FMResultSet* res =[database executeQuery:@"SELECT LAST_INSERT_ROWID();"];
            int id_main = 0;
            
            while([res next])
            {
                id_main = [res intForColumn:@"LAST_INSERT_ROWID()"];
            }
        query = [NSString stringWithFormat:@"insert into car_wash(type_wash,price,id_main) values('%@','%@','%d')",self.moykaText.text,self.priceText.text,id_main];
            [database executeUpdate:query];
        [database close];
        [self.delegate setResult:@"OK!"];
        [self dismissViewControllerAnimated:YES completion:nil];
    }
    else
    {
        for(int i = 0 ;i<errors.count;i++)
        {
            if([[errors objectAtIndex:i] isEqualToString:@"mileage"])
            {
                CGPoint point = CGPointMake(self.viewMileage.frame.origin.x +self.viewMileage.frame.size.width/2+35,self.viewMileage.frame.origin.y + self.viewMileage.frame.size.height/2);
                CGPoint pointTo = CGPointMake(self.viewMileage.frame.origin.x +self.viewMileage.frame.size.width/2-35,self.viewMileage.frame.origin.y + self.viewMileage.frame.size.height/2);
                CABasicAnimation *theAnimation;
                
                theAnimation=[CABasicAnimation animationWithKeyPath:@"position"];
                theAnimation.duration = 0.07;
                theAnimation.repeatCount = 2;
                theAnimation.autoreverses = YES;
                theAnimation.fromValue= [NSValue valueWithCGPoint:point];
                theAnimation.toValue= [NSValue valueWithCGPoint:pointTo];
                [self.viewMileage.layer addAnimation:theAnimation forKey:@"animatePosition"];
            }
            else if([[errors objectAtIndex:i] isEqualToString:@"moyka"])
            {
                CGPoint point = CGPointMake(self.typeMoyka.frame.origin.x +self.typeMoyka.frame.size.width/2+35,self.typeMoyka.frame.origin.y + self.typeMoyka.frame.size.height/2);
                CGPoint pointTo = CGPointMake(self.typeMoyka.frame.origin.x +self.typeMoyka.frame.size.width/2-35,self.typeMoyka.frame.origin.y + self.typeMoyka.frame.size.height/2);
                CABasicAnimation *theAnimation;
                
                theAnimation=[CABasicAnimation animationWithKeyPath:@"position"];
                theAnimation.duration = 0.07;
                theAnimation.repeatCount = 2;
                theAnimation.autoreverses = YES;
                theAnimation.fromValue= [NSValue valueWithCGPoint:point];
                theAnimation.toValue= [NSValue valueWithCGPoint:pointTo];
                [self.typeMoyka.layer addAnimation:theAnimation forKey:@"animatePosition"];
            }
            else if([[errors objectAtIndex:i] isEqualToString:@"price"])
            {
                CGPoint point = CGPointMake(self.viewPrice.frame.origin.x +self.viewPrice.frame.size.width/2+35,self.viewPrice.frame.origin.y + self.viewPrice.frame.size.height/2);
                CGPoint pointTo = CGPointMake(self.viewPrice.frame.origin.x +self.viewPrice.frame.size.width/2-35,self.viewPrice.frame.origin.y + self.viewPrice.frame.size.height/2);
                CABasicAnimation *theAnimation;
                
                theAnimation=[CABasicAnimation animationWithKeyPath:@"position"];
                theAnimation.duration = 0.07;
                theAnimation.repeatCount = 2;
                theAnimation.autoreverses = YES;
                theAnimation.fromValue= [NSValue valueWithCGPoint:point];
                theAnimation.toValue= [NSValue valueWithCGPoint:pointTo];
                [self.viewPrice.layer addAnimation:theAnimation forKey:@"animatePosition"];
            }
        }
    }
}
-(void)initShadow
{
    self.viewDate.layer.shadowColor = [UIColor colorWithRed:24.f/255.f green:25.f/255.f blue:27.f/255.f alpha:1.f].CGColor;
    self.viewDate.layer.shadowOffset = CGSizeMake(0.0f,4.0f);
    self.viewDate.layer.masksToBounds = NO;
    self.viewDate.layer.shadowRadius = 2.5f;
    self.viewDate.layer.shadowOpacity = 0.2;
    
    self.viewTime.layer.shadowColor = [UIColor colorWithRed:24.f/255.f green:25.f/255.f blue:27.f/255.f alpha:1.f].CGColor;
    self.viewTime.layer.shadowOffset = CGSizeMake(0.0f,4.0f);
    self.viewTime.layer.masksToBounds = NO;
    self.viewTime.layer.shadowRadius = 2.5f;
    self.viewTime.layer.shadowOpacity = 0.2;
    
    self.viewMileage.layer.shadowColor = [UIColor colorWithRed:24.f/255.f green:25.f/255.f blue:27.f/255.f alpha:1.f].CGColor;
    self.viewMileage.layer.shadowOffset = CGSizeMake(0.0f,4.0f);
    self.viewMileage.layer.masksToBounds = NO;
    self.viewMileage.layer.shadowRadius = 2.5f;
    self.viewMileage.layer.shadowOpacity = 0.2;
    
    self.viewPrice.layer.shadowColor = [UIColor colorWithRed:24.f/255.f green:25.f/255.f blue:27.f/255.f alpha:1.f].CGColor;
    self.viewPrice.layer.shadowOffset = CGSizeMake(0.0f,4.0f);
    self.viewPrice.layer.masksToBounds = NO;
    self.viewPrice.layer.shadowRadius = 2.5f;
    self.viewPrice.layer.shadowOpacity = 0.2;
    
}
-(IBAction)back:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (IBAction)openCalendar:(id)sender {
    HSDatePickerViewController *hsdpvc = [[HSDatePickerViewController alloc] init];
    hsdpvc.delegate = self;
    if (self.selectedDate) {
        hsdpvc.date = self.selectedDate;
    }
    
    [self presentViewController:hsdpvc animated:YES completion:nil];
}
- (void)hsDatePickerPickedDate:(NSDate *)date {
    NSLog(@"Date picked %@", date);
    NSDateFormatter *dateFormater = [NSDateFormatter new];
    dateFormater.dateFormat = @"dd.MM.yyyy HH:mm:ss";
    
    self.selectedDate = date;
    NSDateFormatter *format = [NSDateFormatter new];
    [format setDateFormat:@"HH:mm"];
    self.timeText.text = [format stringFromDate:self.selectedDate];
    [format setDateFormat:@"dd.MM.yyyy"];
    self.dateText.text = [format stringFromDate:self.selectedDate];
}
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
    // self.mileage.text = [NSString stringWithFormat:@"%@ км",self.mileage.text];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)initDefaultMenu
{
    //Заполнение комбобокса сервиса
    NSMutableArray *dropdownItems = [[NSMutableArray alloc] init];
    for (int i = 0; i < self.dataMenu.count; i++) {
        NSDictionary *dict = self.dataMenu[i];
        IGLDropDownItem *item = [[IGLDropDownItem alloc] init];
        [item setText:dict[@"title"]];
        [dropdownItems addObject:item];
    }
    
    NSMutableArray *itemsType = [[NSMutableArray alloc] init];
    for (int i = 0; i < self.dataMenu.count; i++) {
        NSDictionary *dict = self.dataMenu[i];
        IGLDropDownItem *item = [[IGLDropDownItem alloc] init];
        [item setText:dict[@"title"]];
        [itemsType addObject:item];
    }

    self.menuType = [[IGLDropDownMenu alloc] initWithMenuButtonCustomView:self.typeMoyka];
    self.moykaText.text = @"Выберите вид мойки";
    
    self.menuType.dropDownItems = itemsType;
    self.menuType.paddingLeft = 15;
    [self.menuType setFrame:[self.typeMoyka frame]];
    // self.viewS.hidden= YES;
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
    
    self.viewMileage.layer.shadowColor = [UIColor colorWithRed:24.f/255.f green:25.f/255.f blue:27.f/255.f alpha:1.f].CGColor;
    self.viewMileage.layer.shadowOffset = CGSizeMake(0.0f,4.0f);
    self.viewMileage.layer.masksToBounds = NO;
    self.viewMileage.layer.shadowRadius = 2.5f;
    self.viewMileage.layer.shadowOpacity = 0.2;
    
    [self.view addSubview:self.menuType];
    [self.menuType reloadView];
}
- (void)dropDownMenu:(IGLDropDownMenu *)dropDownMenu selectedItemAtIndex:(NSInteger)index
{
    //Получаем выбранную марку
    if(dropDownMenu == self.menuType)
    {
        IGLDropDownItem *item = self.menuType.dropDownItems[index];
        self.moykaText.text = item.text;
        [self.moykaText setTextColor:[UIColor whiteColor]];
    }
}
@end
