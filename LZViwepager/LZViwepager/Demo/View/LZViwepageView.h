//
//  LZViwepageView.h
//  LZViwepager
//
//  Created by lzing on 16/3/20.
//  Copyright © 2016年 LZING. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LZViwepageView : UIView

/**
 *  图片数组
 */
@property(nonatomic, strong, readonly)NSArray *imageArr;
/**
 *  当前页面page的颜色
 */
@property(nonatomic, strong)UIColor *currentpageColor;
/**
 *  非当前页面page的颜色
 */
@property(nonatomic, strong)UIColor *pageIndicatorTintColor;

/**
 *  里面装的是每一个滚动画面的UIImageView
 */
@property(nonatomic, strong, readonly)NSArray<UIImageView *> *imageViewArr;
/**
 *  图片轮播器对象
 *
 *  @param frame    图片轮播器的frame
 *  @param imageArr 图片名称的数组
 *  @param secoder  每次轮播的时间，默认时间是1.5秒，如果填入的时间小于0.5秒会使用默认时间
 *
 *  @return 返回一个图片轮播器对象
 */
- (instancetype)initWithFrame:(CGRect)frame WithImageArr:(NSArray *)imageArr WithImagePlayerSpace:(NSInteger) secoder;

/**
 *  创建一个图片轮播器的View
 *
 *  @param frame    图片轮播器的frame
 *  @param imageArr 图片名称的数组
 *  @param secoder  每次轮播的时间，默认时间是1.5秒，如果填入的时间小于0.5秒会使用默认时间
 *
 *  @return 返回一个图片轮播器
 */
+ (instancetype)imagePlayViewWithFrame:(CGRect)frame WithImageArr:(NSArray *)imageArr WithImagePlayerSpace:(NSInteger) secoder;


@end
