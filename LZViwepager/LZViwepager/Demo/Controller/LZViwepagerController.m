//
//  LZViwepagerController.m
//  LZViwepager
//
//  Created by lzing on 16/3/20.
//  Copyright © 2016年 LZING. All rights reserved.
//

#import "LZViwepagerController.h"
#import "LZViwepageView.h"

@interface LZViwepagerController ()<LZViwepageViewDelegate>

@property(nonatomic, strong)NSArray *imageArr;

@end

@implementation LZViwepagerController

- (void)viewDidLoad {
    [super viewDidLoad];
    CGRect frame = CGRectMake([UIScreen mainScreen].bounds.size.width / 2 - 150 , 50, 300, 160);
    
    /**
     *  一句代码创建图片轮播器
     */
    // 创建view
    LZViwepageView *viwepageView = [LZViwepageView imagePlayViewWithFrame:frame WithImageArr:self.imageArr WithImagePlayerSpace:1];
    
    viwepageView.delegate = self;
    
    [self.view addSubview:viwepageView];
}

#pragma mark - <LZViwepageViewDelegate>
- (void)viwepageView:(LZViwepageView *)viwepageView didClickImageAtIndex:(NSInteger)index {
    NSLog(@"%ld 几张被点击了", index);
}

#pragma mark - 懒加载
- (NSArray *)imageArr {
    
    if (_imageArr == nil) {

        NSMutableArray *mtbArr = [NSMutableArray array];
        for (NSInteger i = 0; i < 5; i++) {
            
            NSString *imageStr = [NSString stringWithFormat:@"img_%02ld",i+1];
            [mtbArr addObject:imageStr];
        }
        _imageArr = [NSArray arrayWithArray:mtbArr];
    }
    return _imageArr;
}



@end
