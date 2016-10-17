//
//  MGGrojiCircleCollectionViewCell.h
//  MyGrid
//
//  Created by Kirti  on 21/09/16.
//  Copyright © 2016 Devashis. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MGGrojiCircleCollectionViewCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIView *ciiclesView;
@property (weak, nonatomic) IBOutlet UILabel *circleLabel;
@property(assign,nonatomic)BOOL selectedCircle;
@property (weak, nonatomic) IBOutlet UIView *backgroundImage;

@end
