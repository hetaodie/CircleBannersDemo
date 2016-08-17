//
//  CycleBannersView.h
//  CircleBannersDemo
//
//  Created by Weixu on 16/6/1.
//  Copyright © 2016年 Netease. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CycleBannersViewDelegate <NSObject>

- (void)cycleBannersViewScrollOffSet:(CGFloat)scrollOffSet;

/** 图片滚动回调 */
- (void)cycleBannersView:(UIScrollView *)cycleScrollView didScrollToIndex:(NSInteger)index;

- (void)onClickItemBannersIndex:(int)aIndex;

@end

@interface CycleBannersView : UIView
@property (retain, nonatomic) IBOutlet UICollectionView *collectionView;
@property (retain, nonatomic) IBOutlet UICollectionViewFlowLayout *flowLayout;

@property (assign, nonatomic) id<CycleBannersViewDelegate>delegate;
@property (retain, nonatomic) IBOutlet UIPageControl *pageControl;

/** 是否无限循环,默认Yes */
@property (nonatomic,assign) BOOL infiniteLoop;
/** 是否自动滚动,默认Yes */
@property (nonatomic,assign) BOOL autoScroll;

/** 自动滚动间隔时间,默认2s */
@property (nonatomic, assign) CGFloat autoScrollTimeInterval;

/** 轮播图片的ContentMode，默认为 UIViewContentModeScaleToFill */
@property (nonatomic, assign) UIViewContentMode bannerImageViewContentMode;

/** 占位图，用于网络未加载到图片时 */
@property (nonatomic, strong) UIImage *placeholderImage;

+ (CycleBannersView *)viewFromXib;

-(void)setCurrentPageDotColor:(UIColor *)currentPageDotColor;

- (void)setPageDotColor:(UIColor *)pageDotColor;

- (void)showBannersWithBannersArray:(NSArray *)aBannersArray;
@end
