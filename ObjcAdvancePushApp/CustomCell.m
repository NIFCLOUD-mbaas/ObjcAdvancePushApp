//
//  CustomCell.m
//  ObjcAdvancePushApp
//
//  Created by NIFTY on 2016/07/27.
//  Copyright © 2016年 NIFTY Corporation. All rights reserved.
//

#import "CustomCell.h"
#import <NCMB/NCMB.h>
#import "AppDelegate.h"

@interface CustomCell ()
/** Top画面のTableViewのcell用 **/
// icon表示用ImageView
@property (weak,nonatomic) IBOutlet UIImageView *iconImageView_top;
// Shop名表示用ラベル
@property (weak,nonatomic) IBOutlet UILabel *shopName_top;
// カテゴリ表示用ラベル
@property (weak,nonatomic) IBOutlet UILabel *category_top;

/** お気に入り画面のTableViewのcell用 **/
// Shop名表示用ラベル
@property (weak,nonatomic) IBOutlet UILabel *shopName_favorite;
// お気に入りON/OFF設定用スイッチ
@property (weak,nonatomic) IBOutlet UISwitch *switch_favorite;
// スイッッチ選択時objectId一時保管用
@property (nonatomic) NSString *objectIdTemporary;

@end

@implementation CustomCell

/** Top画面のTableViewのcell **/
- (void)setCell_top:(NCMBObject *)object {
    // 【mBaaS：ファイルストア①】icon画像の取得
    // 取得した「Shop」クラスデータからicon名を取得
    NSString *imageName = [object objectForKey:@"icon_image"];
    // ファイル名を設定
    NCMBFile *imageFile = [NCMBFile fileWithName:imageName data:nil];
    [imageFile getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
        if (error) {
            // ファイル取得失敗時の処理
            NSLog(@"icon画像の取得に失敗しました:%ld",(long)error.code);
        } else {
            // ファイル取得成功時の処理
            NSLog(@"icon画像の取得に成功しました");
            // icon画像を設定
            self.iconImageView_top.image = [[UIImage alloc]initWithData:data];
        }
    }];
    
    // Shop名を設定
    self.shopName_top.text = [object objectForKey:@"name"];
    // categoryを設定
    self.category_top.text = [object objectForKey:@"category"];
}

/** お気に入り画面のTableViewのcell **/
- (void)setCell_favorite:(NCMBObject *)object {
    NSString *objId = object.objectId;
    //　Shop名を設定
    self.shopName_favorite.text = [object objectForKey:@"name"];
    // objectIdを保持
    self.objectIdTemporary = objId;
    // スイッチ選択時に実行されるメソッドの設定
    [self.switch_favorite addTarget:self action:@selector(switchChenged:) forControlEvents:UIControlEventValueChanged];
    // スイッチの初期設定
    self.switch_favorite.on = NO;
    // お気に入り登録されている場合はスイッチをONに設定
    // AppDelegate
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    NSArray *favoriteArray = [appDelegate.current_user objectForKey:@"favorite"];
    for (NSString *element in favoriteArray) {
        if ([element isEqualToString:objId]) {
            self.switch_favorite.on = YES;
        }
    }
}

// スイッチ選択時の処理
- (void)switchChenged:(UISwitch *)sender {
    // AppDelegate
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    if (sender.on) {
        // スイッチがONになったときの処理
        // 追加
        [appDelegate.favoriteObjectIdTemporaryArray addObject:self.objectIdTemporary];
    } else {
        // スイッチがOFFになったときの処理
        // 削除
        [appDelegate.favoriteObjectIdTemporaryArray removeObject:self.objectIdTemporary];
    }
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
