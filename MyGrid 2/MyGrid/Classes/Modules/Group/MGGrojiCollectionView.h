//
//  MGGrojiCollectionView.h
//  MyGrid
//
//  Created by Devashis on 25/04/16.
//  Copyright © 2016 Devashis. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MGGrojiCollectionViewDelegate <NSObject>

@optional
-(void)didSelectCellWithIndexPathItem:(NSInteger)item;
-(void)didRemoveUserWithIndexPath:(NSInteger)item;
@end

@interface MGGrojiCollectionView : UIView

@property (weak, nonatomic)id<MGGrojiCollectionViewDelegate> delegate;

@property (assign, nonatomic) BOOL bIsSimulationRequired;

- (void)setupProductListWirhArray:(NSArray *)productsArray;

- (void)reloadCollectionView;



@end
