//
//  MCViewController.m
//  tableview悬浮userCenter
//  QQ:287929070
//  Created by lujh on 16/4/19.
//  Copyright © 2016年 MuChen. All rights reserved.
//  QQ:287929070
#define TableViewSectionHeaderHeight 246
#import "MCViewController.h"
#import "JKMenuDropView.h"
@interface MCViewController()<UIScrollViewDelegate,UITableViewDelegate,UITableViewDataSource,JKMenuDropViewDelegate>

@end

@implementation MCViewController


-(void)viewDidLoad{
    
    self.navigationController.navigationBar.translucent = NO;
    
    self.title = @"tableView悬浮";
    
    // 初始化TableView
    [self setUpTableView];
    
    // 设置tableview的偏移量为-200通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(setTableViewContenInset) name:@"kSetTableViewContentInsetNSNotification" object:nil];
    
    // 设置tableview的偏移量为0通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(setBackTableViewContenInset) name:@"kSetBackTableViewContentInsetNSNotification" object:nil];

}

#pragma mark -设置tableview的偏移量通知

- (void)setTableViewContenInset {

    [self.tableView setContentInset:UIEdgeInsetsMake(-TableViewSectionHeaderHeight, 0, 0, 0)];

}

- (void)setBackTableViewContenInset {

     [self.tableView setContentInset:UIEdgeInsetsMake(0, 0, 0, 0)];

}

#pragma mark -初始化TableView

- (void)setUpTableView {

    // tableView
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 64) style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
    
    // tableView头视图
    _headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, TableViewSectionHeaderHeight)];
    _headerView.backgroundColor = [UIColor cyanColor];
    self.tableView.tableHeaderView = _headerView;
    
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:_headerView.frame];
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    imageView.image = [UIImage imageNamed:@"1.jpg"];
    [_headerView addSubview:imageView];
   
}

#pragma mark -UITableViewDataSource

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    
    if(tableView == self.tableView && section == 0){
        return 44;
    }else{
        return 0;
    }
    
}

-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    if(tableView == self.tableView && section == 0){
        
        
        CGFloat deviceWidth = [UIScreen mainScreen].bounds.size.width;
        CGSize size = CGSizeMake(deviceWidth, 44.0f);
        JKMenuDropView * menuView = [JKMenuDropView JKMenuDropViewWithSize:size];
        menuView.menuTitles = @[@"全部",@"附近",@"智能排序",@"筛选"];
        menuView.delegate = self;
        return menuView;
        
    }else {
        
        return nil;
    }
    
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return 20;
    
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *ID = @"DynamicViewCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    
    if (cell == nil) {
        
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
        cell.textLabel.text = [NSString stringWithFormat:@"第%ld行",indexPath.row];
        
    }
    
    return cell;
}

- (void) tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    CATransform3D rotation;
    
    
    rotation = CATransform3DMakeRotation( (90.0*M_PI)/180, 0.0, 0.7, 0.4);
    rotation.m34 = 1.0/ -600;
    cell.layer.transform = rotation;
    cell.layer.shadowColor = [[UIColor blackColor]CGColor];
    cell.layer.shadowOffset = CGSizeMake(10, 10);
    cell.alpha = 0;
    
    //    cell.layer.anchorPoint = CGPointMake(0, 0.5);
    
    [UIView beginAnimations:@"rotation" context:NULL];
    [UIView setAnimationDuration:0.8];
    cell.layer.transform = CATransform3DIdentity;
    cell.alpha = 1;
    cell.layer.shadowOffset = CGSizeMake(0, 0);
    [UIView commitAnimations];
    
}

#pragma mark -JKMenuDropViewDelegate

- (NSInteger)numOfColInJKMenuView{
    
    return 4;
}

- (NSArray *)JKMenuDataSourceAtMenuBtnIndex:(NSInteger)menuBtnIndex{
    
    if (menuBtnIndex == 0) {
        return @[@{@"Jackie  0" : @[@"Jackie  0 - 1",
                                    @"Jackie  0 - 2",
                                    @"Jackie  0 - 3",
                                    @"Jackie  0 - 4",]},
                 @{@"Jackie  1" : @[@"Jackie  1 - 1",
                                    @"Jackie  1 - 2",
                                    @"Jackie  1 - 3",
                                    @"Jackie  1 - 4",]},
                 @{@"Jackie  2" : @[@"Jackie  2 - 1",
                                    @"Jackie  2 - 2",
                                    @"Jackie  2 - 3",
                                    @"Jackie  2 - 4",]},
                 @{@"Jackie  3" : @[@"Jackie  3 - 1",
                                    @"Jackie  3 - 2",
                                    @"Jackie  3 - 3",
                                    @"Jackie  3 - 4",]},
                 @{@"Jackie  4" : @[@"Jackie  4 - 1",
                                    @"Jackie  4 - 2",
                                    @"Jackie  4 - 3",
                                    @"Jackie  4 - 4",]}];
    } else if (menuBtnIndex == 1) {
        return @[@"Jackie1 == 1",@"Jackie1 ==2",@"Jackie1 ==3",@"Jackie1 ==4",@"Jackie1 ==5"];
    } else if (menuBtnIndex == 2) {
        return @[@"Jackie2 ==1",@"Jackie2 ==2",@"Jackie2 ==3",@"Jackie2 ==4",@"Jackie2 ==5"];
    } else  {
        return @[@"Jackie3 ==1",@"Jackie3 ==2",@"Jackie3 ==3",@"Jackie3 ==4",@"Jackie3 ==5"];
    }
}

#pragma mark -选中的Item

- (void)JKMenuDidSelectedItemWithMenuBtnIndex:(NSInteger)menuBtnIndex menuItem:(NSString *)menuString leftMenuItemString:(NSString *)leftItemString{
    
    [self.tableView setContentInset:UIEdgeInsetsMake(0, 0, 0, 0)];
    
    NSString * selectedString = [NSString stringWithFormat:@"\n输出如下:\n menuBtnIndex == %zd  \n menuString == %@  \n leftItemString == %@",menuBtnIndex,menuString,leftItemString];
}

#pragma mark -是单个TableView还是多个

- (JKMenuItemType)JKMenuItemTypeForRowsAtMenuBtnIndex:(NSInteger)menuBtnIndex{
    
    if (menuBtnIndex == 0) {
        
        return JKMenuItemTypeCouple;
        
    } else {
        
        return JKMenuItemTypeSingle;
        
    }
}

- (void)dealloc {

    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
}

@end










