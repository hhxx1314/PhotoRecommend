//
//  MWRecmandCell.h
//  ThirdControl
//
//  Created by Wangjianlong on 16/2/22.
//  Copyright © 2016年 Autohome. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MWPhoto,MWPhotoBrowser;
@interface MWRecmandCell : UICollectionViewCell
/**数据*/
@property (nonatomic, strong)MWPhoto *photo;
/**图像*/
@property (nonatomic, weak)UIImageView *imgView;
/**背景view*/
@property (nonatomic, weak)UIView *descBackgroundView;
/**描述label*/
@property (nonatomic, weak)UILabel *descLabel;

@end