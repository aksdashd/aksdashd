//
//  MGEmojiView.m
//  MyGrid
//
//  Created by Devashis on 05/07/16.
//  Copyright © 2016 Devashis. All rights reserved.
//

#import "MGEmojiView.h"

#import "MGEmojiCollectionViewCell.h"

#define kProductCellIdentifier @"ProductsCellIdentifier"

@interface MGEmojiView ()<UICollectionViewDataSource,
                          UICollectionViewDelegate,
                          UICollectionViewDelegateFlowLayout>

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (strong, nonatomic) NSArray *groupMembersArray;

@end

@implementation MGEmojiView

- (void)awakeFromNib {
    UINib *nib = [UINib nibWithNibName:@"MGEmojiCollectionViewCell" bundle: nil];
    [self.collectionView registerNib:nib forCellWithReuseIdentifier:kProductCellIdentifier];
    
    [self.collectionView setDataSource:self];
    [self.collectionView setDelegate:self];
}

#pragma Helper Methods
- (void)setupProductListWirhArray:(NSArray *)productsArray {
    self.groupMembersArray = [[NSArray alloc] initWithArray:productsArray];
    [self.collectionView reloadData];
}


- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView*)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView*)collectionView numberOfItemsInSection:(NSInteger)section {
 
    
    return [self.groupMembersArray count];
    
    
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    MGEmojiCollectionViewCell *cell = (MGEmojiCollectionViewCell *)[self.collectionView dequeueReusableCellWithReuseIdentifier:kProductCellIdentifier forIndexPath:indexPath];
    
    NSString *imageName = [NSString stringWithFormat:@"%@.png",self.groupMembersArray[indexPath.item]];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *path = [NSString stringWithFormat:@"%@/%@",[[paths objectAtIndex:0] stringByAppendingPathComponent:@"emoji_01_07_2016/emoji"],imageName];
    
    cell.imageView.image = [UIImage imageWithContentsOfFile:path];
    //cell.imageView.image = [UIImage imageNamed:@"sample_user_image1"];
    cell.tag = [self.groupMembersArray[indexPath.row] integerValue];
    
    
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(collectionView.frame.size.width/3.2 , 140);
}

#pragma mark - Collection view delegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    MGEmojiCollectionViewCell *cell = [self.collectionView cellForItemAtIndexPath:indexPath];
    [self.delegate didSelectEmojiAtIndexItem:cell.tag];
}


@end
