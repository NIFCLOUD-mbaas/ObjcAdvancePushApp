//
//  LocalNotificationManager.h
//  ObjcAdvancePushApp
//
//  Created by oono on 2016/08/02.
//  Copyright © 2016年 Nifty. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LocalNotificationManager : NSObject
// ローカルプッシュを設定する
+(void) scheduleLocalNotificationAtData:(NSDate *)deliveryTime alertBody:(NSString *)alertBody userInfo:(NSDictionary *)userInfo;

@end
