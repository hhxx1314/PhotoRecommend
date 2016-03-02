//
//  MWRecmandCell.m
//  ThirdControl
//
//  Created by Wangjianlong on 16/2/22.
//  Copyright © 2016年 Autohome. All rights reserved.
//

#import "MWRecmandCell.h"
#import "MWPhoto.h"
#import "UIImageView+WebCache.h"

@implementation MWRecmandCell
- (instancetype)initWithCoder:(NSCoder *)aDecoder{
    if (self = [super initWithCoder:aDecoder]) {
        [self setup];
    }
    return self;
}
- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self setup];
    }
    return self;
}
- (void)setup
{
    UIImageView *imgView = [[UIImageView alloc]initWithFrame:self.bounds];
    [self.contentView addSubview:imgView];
    self.imgView = imgView;
    
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectZero];
    label.backgroundColor = [UIColor clearColor];
    label.textAlignment = NSTextAlignmentLeft;
    [self.contentView addSubview:label];
    self.descLabel = label;
}
- (void)layoutSubviews{
    [super layoutSubviews];
    CGFloat viewW = self.bounds.size.width;
    CGFloat viewH = self.bounds.size.height;
    CGFloat scale = [UIScreen mainScreen].bounds.size.width /320;
    CGFloat margin = 6 * scale;
    CGFloat imgh = viewW *3 /4;
    self.imgView.frame = CGRectMake(0, 0, viewW, imgh);
   
    self.descLabel.frame = CGRectMake(0, imgh + margin, viewW, viewH - imgh -margin);
}
- (void)setPhoto:(MWPhoto *)photo{
    _photo = photo;
    
    if (![_photo underlyingImage]) {
        [_photo loadUnderlyingImageAndNotify];
    }
    
    if (_photo.underlyingImage) {
        [self.imgView setImage:_photo.underlyingImage];
    }else {
//        [self.imgView sd_setImageWithURL:[_photo photoURL] placeholderImage:[[AHSkinManager sharedManager] imageWithImageKey:default_180_136]];
    }
    
    self.descLabel.text = _photo.caption ? _photo.caption : @"汽车之家,感谢您的支持!";
}
@end