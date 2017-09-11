//
//  LSLTitleEditView.h
//  High-imitation-Keynote-RenameView
//
//  Created by Bruce Li on 16/11/20.
//  Copyright © 2016年 LongshaoDream. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^LSLTitleEditEndCompletion)(NSString *title);
typedef void(^LSLTitleEditEndAnimationCompletion)();

@interface LSLTitleEditView : UIView 

- (instancetype)initWithFrame:(CGRect)frame
                     andTitle:(NSString *)title
           andOriginImageView:(UIImageView *)originImageView
                   completion:(LSLTitleEditEndCompletion)completion
          animationCompletion:(LSLTitleEditEndAnimationCompletion)animationCompletion;
@end
