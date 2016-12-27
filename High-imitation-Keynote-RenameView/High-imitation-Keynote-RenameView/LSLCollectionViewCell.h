//
//  LSLCollectionViewCell.h
//  High-imitation-Keynote-RenameView
//
//  Created by Bruce Li on 16/11/20.
//  Copyright © 2016年 XMindKate. All rights reserved.
//

#import <UIKit/UIKit.h>

@class LSLCollectionViewCell;

@protocol LSLCollectionViewCellDelegate <NSObject>
@optional
- (void)renameMapWithCell:(LSLCollectionViewCell *)cell;
@end

@interface LSLCollectionViewCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UIButton *titleButton;

@property (nonatomic, weak) id<LSLCollectionViewCellDelegate> delegate;

@end
