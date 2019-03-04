//
//  Services.m
//  AvtoDrive
//
//  Created by Admin on 18.09.18.
//  Copyright © 2018 Admin. All rights reserved.
//

#import "Services.h"
#import "IGLDropDownMenu.h"
#import "IGLDropDownItem.h"

@interface Services()<IGLDropDownMenuDelegate>
@property (nonatomic) IGLDropDownMenu * menu;
@property (nonatomic, copy) NSArray *dataArray;
@end
@implementation Services

-(instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if(self)
    {
        
        [[NSBundle mainBundle]loadNibNamed:@"Service" owner:self options:nil ];
        
        if([self.typeSeque isEqualToString:@"service"])
        { self.dataArray = @[@{@"title":@"Замена масла"},@{@"title":@"Замена тормозов"},@{@"title": @"Жидкость для сцепления"}];
        }
        else
        {
            self.dataArray = @[@{@"title":@"Ксенон"},@{@"title":@"Полировка кузова"},@{@"title": @"Тонировка"}];
        }
        self.viewPrice.layer.shadowColor = [UIColor colorWithRed:24.f/255.f green:25.f/255.f blue:27.f/255.f alpha:1.f].CGColor;
        self.viewPrice.layer.shadowOffset = CGSizeMake(0.0f,4.0f);
        self.viewPrice.layer.masksToBounds = NO;
        self.viewPrice.layer.shadowRadius = 2.5f;
        self.viewPrice.layer.shadowOpacity = 0.2;
        
        self.del_service.layer.shadowColor = [UIColor colorWithRed:24.f/255.f green:25.f/255.f blue:27.f/255.f alpha:1.f].CGColor;
        self.del_service.layer.shadowOffset = CGSizeMake(0.0f,4.0f);
        self.del_service.layer.masksToBounds = NO;
        self.del_service.layer.shadowRadius = 2.5f;
        self.del_service.layer.shadowOpacity = 0.2;
        
        self.viewType.layer.shadowColor = [UIColor colorWithRed:24.f/255.f green:25.f/255.f blue:27.f/255.f alpha:1.f].CGColor;
        self.viewType.layer.shadowOffset = CGSizeMake(0.0f,4.0f);
        self.viewType.layer.masksToBounds = NO;
        self.viewType.layer.shadowRadius = 2.5f;
        self.viewType.layer.shadowOpacity = 0.2;
        
        
        [self addSubview:self.container];
        [self initDefaultMenu];
        self.add_service.hidden = YES;
        
    }
    return self;
}
- (void)initDefaultMenu
{
    if([self.typeSeque isEqualToString:@"service"])
    {
        self.dataArray = @[@{@"title":@"Аккумулятор"},@{@"title":@"Балансировка шин"},@{@"title": @"Жидкость для сцепления"},@{@"title": @"Замена масла"},@{@"title": @"Подвеска"},@{@"title": @"Ремонт двигателя"},@{@"title": @"Замена фильтра"},@{@"title": @"Сцепление"}];
    }
    else
    {
        self.dataArray = @[@{@"title":@"Ксенон"},@{@"title":@"Полировка кузова"},@{@"title": @"Тонировка"},@{@"title": @"Покраска дисков"},@{@"title": @"Покраска кузова"},@{@"title": @"Автозвук"}];
    }
    
    NSMutableArray *itemsType = [[NSMutableArray alloc]init];
    for(int i = 0; i<self.dataArray.count;i++)
    {
        NSDictionary *dict = self.dataArray[i];
        IGLDropDownItem *item = [[IGLDropDownItem alloc] init];
        //добавить иконки
        [item setText:dict[@"title"]];
        [itemsType addObject:item];
    }
    self.menu = [[IGLDropDownMenu alloc] initWithMenuButtonCustomView:_viewType];
    if([self.typeSeque isEqualToString:@"service"])
    self.typeText.text = @"Выберите вид сервиса";
    else
        self.typeText.text = @"Выберите тип тюнинга";
    self.menu.menuIconImage = [UIImage imageNamed:@"add.png"];
    self.menu.dropDownItems = itemsType;
    self.menu.paddingLeft = 15;
    [self.menu setFrame:[self.viewType frame]];
    self.menu.delegate = self;
    self.menu.gutterY = 0;
    self.menu.type = IGLDropDownMenuTypeSlidingInBoth;
    self.menu.itemAnimationDelay = 0.1;
    self.menu.flipWhenToggleView = YES;
    
    [self.container addSubview:self.menu];
    [self.menu reloadView];
}
-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if(self)
    {
        [[NSBundle mainBundle]loadNibNamed:@"Service" owner:self options:nil ];
        self.container.frame = self.bounds;
        [self addSubview:self.container];
    }
    return self;
}
- (void)dropDownMenu:(IGLDropDownMenu *)dropDownMenu selectedItemAtIndex:(NSInteger)index
{
        IGLDropDownItem *item = self.menu.dropDownItems[index];
        self.currService = item.text;
    self.typeText.text = item.text;
    
}
- (IBAction)add:(id)sender {
}
@end
