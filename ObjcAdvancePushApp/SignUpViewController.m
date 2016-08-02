//
//  SignUpViewController.m
//  ObjcAdvancePushApp
//
//  Created by NIFTY on 2016/07/27.
//  Copyright © 2016年 NIFTY Corporation. All rights reserved.
//

#import "SignUpViewController.h"
#import <NCMB/NCMB.h>

@interface SignUpViewController ()<UITextFieldDelegate>
// メールアドレス入力欄
@property (weak,nonatomic) IBOutlet UITextField *address;
// ステータス表示用ラベル
@property (weak,nonatomic) IBOutlet UILabel *statusLabel;

@end

@implementation SignUpViewController

// インスタンス化された直後、初回のみ実行されるメソッド
- (void)viewDidLoad {
    [super viewDidLoad];
    // TextFieldにdelegateを設定
    self.address.delegate = self;
}

// 「登録メールを送信」ボタン押下時の処理
- (IBAction)signUp:(UIButton *)sender{
    // キーボードを閉じる
    [self closeKeyboad];
    
    if ([self.address.text isEqualToString:@""]) {
        self.statusLabel.text = @"メールアドレスを入力してください";
        
        return;
    }
    
    // 【mBaaS：会員管理①】会員登録用メールを要求する
    [NCMBUser requestAuthenticationMailInBackground:self.address.text block:^(NSError *error) {
        if (error) {
            // ログイン失敗時の処理
            NSLog(@"エラーが発生しました:%ld",(long)error.code);
            self.statusLabel.text = [NSString stringWithFormat:@"エラーが発生しました:%ld",(long)error.code];
        } else {
            // ログイン成功時の処理
            NSLog(@"登録用メールを送信しました");
            self.statusLabel.text = @"登録用メールを送信しました";
            // TextFieldを空にする
            self.address.text = @"";
        }
    }];
}

// 背景タップ時にキーボードを隠す
- (IBAction)tapScreen:(UITapGestureRecognizer *)sender{
    [self.view endEditing:YES];
}

// キーボードを閉じる
- (void)closeKeyboad {
    [self.address resignFirstResponder];
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
