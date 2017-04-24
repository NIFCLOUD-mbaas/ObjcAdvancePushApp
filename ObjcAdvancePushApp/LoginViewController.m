//
//  LoginViewController.m
//  ObjcAdvancePushApp
//
//  Created by FJCT on 2016/07/27.
//  Copyright 2017 FUJITSU CLOUD TECHNOLOGIES LIMITED All Rights Reserved.
//

#import "LoginViewController.h"
#import <NCMB/NCMB.h>
#import "AppDelegate.h"

@interface LoginViewController ()<UITextFieldDelegate>
// メールアドレス入力欄
@property (weak,nonatomic) IBOutlet UITextField *address;
// パスワード入力欄
@property (weak,nonatomic) IBOutlet UITextField *password;
// ステータス表示用ラベル
@property (weak,nonatomic) IBOutlet UILabel *statusLabel;

@end

@implementation LoginViewController

// インスタンス化された直後、初回のみ実行されるメソッド
- (void)viewDidLoad {
    [super viewDidLoad];
    // TextFieldにdelegateを設定
    self.address.delegate = self;
    self.password.delegate = self;
    // Passwordをセキュリティ入力に設定
    self.password.secureTextEntry = YES;
    
}

// 「ログイン」ボタン押下時の処理
- (IBAction)login:(UIButton *)sender{
    // キーボードを閉じる
    [self closeKeyboad];
    // 入力確認
    if ([self.address.text isEqualToString:@""] || [self.password.text isEqualToString:@""]) {
        self.statusLabel.text = @"未入力の項目があります";
        // TextFieldを空に
        [self cleanTextField];
        
        return;
    }
    // 【mBaaS：会員管理②】メールアドレスとパスワードでログイン
    [NCMBUser logInWithMailAddressInBackground:self.address.text password:self.password.text block:^(NCMBUser *user, NSError *error) {
        if (error) {
            // ログイン失敗時の処理
            NSLog(@"ログインに失敗しました:%ld",(long)error.code);
            self.statusLabel.text = [NSString stringWithFormat:@"ログインに失敗しました:%ld",(long)error.code];
        } else {
            // ログイン成功時の処理
            NSLog(@"ログインに成功しました:%@",user.objectId);
            // AppDelegateにユーザー情報を保持
            AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
            appDelegate.current_user = user;
            // TextFieldを空にする
            [self cleanTextField];
            // statusLabelを空にする
            self.statusLabel.text = @"";
            // 画面遷移
            [self performSegueWithIdentifier:@"login" sender:self];
        }
    }];
}

// 「会員登録」ボタン押下時の処理
- (IBAction)toSignUp:(UIButton *)sender{
    // TextFieldを空にする
    [self cleanTextField];
    // statusLabelを空にする
    self.statusLabel.text = @"";
    // キーボードを閉じる
    [self closeKeyboad];
}

// 背景タップ時にキーボードを隠す
- (IBAction)tapScreen:(UITapGestureRecognizer *)sender{
    [self.view endEditing:YES];
}

// TextFieldを空にする
- (void)cleanTextField {
    self.address.text = @"";
    self.password.text = @"";
}

// キーボードを閉じる
- (void)closeKeyboad {
    [self.address resignFirstResponder];
    [self.password resignFirstResponder];
}

// キーボードの「Return」押下時の処理
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    // キーボードを閉じる
    [textField resignFirstResponder];
    
    return YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
