//
//  LocalNotificationManager.m
//  ObjcAdvancePushApp
//
//  Created by FJCT on 2016/08/02.
//  Copyright 2017 FUJITSU CLOUD TECHNOLOGIES LIMITED All Rights Reserved.
//

#import <UIKit/UIKit.h>
#import "LocalNotificationManager.h"

@implementation LocalNotificationManager

// ローカルプッシュを設定する
+(void) scheduleLocalNotificationAtData:(NSDate *)deliveryTime alertBody:(NSString *)alertBody userInfo:(NSDictionary *)userInfo {
    // 配信時間を今より過去に設定しない
    if (deliveryTime.timeIntervalSinceNow <= 0) {
        NSLog(@"配信設定時間が過ぎています");
        return;
    }
    // ローカルプッシュの作成
    UILocalNotification *localNotification = [[UILocalNotification alloc] init];
    // 表示時間の設定
    localNotification.fireDate = deliveryTime;
    localNotification.timeZone = [NSTimeZone localTimeZone];
    // 表示されるメッセージの設定
    localNotification.alertBody = alertBody;
    // 作成したローカルプッシュを設定
    [[UIApplication sharedApplication]scheduleLocalNotification:localNotification];
}

@end
