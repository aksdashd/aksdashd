//
//  MGConstants.h
//  MyGrid
//
//  Created by Devashis on 19/03/16.
//  Copyright © 2016 Devashis. All rights reserved.
//

#import <Foundation/Foundation.h>

#define DEGREES_TO_RADIANS(angle) ((angle) / 180.0 * M_PI)

//Base tags for different circles
static NSInteger const BaseTagForFirstCicle = 1000;
static NSInteger const BaseTagForSecondCicle = 2000;
static NSInteger const BaseTagForThirdCicle = 3000;
static NSInteger const BaseTagForFourthCicle = 4000;

extern int const iPhone4Height;

extern int const iPhone5Height;

extern int const iPhone6Height;

extern int const iPhone6sHeight;

extern NSString *const MGCONTACTS;

extern NSString *const MGGROJI;

extern NSString *const MGCHAT;

extern NSString *const MGNOTIFICATIONS;

extern NSString *const MGPROFILE;

//Used in Contact Items Model
extern NSString *const MGITEMS;

extern NSString *const MGDISPLAYNAME;

extern NSString *const MGIMAGE;

extern NSString *const MGURL;

extern NSString *const MGID;

//Menu Items
extern NSString *const MGPEOPLENEARBY;
extern NSString *const MGMESSAGES;
extern NSString *const MGCREATENEWCIRCLE;
extern NSString *const MGMYGRID;
extern NSString *const MGINVITE;
extern NSString *const MGSETTINGS;
extern NSString *const MGLOGOUT;

//Parsing and Web Service Request
extern NSString *const MGOUTPUT;
extern NSString *const MGSTATUS;
extern NSString *const MGDATA;
extern NSString *const MGDISPLAY_NAME;
extern NSString *const MGUSER_ID;

//Circles
extern  NSString *const CIRCLE_ID;

//Initial Screen Like Invitations to SWIPE
extern NSString *const MGINVITATIONNOTIFICATION;
extern NSString *const CIRCLE_NAME;
extern NSString *const CIRCLE_IMAGE;

typedef NS_ENUM(NSInteger,MenuItem)
{
    MenuItem_PeopleNearBy,
    MenuItem_Mesages,
    MenuItem_CreateNewCircle,
    MenuItem_MyGrid,
    MenuItem_Invite,
    MenuItem_Settings,
    MenuItem_LogOut
};


typedef NS_ENUM(NSInteger,ContactTypes)
{
    ContactTypes_Facebook,
    ContactTypes_GooglePlus,
    ContactTypes_Contact
};

typedef NS_ENUM(NSInteger,TypeOfTable)
{
    TypeOfTable_SocialMediaOptions,
    TypeOfTable_SelectedContact
};

typedef NS_ENUM(NSInteger,TabBarTpye)
{
    TabBarTpye_Contacts,
    TabBarTpye_Groji,
    TabBarTpye_Profile,
    TabBarTpye_Chat,
    TabBarTpye_Notifications
};

typedef NS_ENUM(NSInteger,ButtonOptionType)
{
    ButtonOptionType_New,
    ButtonOptionType_Existing
};

