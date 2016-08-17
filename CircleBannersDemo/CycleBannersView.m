//
//  CycleBannersView.m
//  CircleBannersDemo
//
//  Created by Weixu on 16/6/1.
//  Copyright © 2016年 Netease. All rights reserved.
//

#import "CycleBannersView.h"
#import "CycleBannersCollectionViewCell.h"


@interface CycleBannersView()

@property (nonatomic, retain) NSTimer *timer;
@property (nonatomic, retain) NSArray *imagePathsGroup;

@property (nonatomic, assign) NSInteger totalItemsCount;


@end
@implementation CycleBannersView


#pragma mark -
#pragma mark life cycle

- (void)dealloc
{
    [self invalidateTimer];
//    [_imagePathsGroup release];
//    [super dealloc];
}

- (void)layoutSubviews{
    _flowLayout.itemSize = self.frame.size;
}

- (void)awakeFromNib{
    [self.collectionView registerNib:[UINib nibWithNibName:@"CycleBannersCollectionViewCell" bundle:nil]  forCellWithReuseIdentifier:@"CycleBannersCollectionViewCell"];
    self.collectionView.scrollsToTop = NO;
    
    [self initialization];
    
    NSArray *array = [NSArray arrayWithObjects:@"0",@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8", nil];
    
    [self showBannersWithBannersArray:array];
}

//解决当父View释放时，当前视图因为被Timer强引用而不能释放的问题
- (void)willMoveToSuperview:(UIView *)newSuperview
{
    if (!newSuperview) {
        [self invalidateTimer];
    }
}

#pragma mark -
#pragma mark delegate

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return  _totalItemsCount;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CycleBannersCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"CycleBannersCollectionViewCell" forIndexPath:indexPath];
    int  itemIndex = indexPath.row % 9;
    UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"%d.jpg",itemIndex]];
    cell.imagView.image = image;
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (!self.imagePathsGroup.count) return; // 解决清除timer时偶尔会出现的问题
    int itemIndex = [self currentIndex];
    
    int indexOnPageControl = itemIndex % self.imagePathsGroup.count;
    self.pageControl.currentPage = indexOnPageControl;
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
        if (self.autoScroll) {
            [self invalidateTimer];
        }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
        if (self.autoScroll) {
            [self setupTimer];
        }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    [self scrollViewDidEndScrollingAnimation:self.collectionView];
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{
    NSLog(@"scrollViewDidEndScrollingAnimation");
    int itemIndex = [self currentIndex];
    int indexOnPageControl = itemIndex % 9;
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(cycleBannersView:didScrollToIndex:)]) {
        [self.delegate cycleBannersView:self.collectionView didScrollToIndex:indexOnPageControl];
    }
}

#pragma mark -
#pragma mark Notification Function

#pragma mark -
#pragma mark public Function

+ (CycleBannersView *)viewFromXib{
    NSArray *views = [[NSBundle mainBundle] loadNibNamed:@"CycleBannersView" owner:nil options:nil];
    return [views firstObject];
}


- (void)setCurrentPageDotColor:(UIColor *)currentPageDotColor
{
    self.pageControl.currentPageIndicatorTintColor = currentPageDotColor;
}


- (void)setPageDotColor:(UIColor *)pageDotColor
{
    self.pageControl.pageIndicatorTintColor = pageDotColor;
}

- (void)setInfiniteLoop:(BOOL)infiniteLoop{
    _infiniteLoop = infiniteLoop;
}

- (void)setAutoScrollTimeInterval:(CGFloat)autoScrollTimeInterval
{
    _autoScrollTimeInterval = autoScrollTimeInterval;
    
    [self setAutoScroll:self.autoScroll];
}


- (void)setAutoScroll:(BOOL)autoScroll{
    _autoScroll = autoScroll;
    
    [self invalidateTimer];
    
    if (_autoScroll) {
        [self setupTimer];
    }
}


- (void)showBannersWithBannersArray:(NSArray *)aBannersArray{
    
    if (aBannersArray.count < self.imagePathsGroup.count) {
        [self.collectionView setContentOffset:CGPointZero animated:NO];
    }
    self.imagePathsGroup = aBannersArray;
    
    _totalItemsCount = self.infiniteLoop ? self.imagePathsGroup.count * 1000 : self.imagePathsGroup.count;
    
    if (self.imagePathsGroup.count != 1) {
        self.collectionView.scrollEnabled = YES;
        [self setAutoScroll:self.autoScroll];
    } else {
        [self invalidateTimer];
        self.collectionView.scrollEnabled = NO;
    }
    
    [self.collectionView reloadData];
    
    [self setupPageControl];
}


#pragma mark -
#pragma mark btn Function

#pragma mark -
#pragma mark private Function

- (void)setupPageControl
{
    int indexOnPageControl = [self currentIndex] % self.imagePathsGroup.count;
    
    self.pageControl.numberOfPages = self.imagePathsGroup.count;
    self.pageControl.currentPage = indexOnPageControl;

}


- (void)initialization
{
    _autoScrollTimeInterval = 2.0;
    _autoScroll = YES;
    
    _infiniteLoop = YES;
    _bannerImageViewContentMode = UIViewContentModeScaleToFill;
}

- (int)currentIndex
{

    int index = 0;
    if (_flowLayout.scrollDirection == UICollectionViewScrollDirectionHorizontal) {
        index = (self.collectionView.contentOffset.x + _flowLayout.itemSize.width * 0.5) / _flowLayout.itemSize.width;
    } else {
        index = (self.collectionView.contentOffset.y + _flowLayout.itemSize.height * 0.5) / _flowLayout.itemSize.height;
    }
    return MAX(0, index);
}


- (void)setupTimer
{
    NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:self.autoScrollTimeInterval target:self selector:@selector(automaticScroll) userInfo:nil repeats:YES];
    _timer = timer;
    [[NSRunLoop mainRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
}

- (void)invalidateTimer
{
    [_timer invalidate];
    _timer = nil;
}

- (void)automaticScroll
{
    if (0 == _totalItemsCount) return;
    int currentIndex = [self currentIndex];
    int targetIndex = currentIndex + 1;
    if (targetIndex >= _totalItemsCount) {
        if (self.infiniteLoop) {
            targetIndex = _totalItemsCount * 0.5;
            [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:targetIndex inSection:0] atScrollPosition:UICollectionViewScrollPositionNone animated:NO];
        }
        return;
    }
    
    [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:targetIndex inSection:0] atScrollPosition:UICollectionViewScrollPositionNone animated:YES];
}


@end
