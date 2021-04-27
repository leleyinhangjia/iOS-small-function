//
//  JKMenuDataModel.m
//  JKMenuDrop
//
//  Created by apple on 2017/2/21.
//  Copyright © 2017年 com.shichuang. All rights reserved.
//

#import "JKMenuDataModel.h"
#import "JKMenuRightTableDataModel.h"
@implementation JKMenuDataModel

+ (NSDictionary *)mj_objectClassInArray {
    return @{@"rightTableData" : [JKMenuRightTableDataModel class]};
}

@end
