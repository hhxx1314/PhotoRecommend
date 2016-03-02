//
//  MWGroupPhoto.h
//  ThirdControl
//
//  Created by Wangjianlong on 16/2/20.
//  Copyright © 2016年 Autohome. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MWPhotoProtocol.h"
#import "MWPhoto+Recommand.h"


@interface MWGroupPhoto : NSObject<MWPhoto>


/**frame*/
@property (nonatomic, assign)CGSize recomViewSize;

/**sectionInset*/
@property (nonatomic, assign)UIEdgeInsets sectionInset;

/**数据*/
@property (nonatomic, strong,readonly)NSArray<MWPhoto *> *photos;

+ (instancetype)groupModelWithPhotos:(NSArray<MWPhoto *> *)photos;

@end
