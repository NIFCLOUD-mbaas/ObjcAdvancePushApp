//
//  CustomCell.h
//  ObjcAdvancePushApp
//
//  Created by FJCT on 2016/07/27.
//  Copyright 2017 FUJITSU CLOUD TECHNOLOGIES LIMITED All Rights Reserved.
//

#import <UIKit/UIKit.h>
#import <NCMB/NCMB.h>

@interface CustomCell : UITableViewCell
/** Top画面のTableViewのcell **/
- (void)setCell_top:(NCMBObject *)object;
/** お気に入り画面のTableViewのcell **/
- (void)setCell_favorite:(NCMBObject *)object;
@end
