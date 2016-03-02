//
//  MWPhoto+Recommand.h
//  ThirdControl
//
//  Created by Wangjianlong on 16/2/22.
//  Copyright © 2016年 Autohome. All rights reserved.
//

#import "MWPhoto.h"
//NSIndexPath *path,NSURL *photoURL
typedef void(^MWClickCellBlock)(id);

@interface MWPhoto (Recommand)

/*!
@property
@abstract 定义block,封装点击cell触发的事件
*/

@property (nonatomic, copy)MWClickCellBlock clickCellBlock;
/*!
 @property
 @abstract 点击图集后传到业务层的数据载体
 */
@property (nonatomic, strong)id recommendModel;


@end
