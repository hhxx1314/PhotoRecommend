//
//  MWRecmandView.m
//  ThirdControl
//
//  Created by Wangjianlong on 16/2/22.
//  Copyright © 2016年 Autohome. All rights reserved.
//

#import "MWRecmandView.h"
#import "MWRecmandCell.h"
#import "MWGroupPhoto.h"
#import "MWPhotoBrowser.h"
#import "MWPhoto+Recommand.h"
#define IS_Above_IOS7 ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7)
#define IOS7_STATUS_BAR_HEGHT (IS_Above_IOS7 ? 20.0f : 0.0f)
static NSString  * const MWRecmandView_Identifer = @"MWRecmandView-cell";
#define Margin 10

@interface MWRecmandView ()<UICollectionViewDataSource,UICollectionViewDelegate>

/**布局对象*/
@property (nonatomic, strong) UICollectionViewFlowLayout *flowLayout;
/**视图view*/
@property (nonatomic, strong) UICollectionView *recommView;

/**行间距*/
@property (nonatomic, assign)CGFloat lineSpace;
/**列间距*/
@property (nonatomic, assign)CGFloat rowSpace;

@end

@implementation MWRecmandView

- (void)dealloc{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder{
    if (self = [super initWithCoder:aDecoder]) {
        [self initialisation];
    }
    return self;
}
- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self initialisation];
    }
    return self;
}
- (void)initialisation{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(handleMWPhotoLoadingDidEndNotification:)
                                                 name:MWPHOTO_LOADING_DID_END_NOTIFICATION
                                               object:nil];
    self.backgroundColor = [UIColor blackColor];
    self.multipleTouchEnabled = NO;
    _flowLayout = [[UICollectionViewFlowLayout alloc]init];
    _recommView = [[UICollectionView alloc]initWithFrame:self.bounds collectionViewLayout:_flowLayout];
    _recommView.directionalLockEnabled = YES;
    [self addSubview:_recommView];
    [_recommView registerClass:[MWRecmandCell class] forCellWithReuseIdentifier:MWRecmandView_Identifer];
    _recommView.backgroundColor = [UIColor clearColor];
    _recommView.dataSource = self;
    _recommView.delegate = self;
}
- (void)layoutSubviews{
    [super layoutSubviews];
    if (!CGSizeEqualToSize(self.groupPhoto.recomViewSize, CGSizeZero)) {
        
        CGFloat w = self.groupPhoto.recomViewSize.width;
        CGFloat h = self.groupPhoto.recomViewSize.height;
        if (h<360) {
            h = 360;
        }
        CGFloat y = (self.bounds.size.height - IOS7_STATUS_BAR_HEGHT -44 - h)/2;
        _recommView.frame = CGRectMake(0, IOS7_STATUS_BAR_HEGHT + 44 + y, w, h);
    }else {
        CGFloat w = self.bounds.size.width;
        CGFloat h = 360;
        CGFloat y = (self.bounds.size.height - IOS7_STATUS_BAR_HEGHT -44 - h)/2;
         _recommView.frame = CGRectMake(0, IOS7_STATUS_BAR_HEGHT + 44 + y, w, h);
    }
    
}

- (void)setGroupPhoto:(MWGroupPhoto *)groupPhoto{
    if (_groupPhoto != groupPhoto && groupPhoto != nil) {
        _groupPhoto = groupPhoto;
        
        if (UIEdgeInsetsEqualToEdgeInsets(_groupPhoto.sectionInset, UIEdgeInsetsZero)) {
            _lineSpace = Margin;
            _rowSpace = Margin;
        }else {
            
            _lineSpace = self.groupPhoto.sectionInset.top;
            _rowSpace = self.groupPhoto.sectionInset.left;
        }
        _flowLayout.minimumInteritemSpacing = 2;
        _flowLayout.minimumLineSpacing = 15;
        _flowLayout.sectionInset = UIEdgeInsetsMake(0, _rowSpace, 0, _rowSpace);
        [self.recommView reloadData];
    }
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
   
    MWGroupPhoto *model = self.groupPhoto;
    return model.photos.count;
}
- (MWRecmandCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    MWRecmandCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:MWRecmandView_Identifer forIndexPath:indexPath];
    cell.backgroundColor = [UIColor clearColor];
   
    MWGroupPhoto *model = self.groupPhoto;
    cell.photo = model.photos[indexPath.item];
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    CGFloat width = collectionView.frame.size.width;
    CGFloat space = _rowSpace *2 + 2;
    CGFloat itemW = (width - space)/2;
    CGFloat itemH = itemW * 3/4 + 10 + [UIFont systemFontOfSize:12].lineHeight;
    return CGSizeMake(itemW, itemH);
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    MWGroupPhoto *model = self.groupPhoto;
    MWPhoto *photo = model.photos[indexPath.item];
    id subModel = photo.recommendModel;
    if (photo.clickCellBlock) {
        photo.clickCellBlock(subModel);
    }
}
- (void)handleMWPhotoLoadingDidEndNotification:(NSNotification *)notification {
    id <MWPhoto> photo = [notification object];
    NSLog(@"%@",[NSThread currentThread]);
    for (MWRecmandCell *cell in [self.recommView visibleCells]) {
        if (cell.photo == photo) {
            cell.photo = photo;
            break;
        }
    }

}

@end
