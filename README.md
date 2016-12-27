# High-imitation-Keynote-RenameView

## 学习Keynote的重命名动画，自己用一个UIView实现，兼容iPhone/iPad横竖屏及分屏，简单易用。

### 一、使用说明：

```objc 
    /// instantiate method
- (instancetype)initWithFrame:(CGRect)frame
                     andTitle:(NSString *)title
           andOriginImageView:(UIImageView *)originImageView
                   completion:(LSLTitleEditEndCompletion)completion
          animationCompletion:(LSLTitleEditEndAnimationCompletion)animationCompletion;	
```

###二、GIF演示
![](https://github.com/SilongLi/High-imitation-Keynote-RenameView/raw/master/High-imitation-Keynote-RenameView/High-imitation-Keynote-RenameView/GIF/renameTitleiPhone.gif)

![](https://github.com/SilongLi/High-imitation-Keynote-RenameView/raw/master/High-imitation-Keynote-RenameView/High-imitation-Keynote-RenameView/GIF/renameTitleLandScreen.gif)

![](https://github.com/SilongLi/High-imitation-Keynote-RenameView/raw/master/High-imitation-Keynote-RenameView/High-imitation-Keynote-RenameView/GIF/renameTitleiPad.gif)