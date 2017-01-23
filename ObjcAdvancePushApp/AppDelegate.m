//
//  AppDelegate.m
//  ObjcAdvancePushApp
//
//  Created by NIFTY on 2016/07/27.
//  Copyright © 2016年 NIFTY Corporation. All rights reserved.
//

#import "AppDelegate.h"
#import "LocalNotificationManager.h"

@interface AppDelegate ()

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // 【mBaaS】 APIキーの設定とSDKの初期化
    [NCMB setApplicationKey:@"YOUR_NCMB_APPLICATIONKEY"
                  clientKey:@"YOUR_NCMB_CLIENTKEY"];
    
    // 【mBaaS：プッシュ通知①】デバイストークンの取得
    // デバイストークンの要求
    if (NSFoundationVersionNumber > NSFoundationVersionNumber_iOS_7_1){
        /** iOS8以上 **/
        //通知のタイプを設定したsettingを用意
        UIUserNotificationType type = UIUserNotificationTypeAlert |
        UIUserNotificationTypeBadge |
        UIUserNotificationTypeSound;
        UIUserNotificationSettings *setting;
        setting = [UIUserNotificationSettings settingsForTypes:type
                                                    categories:nil];
        //通知のタイプを設定
        [[UIApplication sharedApplication] registerUserNotificationSettings:setting];
        //DevoceTokenを要求
        [[UIApplication sharedApplication] registerForRemoteNotifications];
    } else {
        /** iOS8未満 **/
        [[UIApplication sharedApplication] registerForRemoteNotificationTypes:
         (UIRemoteNotificationTypeAlert |
          UIRemoteNotificationTypeBadge |
          UIRemoteNotificationTypeSound)];
    }
    
    NSDictionary *remoteNotification = [launchOptions objectForKey:@"UIApplicationLaunchOptionsRemoteNotificationKey"];
    if (remoteNotification) {
        // 【mBaaS：プッシュ通知⑥】リッチプッシュ通知を表示させる処理
        [NCMBPush handleRichPush:remoteNotification];
        
        // 【mBaaS：プッシュ通知⑧】アプリが起動されたときにプッシュ通知の情報（ペイロード）からデータを取得する
        // プッシュ通知情報の取得
        NSString *deliveryTime = [remoteNotification objectForKey:@"deliveryTime"];
        NSString *message = [remoteNotification objectForKey:@"message"];
        if (deliveryTime && message) {
            // ローカルプッシュ配信
            [self localNotificationDeliver:deliveryTime message:message];
        }
    }
    
    return YES;
}

// 【mBaaS：プッシュ通知②】デバイストークンの取得後に呼び出されるメソッド
- (void)application:(UIApplication*)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData*)deviceToken{
    // 端末情報を扱うNCMBInstallationのインスタンスを作成
    NCMBInstallation *installation = [NCMBInstallation currentInstallation];
    // デバイストークンを設定
    [installation setDeviceTokenFromData:deviceToken];
    // 端末情報をデータストアに登録
    [installation saveInBackgroundWithBlock:^(NSError *error) {
        if(error){
            // 端末情報の登録に失敗した時の処理
            NSLog(@"デバイストークン取得に失敗しました:%ld",(long)error.code);
        } else {
            // 端末情報の登録に成功した時の処理
            NSLog(@"デバイストークン取得に成功しました");
        }
    }];
}

// 【mBaaS：プッシュ通知⑦】アプリが起動中にプッシュ通知の情報（ペイロード）からデータを取得する
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    // プッシュ通知情報の取得
    NSString *deliveryTime = [userInfo objectForKey:@"deliveryTime"];
    NSString *message = [userInfo objectForKey:@"message"];
    // 値を取得した後の処理
    if (deliveryTime && message) {
        NSLog(@"ペイロードを取得しました：deliveryTime[%@],message[%@]",deliveryTime,message);
        // ローカルプッシュ配信
        [self localNotificationDeliver:deliveryTime message:message];
    }
}

// プッシュ通知が許可された場合に呼ばれるメソッド
- (void)application:(UIApplication *)application didRegisterUserNotificationSettings:(UIUserNotificationSettings *)notificationSettings {
    UIUserNotificationType allowedType = notificationSettings.types;
    switch (allowedType) {
        case UIUserNotificationTypeNone:
            NSLog(@"端末側でプッシュ通知が拒否されました");
            break;
        default:
            NSLog(@"端末側でプッシュ通知が許可されました");
            break;
    }
}

// LocalNotification配信
- (void)localNotificationDeliver:(NSString *)deliveryTime message:(NSString *)message {
    // 配信時間(String→NSDate)を設定
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    NSDate *deliveryTimeDate = [formatter dateFromString:deliveryTime];
    // ローカルプッシュを作成
    [LocalNotificationManager scheduleLocalNotificationAtData:deliveryTimeDate alertBody:message userInfo:nil];
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
