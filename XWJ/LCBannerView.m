//
//  LCBannerView.m
//  LCBannerViewDemo
//
//  Created by Leo on 15/11/30.
//  Copyright © 2015年 Leo. All rights reserved.
//
//  V 1.0.0

#import "LCBannerView.h"
#import "UIImageView+WebCache.h"

static CGFloat LCPageDistance = 10.0f;      // pageControl 到底部的距离

@interface LCBannerView () <UIScrollViewDelegate>

@property (nonatomic, weak) id<LCBannerViewDelegate> delegate;

@property (nonatomic, copy) NSString *imageName;
@property (nonatomic, strong) NSArray *imageURLs;
@property (nonatomic, assign) NSInteger count;
@property (nonatomic, assign) CGFloat timerInterval;
@property (nonatomic, strong) UIColor *currentPageIndicatorTintColor;
@property (nonatomic, strong) UIColor *pageIndicatorTintColor;
@property (nonatomic, copy) NSString *placeholderImage;

@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, weak) UIScrollView *scrollView;
@property (nonatomic, weak) UIPageControl *pageControl;
@property NSInteger mode ;


@end

@implementation LCBannerView

+ (instancetype)bannerViewWithFrame:(CGRect)frame delegate:(id<LCBannerViewDelegate>)delegate imageName:(NSString *)imageName count:(NSInteger)count timerInterval:(NSInteger)timeInterval currentPageIndicatorTintColor:(UIColor *)currentPageIndicatorTintColor pageIndicatorTintColor:(UIColor *)pageIndicatorTintColor {
    
    return [[self alloc] initWithFrame:frame
                              delegate:delegate
                             imageName:imageName
                                 count:count
                         timerInterval:timeInterval
         currentPageIndicatorTintColor:currentPageIndicatorTintColor
                pageIndicatorTintColor:pageIndicatorTintColor];
}

+ (instancetype)bannerViewWithFrame:(CGRect)frame delegate:(id<LCBannerViewDelegate>)delegate titles:(NSArray *)titles timerInterval:(NSInteger)timeInterval currentPageIndicatorTintColor:(UIColor *)currentPageIndicatorTintColor pageIndicatorTintColor:(UIColor *)pageIndicatorTintColor{
    return [[self alloc] initWithFrame:frame
                              delegate:delegate
                             titles:titles
                      timerInterval:timeInterval
         currentPageIndicatorTintColor:currentPageIndicatorTintColor
                pageIndicatorTintColor:pageIndicatorTintColor];
}

+ (instancetype)bannerViewWithFrame:(CGRect)frame delegate:(id<LCBannerViewDelegate>)delegate imageURLs:(NSArray *)imageURLs placeholderImage:(NSString *)placeholderImage timerInterval:(NSInteger)timeInterval currentPageIndicatorTintColor:(UIColor *)currentPageIndicatorTintColor pageIndicatorTintColor:(UIColor *)pageIndicatorTintColor {
    
    return [[self alloc] initWithFrame:frame
                              delegate:delegate
                             imageURLs:imageURLs
                      placeholderImage:placeholderImage
                         timerInterval:timeInterval
         currentPageIndicatorTintColor:currentPageIndicatorTintColor
                pageIndicatorTintColor:pageIndicatorTintColor];
}


- (instancetype)initWithFrame:(CGRect)frame delegate:(id<LCBannerViewDelegate>)delegate imageName:(NSString *)imageName count:(NSInteger)count timerInterval:(NSInteger)timeInterval currentPageIndicatorTintColor:(UIColor *)currentPageIndicatorTintColor pageIndicatorTintColor:(UIColor *)pageIndicatorTintColor {
    
    if (self = [super initWithFrame:frame]) {
        
        self.delegate = delegate;
        self.imageName = imageName;
        self.count = count;
        self.timerInterval = timeInterval;
        self.currentPageIndicatorTintColor = currentPageIndicatorTintColor;
        self.pageIndicatorTintColor = pageIndicatorTintColor;
        self.mode = -1;

        [self setupMainView];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame delegate:(id<LCBannerViewDelegate>)delegate titles:(NSArray *)titles  timerInterval:(NSInteger)timeInterval currentPageIndicatorTintColor:(UIColor *)currentPageIndicatorTintColor pageIndicatorTintColor:(UIColor *)pageIndicatorTintColor {
    
    if (self = [super initWithFrame:frame]) {
        
        self.delegate = delegate;
        self.titles = titles;
        self.count = titles.count;
        self.timerInterval = timeInterval;
        self.currentPageIndicatorTintColor = currentPageIndicatorTintColor;
        self.pageIndicatorTintColor = pageIndicatorTintColor;

        self.mode = -1;
        [self setupMainView2];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame delegate:(id<LCBannerViewDelegate>)delegate imageURLs:(NSArray *)imageURLs placeholderImage:(NSString *)placeholderImage timerInterval:(NSInteger)timeInterval currentPageIndicatorTintColor:(UIColor *)currentPageIndicatorTintColor pageIndicatorTintColor:(UIColor *)pageIndicatorTintColor :(UIViewContentMode)m{
    
    if (self = [super initWithFrame:frame]) {
        
        self.delegate = delegate;
        self.imageURLs = imageURLs;
        self.count = imageURLs.count;
        self.timerInterval = timeInterval;
        self.currentPageIndicatorTintColor = currentPageIndicatorTintColor;
        self.pageIndicatorTintColor = pageIndicatorTintColor;
        self.placeholderImage = placeholderImage;
        self.mode = m;
        
        [self setupMainView];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame delegate:(id<LCBannerViewDelegate>)delegate imageURLs:(NSArray *)imageURLs placeholderImage:(NSString *)placeholderImage timerInterval:(NSInteger)timeInterval currentPageIndicatorTintColor:(UIColor *)currentPageIndicatorTintColor pageIndicatorTintColor:(UIColor *)pageIndicatorTintColor {
    
    if (self = [super initWithFrame:frame]) {
        
        self.delegate = delegate;
        self.imageURLs = imageURLs;
        self.count = imageURLs.count;
        self.timerInterval = timeInterval;
        self.currentPageIndicatorTintColor = currentPageIndicatorTintColor;
        self.pageIndicatorTintColor = pageIndicatorTintColor;
        self.placeholderImage = placeholderImage;

        self.mode = -1;

        [self setupMainView];
    }
    return self;
}

- (void)setupMainView2 {
    
    CGFloat scrollW = self.frame.size.width;
    CGFloat scrollH = self.frame.size.height;
    
    // set up scrollView
    [self addSubview:({
        
        UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, scrollW, scrollH)];
        
        for (int i = 0; i < self.count + 2; i++) {
            
            NSInteger tag = 0;
   
            
            if (i == 0) {
                
                tag = self.count;
                

                
            } else if (i == self.count + 1) {
                
                tag = 1;
                

            } else {
                
                tag = i;
                

            }
            
            UIButton *btn = [[UIButton alloc] init];
            btn.tag = tag;
            
            if (self.titles.count > 0) {    // from local
                
                [btn setTitle:[self.titles objectAtIndex:(tag - 1)] forState:UIControlStateNormal];

                
            }
            
            btn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft ;
            [btn setImageEdgeInsets:UIEdgeInsetsMake(0, 10, 0, 0)];
            [btn setTitleEdgeInsets:UIEdgeInsetsMake(0, 15, 0, 0)];
            
            [btn setTitleColor:[UIColor colorWithRed:142.0/255.0 green:143.0/255.0 blue:145.0/255.0 alpha:1.0] forState:UIControlStateNormal];
//            btn.clipsToBounds = YES;
            btn.frame = CGRectMake(scrollW * i, 0, scrollW-10 , scrollH);
            btn.titleLabel.font = [UIFont systemFontOfSize:14];
            btn.titleLabel.lineBreakMode = NSLineBreakByTruncatingTail;
            btn.titleLabel.numberOfLines = 1;
            [btn setImage:[UIImage imageNamed:@"newMesIcon"] forState:UIControlStateNormal];
            [scrollView addSubview:btn];
            
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageViewTaped:)];
            [btn addGestureRecognizer:tap];
        }
        
        scrollView.delegate = self;
        scrollView.scrollsToTop = NO;
        scrollView.pagingEnabled = YES;
        scrollView.showsHorizontalScrollIndicator = NO;
        scrollView.contentOffset = CGPointMake(scrollW, 0);
        scrollView.contentSize = CGSizeMake((self.count + 2) * scrollW, 0);
        
        self.scrollView = scrollView;
    })];
    
    [self addTimer];
    
    // set up pageControl
    [self addSubview:({
        
        UIPageControl *pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(0, scrollH - 10.0f - LCPageDistance, scrollW, 10.0f)];
        pageControl.numberOfPages = self.count;
        pageControl.userInteractionEnabled = NO;
        pageControl.currentPageIndicatorTintColor = self.currentPageIndicatorTintColor ?: [UIColor blueColor];
        pageControl.pageIndicatorTintColor = self.pageIndicatorTintColor ?: [UIColor yellowColor];
        
        
        self.pageControl = pageControl;
    })];
}

- (void)setupMainView {
    
    CGFloat scrollW = self.frame.size.width;
    CGFloat scrollH = self.frame.size.height;
    
    // set up scrollView
    [self addSubview:({
        
        UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, scrollW, scrollH)];
        
        for (int i = 0; i < self.count + 2; i++) {
            
            NSInteger tag = 0;
            NSString *currentImageName = nil;
            
            if (i == 0) {
                
                tag = self.count;
                
                currentImageName = [NSString stringWithFormat:@"%@_%02ld", self.imageName, (long)self.count];
                
            } else if (i == self.count + 1) {
                
                tag = 1;
                
                currentImageName = [NSString stringWithFormat:@"%@_01", self.imageName];
                
            } else {
                
                tag = i;
                
                currentImageName = [NSString stringWithFormat:@"%@_%02d", self.imageName, i];
            }
            
            UIImageView *imageView = [[UIImageView alloc] init];
            imageView.tag = tag;
            
            if (self.imageName.length > 0) {    // from local
                
                UIImage *image = [UIImage imageNamed:currentImageName];
                if (!image) {
                    
                    NSLog(@"ERROR: No image named `%@`!", currentImageName);
                }
                
                imageView.image = image;
                
            } else {    // from internet
                
                [imageView sd_setImageWithURL:[NSURL URLWithString:self.imageURLs[tag - 1]]
                             placeholderImage:self.placeholderImage.length > 0 ? [UIImage imageNamed:self.placeholderImage] : nil];
            }
            
            imageView.clipsToBounds = YES;
            imageView.userInteractionEnabled = YES;
            
//            if (self.changeMode ) {
//                imageView.contentMode = self.mode;
//            }else
//                imageView.contentMode = UIViewContentModeRedraw;

            if (self.mode!=-1) {
                imageView.contentMode = self.mode;
            }else
                imageView.contentMode = UIViewContentModeRedraw;

//            imageView.contentMode = UIViewContentModeScaleAspectFit;

            imageView.frame = CGRectMake(scrollW * i, 0, scrollW, scrollH);
            [scrollView addSubview:imageView];
            
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageViewTaped:)];
            [imageView addGestureRecognizer:tap];
        }
        
        scrollView.delegate = self;
        scrollView.scrollsToTop = NO;
        scrollView.pagingEnabled = YES;
        scrollView.showsHorizontalScrollIndicator = NO;
        scrollView.contentOffset = CGPointMake(scrollW, 0);
        scrollView.contentSize = CGSizeMake((self.count + 2) * scrollW, 0);
        
        self.scrollView = scrollView;
    })];
    
    [self addTimer];
    
    // set up pageControl
    [self addSubview:({
        
        UIPageControl *pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(0, scrollH - 10.0f - LCPageDistance, scrollW, 10.0f)];
        pageControl.numberOfPages = self.count;
        pageControl.userInteractionEnabled = NO;
//        pageControl.currentPageIndicatorTintColor = self.currentPageIndicatorTintColor ?: [UIColor orangeColor];
//        pageControl.pageIndicatorTintColor = self.pageIndicatorTintColor ?: [UIColor lightGrayColor];
        pageControl.currentPageIndicatorTintColor = [UIColor colorWithRed:0.27 green:0.82 blue:0.82 alpha:1];
        pageControl.pageIndicatorTintColor = self.pageIndicatorTintColor ?: [UIColor lightGrayColor];
        
        self.pageControl = pageControl;
    })];
}

- (void)imageViewTaped:(UITapGestureRecognizer *)tap {
    
    if ([self.delegate respondsToSelector:@selector(bannerView:didClickedImageIndex:)]) {
        
        [self.delegate bannerView:self didClickedImageIndex:tap.view.tag - 1];
    }
}

#pragma mark - Timer

- (void)addTimer {
    
    self.timer = [NSTimer scheduledTimerWithTimeInterval:self.timerInterval target:self selector:@selector(nextImage) userInfo:nil repeats:YES];
    
    [[NSRunLoop currentRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
}

- (void)removeTimer {
    
    if (self.timer) {
        
        [self.timer invalidate];
        
        self.timer = nil;
    }
}

- (void)nextImage {
    
    NSInteger currentPage = self.pageControl.currentPage;
    
    [self.scrollView setContentOffset:CGPointMake((currentPage + 2) * self.scrollView.frame.size.width, 0)
                             animated:YES];
}

#pragma mark - UIScrollView Delegate Methods

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    CGFloat scrollW = self.scrollView.frame.size.width;
    NSInteger currentPage = self.scrollView.contentOffset.x / scrollW;
    
    if (currentPage == self.count + 1) {
        
        self.pageControl.currentPage = 0;
        
    } else if (currentPage == 0) {
        
        self.pageControl.currentPage = self.count;
        
    } else {
        
        self.pageControl.currentPage = currentPage - 1;
    }
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView {
    
    [self scrollViewDidEndDecelerating:scrollView];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    
    CGFloat scrollW = self.scrollView.frame.size.width;
    NSInteger currentPage = self.scrollView.contentOffset.x / scrollW;
    
    if (currentPage == self.count + 1) {
        
        self.pageControl.currentPage = 0;
        
        [self.scrollView setContentOffset:CGPointMake(scrollW, 0) animated:NO];
        
    } else if (currentPage == 0) {
        
        self.pageControl.currentPage = self.count;
        
        [self.scrollView setContentOffset:CGPointMake(self.count * scrollW, 0) animated:NO];
        
    } else {
        
        self.pageControl.currentPage = currentPage - 1;
    }
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    
    [self removeTimer];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    
    [self addTimer];
}

@end
