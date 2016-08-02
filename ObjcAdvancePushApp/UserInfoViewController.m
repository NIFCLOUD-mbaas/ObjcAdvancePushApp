//
//  UserInfoViewController.m
//  ObjcAdvancePushApp
//
//  Created by NIFTY on 2016/07/27.
//  Copyright © 2016年 NIFTY Corporation. All rights reserved.
//

#import "UserInfoViewController.h"
#import "AppDelegate.h"

@interface UserInfoViewController ()
// メールアドレス表示用ラベル
@property (weak,nonatomic) IBOutlet UILabel *mailAddress;
// ニックネーム表示用ラベル
@property (weak,nonatomic) IBOutlet UILabel *nickname;
// 性別表示用ラベル
@property (weak,nonatomic) IBOutlet UILabel *gender;
// 都道府県表示用ラベル
@property (weak,nonatomic) IBOutlet UILabel *prefecture;

@end

@implementation UserInfoViewController

// インスタンス化された直後、初回のみ実行されるメソッド
- (void)viewDidLoad {
    [super viewDidLoad];
    // 各ラベルに値を設定
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    self.mailAddress.text = [appDelegate.current_user objectForKey:@"mailAddress"];
    self.nickname.text = [appDelegate.current_user objectForKey:@"nickname"];
    self.gender.text = [appDelegate.current_user objectForKey:@"gender"];
    self.prefecture.text = [appDelegate.current_user objectForKey:@"prefecture"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
