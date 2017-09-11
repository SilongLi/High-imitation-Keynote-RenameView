//
//  LSLTitleEditView.m
//  High-imitation-Keynote-RenameView
//
//  Created by Bruce Li on 16/11/20.
//  Copyright © 2016年 LongshaoDream. All rights reserved.
//

#import "LSLTitleEditView.h"

#define IPHONE [[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone
#define IPAD   [[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad
#define UIViewAnimationOptionCurveKeyboard 7<<16

@interface LSLTitleEditView ()<UITextFieldDelegate>

@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UITextField *textField;

@property (nonatomic, copy) LSLTitleEditEndCompletion completion;
@property (nonatomic, copy) LSLTitleEditEndAnimationCompletion animationCompletion;
@property (nonatomic, strong) NSString *originTitle;
@property (nonatomic, weak) UIImageView *originImageView;

@property (nonatomic, assign) CGRect imageFrameToMove;

@property (nonatomic, assign) BOOL enableLayout;

@end

@implementation LSLTitleEditView

- (instancetype)initWithFrame:(CGRect)frame 
                     andTitle:(NSString *)title
           andOriginImageView:(UIImageView *)originImageView
                   completion:(LSLTitleEditEndCompletion)completion
          animationCompletion:(LSLTitleEditEndAnimationCompletion)animationCompletion {
    
    if (self = [super init]) {
        NSParameterAssert(originImageView);
         
        self.backgroundColor = [UIColor clearColor];
        
        _originImageView = originImageView;
        
        _imageView = [[UIImageView alloc] init];
        _imageView.layer.cornerRadius    = 5;
        _imageView.layer.masksToBounds   = YES;
        _imageView.layer.backgroundColor = [UIColor whiteColor].CGColor;
        _imageView.image                 = originImageView.image;
        _imageView.frame                 = [_originImageView convertRect:_originImageView.bounds toView:self];
        [self addSubview:_imageView];
        
        _textField = [[UITextField alloc] init];
        [_textField setReturnKeyType:UIReturnKeyDone];
        [_textField setText:title];
        [_textField setFont:[UIFont systemFontOfSize:(IPHONE ? 17 : 20)]];
        [_textField setTextAlignment:NSTextAlignmentCenter];
        [_textField setBackgroundColor:[UIColor whiteColor]];
        [_textField setClipsToBounds:YES];
        [_textField.layer setCornerRadius:5];
        [_textField setClearButtonMode:UITextFieldViewModeAlways];
        [_textField setDelegate:self];
        [_textField setAlpha:0];
        [self addSubview:_textField];
        
        [self layoutSubviewsWithSize:frame.size];
        
        _enableLayout = YES;
        
        _originTitle = title;
        _completion  = completion;
        _animationCompletion = animationCompletion;
        
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGesture:)];
        [self addGestureRecognizer:tapGesture];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    if (!self.enableLayout) return;
    
    self.frame = self.superview.bounds;
    
    [self layoutSubviewsWithSize:self.bounds.size];
    [self.imageView setFrame:self.imageFrameToMove];
}

- (void)layoutSubviewsWithSize:(CGSize)size {
    BOOL isLandscape   = ([UIScreen mainScreen].bounds.size.width > [UIScreen mainScreen].bounds.size.height) ? YES : NO;
    BOOL isWidthNarrow = [UIApplication sharedApplication].keyWindow.rootViewController.traitCollection.horizontalSizeClass == UIUserInterfaceSizeClassCompact;
    
    /// If width greater than half screen width on iPad, subviews for left and right structure.
    CGFloat halfScreenWidth = [UIScreen mainScreen].bounds.size.width / 2;
    /// The split screen is about 20 points in the middle of the interval.
    CGFloat interval = 20;
    BOOL halfScreen  = NO; /// 1/2 screen width
    if (size.width - halfScreenWidth > -interval &&
        size.width - halfScreenWidth < 0) {
        halfScreen   = YES;
    }
    BOOL greaterHalfScreen = NO; /// (2/3 || 1/1) screen width
    if (size.width - halfScreenWidth > 0) {
        greaterHalfScreen  = YES;
    }
    
    BOOL iPhoneCompact = IPHONE && (!isLandscape && isWidthNarrow);
    BOOL iPadCompact   = IPAD   && (!isLandscape || (isLandscape && !greaterHalfScreen && !halfScreen));
    
    CGFloat imageX, imageY, imageW, imageH;
    CGFloat fieldX, fieldY, fieldW, fieldH;
    
    CGFloat space = IPAD ? 50 : 40;
    CGFloat navigationBarHeight = (IPHONE && isLandscape) ? 32 : 64;
    fieldH = 50;
    // up and down structure
    if (iPhoneCompact || iPadCompact) {
        if (IPHONE) {
            CGFloat margin = size.width / 5;
            imageW = margin * 3;
            imageH = imageW * 0.618;
            imageX = margin;
            imageY = navigationBarHeight + (size.height * 0.5 - navigationBarHeight - imageH - fieldH - space);
            
            fieldX = 30;
            fieldY = imageY + imageH + space;
            fieldW = size.width - fieldX * 2;
        } else {
            imageW = 200;
            imageH = imageW * 0.618;
            imageX = (size.width - imageW) / 2;
            imageY = navigationBarHeight + (size.height * 0.5 - navigationBarHeight - imageH - fieldH - space - 30);
            
            fieldW = (imageW * 1.618 > size.width) ? (size.width - 30 * 2) : imageW * 1.618;
            fieldX = (size.width - fieldW) / 2;
            fieldY = imageY + imageH + space;
        }
        
    } else { // left and right structure
        if (IPHONE) {
            CGFloat margin = size.width / 10;
            imageW = margin * 2.168;
            imageH = imageW * 0.618;
            imageX = margin * 1.2;
            imageY = navigationBarHeight + (size.height * 0.37 - imageH - navigationBarHeight);
            
            fieldX = imageX + imageW + space;
            fieldY = imageY + (imageH - fieldH) / 2;
            fieldW = size.width - fieldX - imageX;
            
        } else {
            if (halfScreen) {
                CGFloat margin = 20;
                imageW = (size.width - margin * 3) / 2;
                imageH = imageW * 0.618;
                imageX = margin;
                imageY = navigationBarHeight + (size.height * 0.37 - imageH - navigationBarHeight);
                
                fieldX = imageX + imageW + margin;
                fieldY = imageY + (imageH - fieldH) / 2;
                fieldW = imageW;
                
            } else {
                imageW = 300;
                imageH = imageW * 0.618;
                imageX = (size.width - imageW * 2 - space) / 2;
                imageY = navigationBarHeight + (size.height * 0.37 - imageH - navigationBarHeight);
                
                fieldX = imageX + imageW + space;
                fieldY = imageY + (imageH - fieldH) / 2;
                fieldW = imageW;
            }
        }
    }
    
    _imageFrameToMove = CGRectMake(imageX, imageY, imageW, imageH);
    [_textField setFrame:CGRectMake(fieldX, fieldY, fieldW, fieldH)];
}

- (void)startEnterAnimation {
    // Get keyboard height, animation duration and curve
    NSTimeInterval duration = 0.25;
    
    __weak typeof(self) weakSelf = self;
    [UIView animateWithDuration:duration delay:0 options:UIViewAnimationOptionCurveKeyboard animations:^{
        weakSelf.backgroundColor =[UIColor colorWithRed:231/255.0 green:233/255.0 blue:238/255.0 alpha:1.0];
        [weakSelf.imageView setFrame:weakSelf.imageFrameToMove];
    } completion:^(BOOL finished) {
    }];
    
    [UIView animateWithDuration:duration/2 delay:duration/2  options:UIViewAnimationOptionCurveKeyboard animations:^{
        [weakSelf.textField setAlpha:1];
    } completion:^(BOOL finished) {
    }];
}

- (void)startEndAnimation {
    // Get keyboard height, animation duration and curve
    NSTimeInterval duration = 0.25;
    
    __weak typeof(self) weakSelf = self;
    [UIView animateWithDuration:duration delay:0 options:UIViewAnimationOptionCurveKeyboard animations:^{
        weakSelf.imageView.frame = [weakSelf.originImageView convertRect:weakSelf.originImageView.bounds toView:weakSelf];
        weakSelf.backgroundColor = [UIColor clearColor];
        
    } completion:^(BOOL finished) {
        if (weakSelf.animationCompletion) {
            weakSelf.animationCompletion();
        }
        [weakSelf removeFromSuperview];
    }];
    
    [UIView animateWithDuration:duration/2 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        [weakSelf.textField setAlpha:0];
    } completion:^(BOOL finished) {
    }];
}

- (BOOL)becomeFirstResponder {
    [self startEnterAnimation];
    return [self.textField becomeFirstResponder];
}

- (BOOL)resignFirstResponder {
    return [self.textField resignFirstResponder];
}

#pragma mark - gesture

-(void)tapGesture:(UITapGestureRecognizer *)tapGesture {
    [self didEndEditingAndPopViewController];
}

#pragma mark - <UITextFieldDelegate>

-(BOOL)textFieldShouldReturn:(UITextField *)textField {
    [self didEndEditingAndPopViewController];
    return YES;
}

- (void)didEndEditingAndPopViewController {
    NSString *title = self.textField.text;
    
    self.enableLayout = NO;
    [self resignFirstResponder];
    
    if (self.completion) {
        BOOL titleInvalid = (title.length == 0 || [title isEqualToString:self.originTitle]);
        self.completion(titleInvalid ? nil : title);
    }
    
    [self startEndAnimation];
}

@end
