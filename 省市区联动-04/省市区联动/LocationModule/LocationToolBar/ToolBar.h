//
//  ToolBar.h
//  省市区联动
//
//  Created by Dian Xin on 2019/1/6.
//  Copyright © 2019年 com.ovix. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ToolBar;

@protocol ToolBarDelegate <NSObject>

@required
- (void) toolBarDone:(ToolBar *)toolBar;//要传toolBar button不是一定要传
- (void) toolBarCancel;
@end

@interface ToolBar : UIToolbar

@property (weak, nonatomic) id<ToolBarDelegate> keyBoardDelegate;//代理名delegate会提示UIToolBar已经有了delegate属性 所以这里代理不能用delegate 要换个名字

- (instancetype) makeToolBar;

+ (instancetype) makeToolBar;

@end
