//
//  MWPhoto+Recommand.m
//  ThirdControl
//
//  Created by Wangjianlong on 16/2/22.
//  Copyright © 2016年 Autohome. All rights reserved.
//

#import "MWPhoto+Recommand.h"
#import <objc/runtime.h>

static void *strKey = &strKey;
static void *modelKey = &modelKey;

@implementation MWPhoto (Recommand)

- (void)setClickCellBlock:(MWClickCellBlock)clickCellBlock{
    objc_setAssociatedObject(self, & strKey, clickCellBlock, OBJC_ASSOCIATION_COPY);
}
- (MWClickCellBlock)clickCellBlock{
    return objc_getAssociatedObject(self, &strKey);
}
- (void)setRecommendModel:(id)recommendModel{
    objc_setAssociatedObject(self, & modelKey, recommendModel, OBJC_ASSOCIATION_RETAIN);
}
- (id)recommendModel{
    return objc_getAssociatedObject(self, &modelKey);
}
@end
