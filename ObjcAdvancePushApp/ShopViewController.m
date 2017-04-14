//
//  ShopViewController.m
//  ObjcAdvancePushApp
//
//  Created by FJCT on 2016/07/27.
//  Copyright 2017 FUJITSU CLOUD TECHNOLOGIES LIMITED All Rights Reserved.
//

#import "ShopViewController.h"
#import <NCMB/NCMB.h>
#import "AppDelegate.h"

@interface ShopViewController ()
// Shop画像を表示するView
@property (weak,nonatomic) IBOutlet UIImageView *shopView;
// お気に入りBarButtonItem
@property (weak,nonatomic) IBOutlet UIBarButtonItem *favoriteBarButton;
// AppDelegate
@property (nonatomic) AppDelegate *appDelegate;

@end

@implementation ShopViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // AppDelegate
    self.appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    // 【mBaaS：ファイルストア②】Shop画像の取得
    // 取得した「Shop」クラスデータからShop画面用の画像名を取得
    NSString *imageName = [self.appDelegate.shopList[self.shopIndex] objectForKey:@"shop_image"];
    // ファイル名を設定
    NCMBFile *imageFile = [NCMBFile fileWithName:imageName data:nil];
    // ファイルを検索
    [imageFile getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
        if (error) {
            // ファイル取得失敗時の処理
            NSLog(@"Shop画像の取得に失敗しました:%ld",(long)error.code);
        } else {
            // ファイル取得成功時の処理
            NSLog(@"Shop画像の取得に成功しました");
            // AppDelegateに「Shop」クラスの情報を保持
            self.shopView.image = [UIImage imageWithData:data];
            // shopViewをViewに追加
            [self.view addSubview:self.shopView];
        }
    }];
    
    // お気に入りBarButtonItemの初期設定
    self.favoriteBarButton.image = [UIImage imageNamed:@"favorite_off"];
    self.favoriteBarButton.tag = 0;
    NSArray *favoriteObjectIdArray = [self.appDelegate.current_user objectForKey:@"favorite"];
    // お気に入り登録されている場合の設定
    for (NSString *objId in favoriteObjectIdArray) {
        NCMBObject *object = self.appDelegate.shopList[self.shopIndex];
        if ([objId isEqualToString:object.objectId]) {
            self.favoriteBarButton.image = [UIImage imageNamed:@"favorite_on"]; // 「♥」
            self.favoriteBarButton.tag = 1;
        }
    }
}

// 「お気に入り」ボタン押下時の処理
- (IBAction)tapFavoriteBtn:(UIBarButtonItem *)sender {
    NSMutableArray *favoriteObjectIdArray = [self.appDelegate.current_user objectForKey:@"favorite"];
    NCMBObject *object = self.appDelegate.shopList[self.shopIndex];
    NSString *objId = object.objectId;
    // お気に入り状況に応じて処理
    if (sender.tag == 0) {
        sender.image = [UIImage imageNamed:@"favorite_on"]; // 「♥」
        sender.tag = 1;
        // 追加
        [favoriteObjectIdArray addObject:objId];
    } else {
        sender.image = [UIImage imageNamed:@"favorite_off"]; // 「♡」
        sender.tag = 0;
        // 削除
        [favoriteObjectIdArray removeObject:objId];
    }
    // 【mBaaS：会員管理⑤】ユーザー情報の更新
    // ログイン中のユーザーを取得
    NCMBUser *user = [NCMBUser currentUser];
    // 更新された値を設定
    [user setObject:favoriteObjectIdArray forKey:@"favorite"];
    // ユーザー情報を更新
    [user saveInBackgroundWithBlock:^(NSError *error) {
        if (error) {
            // 更新に失敗した場合の処理
            NSLog(@"お気に入り情報更新に失敗しました:%ld",(long)error.code);
            // お気に入り状況に応じて処理
            if (sender.tag == 0) {
                sender.image = [UIImage imageNamed:@"favorite_on"]; // 「♥」
                sender.tag = 1;
                // 追加
                [favoriteObjectIdArray addObject:objId];
            } else {
                sender.image = [UIImage imageNamed:@"favorite_off"]; // 「♡」
                sender.tag = 0;
                // 削除
                [favoriteObjectIdArray removeObject:objId];
            }
        } else {
            // 更新に成功した場合の処理
            NSLog(@"お気に入り情報更新に成功しました");
            // AppDelegateに保持していたユーザー情報の更新
            self.appDelegate.current_user = user;
            // 【mBaaS：プッシュ通知⑤】installationにユーザー情報を紐づける
            NCMBInstallation *installation = [NCMBInstallation currentInstallation];
            if (installation) {
                // お気に入り情報を設定
                [installation setObject:favoriteObjectIdArray forKey:@"favorite"];
                // installation情報の更新
                [installation saveInBackgroundWithBlock:^(NSError *error) {
                    if (error) {
                        // installation更新失敗時の処理
                        NSLog(@"installation更新(お気に入り)に失敗しました:%ld",(long)error.code);
                    } else {
                        // installation更新成功時の処理
                        NSLog(@"installation更新(お気に入り)に成功しました");
                    }
                }];
            }
        }
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
