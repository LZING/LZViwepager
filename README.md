# LZViwepager
#一句话实现图片轮播/Viwepager ScrollView

### 修改日志：
2016.03.20 -- 创建一句话图片轮播LZViwepager

--------------------------------------------------------------------------------------------------------------------

### 注意
#worning缓存缓存的话我觉得没有SDWebImage做的好,所以不做啦

--------------------------------------------------------------------------------------------------------------------

##使用方法

    // view的frame
    CGRect frame = CGRectMake([UIScreen mainScreen].bounds.size.width / 2 - 150 , 50, 300, 160);
    // 创建view
    LZViwepageView *viwepageView = [LZViwepageView imagePlayViewWithFrame:frame WithImageArr:self.imageArr WithImagePlayerSpace:1];
    // 添加到父控件上
    [self.view addSubview:viwepageView];

--------------------------------------------------------------------------------------------------------------------