//
//  MWGroupPhoto.m
//  ThirdControl
//
//  Created by Wangjianlong on 16/2/20.
//  Copyright © 2016年 Autohome. All rights reserved.
//

#import "MWGroupPhoto.h"
@interface MWGroupPhoto()
/**数据源*/
@property (nonatomic, strong)NSArray *pri_dataSource;
@end



@implementation MWGroupPhoto

@synthesize underlyingImage = _underlyingImage; // synth property from protocol

+ (instancetype)groupModelWithPhotos:(NSArray *)photos{
    
    MWGroupPhoto *model = [[self alloc]init];
    if (photos == nil || photos.count==0) {
        model.pri_dataSource = [[NSArray alloc]init];
    }else {
        model.pri_dataSource = [NSArray arrayWithArray:photos];
    }
    
    return model;
}
- (NSArray *)photos{
    return _pri_dataSource.copy;
}

- (void)loadAllImageWithPhotos{
    [self.pri_dataSource enumerateObjectsUsingBlock:^(MWPhoto * obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (!obj.underlyingImage) {
            [obj loadUnderlyingImageAndNotify];
        }
    }];
}
- (UIImage *)underlyingImage {
    return nil;
}

- (void)loadUnderlyingImageAndNotify {
    
}

// Set the underlyingImage and call decompressImageAndFinishLoading on the main thread when complete.
// On error, set underlyingImage to nil and then call decompressImageAndFinishLoading on the main thread.
- (void)performLoadUnderlyingImageAndNotify {
    
    
}

// Release if we can get it again from path or url
- (void)unloadUnderlyingImage {
    
}

- (void)decompressImageAndFinishLoading {
    
}

- (void)imageLoadingComplete {
}

- (void)postCompleteNotification {
}

- (void)cancelAnyLoading {
}

@end
