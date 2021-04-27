//
//  JKMenuDropView.h
//  JKMenuDrop
//
//  Created by apple on 2017/2/21.
//  Copyright © 2017年 com.shichuang. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, JKMenuItemType) {
    JKMenuItemTypeSingle = 0,          /**一个tableView*/
    JKMenuItemTypeCouple              /**两个TableVeiw*/
};

@protocol JKMenuDropViewDelegate <NSObject>

@required
/**
 一共有几个Btn

 @return Btn的个数
 */
- (NSInteger)numOfColInJKMenuView;

@optional
/**
 获取Single点击的Item

 @param menuBtnIndex meunBtn 的索引
 @param menuString  点击的ItemString
 */
- (void)JKMenuDidSelectedItemWithMenuBtnIndex:(NSInteger)menuBtnIndex menuItem:(NSString*)menuString leftMenuItemString:(NSString *)leftItemString;
@required
/**
 每一列的数据源

 @param menuBtnIndex MenuBtn的索引

 @return 每一列的数据源
 */
- (NSArray*)JKMenuDataSourceAtMenuBtnIndex:(NSInteger)menuBtnIndex;

@optional

/**
 注意：如果实现此方法 且 对应的menuBtnIndex  的JKMenuItemType为JKMenuItemTypeCouple  其数据格式必须为@[@{@"Jackie == 0" : @[@"Jackie == 0 --- 1",
                            @"Jackie == 0 --- 2",
                            @"Jackie == 0 --- 3",
                            @"Jackie == 0 --- 4"]}];否则该工具不可使用

 @param menuBtnIndex 点击的第几个btnIndex

 @return JKMenuView的类型
 */
- (JKMenuItemType)JKMenuItemTypeForRowsAtMenuBtnIndex:(NSInteger)menuBtnIndex;

@end

@interface JKMenuDropView : UIView

/**
 创建菜单视图的构造方法

 @param size 菜单视图的大小尺寸

 @return JKMenuDropView
 */
+ (instancetype)JKMenuDropViewWithSize:(CGSize)size;

/**菜单的主标题*/
@property (nonatomic,strong) NSArray * menuTitles;

@property (nonatomic,weak)id <JKMenuDropViewDelegate> delegate;

/**
 刷新数据 ： 下一阶段完善
 */
//- (void)reloadData;

@end
