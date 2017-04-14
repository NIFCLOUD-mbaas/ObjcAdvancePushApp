//
//  AppDelegate.h
//  ObjcAdvancePushApp
//
//  Created by NIFTY on 2016/07/27.
//  Copyright 2017 FUJITSU CLOUD TECHNOLOGIES LIMITED All Rights Reserved.
//

#import <UIKit/UIKit.h>
#import <NCMB/NCMB.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
// mBaaSから取得した「Shop」クラスのデータ格納用
@property (nonatomic) NSArray *shopList;
// mBaaSから取得した「User」情報データ格納用
@property (nonatomic) NCMBUser *current_user;
// お気に入り情報一時格納用
@property (nonatomic) NSMutableArray *favoriteObjectIdTemporaryArray;

@end

