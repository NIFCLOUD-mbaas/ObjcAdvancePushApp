//
//  LocalNotificationManager.h
//  ObjcAdvancePushApp
//
//  Created by oono on 2016/08/02.
//  Copyright 2017 FUJITSU CLOUD TECHNOLOGIES LIMITED All Rights Reserved.
//

#import <Foundation/Foundation.h>

@interface LocalNotificationManager : NSObject
// ローカルプッシュを設定する
+(void) scheduleLocalNotificationAtData:(NSDate *)deliveryTime alertBody:(NSString *)alertBody userInfo:(NSDictionary *)userInfo;

@end
