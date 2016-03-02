//
//  MWRecmandView.h
//  ThirdControl
//
//  Created by Wangjianlong on 16/2/22.
//  Copyright © 2016年 Autohome. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MWGroupPhoto,MWPhotoBrowser;

@interface MWRecmandView : UIView

/**数据模型*/
@property (nonatomic, strong)MWGroupPhoto *groupPhoto;

/**headerView*/
@property (nonatomic, strong)UIView *headerView;

/***/
@property (nonatomic, weak)MWPhotoBrowser *photoBrowser;

@end
