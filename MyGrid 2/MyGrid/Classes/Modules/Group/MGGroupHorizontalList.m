//
//  MGGroupHorizontalList.m
//  MyGrid
//
//  Created by Devashis on 24/04/16.
//  Copyright © 2016 Devashis. All rights reserved.
//

#import "MGGroupHorizontalList.h"

#import "MGGrojiContactButtonView.h"

static int const DefaultWidthOfGroupTypeButtons = 65;

@interface MGGroupHorizontalList ()
{
    float x;
}



@end

@implementation MGGroupHorizontalList

- (void)createUI
{
    if (_arrGroupList == nil)
    {
        self.arrGroupList = [NSMutableArray new];
    }
    
    //__block float x = 20;
    x = 20;
    [[self.scrollView subviews] makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    [self.arrGroupList enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        NSInteger totalScrrenWidth = self.frame.size.width;
        
        NSInteger totalScrrenHeight = self.frame.size.height;
        
        NSInteger countForTotalButtonsInVisibility = totalScrrenWidth / DefaultWidthOfGroupTypeButtons;
        
        float y = (totalScrrenHeight / 2) - (DefaultWidthOfGroupTypeButtons / 2) - 15;
        
        CGRect frameButtonView = CGRectMake(x, y, DefaultWidthOfGroupTypeButtons, DefaultWidthOfGroupTypeButtons);
        
        [self.scrollView setContentSize:CGSizeMake((countForTotalButtonsInVisibility * DefaultWidthOfGroupTypeButtons) + (countForTotalButtonsInVisibility * 10), self.frame.size.height)];
        
        MGGrojiMainModel *model = obj;
        
        MGGrojiContactButtonView *buttonView = [[MGGrojiContactButtonView alloc] initWithFrame:frameButtonView withModel:model withParentView:self andDeleagte:self.parentView];
        [self.scrollView addSubview:buttonView];
        
        float lx = buttonView.frame.origin.x - 5;
        float ly = buttonView.frame.origin.y + buttonView.frame.size.height + 2;
        float lWidth = buttonView.frame.size.width + 10;
        float lHeight = 30;
        
        UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(lx, ly, lWidth, lHeight)];
        title.text = model.circleName;
        [title setTextColor:[UIColor whiteColor]];
        title.font = [UIFont fontWithName:@"Helvetica" size:12];
        title.numberOfLines = 0;
        title.lineBreakMode = NSLineBreakByWordWrapping;
        title.textAlignment = NSTextAlignmentCenter;
        [self.scrollView addSubview:title];
        
        x = x + buttonView.frame.size.width + 20;
    }];
}

- (void)updateUI
{
    //float x = 0;
    //[[self.scrollView subviews] makeObjectsPerformSelector:@selector(removeFromSuperview)];
//    for (MGGrojiContactButtonView *buttonView in self.scrollView.subviews)
//    {
//        x = buttonView.frame.origin.x + buttonView.frame.size.width + 20;
//    }
    
    for (NSInteger count = 1; count < [self.arrGroupList count] - 1; count++)
    {
        NSInteger totalScrrenWidth = self.frame.size.width;
        
        NSInteger totalScrrenHeight = self.frame.size.height;
        
        NSInteger countForTotalButtonsInVisibility = totalScrrenWidth + 1 / DefaultWidthOfGroupTypeButtons;
        
        float y = (totalScrrenHeight / 2) - (DefaultWidthOfGroupTypeButtons / 2) - 15;
        
        CGRect frameButtonView = CGRectMake(x, y, DefaultWidthOfGroupTypeButtons, DefaultWidthOfGroupTypeButtons);
        
        [self.scrollView setContentSize:CGSizeMake((countForTotalButtonsInVisibility * DefaultWidthOfGroupTypeButtons), self.frame.size.height)];
        //[self.scrollView setContentSize:CGSizeMake(1000, self.frame.size.height)];
        
        MGGrojiMainModel *model = self.arrGroupList[count];
        
        MGGrojiContactButtonView *buttonView = [[MGGrojiContactButtonView alloc] initWithFrame:frameButtonView withModel:model withParentView:self andDeleagte:self.parentView];
        [self.scrollView addSubview:buttonView];
        
        float lx = buttonView.frame.origin.x - 5;
        float ly = buttonView.frame.origin.y + buttonView.frame.size.height + 2;
        float lWidth = buttonView.frame.size.width + 10;
        float lHeight = 30;
        
        UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(lx, ly, lWidth, lHeight)];
        title.text = model.circleName;
        [title setTextColor:[UIColor whiteColor]];
        title.font = [UIFont fontWithName:@"Helvetica" size:12];
        title.numberOfLines = 0;
        title.lineBreakMode = NSLineBreakByWordWrapping;
        title.textAlignment = NSTextAlignmentCenter;
        [self.scrollView addSubview:title];
        
        x = x + buttonView.frame.size.width + 20;
    }
        
    

}



@end
