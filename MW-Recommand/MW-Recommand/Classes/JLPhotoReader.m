//
//  JLPhotoReader.m
//  MW-Recommand
//
//  Created by Wangjianlong on 16/3/5.
//  Copyright © 2016年 JL. All rights reserved.
//

#import "JLPhotoReader.h"
#import "MWGroupPhoto.h"

#define IS_Above_IOS7 ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7)
#define IOS7_STATUS_BAR_HEGHT (IS_Above_IOS7 ? 20.0f : 0.0f)

#define rightbMargin 5
#define rightbBtnMargin 10
#define rightBtnWidth 30



NSString *const JLPhotoReaderShareButton = @"JLPhotoReaderShareButton";
NSString *const JLPhotoReaderDownloadButton = @"JLPhotoReaderDownloadButton";
NSString *const JLPhotoReaderCollectionButton = @"JLPhotoReaderCollectionButton";

@interface JLPhotoReader ()
/**导航条*/
@property (nonatomic, strong)UIView *headerView;
/**底部条*/
@property (nonatomic, strong)UIView *footerView;

@property (nonatomic, strong) UIImageView         *footImageView;

/**右侧视图容器*/
@property (nonatomic, strong)UIView               *rightViewContainer;
/**页码label*/
@property (nonatomic, strong) UILabel             *pageLabel;
/**图集label*/
@property (nonatomic, strong) UILabel             *recommendLabel;

/**数据源提供的centerView*/
@property (nonatomic, strong)UIView *dataSource_CenterView;

/**进入推荐图集前的,header和footer的显示状态*/
@property (nonatomic, assign)BOOL pre_Hidden;

/**是否包含推荐图集*/
@property (nonatomic, assign)BOOL containerPhotos;

/**收藏按钮*/
@property (nonatomic, strong) UIButton *collectionBtn;

/**footerView的透明度*/
@property (nonatomic, assign)CGFloat footerAlpha;


@end

@implementation JLPhotoReader

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    //    [footerTextView removeObserver:self forKeyPath:@"contentSize"];
}



- (UILabel *)recommendLabel{
    if (_recommendLabel == nil) {
        CGRect tempFrame = CGRectMake(0, IOS7_STATUS_BAR_HEGHT, self.headerView.bounds.size.width, 44);
        _recommendLabel = [[UILabel alloc] initWithFrame:tempFrame];
        [_recommendLabel setBackgroundColor:[UIColor clearColor]];
        [_recommendLabel setFont:[UIFont systemFontOfSize:17]];
        
        [_recommendLabel setTextColor:[UIColor orangeColor]];
        [_recommendLabel setTextAlignment:NSTextAlignmentCenter];
        [_recommendLabel setText:@"更多阅读"];
        _recommendLabel.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleWidth;
    }
    return _recommendLabel;
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.collectionBtn.selected = self.isContentCollect;
    if (self.delegateReader && [self.delegateReader respondsToSelector:@selector(readerViewWillAppear)]) {
        [self.delegateReader readerViewWillAppear];
    }
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    if (self.delegateReader && [self.delegateReader respondsToSelector:@selector(readerViewWillDisappear)]) {
        [self.delegateReader readerViewWillDisappear];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //初始化footeView的透明度
    self.footerAlpha = 1.0f;
    
    
    
    [self addHeaderView];
    if (!self.footerView) {
        [self addFooterView];
    }
}

- (void)addHeaderView
{
    // 如果实现 footer view 回调时，使用传入的视图
    if (self.dataSource && [self.dataSource respondsToSelector:@selector(headerViewForPhotoReader:)]) {
        self.headerView = [self.dataSource headerViewForPhotoReader:self];
    }
    [self.view addSubview:self.headerView];
}

- (void)addFooterView
{
    // 如果实现 footer view 回调时，使用传入的视图
    if (self.dataSource && [self.dataSource respondsToSelector:@selector(footerViewForPhotoReader:)]) {
        self.footerView = [self.dataSource footerViewForPhotoReader:self];
        self.footerAlpha = self.footerView.alpha;
    }
    [self.view addSubview:self.footerView];
}
- (void)updateNavigation{
    [super updateNavigation];
    NSUInteger numberOfPhotos = [self.delegate numberOfPhotosInPhotoBrowser:self];
    if (self.contentStyle == JLPhotoReaderContentContainRecommend) {
        numberOfPhotos -= 1;
    }
    if (numberOfPhotos > 1) {
        if ([self.delegate respondsToSelector:@selector(photoBrowser:titleForPhotoAtIndex:)]) {
            
            [_pageLabel setText:[self.delegate photoBrowser:self titleForPhotoAtIndex:self.currentIndex]];
            
        } else {
            [_pageLabel setText:[NSString stringWithFormat:@"%lu / %lu", (unsigned long)(self.currentIndex+1), (unsigned long)numberOfPhotos]];
        }
    } else {
        [_pageLabel setText:@""];
    }
}

- (void)setControlsHidden:(BOOL)hidden animated:(BOOL)animated permanent:(BOOL)permanent{
    [super setControlsHidden:hidden animated:animated permanent:permanent];
    if (animated) {
        
        [UIView animateWithDuration:0.3
                         animations:^
         {
             if (hidden) {
                 [self.headerView setAlpha:0];
                 [self.footerView setAlpha:0];
             }else{
                 self.pre_Hidden = NO;
                 [self.headerView setAlpha:1];
                 [self.footerView setAlpha:self.footerAlpha];
             }
         }
                         completion:^(BOOL finished)
         {
             
         }
         ];
    }else {
        if (hidden) {
            [self.headerView setAlpha:0];
            [self.footerView setAlpha:0];
        }else{
            [self.headerView setAlpha:1];
            [self.footerView setAlpha:self.footerAlpha];
        }
    }
}

- (void)layoutVisiblePages{
    
    [super layoutVisiblePages];
    if (![self.delegateReader respondsToSelector:@selector(footerViewForPhotoReader:)]) {
        float height = self.footerView.bounds.size.height;
        self.footerView.frame = [self frameForToolbarAtOrientation:self.interfaceOrientation];
        
    }
}

- (void)backToRoot:(UIButton *)sender{
    
    
    
    [UIApplication sharedApplication].statusBarHidden=NO;
    
    CATransition * transition=[CATransition animation];
    transition.duration=0.3f;
    transition.timingFunction=[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
    transition.type=kCATransitionReveal;
    if (self.popStyle == JLPhotoReaderPopStylePush) {
        transition.subtype=kCATransitionFromLeft;
    }else {
        transition.subtype = kCATransitionFromBottom;
    }
    
    transition.delegate=self;
    [self.navigationController.view.layer addAnimation:transition forKey:nil];
    
    [self.navigationController popViewControllerAnimated:NO];
    
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    [super scrollViewDidScroll:scrollView];
    id<MWPhoto> photo = [self photoAtIndex:self.currentIndex];
    if ([photo isKindOfClass:[MWGroupPhoto class]]) {
        self.containerPhotos = YES;
        [self controlHeaderControlsHidden:NO];
    } else if ([photo isKindOfClass:[MWPhoto class]] && self.containerPhotos){
        
        [self controlHeaderControlsHidden:YES];
    }
}

- (void)controlHeaderControlsHidden:(BOOL)hidden{
    if (!hidden) {
        if (self.headerView.alpha == 0.0f) {
            self.pre_Hidden = YES;
        }
        if (!self.recommendLabel.superview) {
            [self.headerView addSubview:self.recommendLabel];
        }
        if (self.headerView.alpha == 0.0f) {
            self.headerView.alpha = 1.0f;
        }
        BOOL statusBarHidden = [UIApplication sharedApplication].statusBarHidden;
        if (statusBarHidden) {
            [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationFade];
        }
        
        
        _recommendLabel.hidden = NO;
        self.pageLabel.hidden = YES;
        self.rightViewContainer.hidden = YES;
        self.footerView.hidden = YES;
        
    } else {
        if (self.containerPhotos) {
            
            if (self.pre_Hidden) {
                [self setControlsHidden:YES animated:NO permanent:NO];
            }
            _recommendLabel.hidden = YES;
            self.pageLabel.hidden = NO;
            self.rightViewContainer.hidden = NO;
            self.footerView.hidden = NO;
            
        }
        self.containerPhotos = NO;
    }
}

@end
