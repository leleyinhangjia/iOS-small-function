//
//  JKMaskView.h
//  JKMenuDrop
//
//  Created by apple on 2017/2/21.
//  Copyright © 2017年 com.shichuang. All rights reserved.
//

#import <UIKit/UIKit.h>

@class JKMenuDataModel,JKMenuRightTableDataModel;
typedef NS_ENUM(NSInteger, JKMenuDropType) {
    JKMenuDropTypeSingleCol = 0,          /**一个TableView*/
    JKMenuDropTypeTwoCol              /**两个TableView*/
};

@protocol JKMenuDetailViewDelegate <NSObject>

@optional
/**
 改变MenuBtn的选中与非选中状态等
 */
- (void)changeMenuBtnSelectedStatus;
@optional
/**
 选中的单个表格的视图的回调

 @param menuIndex menuBtn的索引
 @param model     回调的数据模型
 @param indexPath Cell的索引
 */
- (void)selectedMenuItemWitnMenuIndex:(NSInteger)menuIndex dataModel:(JKMenuDataModel*)model indexPath:(NSIndexPath*)indexPath;
@optional
/**
 通知向上一个视图 本界面是否是展开的状态

 @param isExpend 是否展开
 */
- (void)menuViewExpendStatus:(BOOL)isExpend;
@optional
/**
 当有两个表格的时候的回调

 @param menuIndex      menuBtn的索引
 @param leftDataModel  左边数据源的模型
 @param leftIndexPath  左边Table的索引
 @param rightDataModel 右边数据源的模型
 @param rightIndexPath 右边数据源的索引
 */
- (void)selectedLeftTableWithMenuIndex:(NSInteger)menuIndex leftDataModel:(JKMenuDataModel *) leftDataModel leftTableIndexPath:(NSIndexPath *)leftIndexPath rightDataModel:(JKMenuRightTableDataModel *) rightDataModel rightDataIndexPath:(NSIndexPath*)rightIndexPath;

@end

@interface JKMenuDetailView : UIView


+(instancetype)JKMenuDetailViewWithSize:(CGSize)size;

/**
 点击按钮的时候改变MainView的尺寸
 */
- (void)changeMainViewWithAnimateClickTheSameBtn:(BOOL)isSame;

@property (nonatomic,weak) id <JKMenuDetailViewDelegate>delegate;

/**点击的第几个MenuIndex*/
@property (nonatomic,assign) NSInteger menuIndex;

/**具体的菜单Menu*/
@property (nonatomic,assign) JKMenuDropType menuType;

/**数据源*/
@property (nonatomic,strong) NSArray * dataArray;

/**具体菜单的标题*/
@property (nonatomic,copy) NSString * menuBtnTitle;

/**单个表格的IndexPath*/
@property (nonatomic,strong) NSIndexPath * singleIndexPath;
/**左边视图的索引*/
@property (nonatomic,assign) NSInteger leftTabIndex;

/**左边视图被选中的字符串*/
@property (nonatomic,copy) NSString * seletedLeftString;

@end
