//
//  FavoriteViewController.m
//  ObjcAdvancePushApp
//
//  Created by FJCT on 2016/07/27.
//  Copyright 2017 FUJITSU CLOUD TECHNOLOGIES LIMITED All Rights Reserved.
//

#import "FavoriteViewController.h"
#import <NCMB/NCMB.h>
#import "AppDelegate.h"
#import "CustomCell.h"

@interface FavoriteViewController ()<UITableViewDelegate, UITableViewDataSource>
// お気に入り一覧表示用テーブル
@property (weak,nonatomic) IBOutlet UITableView *favoriteTableView;
// ステータス表示用ラベル
@property (weak,nonatomic) IBOutlet UILabel *statusLabel;
// 変更前のお気に入り情報保管用
@property (nonatomic) NSArray *temporaryArray;
// AppDelegate
@property (nonatomic) AppDelegate *appDelegate;

@end

// テーブル表示件数
const NSInteger NUMBER_OF_SHOPS_FAVORITE = 4;

@implementation FavoriteViewController

// インスタンス化された直後、初回のみ実行されるメソッド
- (void)viewDidLoad {
    [super viewDidLoad];
    // AppDelegate
    self.appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    // favoriteObjectIdTemporaryArrayにuserのお気に入り情報を設定
    self.appDelegate.favoriteObjectIdTemporaryArray = [self.appDelegate.current_user objectForKey:@"favorite"];
    // バックアップ
    self.temporaryArray = [self.appDelegate.current_user objectForKey:@"favorite"];
    // tableViewの設定
    self.favoriteTableView.delegate = self;
    self.favoriteTableView.dataSource = self;
}

// favoriteTableViewのセル表示数を設定
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return NUMBER_OF_SHOPS_FAVORITE;
}
// favoriteTableViewのセルの内容を設定
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    // cellデータを取得
    CustomCell *cell = (CustomCell *)[tableView dequeueReusableCellWithIdentifier:@"favoriteTableCell" forIndexPath:indexPath];
    // 「表示件数」＜「取得件数」の場合objectを作成
    NCMBObject *object;
    if (indexPath.row < [self.appDelegate.shopList count]) {
        object = self.appDelegate.shopList[indexPath.row];
    }
    // cellにデータを設定
    if (object) {
        [cell setCell_favorite:object];
    }
    
    return cell;
}

- (IBAction)savefavorite:(UIButton *)sender {
    // 【mBaaS：会員管理④】ユーザー情報の更新
    // ログイン中のユーザーを取得
    NCMBUser *user = [NCMBUser currentUser];
    // 更新された値を設定
    [user setObject:self.appDelegate.favoriteObjectIdTemporaryArray forKey:@"favorite"];
    // ユーザー情報を更新
    [user saveInBackgroundWithBlock:^(NSError *error) {
        if (error) {
            // 更新に失敗した場合の処理
            NSLog(@"お気に入り情報更新に失敗しました:%ld",(long)error.code);
            self.statusLabel.text = [NSString stringWithFormat:@"お気に入り情報更新に失敗しました:%ld",(long)error.code];
            // 3秒後にstatusLabelを空にする
            int64_t deley = 3 * NSEC_PER_SEC;
            int64_t time = dispatch_time(DISPATCH_TIME_NOW, deley);
            dispatch_after(time, dispatch_get_main_queue(), ^(void){
                self.statusLabel.text = @"";
            });
            // AppDelegateに保持していたユーザー情報を戻す
            [user setObject:self.temporaryArray forKey:@"favorite"];
            self.appDelegate.current_user = user;
        } else {
            // 更新に成功した場合の処理
            NSLog(@"お気に入り情報更新に成功しました");
            self.statusLabel.text = @"お気に入り情報更新に成功しました";
            // 3秒後にstatusLabelを空にする
            int64_t deley = 3 * NSEC_PER_SEC;
            int64_t time = dispatch_time(DISPATCH_TIME_NOW, deley);
            dispatch_after(time, dispatch_get_main_queue(), ^(void){
                self.statusLabel.text = @"";
            });
            // AppDelegateに保持していたユーザー情報の更新
            self.appDelegate.current_user = user;
            // バックアップ
            self.temporaryArray = self.appDelegate.favoriteObjectIdTemporaryArray;
            // 【mBaaS：プッシュ通知④】installationにユーザー情報を紐づける
            NCMBInstallation *installation = [NCMBInstallation currentInstallation];
            if (installation) {
                // お気に入り情報を設定
                [installation setObject:self.appDelegate.favoriteObjectIdTemporaryArray forKey:@"favorite"];
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
