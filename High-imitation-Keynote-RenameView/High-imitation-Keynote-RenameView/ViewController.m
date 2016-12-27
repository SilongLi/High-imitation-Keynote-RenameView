//
//  ViewController.m
//  High-imitation-Keynote-RenameView
//
//  Created by Bruce Li on 16/11/20.
//  Copyright © 2016年 XMindKate. All rights reserved.
//

#import "ViewController.h"
#import "LSLCollectionViewCell.h"
#import "LSLTitleEditView.h"

@interface ViewController ()<LSLCollectionViewCellDelegate>

@property (nonatomic, strong) NSMutableArray *titleArray;

@end

@implementation ViewController

- (instancetype)init {
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    [layout setMinimumLineSpacing:20];
    [layout setMinimumInteritemSpacing:20];
    
    return self = [super initWithCollectionViewLayout:layout];
}

#pragma mark - 

- (NSMutableArray *)titleArray {
    if (!_titleArray) {
        NSMutableArray *titles = [@[] mutableCopy];
        for (NSUInteger i = 0; i<20; i++) {
            [titles addObject:@"advance"];
        }
        _titleArray = [titles mutableCopy];
    }
    return _titleArray;
}

#pragma mark - <UICollectionViewDataSource>

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.titleArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    LSLCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"RenameCell" forIndexPath:indexPath];
    [cell.titleButton setTitle:[self.titleArray objectAtIndex:indexPath.item] forState:UIControlStateNormal];
    cell.delegate = self;
    return cell;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(20, 20, 20, 20);
}


#pragma mark - <LSLCollectionViewCellDelegate>

- (void)renameMapWithCell:(LSLCollectionViewCell *)cell {
    if (!cell) return;
    
    /// work around : to avoid rename more than 2 cell title at the same time.
    if ([self.view viewWithTag:1997]) {
        return;
    }
    
    [cell.imageView setHidden:YES];
    
    NSIndexPath *indexPath = [self.collectionView indexPathForCell:cell];
    NSString *originTitle  = self.titleArray[indexPath.item];
    
    __weak typeof(self) weakSelf = self;
    LSLTitleEditView *titleEditView = [[LSLTitleEditView alloc] initWithFrame:self.view.bounds andTitle:cell.titleButton.titleLabel.text andOriginImageView:cell.imageView completion:^(NSString *title) {
        if (title && ![originTitle isEqualToString:title]) {
            self.titleArray[indexPath.item] = [title copy];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                if (indexPath) {
                    [weakSelf.collectionView reloadItemsAtIndexPaths:@[indexPath]];
                }
            });
        }
        
    } animationCompletion:^{
        [cell.imageView setHidden:NO];
    }];
    
    [titleEditView setTag:1997];
    [self.view addSubview:titleEditView];
    
    [titleEditView setTranslatesAutoresizingMaskIntoConstraints:NO];
    [[titleEditView.leadingAnchor   constraintEqualToAnchor:self.view.leadingAnchor]    setActive:YES];
    [[titleEditView.trailingAnchor  constraintEqualToAnchor:self.view.trailingAnchor]   setActive:YES];
    [[titleEditView.topAnchor       constraintEqualToAnchor:self.view.topAnchor]        setActive:YES];
    [[titleEditView.bottomAnchor    constraintEqualToAnchor:self.view.bottomAnchor]     setActive:YES];
    
    [titleEditView becomeFirstResponder];
}

@end
