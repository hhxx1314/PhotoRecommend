//
//  JLPhotoReader.h
//  MW-Recommand
//
//  Created by Wangjianlong on 16/3/5.
//  Copyright © 2016年 JL. All rights reserved.
//


#import <UIKit/UIKit.h>
#import "MWPhotoBrowser.h"

/*!
 *  分享按钮标识
 */
extern NSString *const JLPhotoReaderShareButton;
/*!
 *  下载按钮标识
 */
extern NSString *const JLPhotoReaderDownloadButton;
/*!
 *  收藏按钮标识
 */
extern NSString *const JLPhotoReaderCollectionButton;

/**内容样式*/
typedef NS_ENUM(NSUInteger, JLPhotoReaderContentStyle) {
    /**只包含图片*/
    JLPhotoReaderContentOnlyImage,
    /**包含推荐图集*/
    JLPhotoReaderContentContainRecommend,
    /**预留样式*/
    JLPhotoReaderContentOther
};

/**内容样式*/
typedef NS_ENUM(NSUInteger,  JLPhotoReaderPopStyle) {
    /**由上到下*/
    JLPhotoReaderPopStylePresent,
    /**由左到右*/
    JLPhotoReaderPopStylePush
    
};


@protocol JLPhotoReaderDataSource;
@protocol JLPhotoReaderDelegate;

/*!
 *  基本读图控件
 */
@interface JLPhotoReader : MWPhotoBrowser

@property (nonatomic, weak) id<JLPhotoReaderDataSource> dataSource;
@property (nonatomic, weak) id<JLPhotoReaderDelegate  > delegateReader;


/*!
 *  标识导航右侧显示的按钮，传（JLPhotoReaderShareButton、JLPhotoReaderDownloadButton,JLPhotoReaderCollectionButton）
 */
@property (nonatomic, strong) NSArray *navigationRightViews;

/*!
 *  内容样式
 */
@property (nonatomic, assign)JLPhotoReaderContentStyle contentStyle;
/*!
 *  文章是否收藏过(适用于整个文章)
 */
@property (nonatomic, assign,getter=isContentCollect)BOOL contentCollect;

/**弹出样式*/
@property (nonatomic, assign)JLPhotoReaderPopStyle popStyle;
//wjl  增加 2016-2-25

/*!
 @property
 @abstract 分享内容
 */
@property (nonatomic, strong) NSString *pictureShareContent;
/*!
 @property
 @abstract 分享地址
 */
@property (nonatomic, strong) NSString *shareContentUrl;

@property (nonatomic, strong) NSMutableArray                *descriptionArray;


@end

/*!
 *  依赖的数据源
 */
@protocol JLPhotoReaderDataSource <NSObject>

@optional
/*!
 *  如果需要定制底部视图时实现
 *
 *  @param reader 读图控件
 *
 *  @return 底部视图
 */
- (UIView *)headerViewForPhotoReader:(JLPhotoReader *)reader;
/*!
 *  如果需要定制底部视图时实现
 *
 *  @param reader 读图控件
 *
 *  @return 底部视图
 */
- (UIView *)footerViewForPhotoReader:(JLPhotoReader *)reader;

/*!
 *  如果需要定制headerView中间视图的实现
 *
 *  @param reader 读图控件
 *
 *  @return centerView
 */
- (UIView *)centerViewInHeaderViewForPhotoReader:(JLPhotoReader *)reader;

@end

/*!
 *  读图不同时机触发的代理
 */
@protocol JLPhotoReaderDelegate <NSObject>

@optional
/*!
 *  读图控件将要显示时回调
 */
- (void)readerViewWillAppear;
/*!
 *  读图控件将要消失时回调
 */
- (void)readerViewWillDisappear;

//2015-10-16 吴立汉 读图控件将要转屏
- (void)readerViewWillRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration;
//2015-10-16 吴立汉 读图控件将要转屏

/*!
 *  点击分享按钮时回调
 *
 *  @param sender 分享按钮
 */
- (void)didSelectedShareButton:(UIButton *)sender;
/*!
 *  点击下载按钮时回调
 *
 *  @param sender 下载按钮
 */
- (void)didSelectedDownloadButton:(UIButton *)sender;

/*!
 *  分享成功回调
 *
 *  @param platform 分享平台
 */
- (void)didReceiveShareSuccess:(NSString *)platform;
/*!
 *  分享失败回调
 *
 *  @param platform 分享平台
 */
- (void)didReceiveShareFailed:(NSString *)platform;

/*!
 *  点击收藏按钮
 */
- (void)didselectCollectionButton:(UIButton *)sender;
/*!
 *  取消收藏
 */
- (void)didDeSelectCollectionButton:(UIButton *)sender;
@end
