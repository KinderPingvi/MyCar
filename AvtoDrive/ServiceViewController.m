//
//  ServiceViewController.m
//  AvtoDrive
//
//  Created by Admin on 18.09.18.
//  Copyright © 2018 Admin. All rights reserved.
//

#import "ServiceViewController.h"
#import "HSDatePickerViewController.h"
#import "IGLDropDownMenu.h"
#import "IGLDropDownItem.h"
#import "Services.h"
#import "AppDelegate.h"
#import "FMDB.h"
#import "HistoryTableViewController.h"

@interface ServiceViewController ()<HSDatePickerViewControllerDelegate,IGLDropDownMenuDelegate,CAAnimationDelegate>
@property (nonatomic, strong) NSDate *selectedDate;
@property (nonatomic, strong) IGLDropDownMenu *menuService;
@property (nonatomic,copy) NSArray *dataMenu;
@property (nonatomic) NSString *currService;
@property (nonatomic) Boolean dopSection;
@property NSString *type;


@end

@implementation ServiceViewController
@synthesize delegate;
- (void)viewDidLoad {
    [super viewDidLoad];
  
    Bar *navBar = [[Bar alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 80)];
    navBar.text.text = @"Cервис";
    [navBar.buttonOk addTarget:self action:@selector(save:)
              forControlEvents:UIControlEventTouchUpInside];
    [navBar.backButton addTarget:self action:@selector(back:)
                forControlEvents:UIControlEventTouchUpInside];
    UIColor *cl = [[UIColor alloc]initWithRed:125.0/255.0 green:55.0/255.0 blue:63.0/255.0 alpha:1.0];
    [navBar.container setBackgroundColor:cl];
    [navBar.image setImage:[UIImage imageNamed:@"service_back.png"]];
    [self.view addSubview:navBar];
    _selectedDate =[NSDate date];
    NSDateFormatter *format = [NSDateFormatter new];
    [format setDateFormat:@"HH:mm"];
    self.timeText.text = [format stringFromDate:self.selectedDate];
    [format setDateFormat:@"dd.MM.yyyy"];
    self.dateText.text = [format stringFromDate:self.selectedDate];
    UIColor *colour;
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
    
    self.addService.layer.shadowColor = [UIColor colorWithRed:24.f/255.f green:25.f/255.f blue:27.f/255.f alpha:1.f].CGColor;
    self.addService.layer.shadowOffset = CGSizeMake(0.0f,4.0f);
    self.addService.layer.masksToBounds = NO;
    self.addService.layer.shadowRadius = 2.5f;
    self.addService.layer.shadowOpacity = 0.2;
    
    if([_typeSeque isEqualToString:@"service"])
    { self.dataMenu = @[@{@"title":@"Аккумулятор"},@{@"title":@"Балансировка шин"},@{@"title": @"Жидкость для сцепления"},@{@"title": @"Замена масла"},@{@"title": @"Подвеска"},@{@"title": @"Ремонт двигателя"},@{@"title": @"Замена фильтра"},@{@"title": @"Сцепление"}];
        self.type = @"Сервис";
        colour = [[UIColor alloc]initWithRed:125.0/255.0 green:55.0/255.0 blue:63.0/255.0 alpha:1.0];
    }
    else
    {
        self.dataMenu = @[@{@"title":@"Ксенон"},@{@"title":@"Полировка кузова"},@{@"title": @"Тонировка"},@{@"title": @"Покраска дисков"},@{@"title": @"Покраска кузова"},@{@"title": @"Автозвук"}];
        self.type = @"Тюнинг";
        navBar.text.text = @"Тюнинг";
         [navBar.image setImage:[UIImage imageNamed:@"tuning_back.png"]];
        cl = [[UIColor alloc]initWithRed:84.0/255.0 green:63.0/255.0 blue:106.0/255.0 alpha:1.0];
        [navBar.container setBackgroundColor:cl];
        colour = [[UIColor alloc]initWithRed:198.0/255.0 green:137.0/255.0 blue:116.0/245.0 alpha:1];
    }
    self.serviceItem.typeSeque = self.typeSeque;
    [self.serviceItem initDefaultMenu];
    _dopSection = NO;
    [self initDefaultMenu];
}
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
   // self.mileage.text = [NSString stringWithFormat:@"%@ км",self.mileage.text];
}

- (IBAction)mileage_edit:(id)sender {
    if(![self.mileage.text isEqualToString:@""])
    {
        [self.mileageImg setImage:[UIImage imageNamed:@"mileage_w.png"]];
    }
}
- (UIImage *)imageWithImage:(UIImage *)image convertToSize:(CGSize)size {
    UIGraphicsBeginImageContext(size);
    [image drawInRect:CGRectMake(0, 0, size.width, size.height)];
    UIImage *destImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return destImage;
}

-(IBAction)back:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];

}
- (IBAction)save:(id)sender {
    NSMutableArray * errors = [NSMutableArray array];
    if([self.mileage.text isEqualToString:@""])
        [errors addObject:@"mileage"];
    if([self.comboText.text isEqualToString:@"Выберите вид сервиса"])
        [errors addObject:@"service"];
    if([self.price.text isEqualToString:@""])
        [errors addObject:@"price"];
    if(errors.count<=0)
    {  // Получить указатель на делегат приложения
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
   BOOL sugess;
    dateFormatter.dateFormat = @"d.MM.yyyy h:m:s";
   // [database beginTransaction];
        
    if(![self.mileage.text isEqualToString:@""])
    { NSString * query = [NSString stringWithFormat:@"INSERT INTO  events(datecreate,id_auto,type_service,mileage) VALUES('%@','%d','%@','%@');",[dateFormatter stringFromDate:(_selectedDate)],app.car.id_car,self.type,_mileage.text];
    sugess = [database executeUpdate:query];
   // NSLog([NSString stringWithFormat:@"%@"],sugess);
    FMResultSet* res =[database executeQuery:@"SELECT LAST_INSERT_ROWID();"];
    int id_main = 0;
    
    while([res next])
    {
        id_main = [res intForColumn:@"LAST_INSERT_ROWID()"];
    }
    query = [NSString stringWithFormat:@"insert into event_item(type,price,pp,id_main) values('%@','%@','%s','%d')",_currService,_price.text,"1",id_main];
    sugess = [database executeUpdate:query];
    //Если добавлен еще вид сервиса
    if(self.dopSection)
    {
        query = [NSString stringWithFormat:@"insert into event_item(type,price,pp,id_main) values('%@','%@','%s','%d')",self.serviceItem.currService,self.serviceItem.price.text,"2",id_main];
        sugess = [database executeUpdate:query];
    }
        [database close];
        
    }
        NSLog(@"Complete");
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
                CGPoint point = CGPointMake(self.viewS.frame.origin.x +self.viewS.frame.size.width/2+35,self.viewS.frame.origin.y + self.viewS.frame.size.height/2);
                CGPoint pointTo = CGPointMake(self.viewS.frame.origin.x +self.viewS.frame.size.width/2-35,self.viewS.frame.origin.y + self.viewS.frame.size.height/2);
                CABasicAnimation *theAnimation;
                
                theAnimation=[CABasicAnimation animationWithKeyPath:@"position"];
                theAnimation.duration = 0.07;
                theAnimation.repeatCount = 2;
                theAnimation.autoreverses = YES;
                theAnimation.fromValue= [NSValue valueWithCGPoint:point];
                theAnimation.toValue= [NSValue valueWithCGPoint:pointTo];
                [self.viewS.layer addAnimation:theAnimation forKey:@"animatePosition"];
            }
            else
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
typedef void (^animationCompletionBlock)(void);
#define kAnimationCompletionBlock @"animationAdd"
- (IBAction)addService:(id)sender {
    
    //Animation addButton
    CABasicAnimation *anim;
    anim=[CABasicAnimation animationWithKeyPath:@"position"];
    anim.duration = 0.1;
    anim.repeatCount = 1;
    anim.autoreverses = NO;
    anim.fromValue= [NSValue valueWithCGPoint:CGPointMake(self.addService.frame.origin.x + self.addService.frame.size.width/2,self.addService.frame.origin.y + self.addService.frame.size.height/2 +5)];
    
    anim.toValue= [NSValue valueWithCGPoint:CGPointMake(self.addService.frame.origin.x + self.addService.frame.size.width/2, self.viewPrice.frame.origin.y + self.viewPrice.frame.size.height/2)];
    animationCompletionBlock theBlock = ^void(void)
    {
        _addService.hidden = YES;
        CABasicAnimation *theAnimation;
        self.serviceItem.hidden = NO;
        
        theAnimation=[CABasicAnimation animationWithKeyPath:@"position"];
        theAnimation.duration = 0.2;
        theAnimation.repeatCount = 1;
        theAnimation.autoreverses = NO;
        theAnimation.fromValue= [NSValue valueWithCGPoint:CGPointMake(self.viewPrice.frame.origin.x + self.viewPrice.frame.size.width/2,self.viewPrice.frame.origin.y + self.viewPrice.frame.size.height/2)];
        
        theAnimation.toValue= [NSValue valueWithCGPoint:CGPointMake(self.serviceItem.frame.origin.x + self.serviceItem.frame.size.width/2, self.serviceItem.frame.origin.y + self.serviceItem.frame.size.height/2)];
        [self.serviceItem.layer addAnimation:theAnimation forKey:@"animatePosition"];
        [self.serviceItem.del_service addTarget:self action:@selector(delService:)
                               forControlEvents:UIControlEventTouchUpInside];
        _dopSection = YES;
    };
    [anim setValue: theBlock forKey: kAnimationCompletionBlock];
    anim.delegate = self;
    [self.addService.layer addAnimation:anim forKey:@"animatePosition"];
 
}
-(void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
{
    animationCompletionBlock theBlock = [anim valueForKey: kAnimationCompletionBlock];
    if(flag)
    {
        if (theBlock)
            theBlock();
        else
        {
            self.serviceItem.hidden = YES;
            _dopSection = NO;
            self.serviceItem.currService = @"";
            self.serviceItem.price.text = @"";
        }
    }
}


-(IBAction)delService:(id)sender
{
    CABasicAnimation *theAnimation;
    
    _addService.hidden = NO;
    theAnimation=[CABasicAnimation animationWithKeyPath:@"position"];
    theAnimation.duration = 0.9;
    theAnimation.repeatCount = 1;
    theAnimation.autoreverses = NO;
    theAnimation.fromValue= [NSValue valueWithCGPoint:CGPointMake(self.serviceItem.frame.origin.x + self.serviceItem.frame.size.width/2+5,self.serviceItem.frame.origin.y+self.serviceItem.frame.size.height/2)];
    theAnimation.toValue= [NSValue valueWithCGPoint:CGPointMake(-2000,self.serviceItem.frame.origin.y + self.serviceItem.frame.size.height/2)];
    
    CABasicAnimation *theAnimationAdd;
    theAnimationAdd=[CABasicAnimation animationWithKeyPath:@"position"];
    theAnimationAdd.duration = 0.5;
    theAnimationAdd.repeatCount = 1;
    theAnimationAdd.autoreverses = NO;
    theAnimationAdd.fromValue= [NSValue valueWithCGPoint:CGPointMake(self.addService.frame.origin.x + self.addService.frame.size.width/2,self.viewS.frame.origin.y + self.viewS.frame.size.height/2)];
    theAnimationAdd.toValue= [NSValue valueWithCGPoint:CGPointMake(self.addService.frame.origin.x + self.addService.frame.size.width/2,self.addService.frame.origin.y + self.viewS.frame.size.height+10)];
    // theAnimation.delegate = self;
    [self.addService.layer addAnimation:theAnimationAdd forKey:@"animatePosition"];
   
    [theAnimation setValue: nil forKey: kAnimationCompletionBlock];
    theAnimation.delegate = self;
    [self.serviceItem.layer addAnimation:theAnimation forKey:@"animDel"];
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
- (void)initDefaultMenu
{
    //Заполнение комбобокса
    NSMutableArray *dropdownItems = [[NSMutableArray alloc] init];
    for (int i = 0; i < self.dataMenu.count; i++) {
        NSDictionary *dict = self.dataMenu[i];
        IGLDropDownItem *item = [[IGLDropDownItem alloc] init];
        [item setText:dict[@"title"]];
        [dropdownItems addObject:item];
    }
    self.menuService = [[IGLDropDownMenu alloc] initWithMenuButtonCustomView:_viewS];
    if([self.typeSeque isEqualToString:@"service"])
    self.comboText.text = @"Выберите вид сервиса";
    
    else
        self.comboText.text = @"Выберите тип тюнинга";
    self.menuService.menuIconImage = [UIImage imageNamed:@"add.png"];
    self.menuService.dropDownItems = dropdownItems;
    self.menuService.paddingLeft = 15;
    [self.menuService setFrame:[self.viewS frame]];
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
    [self.view addSubview:self.menuService];
    
    [self.menuService reloadView];
}

- (void)dropDownMenu:(IGLDropDownMenu *)dropDownMenu selectedItemAtIndex:(NSInteger)index
{
    //Получаем выбранную марку
    if(dropDownMenu == self.menuService)
    {
        IGLDropDownItem *item = self.menuService.dropDownItems[index];
        self.currService = item.text;
        self.comboText.text = item.text;
        [self.comboText setTextColor:[UIColor whiteColor]];
    }
}

@end
