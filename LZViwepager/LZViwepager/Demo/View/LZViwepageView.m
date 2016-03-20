//
//  LZViwepageView.m
//  LZViwepager
//
//  Created by lzing on 16/3/20.
//  Copyright © 2016年 LZING. All rights reserved.
//

#import "LZViwepageView.h"

@interface LZViwepageView ()<UIScrollViewDelegate>

// scrollView
@property(nonatomic, weak)UIScrollView *scrollView;

// 页面显示器
@property(nonatomic, weak)UIPageControl *pageControl;

// 当前的页数
@property(nonatomic, assign)NSInteger index;

// 得到当前的timer
@property(nonatomic, weak)NSTimer *timer;

@end

@implementation LZViwepageView

/**
 *  图片轮播器对象
 *
 *  @param frame    图片轮播器的frame
 *  @param imageArr 图片名称的数组
 *  @param secoder  每次轮播的时间，默认时间是1.5秒，如果填入的时间小于0.5秒会使用默认时间
 *
 *  @return 返回一个图片轮播器对象
 */
- (instancetype)initWithFrame:(CGRect)frame WithImageArr:(NSArray *)imageArr WithImagePlayerSpace:(NSInteger) secoder {
    
    if (self = [super initWithFrame:frame]) {
        
        self.imageArr = imageArr;
        self.secoder = secoder;
    }
    return self;
}

/**
 *  创建一个图片轮播器的View
 *
 *  @param frame    图片轮播器的frame
 *  @param imageArr 图片名称的数组
 *  @param secoder  每次轮播的时间，默认时间是1.5秒，如果填入的时间小于0.5秒会使用默认时间
 *
 *  @return 返回一个图片轮播器
 */
+ (instancetype)imagePlayViewWithFrame:(CGRect)frame WithImageArr:(NSArray *)imageArr WithImagePlayerSpace:(NSInteger)secoder{
    
    return [[self alloc] initWithFrame:frame WithImageArr:imageArr WithImagePlayerSpace:secoder];
}

#pragma mark - 增加子控件
// 增加子控件
- (void)setupSubView {
    
    // 添加scrollView
    [self setupScrollView];
    
    // 添加pageView
    [self setupPageController];
    
    // 增加一个控制器
    [self setupRunLoopTime];
}

// 增加scrollView
- (void)setupScrollView {
    
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
    scrollView.delegate = self;
    scrollView.showsVerticalScrollIndicator = NO;
    scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.pagingEnabled = YES;
    [self addSubview:scrollView];
    self.scrollView = scrollView;
    
    if (self.imageArr.count == 0) {
        return;
    }
    
    // 先加第一张图片进去
    UIImageView *first = [[UIImageView alloc] initWithFrame:self.bounds];
    first.image = [UIImage imageNamed:[self.imageArr lastObject]];
    [scrollView addSubview:first];
    
    // 如果大于1
    if (self.imageArr.count > 1) {
        
        CGFloat selfWidth = self.frame.size.width;
        CGFloat selfHeight = self.frame.size.height;
        
        NSMutableArray *mtbArr = [NSMutableArray array];
        
        for (NSInteger i = 0; i < self.imageArr.count; i ++) {
            // 创建imageView
            UIImageView *imageView = [[UIImageView alloc] init];
            // 设置图片
            UIImage *image = [UIImage imageNamed:self.imageArr[i]];
            // 设置frame 因为这里开始加就已经是第二张了所以要加1
            CGFloat imageViewX = (i + 1) * selfWidth;
            imageView.frame = CGRectMake(imageViewX, 0, selfWidth, selfHeight);
            // 给imageView赋值
            imageView.image = image;
            // 增加手势
            imageView.userInteractionEnabled = YES;
            [imageView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageClick:)]];
            // 加到子控件
            [scrollView addSubview:imageView];
            // 让imageView加进去
            [mtbArr addObject:imageView];
        }
        // 给imageViewArr赋值让外界可以访问到
        _imageViewArr = [NSArray arrayWithArray:mtbArr];
        
        // 设置最后一张图片
        UIImageView *lastImageView= [[UIImageView alloc] init];
        // 第一张图片
        lastImageView.image = [UIImage imageNamed:[self.imageArr firstObject]];
        // 设置frame
        lastImageView.frame = CGRectMake((self.imageArr.count +1 ) * selfWidth, 0, selfWidth, selfHeight);
        // 添加到scrollView
        [scrollView addSubview:lastImageView];
        
        // 判断scrollView的个数然后调节
        scrollView.contentSize = CGSizeMake(selfWidth * (self.imageArr.count + 2) ,selfHeight);
        // 一开始应该现实第二张图片
        scrollView.contentOffset = CGPointMake(selfWidth, 0);
    }
    
    // 占位图片
    self.placeholder = [UIImage imageNamed:@"XMGInifiteScrollView.bundle/placeholder"];
}

/**
 *  建立pageViewController
 */
- (void)setupPageController {
    
    // 页面控制器
    UIPageControl *pageController = [[UIPageControl alloc] init];
    // 页面中心点 这里不能用self的中心点，因为self的中心点是相对外面
    pageController.center = CGPointMake(self.scrollView.center.x, self.scrollView.frame.size.height - 15);
    // 设置未选中的颜色
    pageController.pageIndicatorTintColor = [UIColor grayColor];
    // 设置选中的颜色
    pageController.currentPageIndicatorTintColor = [UIColor whiteColor];
    // 设置页数
    pageController.numberOfPages = self.imageArr.count;
    // 当前页数
    pageController.currentPage = 0;
    // 加入到父控件
    [self addSubview:pageController];
    
    self.pageControl = pageController;
}

/**
 *  增加一个控制器的轮播器
 */
- (void)setupRunLoopTime {
    
    // 当前的runLoop
    NSRunLoop *runloop = [NSRunLoop currentRunLoop];
    NSInteger secoder = 1.5;
    if (self.secoder >= 0.5) {
        secoder = self.secoder;
    }
    NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:secoder target:self selector:@selector(runImage) userInfo:nil repeats:YES];
    // 模式改变，开启线程不然不会开启线程
    [runloop addTimer:timer forMode:NSRunLoopCommonModes];
    // 得到当前的timer
    self.timer = timer;
}

#pragma mark - 监听点击
/**
 *  图片点击
 */
- (void)imageClick:(UITapGestureRecognizer *)tap
{
    if ([self.delegate respondsToSelector:@selector(viwepageView:didClickImageAtIndex:)]) {
        [self.delegate viwepageView:self didClickImageAtIndex:tap.view.tag];
    }
}

#pragma mark - action
/**
 *  图片轮播
 */
- (void)runImage {
    
    CGFloat width = self.scrollView.frame.size.width;
    // 拿到当前的偏移量
    NSInteger index = (self.scrollView.contentOffset.x + 0.5 * width) / width;
    // 得到当前图片的下标
    [self.scrollView setContentOffset:CGPointMake(width * (index + 1), 0) animated:YES];
}

#pragma mark - scrollView代理方法
/**
 *  只要移动就调用
 */
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    // 获得scollView宽度
    CGFloat width = self.scrollView.frame.size.width;
    // 拿到当前的偏移量
    self.index = (self.scrollView.contentOffset.x)/ width;
    // 第一张变到倒数第二张
    if (self.index == 0) {
        // 如果是第0张就让它是第count张
        self.index = self.imageArr.count;
    } else if(self.index == self.imageArr.count + 1) { // 最后一张变为第一张
        // 如果是最后一张就让它是第一张
        self.index = 1;
    }
    // 获取当前页数
    self.pageControl.currentPage = self.index - 1;
    
}

/**
 *  全部都移动都结束的时候调用
 *  移动结束的时候调用
 */
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    
    // 获取当前的index
    CGFloat width = self.scrollView.frame.size.width;
    int index = (self.scrollView.contentOffset.x + 0.5 * width) / width;
    // 偏移 这里一定要动画为NO
    if (index == self.imageArr.count + 1) {
        
        [self.scrollView setContentOffset:CGPointMake(width, 0) animated:NO];
    } else if (index == 0) {
        
        [self.scrollView setContentOffset:CGPointMake((self.imageArr.count) * width, 0) animated:NO];
    }
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView {
    
    [self scrollViewDidEndDecelerating:scrollView];
}

/**
 *  点击时停止时钟
 */
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    
    // 销毁时钟
    [self.timer invalidate];
    self.timer = nil;
}

/**
 *  松手时开启时钟
 */
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    
    // 创建时钟
    [self setupRunLoopTime];
}

#pragma mark -  set &get
/**
 *  重写数组setter方法
 */
- (void)setImageArr:(NSArray *)imageArr {
    
    _imageArr = imageArr;
    // 建立子控件
    [self setupSubView];
}

/**
 *  页面提示按钮的颜色
 */
- (void)setCurrentpageColor:(UIColor *)currentpageColor {
    
    _currentpageColor = currentpageColor;
    self.pageControl.currentPageIndicatorTintColor = currentpageColor;
}

// 为选中页面的颜色
- (void)setPageIndicatorTintColor:(UIColor *)pageIndicatorTintColor {
    
    _pageIndicatorTintColor = pageIndicatorTintColor;
    self.pageControl.pageIndicatorTintColor = pageIndicatorTintColor;
}

#pragma mark - delloc
- (void)dealloc {
    
    // 销毁时钟
    [self.timer invalidate];
    self.timer = nil;
}

@end
