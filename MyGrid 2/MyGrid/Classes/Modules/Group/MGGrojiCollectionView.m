//
//  MGGrojiCollectionView.m
//  MyGrid
//
//  Created by Devashis on 25/04/16.
//  Copyright © 2016 Devashis. All rights reserved.
//

#import "MGGrojiCollectionView.h"

#import "MGGrojiMemberCollectionViewCell.h"

#import "MGContactItemsModel.h"

#import "MGGrojiCircleFriendModel.h"

#define kProductCellIdentifier @"ProductsCell"

@interface MGGrojiCollectionView ()<UICollectionViewDataSource,
                                    UICollectionViewDelegate,
                                    UICollectionViewDelegateFlowLayout>

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (strong, nonatomic) NSArray *groupMembersArray;

@end

@implementation MGGrojiCollectionView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

#pragma mark UIView Methods
- (void)awakeFromNib {
UINib *nib = [UINib nibWithNibName:@"MGGrojiMemberCollectionViewCell" bundle: nil];
[self.collectionView registerNib:nib forCellWithReuseIdentifier:kProductCellIdentifier];
    
    [self.collectionView setDataSource:self];
    [self.collectionView setDelegate:self];
}

#pragma Helper Methods
- (void)setupProductListWirhArray:(NSArray *)productsArray {
    self.groupMembersArray = [[NSArray alloc] initWithArray:productsArray];
    [self.collectionView reloadData];
}

- (void)reloadCollectionView
{
    [self.collectionView reloadData];
}

#pragma mark - Collection view data source
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView*)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView*)collectionView numberOfItemsInSection:(NSInteger)section {
    if (self.bIsSimulationRequired)
    {
        return 50;
    }
    else
    {
        return [self.groupMembersArray count];
    }
    
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    if([[self.groupMembersArray objectAtIndex:indexPath.row] isKindOfClass:[MGContactItemsModel class] ]){
        
        MGContactItemsModel *model = self.groupMembersArray[indexPath.item];
        //    model.displayName = [dataDictionary objectForKey:DISPLAY_NAME];
        //    model.contactId = [[dataDictionary objectForKey:USER_ID] integerValue];
        MGGrojiMemberCollectionViewCell *cell = (MGGrojiMemberCollectionViewCell *)[self.collectionView dequeueReusableCellWithReuseIdentifier:kProductCellIdentifier forIndexPath:indexPath];
        cell.userName.text = model.displayName;
        
        
        cell.membersImage.image = [UIImage imageNamed:@"sample_user_image1"];
        
        return cell;
    }
    else if([[self.groupMembersArray objectAtIndex:indexPath.   row] isKindOfClass:[MGGrojiCircleFriendModel class] ]){
        
        MGGrojiCircleFriendModel *model = self.groupMembersArray[indexPath.item];

        MGGrojiMemberCollectionViewCell *cell = (MGGrojiMemberCollectionViewCell *)[self.collectionView dequeueReusableCellWithReuseIdentifier:kProductCellIdentifier forIndexPath:indexPath];
        cell.userName.text = model.friendName;
        
        
        cell.membersImage.image = [UIImage imageNamed:@"sample_user_image1"];
        
        [cell.deleteUserBtn setTag:indexPath.item];
        
        [cell.deleteUserBtn addTarget:self action:@selector(deleteUserBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
        
        
        return cell;

    }
    
   
    return nil;
    
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(collectionView.frame.size.width/3.2 , 140);
}

#pragma mark - Collection view delegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (self.delegate) {
        [self.delegate didSelectCellWithIndexPathItem:indexPath.item];
    }
}

-(void)deleteUserBtnClicked:(UIButton *)sender{
    if(self.delegate){
        [self.delegate didRemoveUserWithIndexPath:sender.tag];

    }
}

@end
