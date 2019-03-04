//
//  ReminderViewViewController.m
//  AvtoDrive
//
//  Created by Admin on 05.10.18.
//  Copyright © 2018 Admin. All rights reserved.
//

#import "ReminderViewViewController.h"
#import "Bar.h"
#import "IGLDropDownItem.h"
#import "IGLDropDownMenu.h"
#import "AppDelegate.h"
#import "FMDB.h"
#import "HSDatePickerViewController.h"
@interface ReminderViewViewController ()<HSDatePickerViewControllerDelegate,IGLDropDownMenuDelegate>
@property (nonatomic, strong) IGLDropDownMenu *menuService;
@property (nonatomic, strong) IGLDropDownMenu *menuType;
@property (nonatomic, strong) NSDate *selectedDate;
@property NSString *currService;

@property (nonatomic,copy) NSArray *dataMenu;
@property (nonatomic,copy) NSArray *dataType;
@end

@implementation ReminderViewViewController
@synthesize  delegate;
- (void)viewDidLoad {
    [super viewDidLoad];
    _selectedDate =[NSDate date];
    Bar *navBar = [[Bar alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 80)];
    navBar.text.text = @"Напоминание";
    UIColor *cl = [[UIColor alloc]initWithRed:34.0/255.0 green:97.0/255.0 blue:140.0/255.0 alpha:1.0];
    [navBar.container setBackgroundColor:cl];
    [navBar.image setImage:[UIImage imageNamed:@"reminder.png"]];
    [navBar.buttonOk addTarget:self action:@selector(saveReminder:)
              forControlEvents:UIControlEventTouchUpInside];
    [navBar.backButton addTarget:self action:@selector(back:)
              forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:navBar];
    
    self.dataMenu = @[@{@"title":@"Аккумулятор"},@{@"title":@"Балансировка шин"},@{@"title": @"Жидкость для сцепления"},@{@"title": @"Замена масла"},@{@"title": @"Подвеска"},@{@"title": @"Ремонт двигателя"},@{@"title": @"Замена фильтра"},@{@"title": @"Сцепление"}];
    
    self.dataType = @[@{@"title":@"Напоминание по дате"},@{@"title":@"Напоминание по километражу"}];
    [self initDefaultMenu];
    
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
    self.time_text.text = [format stringFromDate:self.selectedDate];
    [format setDateFormat:@"dd.MM.yyyy"];
    self.date_text.text = [format stringFromDate:self.selectedDate];
}
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
     self.mileage.text = [NSString stringWithFormat:@"%@ км",self.mileage.text];
}
- (UIImage *)imageWithImage:(UIImage *)image convertToSize:(CGSize)size {
    UIGraphicsBeginImageContext(size);
    [image drawInRect:CGRectMake(0, 0, size.width, size.height)];
    UIImage *destImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return destImage;
}
- (IBAction)mileage_edit:(id)sender {
    if(![self.mileage.text isEqualToString:@""])
    {
        [self.mileageImg setImage:[UIImage imageNamed:@"mileage_w.png"]];
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(IBAction)saveReminder:(id)sender
{
    NSMutableArray * errors = [NSMutableArray array];
    if([self.menuText.text isEqualToString:@"Выберите вид сервиса"])
        [errors addObject:@"service"];
    if([_typeText.text isEqualToString:@"Напоминание по километражу"])
        if([self.mileage.text isEqualToString:@""])
            [errors addObject:@"mileage"];
    if(errors.count<=0)
    {  // Получить указатель на делегат приложения
       
        NSString *value;
        NSDateFormatter *dateFormatter = [NSDateFormatter new];
        dateFormatter.dateFormat = @"d.MM.yyyy h:m:s";
        int t_r = 0;
        NSDate *currentDate = [NSDate date];
        if([_typeText.text isEqualToString:@"Напоминание по километражу"])
        {
            value = _mileage.text;
            t_r = 1;
        }
        else
         value = [dateFormatter stringFromDate: _selectedDate];
        // [database beginTransaction];
       
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
       NSString * query = [NSString stringWithFormat:@"INSERT INTO  events(datecreate,id_auto,type_service,mileage) VALUES('%@','%d','%@','%@');",[dateFormatter stringFromDate:(_selectedDate)],app.car.id_car,@"Напоминание",@""];
        [database executeUpdate:query];
        FMResultSet* res =[database executeQuery:@"SELECT LAST_INSERT_ROWID();"];
        int id_main = 0;
        while([res next])
        {
            id_main = [res intForColumn:@"LAST_INSERT_ROWID()"];
        }
        query = [NSString stringWithFormat:@"INSERT INTO  reminder(type,value_remi,type_remi,datecreate,id_main) VALUES('%@','%@','%d','%@','%d');",_currService,value,t_r,[dateFormatter stringFromDate:currentDate],id_main];
        [database executeUpdate:query];
        [database close];
        [delegate setResult:@"OK!"];
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
            else if([[errors objectAtIndex:i] isEqualToString:@"service"])
            {
                CGPoint point = CGPointMake(self.menu.frame.origin.x +self.menu.frame.size.width/2+35,self.menu.frame.origin.y + self.menu.frame.size.height/2);
                CGPoint pointTo = CGPointMake(self.menu.frame.origin.x +self.menu.frame.size.width/2-35,self.menu.frame.origin.y + self.menu.frame.size.height/2);
                CABasicAnimation *theAnimation;
                
                theAnimation=[CABasicAnimation animationWithKeyPath:@"position"];
                theAnimation.duration = 0.07;
                theAnimation.repeatCount = 2;
                theAnimation.autoreverses = YES;
                theAnimation.fromValue= [NSValue valueWithCGPoint:point];
                theAnimation.toValue= [NSValue valueWithCGPoint:pointTo];
                [self.menu.layer addAnimation:theAnimation forKey:@"animatePosition"];
            }
        }
    }
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
    for (int i = 0; i < self.dataType.count; i++) {
        NSDictionary *dict = self.dataType[i];
        IGLDropDownItem *item = [[IGLDropDownItem alloc] init];
        [item setText:dict[@"title"]];
        [itemsType addObject:item];
    }
    self.menuService = [[IGLDropDownMenu alloc] initWithMenuButtonCustomView:_menu];
    self.menuText.text = @"Выберите вид сервиса";
    
    self.menuService.dropDownItems = dropdownItems;
    self.menuService.paddingLeft = 15;
    [self.menuService setFrame:[self.menu frame]];
    // self.viewS.hidden= YES;
    self.menuService.delegate = self;
    self.menuService.gutterY = 0;
    self.menuService.type = IGLDropDownMenuTypeSlidingInBoth;
    self.menuService.itemAnimationDelay = 0.1;
    self.menuService.flipWhenToggleView = YES;
    
    self.menuService.layer.shadowColor = [UIColor colorWithRed:24.f/255.f green:25.f/255.f blue:27.f/255.f alpha:1.f].CGColor;
    self.menuService.layer.shadowOffset = CGSizeMake(0.0f,4.0f);
    self.menuService.layer.masksToBounds = NO;
    self.menuService.layer.shadowRadius = 2.5f;
    self.menuService.layer.shadowOpacity = 0.2;
    
  
    
    self.menuType = [[IGLDropDownMenu alloc] initWithMenuButtonCustomView:_type];
    self.typeText.text = @"Напоминание по дате";
    
    self.menuType.dropDownItems = itemsType;
    self.menuType.paddingLeft = 15;
    [self.menuType setFrame:[self.type frame]];
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
    [self.view addSubview:self.menuType];
    [self.view addSubview:self.menuService];
    [self.menuType reloadView];
    [self.menuService reloadView];
    
    self.viewMileage.layer.shadowColor = [UIColor colorWithRed:24.f/255.f green:25.f/255.f blue:27.f/255.f alpha:1.f].CGColor;
    self.viewMileage.layer.shadowOffset = CGSizeMake(0.0f,4.0f);
    self.viewMileage.layer.masksToBounds = NO;
    self.viewMileage.layer.shadowRadius = 2.5f;
    self.viewMileage.layer.shadowOpacity = 0.2;
    
    
}
- (void)dropDownMenu:(IGLDropDownMenu *)dropDownMenu selectedItemAtIndex:(NSInteger)index
{
    //Получаем выбранный пункт меню
    if(dropDownMenu == self.menuService)
    {
        IGLDropDownItem *item = self.menuService.dropDownItems[index];
        self.menuText.text = item.text;
        self.currService = item.text;
        [self.menuText setTextColor:[UIColor whiteColor]];
    }
    else if(dropDownMenu == self.menuType)
    {
        IGLDropDownItem *item = self.menuType.dropDownItems[index];
        self.typeText.text = item.text;
        [self.typeText setTextColor:[UIColor whiteColor]];
        if([_typeText.text isEqualToString:@"Напоминание по километражу"])
        {
            self.mileage.hidden = NO;
            self.viewMileage.hidden = NO;
            self.date.userInteractionEnabled = NO;
            self.time.userInteractionEnabled = NO;
            self.date.hidden = YES;
            self.time.hidden = YES;
        }
        else
        {
            self.date.userInteractionEnabled = YES;
            self.time.userInteractionEnabled = YES;
             self.mileage.hidden = YES;
            self.viewMileage.hidden = YES;
            self.date.hidden = NO;
            self.time.hidden = NO;
        }
    }
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
