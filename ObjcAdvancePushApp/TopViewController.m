//
//  TopViewController.m
//  ObjcAdvancePushApp
//
//  Created by NIFTY on 2016/07/27.
//  Copyright © 2016年 NIFTY Corporation. All rights reserved.
//

#import "TopViewController.h"
#import <NCMB/NCMB.h>
#import "AppDelegate.h"
#import "CustomCell.h"
#import "ShopViewController.h"

@interface TopViewController ()<UITextFieldDelegate, UITableViewDelegate, UITableViewDataSource>
// ニックネーム表示用ラベル
@property (weak,nonatomic) IBOutlet UILabel *nicknameLabel;
// Shop一覧表示用テーブル
@property (weak,nonatomic) IBOutlet UITableView *shopTableView;
// AppDelegate
@property (nonatomic) AppDelegate *appDelegate;

/** ▼初回ユーザー情報登録画面用▼ **/
@property (nonatomic) UIView *registerView;
@property (nonatomic) UILabel *viewLabel;
@property (nonatomic) UITextField *nickname;
@property (nonatomic) UITextField *prefecture;
@property (nonatomic) UISegmentedControl *genderSegCon;
/** ▲初回ユーザー情報登録画面用▲**/

@end
// テーブル表示件数
const NSInteger NUMBER_OF_SHOPS_TOP = 4;
// 初回ユーザー情報登録画面用
static NSArray *GENDER_CONFIG = nil;
@implementation TopViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // tableViewの設定
    self.shopTableView.delegate = self;
    self.shopTableView.dataSource = self;
    // AppDelegate
    self.appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    // 初回ユーザー情報登録画面用
    GENDER_CONFIG = @[@"男性", @"女性"];
    // ユーザー情報が未登録の場合
    if (![self.appDelegate.current_user objectForKey:@"nickname"]) {
        // ユーザー情報登録Viewを表示
        [self userRegisterView];
    } else {
        self.nicknameLabel.text = [NSString stringWithFormat:@"%@さん、こんにちは！",[self.appDelegate.current_user objectForKey:@"nickname"]];
        // 画面更新
        [self checkShop];
    }
    
}

//　mBaaSに登録されているShop情報を取得してテーブルに表示する
- (void)checkShop {
    // 【mBaaS：データストア】「Shop」クラスのデータを取得
    // 「Shop」クラスのクエリを作成
    NCMBQuery *query = [NCMBQuery queryWithClassName:@"Shop"];
    // データストアを検索
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (error) {
            // 検索失敗時の処理
            NSLog(@"検索に失敗しました:%ld",(long)error.code);
        } else {
            // 検索成功時の処理
            NSLog(@"検索に成功しました");
            // AppDelegateに「Shop」クラスの情報を保持
            self.appDelegate.shopList = objects;
            // テーブルの更新
            [self.shopTableView reloadData];
        }
    }];
}

// shopTableViewのセル表示数を設定
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return NUMBER_OF_SHOPS_TOP;
}
// shopTableViewのセルの内容を設定
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    // cellデータを取得
    CustomCell *cell = (CustomCell *)[tableView dequeueReusableCellWithIdentifier:@"shopTableCell" forIndexPath:indexPath];
    // cell
    
    // 「表示件数」＜「取得件数」の場合objectを作成
    NCMBObject *object;
    if (indexPath.row < [self.appDelegate.shopList count]) {
        object = self.appDelegate.shopList[indexPath.row];
    }
    // cellにデータを設定
    if (object) {
        [cell setCell_top:object];
    }
    
    return cell;
}

// cellを選択したときの処理
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // 画面遷移
    [self performSegueWithIdentifier:@"toShopPage" sender:[NSNumber numberWithInteger:indexPath.row]];
}

// segueの設定（全てのsegueで呼ばれるメソッド）
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // ShopViewへ画面遷移（toShopPage）する場合の処理
    if ([segue.identifier isEqualToString:@"toShopPage"]) {
        // TableViewのindex.rowの値をShopViewへ渡す
        ShopViewController *shopViewController = (ShopViewController *)segue.destinationViewController;
        shopViewController.shopIndex = [sender intValue];
    }
}

// 「ログアウト」ボタン押下時の処理
- (IBAction)logOut:(UIBarButtonItem *)sender {
    // ログアウト
    [NCMBUser logOut];
    // 画面を閉じる
    [self dismissViewControllerAnimated:YES completion:nil];
}

/** ▼初回ユーザー情報登録画面の処理▼ **/
// ユーザー情報登録画面の作成
- (void)userRegisterView {
    // Viewを生成
    self.registerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height)];
    // 背景を黒に設定
    self.registerView.backgroundColor = [UIColor blackColor];
    // titleLabelを生成
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake((self.view.bounds.size.width/2)*0.3, (self.view.bounds.size.height)*0.18, (self.view.bounds.size.width)*0.7, 45)];
    titleLabel.text = @"♡ユーザー情報登録♡";
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.font = [UIFont boldSystemFontOfSize:25];
    // nicknameLabelを生成
    UILabel *nicknameLabel = [[UILabel alloc]initWithFrame:CGRectMake((self.view.bounds.size.width/2)*0.35, (self.view.bounds.size.height)*0.29, 75, 20)];
    nicknameLabel.text = @"ニックネーム";
    nicknameLabel.textAlignment = NSTextAlignmentLeft;
    nicknameLabel.textColor = [UIColor whiteColor];
    nicknameLabel.font = [UIFont boldSystemFontOfSize:10];
    // nicknameを生成
    self.nickname = [[UITextField alloc]initWithFrame:CGRectMake((self.view.bounds.size.width/2)*0.35, (self.view.bounds.size.height)*0.33, (self.view.bounds.size.width)*0.65, 30)];
    self.nickname.borderStyle = UITextBorderStyleRoundedRect;
    self.nickname.font = [UIFont systemFontOfSize:14];
    self.nickname.backgroundColor = [UIColor whiteColor];
    self.nickname.delegate = self;
    // genderLabelを生成
    UILabel *genderLabel = [[UILabel alloc]initWithFrame:CGRectMake((self.view.bounds.size.width/2)*0.35, (self.view.bounds.size.height)*0.40, 75, 20)];
    genderLabel.text = @"性別";
    genderLabel.textAlignment = NSTextAlignmentLeft;
    genderLabel.textColor = [UIColor whiteColor];
    genderLabel.font = [UIFont boldSystemFontOfSize:10];
    
    self.genderSegCon = [[UISegmentedControl alloc]initWithItems:GENDER_CONFIG];
    self.genderSegCon.frame = CGRectMake((self.view.bounds.size.width/2)*0.35, (self.view.bounds.size.height)*0.44, (self.view.bounds.size.width)*0.65, 30);
    [self.genderSegCon addTarget:self action:@selector(segConChanged:) forControlEvents:UIControlEventValueChanged];
    self.genderSegCon.tintColor = [UIColor colorWithRed:0.243 green:0.627 blue:0.929 alpha:1];
    // prefectureLabelを生成
    UILabel *prefectureLabel = [[UILabel alloc]initWithFrame:CGRectMake((self.view.bounds.size.width/2)*0.35, (self.view.bounds.size.height)*0.52, 75, 20)];
    prefectureLabel.text = @"都道府県";
    prefectureLabel.textAlignment = NSTextAlignmentLeft;
    prefectureLabel.textColor = [UIColor whiteColor];
    prefectureLabel.font = [UIFont boldSystemFontOfSize:10];
    // prefectureを生成
    self.prefecture = [[UITextField alloc]initWithFrame:CGRectMake((self.view.bounds.size.width/2)*0.35, (self.view.bounds.size.height)*0.56, (self.view.bounds.size.width)*0.65, 30)];
    self.prefecture.borderStyle = UITextBorderStyleRoundedRect;
    self.prefecture.font = [UIFont systemFontOfSize:14];
    self.prefecture.backgroundColor = [UIColor whiteColor];
    self.prefecture.delegate = self;
    // viewLabelを生成
    self.viewLabel = [[UILabel alloc]initWithFrame:CGRectMake((self.view.bounds.size.width/2)*0.35, (self.view.bounds.size.height)*0.65, (self.view.bounds.size.width)*0.65, 30)];
    self.viewLabel.font = [UIFont systemFontOfSize:15];
    self.viewLabel.textColor = [UIColor whiteColor];
    self.viewLabel.textAlignment = NSTextAlignmentCenter;
    // registerButtonを生成
    UIButton *regsterButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 115, 48)];
    regsterButton.center = CGPointMake(self.view.bounds.size.width/2, (self.view.bounds.size.height)*0.8);
    [regsterButton setImage:[UIImage imageNamed:@"setup"] forState:UIControlStateNormal];
    [regsterButton addTarget:self action:@selector(userInfoRegister:) forControlEvents:UIControlEventTouchUpInside];
    // gestureを生成
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapScreen:)];
    // Viewに設定
    [self.view addSubview:self.registerView];
    [self.registerView addSubview:titleLabel];
    [self.registerView addSubview:nicknameLabel];
    [self.registerView addSubview:self.nickname];
    [self.registerView addSubview:self.genderSegCon];
    [self.registerView addSubview:genderLabel];
    [self.registerView addSubview:prefectureLabel];
    [self.registerView addSubview:self.prefecture];
    [self.registerView addSubview:self.viewLabel];
    [self.registerView addSubview:regsterButton];
    [self.registerView addGestureRecognizer:tapGestureRecognizer];
    
}

// genderSegConの値が変わったときに呼び出されるメソッド
- (void)segConChanged:(UISegmentedControl *)sender {
    switch (sender.selectedSegmentIndex) {
        case 0:
            NSLog(@"男性");
            break;
        case 1:
            NSLog(@"女性");
            break;
        default:
            NSLog(@"NG");
            break;
    }
}

// 「登録」ボタン押下時の処理
- (void)userInfoRegister:(UIButton *)sender {
    // キーボードを閉じる
    [self closeKeyboad];
    // 入力確認
    if ([self.nickname.text isEqualToString:@""] || [self.prefecture.text isEqualToString:@""] || [self.genderSegCon selectedSegmentIndex] == -1) {
        self.viewLabel.text = @"未入力の項目があります";
        return;
    }
    // 【mBaaS：会員管理③】ユーザー情報更新
    // ログイン中のユーザーを取得
    NCMBUser *user = [NCMBUser currentUser];
    // ユーザー情報を設定
    [user setObject:self.nickname.text forKey:@"nickname"];
    [user setObject:GENDER_CONFIG[self.genderSegCon.selectedSegmentIndex] forKey:@"gender"];
    [user setObject:self.prefecture.text forKey:@"prefecture"];
    [user setObject:[NSArray new] forKey:@"favorite"];
    // user情報の更新
    [user saveInBackgroundWithBlock:^(NSError *error) {
        if (error) {
            // 更新失敗時の処理
            NSLog(@"ユーザー情報更新に失敗しました:%ld",(long)error.code);
            self.viewLabel.text = [NSString stringWithFormat:@"登録に失敗しました（更新）:%ld",(long)error.code];
        } else {
            // 更新成功時の処理
            NSLog(@"ユーザー情報更新に成功しました");
            // AppDelegateに保持していたユーザー情報の更新
            self.appDelegate.current_user = user;
            // 【mBaaS：プッシュ通知③】installationにユーザー情報を紐づける
            // 使用中端末のinstallation取得
            NCMBInstallation *installation = [NCMBInstallation currentInstallation];
            if (installation) {
                // ユーザー情報を設定
                [installation setObject:self.nickname.text forKey:@"nickname"];
                [installation setObject:GENDER_CONFIG[self.genderSegCon.selectedSegmentIndex] forKey:@"gender"];
                [installation setObject:self.prefecture.text forKey:@"prefecture"];
                [installation setObject:[NSArray new] forKey:@"favorite"];
                // installation情報の更新
                [installation saveInBackgroundWithBlock:^(NSError *error) {
                    if (error) {
                        // installation更新失敗時の処理
                        NSLog(@"installation更新(ユーザー登録)に失敗しました:%ld",(long)error.code);
                    } else {
                        // installation更新成功時の処理
                        NSLog(@"installation更新(ユーザー登録)に成功しました");
                        // 画面を閉じる
                        self.registerView.hidden = YES;
                        // ニックネーム表示用ラベルの更新
                        self.nicknameLabel.text = [NSString stringWithFormat:@"%@さん、こんにちは！",[self.appDelegate.current_user objectForKey:@"nickname"]];
                        // 画面更新
                        [self checkShop];
                    }
                }];
            }
        }
    }];
}
/** ▲初回ユーザー情報登録画面の処理▲ **/

// 背景タップ時にキーボードを隠す
- (void)tapScreen:(UITapGestureRecognizer *)sencder {
    [self.view endEditing:YES];
}

// キーボードを閉じる
- (void)closeKeyboad {
    [self.nickname resignFirstResponder];
    [self.prefecture resignFirstResponder ];
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
