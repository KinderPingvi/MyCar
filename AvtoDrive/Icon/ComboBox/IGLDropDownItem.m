//
//  IGLDropDownItem.m
//  IGLDropDownMenuDemo
//
//  Created by Galvin Li on 8/30/14.
//  Copyright (c) 2014 Galvin Li. All rights reserved.
//

#import "IGLDropDownItem.h"

@interface IGLDropDownItem ()

@property (nonatomic, strong) UIView *customView;

@property (nonatomic, strong) UIImageView *iconImageView;
@property (nonatomic, strong) UIView *bgView;
@property (nonatomic, strong) UILabel *textLabel;

@end

@implementation IGLDropDownItem

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self commonInit];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self commonInit];
    }
    return self;
}

- (instancetype)initWithCustomView:(UIView *)customView
{
    self = [super initWithFrame:CGRectZero];
    if (self) {
        [self addSubview:customView];
        customView.userInteractionEnabled = NO;
        self.customView = customView;
    }
    return self;
}

- (void)commonInit
{
    _paddingLeft = 5;
    _showBackgroundShadow = YES;
    _backgroundColor = [UIColor colorWithRed:50.0f/255.0f green:55.0f/255.0f blue:60.0f/255.0f alpha:1.0f];
   // [_textLabel setTextColor:[UIColor whiteColor]];
    [self initView];
}

- (void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    
    if (self.customView) {
        [self.customView setFrame:self.bounds];
    } else {
        [self.bgView setFrame:self.bounds];
        [self updateLayout];
    }
    
}

- (void)initView
{
    self.bgView = [[UIView alloc] init];
    self.bgView.userInteractionEnabled = NO;
    self.bgView.layer.shouldRasterize = YES;
    [self.bgView setFrame:self.bounds];
    [self addSubview:self.bgView];
    self.bgView.backgroundColor = self.backgroundColor;
    self.showBackgroundShadow = _showBackgroundShadow;

    self.iconImageView = [[UIImageView alloc] init];
    self.iconImageView.contentMode = UIViewContentModeCenter;
    [self addSubview:self.iconImageView];
    
    self.textLabel = [[UILabel alloc] init];
    self.textLabel.numberOfLines = 1;
    self.textLabel.textColor = [UIColor whiteColor];
    [self addSubview:self.textLabel];
    
    [self updateLayout];
    
}

- (void)setIconImage:(UIImage *)iconImage
{
    float actualHeight = iconImage.size.height;
    float actualWidth = iconImage.size.width;
    float maxHeight = 30.0;
    float maxWidth = 30.0;
    float imgRatio = actualWidth/actualHeight;
    float maxRatio = maxWidth/maxHeight;
    float compressionQuality = 0.5;//50 percent compression
    
    if (actualHeight > maxHeight || actualWidth > maxWidth)
    {
        if(imgRatio < maxRatio)
        {
            //adjust width according to maxHeight
            imgRatio = maxHeight / actualHeight;
            actualWidth = imgRatio * actualWidth;
            actualHeight = maxHeight;
        }
        else if(imgRatio > maxRatio)
        {
            //adjust height according to maxWidth
            imgRatio = maxWidth / actualWidth;
            actualHeight = imgRatio * actualHeight;
            actualWidth = maxWidth;
        }
        else
        {
            actualHeight = maxHeight;
            actualWidth = maxWidth;
        }
    }
    
    CGRect rect = CGRectMake(0.0, 0.0, actualWidth, actualHeight);
    UIGraphicsBeginImageContext(rect.size);
    [iconImage drawInRect:rect];
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();

    _iconImage = img;
    [self.iconImageView setImage:self.iconImage];
    
    [self updateLayout];
}

- (void)setShowBackgroundShadow:(BOOL)showBackgroundShadow
{
    _showBackgroundShadow = showBackgroundShadow;
    if (self.showBackgroundShadow) {
        self.bgView.layer.shadowColor = [UIColor grayColor].CGColor;
        self.bgView.layer.shadowOffset = CGSizeMake(0, 0);
        self.bgView.layer.shadowOpacity = 0.2;
    } else {
        self.bgView.layer.shadowOpacity = 0.0;
    }
}

- (void)setBackgroundColor:(UIColor *)backgroundColor
{
    _backgroundColor = backgroundColor;
    self.bgView.backgroundColor = self.backgroundColor;
}

- (void)updateLayout
{
    
    CGFloat selfWidth = CGRectGetWidth(self.bounds);
    CGFloat selfHeight = CGRectGetHeight(self.bounds);
    
    [self.iconImageView setFrame:CGRectMake(self.paddingLeft, 0, selfHeight, selfHeight)];
    if (self.iconImage) {
        [self.textLabel setFrame:CGRectMake(CGRectGetMaxX(self.iconImageView.frame), 0, selfWidth - CGRectGetMaxX(self.iconImageView.frame), selfHeight)];
    } else {
        [self.textLabel setFrame:CGRectMake(self.paddingLeft, 0, selfWidth, selfHeight)];
    }
}

- (void)setPaddingLeft:(CGFloat)paddingLeft
{
    _paddingLeft = paddingLeft;
    
    [self updateLayout];
}

- (void)setObject:(id)object
{
    _object = object;
}

- (void)setText:(NSString *)text
{
    _text = text;
    self.textLabel.text = self.text;
}

@end
