//
//  SSGestureLockView.h
//  SP2P_7
//
//  Created by quanminqianbao on 2018/8/23.
//

#import <UIKit/UIKit.h>

@class SSGestureLockView;



@protocol SSGestureLockViewDelegate <NSObject>
@optional

- (void)didSelectedGestureLockView:(SSGestureLockView *)gestureLockView keyNumStr:(NSString *)keyNumStr;

@end


@interface SSGestureLockView : UIView
///垂直间隔
@property (nonatomic, assign) CGFloat verticalSpace;
///水平间隔
@property (nonatomic, assign) CGFloat horizontalSpace;
///画线的宽度
@property (nonatomic, assign) CGFloat lineWidth;
///画线的颜色
@property (nonatomic, strong) UIColor *selectedLineColor;
///错误是画线的颜色
@property (nonatomic, strong) UIColor *errorLineColor;
@property (nonatomic, strong) UIColor *normalColor;

@property (nonatomic, weak) id<SSGestureLockViewDelegate>delegate;

@property (nonatomic, assign) BOOL showErrorStatus;///展示错误地状态

@end
