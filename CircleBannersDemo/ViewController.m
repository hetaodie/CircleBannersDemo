//
//  ViewController.m
//  CircleBannersDemo
//
//  Created by Weixu on 16/6/1.
//  Copyright © 2016年 Netease. All rights reserved.
//

#import "ViewController.h"
#import "CycleBannersView.h"

@interface ViewController () <CycleBannersViewDelegate>

@property (nonatomic, retain) UIPageControl *pageControl;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    CycleBannersView *cycleBannerView = [CycleBannersView viewFromXib];
    cycleBannerView.delegate = self;
    CGRect frame = self.view.bounds;
    frame.size.height = 200;
    [cycleBannerView setFrame:frame];
    [cycleBannerView setAutoresizingMask:UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleWidth];
    [self.view addSubview:cycleBannerView];
    
//    CGRect pageControlFrame = self.view.frame;
//    pageControlFrame.origin.y = 63;
//    pageControlFrame.size.height = 37;
//    
//    UIPageControl * pageControl = [[UIPageControl alloc] initWithFrame:pageControlFrame];
//    
//    [pageControl setAutoresizingMask:UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleWidth];
//    
//    [self.view addSubview:pageControl];
//    
//    pageControl.pageIndicatorTintColor = [UIColor whiteColor];
//    pageControl.currentPage = 0;
//    pageControl.currentPageIndicatorTintColor = [UIColor redColor];
//    pageControl.numberOfPages = 9;
//    pageControl.userInteractionEnabled = NO;
//    
//    self.pageControl = pageControl;
    
    
}

- (void)cycleBannersView:(UIScrollView *)cycleScrollView didScrollToIndex:(NSInteger)index{
    self.pageControl.currentPage = index;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
