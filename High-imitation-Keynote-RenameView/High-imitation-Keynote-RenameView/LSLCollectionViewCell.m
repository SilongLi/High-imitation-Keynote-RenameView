//
//  LSLCollectionViewCell.m
//  High-imitation-Keynote-RenameView
//
//  Created by Bruce Li on 16/11/20.
//  Copyright © 2016年 XMindKate. All rights reserved.
//

#import "LSLCollectionViewCell.h"

@implementation LSLCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    _imageView.layer.cornerRadius  = 5;
    _imageView.layer.masksToBounds = YES;
}

- (IBAction)titleButtonClicked:(UIButton *)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(renameMapWithCell:)]) {
        [self.delegate renameMapWithCell:self];
    }
}

@end
