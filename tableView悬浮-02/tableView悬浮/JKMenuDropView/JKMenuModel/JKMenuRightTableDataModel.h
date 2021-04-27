//
//  JKMenuRightTableDataModel.h
//  JKMenuDrop
//
//  Created by apple on 2017/2/22.
//  Copyright © 2017年 com.shichuang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JKMenuRightTableDataModel : NSObject

/**每一个筛选条目的Item*/
@property (nonatomic,copy) NSString * title;

/**Item是否被选中*/
@property (nonatomic,assign) BOOL isSelectedItem;

@end
