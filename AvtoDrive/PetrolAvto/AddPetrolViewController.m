//
//  AddPetrolViewController.m
//  AvtoDrive
//
//  Created by Admin on 13.09.18.
//  Copyright © 2018 Admin. All rights reserved.
//

#import "AddPetrolViewController.h"
#import "HSDatePickerViewController.h"
#import "Bar.h"
#import "IGLDropDownMenu.h"
#import "AppDelegate.h"
#import "FMDB.h"

@interface AddPetrolViewController ()<HSDatePickerViewControllerDelegate,IGLDropDownMenuDelegate>
@property (nonatomic, strong) IGLDropDownMenu *menuPetrol;
@property (nonatomic, strong) NSDate *selectedDate;
@property (nonatomic, strong) NSArray *dataMenu;
@end

@implementation AddPetrolViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    Bar *navBar = [[Bar alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 80)];
    navBar.text.text = @"Заправка";
    UIColor *cl = [[UIColor alloc]initWithRed:14.0/255.0 green:100.0/255.0 blue:91.0/255.0 alpha:1.0];
    [navBar.container setBackgroundColor:cl];
    [navBar.image setImage:[UIImage imageNamed:@"petrol_back.png"]];
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
    
    self.dataMenu = @[@{@"title":@"Безнин АИ-92"},@{@"title":@"Бензин АИ-95"},@{@"title": @"Бензин АИ-98"},@{@"title":@"Бензит АИ-100"},@{@"title":@"ДТ"},@{@"title":@"Газ"}];
    [self initDefaultMenu];
    [self initShadow];
}
-(IBAction)save:(id)sender
{
    NSMutableArray * errors = [NSMutableArray array];
    if([self.petrolText.text isEqualToString:@"Выберите топливо"])
        [errors addObject:@"petrol"];
    if([self.priceText.text isEqualToString:@""])
        [errors addObject:@"price"];
    if([self.kolvoText.text isEqualToString:@""])
        [errors addObject:@"kolvo"];
    if([self.summText.text isEqualToString:@""])
        [errors addObject:@"summ"];
    if([self.mileageText.text isEqualToString:@""])
        [errors addObject:@"mileage"];
    if(errors.count<=0)
    {
        // Получить указатель на делегат приложения
        AppDelegate *app = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        // Добавление в базу
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
        
        NSString * query = [NSString stringWithFormat:@"INSERT INTO  events(datecreate,id_auto,type_service,mileage) VALUES('%@','%d','%@','%@');",[dateFormatter stringFromDate:(_selectedDate)],app.car.id_car,@"Заправка",self.mileageText.text];
         [database executeUpdate:query];
        // NSLog([NSString stringWithFormat:@"%@"],sugess);
        FMResultSet* res =[database executeQuery:@"SELECT LAST_INSERT_ROWID();"];
        int id_main = 0;
        
        while([res next])
        {
            id_main = [res intForColumn:@"LAST_INSERT_ROWID()"];
        }
        query = [NSString stringWithFormat:@"insert into petrol(type,price,liters,summa,id_main) values('%@','%@','%@','%@','%d')",self.petrolText.text,self.priceText.text,self.kolvoText.text,self.summText.text,id_main];
        [database executeUpdate:query];
        [database close];
        [self.delegate setResult:@"OK!"];
        [self dismissViewControllerAnimated:YES completion:nil];
    }
    else
    {
    for(int i = 0 ;i<errors.count;i++)
    {
        if([[errors objectAtIndex:i] isEqualToString:@"petrol"])
        {
            CGPoint point = CGPointMake(self.viewPetrol.frame.origin.x +self.viewPetrol.frame.size.width/2+35,self.viewPetrol.frame.origin.y + self.viewPetrol.frame.size.height/2);
            CGPoint pointTo = CGPointMake(self.viewPetrol.frame.origin.x +self.viewPetrol.frame.size.width/2-35,self.viewPetrol.frame.origin.y + self.viewPetrol.frame.size.height/2);
            
            CABasicAnimation *theAnimation;
            
            theAnimation=[CABasicAnimation animationWithKeyPath:@"position"];
            theAnimation.duration = 0.07;
            theAnimation.repeatCount = 2;
            theAnimation.autoreverses = YES;
            theAnimation.fromValue= [NSValue valueWithCGPoint:point];
            theAnimation.toValue= [NSValue valueWithCGPoint:pointTo];
            [self.viewPetrol.layer addAnimation:theAnimation forKey:@"animatePosition"];
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
        else if([[errors objectAtIndex:i] isEqualToString:@"kolvo"])
        {
            CGPoint point = CGPointMake(self.viewKolvo.frame.origin.x +self.viewKolvo.frame.size.width/2+35,self.viewKolvo.frame.origin.y + self.viewKolvo.frame.size.height/2);
            CGPoint pointTo = CGPointMake(self.viewKolvo.frame.origin.x +self.viewKolvo.frame.size.width/2-35,self.viewKolvo.frame.origin.y + self.viewKolvo.frame.size.height/2);
            
            CABasicAnimation *theAnimation;
            
            theAnimation=[CABasicAnimation animationWithKeyPath:@"position"];
            theAnimation.duration = 0.07;
            theAnimation.repeatCount = 2;
            theAnimation.autoreverses = YES;
            theAnimation.fromValue= [NSValue valueWithCGPoint:point];
            theAnimation.toValue= [NSValue valueWithCGPoint:pointTo];
            [self.viewKolvo.layer addAnimation:theAnimation forKey:@"animatePosition"];
        }
        else if([[errors objectAtIndex:i] isEqualToString:@"mileage"])
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
    }
    }
}
-(IBAction)back:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
    // self.mileage.text = [NSString stringWithFormat:@"%@ км",self.mileage.text];
}
- (IBAction)change_price:(id)sender {
    if(![self.priceText.text isEqualToString:@""]&&![self.kolvoText.text isEqualToString:@""])
    {
        double price = [self.priceText.text doubleValue];
        double litres = [self.kolvoText.text doubleValue];
        double sum = price*litres;
        self.summText.text = [NSString stringWithFormat:@"%.2f",sum];
    }
}
- (IBAction)change_litres:(id)sender {
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
    
    self.viewKolvo.layer.shadowColor = [UIColor colorWithRed:24.f/255.f green:25.f/255.f blue:27.f/255.f alpha:1.f].CGColor;
    self.viewKolvo.layer.shadowOffset = CGSizeMake(0.0f,4.0f);
    self.viewKolvo.layer.masksToBounds = NO;
    self.viewKolvo.layer.shadowRadius = 2.5f;
    self.viewKolvo.layer.shadowOpacity = 0.2;
    
    self.viewSumm.layer.shadowColor = [UIColor colorWithRed:24.f/255.f green:25.f/255.f blue:27.f/255.f alpha:1.f].CGColor;
    self.viewSumm.layer.shadowOffset = CGSizeMake(0.0f,4.0f);
    self.viewSumm.layer.masksToBounds = NO;
    self.viewSumm.layer.shadowRadius = 2.5f;
    self.viewSumm.layer.shadowOpacity = 0.2;
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
    self.menuPetrol = [[IGLDropDownMenu alloc] initWithMenuButtonCustomView:_viewPetrol];
    self.petrolText.text = @"Выберите топливо";
    
    self.menuPetrol.dropDownItems = dropdownItems;
    self.menuPetrol.paddingLeft = 15;
    [self.menuPetrol setFrame:[self.viewPetrol frame]];
   
    self.menuPetrol.delegate = self;
    self.menuPetrol.gutterY = 0;
    self.menuPetrol.type = IGLDropDownMenuTypeSlidingInBoth;
    self.menuPetrol.itemAnimationDelay = 0.1;
    self.menuPetrol.flipWhenToggleView = YES;
    
    self.menuPetrol.layer.shadowColor = [UIColor colorWithRed:24.f/255.f green:25.f/255.f blue:27.f/255.f alpha:1.f].CGColor;
    self.menuPetrol.layer.shadowOffset = CGSizeMake(0.0f,4.0f);
    self.menuPetrol.layer.masksToBounds = NO;
    self.menuPetrol.layer.shadowRadius = 2.5f;
    self.menuPetrol.layer.shadowOpacity = 0.2;
    [self.view addSubview:self.menuPetrol];
    [self.menuPetrol reloadView];
   
}
- (void)dropDownMenu:(IGLDropDownMenu *)dropDownMenu selectedItemAtIndex:(NSInteger)index
{
    //Получаем выбранную марку
    if(dropDownMenu == self.menuPetrol)
    {
        IGLDropDownItem *item = self.menuPetrol.dropDownItems[index];
        self.petrolText.text = item.text;
        [self.petrolText setTextColor:[UIColor whiteColor]];
    }
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
   // self.dateLabel.text = [dateFormater stringFromDate:date];
    
    self.selectedDate = date;
    
    NSDateFormatter *format = [NSDateFormatter new];
    [format setDateFormat:@"HH:mm"];
    self.timeText.text = [format stringFromDate:self.selectedDate];
    [format setDateFormat:@"dd.MM.yyyy"];
    self.dateText.text = [format stringFromDate:self.selectedDate];
}




@end
