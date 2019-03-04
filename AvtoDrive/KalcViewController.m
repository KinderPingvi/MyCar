//
//  KalcViewController.m
//  AvtoDrive
//
//  Created by Admin on 12.10.18.
//  Copyright © 2018 Admin. All rights reserved.
//

#import "KalcViewController.h"
#import "Bar.h"
#import "SWRevealViewController.h"


@interface KalcViewController ()<CAAnimationDelegate>

@end

@implementation KalcViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    Bar *navBar = [[Bar alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 80)];
    navBar.text.text = @"Калькулятор";
    [navBar.backButton setImage:[UIImage imageNamed:@"menu2.png"] forState:UIControlStateNormal];
    SWRevealViewController *revealViewController = self.revealViewController;
    if ( revealViewController )
    {
        [navBar.backButton addTarget:self.revealViewController action:@selector(revealToggle:)
                    forControlEvents:UIControlEventTouchUpInside];
        [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
    }
    [navBar.buttonOk addTarget:self action:@selector(calc:)
                forControlEvents:UIControlEventTouchUpInside];
    UIColor *cl = [[UIColor alloc]initWithRed:5.0/255.0 green:8.0/255.0 blue:18.0/255.0 alpha:1.0];
    [navBar.container setBackgroundColor:cl];
    [navBar.image setImage:[UIImage imageNamed:@"calck2.png"]];
    [self.view addSubview:navBar];
    [self initShadow];
}
-(void)initShadow
{
    self.viewPrice.layer.shadowColor = [UIColor colorWithRed:24.f/255.f green:25.f/255.f blue:27.f/255.f alpha:1.f].CGColor;
    self.viewPrice.layer.shadowOffset = CGSizeMake(0.0f,4.0f);
    self.viewPrice.layer.masksToBounds = NO;
    self.viewPrice.layer.shadowRadius = 2.5f;
    self.viewPrice.layer.shadowOpacity = 0.2;
    
    self.viewPetrol.layer.shadowColor = [UIColor colorWithRed:24.f/255.f green:25.f/255.f blue:27.f/255.f alpha:1.f].CGColor;
    self.viewPetrol.layer.shadowOffset = CGSizeMake(0.0f,4.0f);
    self.viewPetrol.layer.masksToBounds = NO;
    self.viewPetrol.layer.shadowRadius = 2.5f;
    self.viewPetrol.layer.shadowOpacity = 0.2;
    
    self.viewMileage.layer.shadowColor = [UIColor colorWithRed:24.f/255.f green:25.f/255.f blue:27.f/255.f alpha:1.f].CGColor;
    self.viewMileage.layer.shadowOffset = CGSizeMake(0.0f,4.0f);
    self.viewMileage.layer.masksToBounds = NO;
    self.viewMileage.layer.shadowRadius = 2.5f;
    self.viewMileage.layer.shadowOpacity = 0.2;
    
    self.viewResPetrol.layer.shadowColor = [UIColor colorWithRed:24.f/255.f green:25.f/255.f blue:27.f/255.f alpha:1.f].CGColor;
    self.viewResPetrol.layer.shadowOffset = CGSizeMake(0.0f,4.0f);
    self.viewResPetrol.layer.masksToBounds = NO;
    self.viewResPetrol.layer.shadowRadius = 2.5f;
    self.viewResPetrol.layer.shadowOpacity = 0.2;
    
    self.viewResPrice.layer.shadowColor = [UIColor colorWithRed:24.f/255.f green:25.f/255.f blue:27.f/255.f alpha:1.f].CGColor;
    self.viewResPrice.layer.shadowOffset = CGSizeMake(0.0f,4.0f);
    self.viewResPrice.layer.masksToBounds = NO;
    self.viewResPrice.layer.shadowRadius = 2.5f;
    self.viewResPrice.layer.shadowOpacity = 0.2;
    
    self.line.layer.shadowColor = [UIColor colorWithRed:24.f/255.f green:25.f/255.f blue:27.f/255.f alpha:1.f].CGColor;
    self.line.layer.shadowOffset = CGSizeMake(0.0f,4.0f);
    self.line.layer.masksToBounds = NO;
    self.line.layer.shadowRadius = 2.5f;
    self.line.layer.shadowOpacity = 0.2;
}
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
    // self.mileage.text = [NSString stringWithFormat:@"%@ км",self.mileage.text];
}
- (IBAction)calc:(UIButton *)sender {
    NSMutableArray * errors = [NSMutableArray array];
    if([self.priceText.text isEqualToString:@""])
        [errors addObject:@"price"];
    if([self.petrolText.text isEqualToString:@""])
        [errors addObject:@"petrol"];
    if([self.mileageText.text isEqualToString:@""])
        [errors addObject:@"mileage"];
    if(errors.count<=0)
    {
    self.viewResPrice.hidden = NO;
    self.viewResPetrol.hidden = NO;
    
    CGPoint point = CGPointMake(self.viewResPetrol.frame.origin.x+self.viewResPetrol.frame.size.width/2,self.viewResPetrol.frame.origin.y + self.viewResPetrol.frame.size.height/2 - 35);
    CGPoint pointTo = CGPointMake(self.viewResPetrol.frame.origin.x+self.viewResPetrol.frame.size.width/2,self.viewResPetrol.frame.origin.y + self.viewResPetrol.frame.size.height/2+15);
    CABasicAnimation *theAnimation;
    
    theAnimation=[CABasicAnimation animationWithKeyPath:@"position"];
    theAnimation.duration = 0.07;
    theAnimation.repeatCount = 2;
    theAnimation.autoreverses = YES;
    theAnimation.fromValue= [NSValue valueWithCGPoint:point];
    theAnimation.toValue= [NSValue valueWithCGPoint:pointTo];
    [self.viewResPetrol.layer addAnimation:theAnimation forKey:@"animatePosition"];
    
    point = CGPointMake(self.viewResPetrol.frame.origin.x+self.viewResPetrol.frame.size.width/2,self.viewResPetrol.frame.origin.y + self.viewResPetrol.frame.size.height/2-35);
    pointTo = CGPointMake(self.viewResPetrol.frame.origin.x+self.viewResPetrol.frame.size.width/2,self.viewResPetrol.frame.origin.y + self.viewResPetrol.frame.size.height/2+15);
    
    theAnimation=[CABasicAnimation animationWithKeyPath:@"position"];
    theAnimation.duration = 0.07;
    theAnimation.repeatCount = 2;
    theAnimation.autoreverses = YES;
    theAnimation.fromValue= [NSValue valueWithCGPoint:point];
    theAnimation.toValue= [NSValue valueWithCGPoint:pointTo];
    [self.viewResPrice.layer addAnimation:theAnimation forKey:@"animatePosition"];
    
    
    
    double litres = [self.petrolText.text doubleValue];
    double mileage = [self.mileageText.text doubleValue];
    
    double result = litres/mileage*100;
    self.R_petrolText.text = [NSString stringWithFormat:@"%.2f",result];
    double price = [self.priceText.text doubleValue];
    double priceRes = result * price;
    
    self.R_priceText.text = [NSString stringWithFormat:@"%.2f",priceRes];
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
            else if([[errors objectAtIndex:i] isEqualToString:@"petrol"])
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
