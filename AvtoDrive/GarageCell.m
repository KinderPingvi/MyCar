//
//  GarageCell.m
//  AvtoDrive
//
//  Created by Admin on 11.10.18.
//  Copyright © 2018 Admin. All rights reserved.
//

#import "GarageCell.h"

@implementation GarageCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.backImage.layer.shadowColor = [UIColor colorWithRed:24.f/255.f green:25.f/255.f blue:27.f/255.f alpha:1.f].CGColor;
    self.backImage.layer.shadowOffset = CGSizeMake(0.0f,4.0f);
    self.backImage.layer.masksToBounds = NO;
    self.backImage.layer.shadowRadius = 2.5f;
    self.backImage.layer.shadowOpacity = 0.2;
    
}
- (IBAction)clickBt:(id)sender {
    
    CABasicAnimation *theAnimation;
    theAnimation=[CABasicAnimation animationWithKeyPath:@"frame.size"];
    theAnimation.duration = 2;
    theAnimation.repeatCount = 1;
    theAnimation.autoreverses = NO;
    theAnimation.fromValue= [NSValue valueWithCGSize:CGSizeMake(self.imageView.frame.size.width, self.imageView.frame.size.height)];
    theAnimation.toValue= [NSValue valueWithCGSize:CGSizeMake(self.imageView.frame.size.width - self.viewBt.frame.size.width, self.imageView.frame.size.height)];
    [self.imageView.layer addAnimation:theAnimation forKey:@"animatePosition"];
    self.imageView.frame  = CGRectMake(self.imageView.frame.origin.x, self.imageView.frame.origin.y, self.imageView.frame.size.width - self.viewBt.frame.size.width, self.imageView.frame.size.height);
}

- (void)willTransitionToState:(UITableViewCellStateMask)state{
    [super willTransitionToState:state];
    if ((state & UITableViewCellStateShowingDeleteConfirmationMask) == UITableViewCellStateShowingDeleteConfirmationMask) {
        for (UIView *subview in self.subviews) {
            if ([NSStringFromClass([subview class]) isEqualToString:@"UITableViewCellDeleteConfirmationControl"]) {
                UIImageView *deleteBtn = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 64, 33)];
                [deleteBtn setImage:[UIImage imageNamed:@"add.png"]];
                [[subview.subviews objectAtIndex:0] addSubview:deleteBtn];
            }
        }
    }
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    self.backImage.layer.shadowColor = [UIColor colorWithRed:24.f/255.f green:25.f/255.f blue:27.f/255.f alpha:1.f].CGColor;
    self.backImage.layer.shadowOffset = CGSizeMake(0.0f,4.0f);
    self.backImage.layer.masksToBounds = NO;
    self.backImage.layer.shadowRadius = 2.5f;
    self.backImage.layer.shadowOpacity = 0.2;
}

@end
