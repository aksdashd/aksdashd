//
//  UITabBarController+Designing.m
//  MyGrid
//
//  Created by Devashis on 15/04/16.
//  Copyright © 2016 Devashis. All rights reserved.
//

#import "UITabBarController+Designing.h"

static NSString *TabContactsImage = @"Contact_tab_Image";
static NSString *TabNotificationsImage = @"Notifications_Tab_Image";
static NSString *TabProfileImage = @"Profile_Tab_Image";
static NSString *TabGrojiImage = @"Groji_tab_Image";
static NSString *TabChatImage = @"Chat_Tab_Image";


@implementation UITabBarController (Designing)


- (void)setDefaultTabDesign
{

    CGRect screenRect = [[UIScreen mainScreen] bounds];
    NSInteger screenHeight = screenRect.size.height;
    float height = self.tabBar.frame.size.height;
   
    switch (screenHeight)
    {
            
        case 667:
        {
            CGSize imageSize = [[UIImage imageNamed:TabProfileImage] size];
            self.tabBar.frame = CGRectMake(self.view.frame.origin.x,
                                           self.tabBar.frame.origin.y-5,
                                           self.view.frame.size.width,
                                           imageSize.height + 9);
            
            height = imageSize.height;
            
        }
            break;
            
        case 736:
        {
            
            CGSize imageSize = [[UIImage imageNamed:TabProfileImage] size];
            self.tabBar.frame = CGRectMake(self.view.frame.origin.x,
                                           self.tabBar.frame.origin.y-5,
                                           self.view.frame.size.width,
                                           imageSize.height + 9);
            height = imageSize.height;
            
        }
            break;
            
    }

    
    for (NSInteger count = 0; count < [self.viewControllers count]; count++)
    {
        
        switch (count)
        {
                
            case TabBarTpye_Contacts:
            {
                
                [self customizeContactsTabWithCount:count withHeight:height];
                
            }
                break;
            case TabBarTpye_Groji:
            {
                
                [self customizeGrojiTabWithCount:count withHeight:height];
                
            }
                break;
            case TabBarTpye_Profile:
            {
                
                [self customizeProfileTabWithCount:count withHeight:height];
            }
                break;
            case TabBarTpye_Chat:
            {
                [self customizeChatTabWithCount:count withHeight:height];
                
            }
                break;
            case TabBarTpye_Notifications:
            {
                [self customizeNotificationsTabWithCount:count withHeight:height];
                
            }
                break;
        }
        
    }
}



#pragma mark - Tab Customization View Creation

//Contact TabBar Cusomization
- (void)customizeContactsTabWithCount :(NSInteger)count withHeight:(float)height
{
    CGRect tabBarRect = self.tabBar.frame;
    NSInteger buttonCount = self.tabBar.items.count;
    CGFloat containingWidth = tabBarRect.size.width/buttonCount;
    float x = containingWidth * count;
    UIView *itemViewContacts = [UIView new];
    
    itemViewContacts.frame = CGRectMake(x, 0, containingWidth, height);
    
    itemViewContacts.backgroundColor = [self getContactsBGColor];
    UIImageView *iconImageView = [[UIImageView alloc] initWithFrame:itemViewContacts.bounds];
    iconImageView.image = [UIImage imageNamed:TabContactsImage];
    [itemViewContacts addSubview:iconImageView];
    UITabBar *tBar = self.tabBar;
    [tBar insertSubview:itemViewContacts atIndex:TabBarTpye_Contacts];
}

- (void)customizeGrojiTabWithCount :(NSInteger)count withHeight:(float)height
{
    CGRect tabBarRect = self.tabBar.frame;
    NSInteger buttonCount = self.tabBar.items.count;
    CGFloat containingWidth = tabBarRect.size.width/buttonCount;
    
    float x = containingWidth * count;
    UIView *itemViewGroji = [UIView new];
    
    itemViewGroji.frame = CGRectMake(x, 0, containingWidth, height);
    
    itemViewGroji.backgroundColor = [self getGrojiBGColor];
    UIImageView *iconImageView = [[UIImageView alloc] initWithFrame:itemViewGroji.bounds];
    iconImageView.image = [UIImage imageNamed:TabGrojiImage];
    [itemViewGroji addSubview:iconImageView];
    UITabBar *tBar = self.tabBar;
    [tBar insertSubview:itemViewGroji atIndex:TabBarTpye_Groji];
}


- (void)customizeProfileTabWithCount:(NSInteger)count withHeight:(float)height
{
    
    CGRect tabBarRect = self.tabBar.frame;
    NSInteger buttonCount = self.tabBar.items.count;
    CGFloat containingWidth = tabBarRect.size.width/buttonCount;
    float x = containingWidth * count;
    
    UIView *itemView = [UIView new];
    
    itemView.frame = CGRectMake(x, 0, containingWidth, height);
    
    itemView.backgroundColor = [self getProfileBGColor];
    UIImageView *iconImageView = [[UIImageView alloc] initWithFrame:itemView.bounds];
    iconImageView.image = [UIImage imageNamed:TabProfileImage];
    [itemView addSubview:iconImageView];
    UITabBar *tBar = self.tabBar;
    [tBar insertSubview:itemView atIndex:TabBarTpye_Profile];
}


- (void)customizeChatTabWithCount:(NSInteger)count withHeight:(float)height
{
    CGRect tabBarRect = self.tabBar.frame;
    NSInteger buttonCount = self.tabBar.items.count;
    CGFloat containingWidth = tabBarRect.size.width/buttonCount;
    float x = containingWidth * count;
    
    UIView *itemView = [UIView new];
    
    itemView.frame = CGRectMake(x, 0, containingWidth, height);
    
    itemView.backgroundColor = [self getChatsBGColor];
    UIImageView *iconImageView = [[UIImageView alloc] initWithFrame:itemView.bounds];
    iconImageView.image = [UIImage imageNamed:TabChatImage];
    [itemView addSubview:iconImageView];
    UITabBar *tBar = self.tabBar;
    [tBar insertSubview:itemView atIndex:TabBarTpye_Chat];
}


- (void)customizeNotificationsTabWithCount:(NSInteger)count withHeight:(float)height
{
    CGRect tabBarRect = self.tabBar.frame;
    NSInteger buttonCount = self.tabBar.items.count;
    CGFloat containingWidth = tabBarRect.size.width/buttonCount;
    float x = containingWidth * count;
    
    UIView *itemView = [UIView new];
    
    itemView.frame = CGRectMake(x, 0, containingWidth, height);
    
    itemView.backgroundColor = [self getNotificationsBGColor];
    UIImageView *iconImageView = [[UIImageView alloc] initWithFrame:itemView.bounds];
    iconImageView.image = [UIImage imageNamed:TabNotificationsImage];
    [itemView addSubview:iconImageView];
    UITabBar *tBar = self.tabBar;
    [tBar insertSubview:itemView atIndex:TabBarTpye_Notifications];
}


#pragma mark - Tabs Background Color
- (UIColor *)getContactsBGColor
{
    return [UIColor colorWithRed:(137/255.0f) green:(112/255.0f) blue:(219/255.0f) alpha:1.0];
}
- (UIColor *)getGrojiBGColor
{
    return [UIColor colorWithRed:(251/255.0f) green:(240/255.0f) blue:(123/255.0f) alpha:1.0];
}
- (UIColor *)getProfileBGColor
{
    return [UIColor colorWithRed:(200/255.0f) green:(85/255.0f) blue:(128/255.0f) alpha:1.0];
}
- (UIColor *)getChatsBGColor
{
    return [UIColor colorWithRed:(221/255.0f) green:(160/255.0f) blue:(119/255.0f) alpha:1.0];
}
- (UIColor *)getNotificationsBGColor
{
    return [UIColor colorWithRed:(98/255.0f) green:(221/255.0f) blue:(171/255.0f) alpha:1.0];
}

@end
