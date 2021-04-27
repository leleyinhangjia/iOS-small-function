//
//  ViewController.m
//  ScrollViewDemo
//
//  Created by 纪明 on 2020/5/28.
//  Copyright © 2020 纪明. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,UIScrollViewDelegate>

@property (nonatomic, strong) UICollectionView    *   collectionView;

@property (nonatomic, strong) UIView              *   bgView;
@property (nonatomic, strong) UIView              *   titleView;
@property (nonatomic, strong) UIScrollView        *   scrollView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"cellID"];
    [self bgView];
    [self titleView];
    [self collectionView];
}
-(UIView *)bgView{
    if (!_bgView) {
        _bgView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 300)];
        _bgView.backgroundColor=[UIColor greenColor];
        [self.view addSubview:_bgView];
    }
    return _bgView;
}
-(UIView *)titleView{
    if (!_titleView) {
        _titleView=[[UIView alloc]initWithFrame:CGRectMake(0, 200, self.view.frame.size.width, 100)];
        _titleView.backgroundColor=[UIColor redColor];
        [self.bgView addSubview:self.titleView];
    }
    return _titleView;
}

#pragma mark - UICollectionViewDelegate
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
  
    return CGSizeMake((self.view.bounds.size.width-30)/2, (self.view.bounds.size.width-30)/2);
  
}

#pragma mark - delegate & dataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
 
        return 10;
   
}
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
   
}
- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    UICollectionViewCell * cell=[collectionView dequeueReusableCellWithReuseIdentifier:@"cellID" forIndexPath:indexPath];
    cell.backgroundColor=[UIColor grayColor];
    cell.layer.cornerRadius=8;
    return  cell;
}

//设置每个item的UIEdgeInsets
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(10, 10, 10, 10 );
}

//设置每个item水平间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 10;
}
//设置每个item垂直间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 10;

}


-(UICollectionView *)collectionView{
    if (!_collectionView) {
        UICollectionViewFlowLayout *stretchyLayout= [UICollectionViewFlowLayout new];
        _collectionView=[[UICollectionView alloc]initWithFrame:CGRectMake(0,0, self.view.frame.size.width, self.view.frame.size.height) collectionViewLayout:stretchyLayout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.alwaysBounceVertical = YES;
        _collectionView.showsVerticalScrollIndicator = NO;
        _collectionView.backgroundColor = [UIColor whiteColor];
        _collectionView.contentInset= UIEdgeInsetsMake(300, 0, 0, 0);
        [_collectionView addObserver:self forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionNew context:nil];
        [self.view addSubview:_collectionView];
    }
    return _collectionView;
}
- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary *)change
                       context:(void *)context
{
    if ([keyPath isEqualToString:@"contentOffset"]) {
        CGPoint offset = [change[NSKeyValueChangeNewKey] CGPointValue];
        NSLog(@"%f",-offset.y);
        if (-offset.y>450) {
              [UIView animateWithDuration:0.5 animations:^{
           self.bgView.frame = CGRectMake(0, 0, self.view.frame.size.width, 500);
                      self.titleView.frame=CGRectMake(0, 400, self.view.frame.size.width, 100);
                       _collectionView.contentInset= UIEdgeInsetsMake(500, 0, 0, 0);
                    }];
             
        }else
        if (-offset.y> 300&&-offset.y<450) {
             [UIView animateWithDuration:0.5 animations:^{
            self.bgView.frame = CGRectMake(0, 0, self.view.frame.size.width, 300);
             self.titleView.frame=CGRectMake(0, 200, self.view.frame.size.width, 100);
             _collectionView.contentInset= UIEdgeInsetsMake(300, 0, 0, 0);
                  }];
        }
        else if (-offset.y > 100 && -offset.y < 300) {
            self.bgView.frame = CGRectMake(0, -offset.y-300, self.view.frame.size.width, 300);
             self.titleView.frame=CGRectMake(0, 200, self.view.frame.size.width, 100);
             _collectionView.contentInset= UIEdgeInsetsMake(300, 0, 0, 0);
        }
        else if (-offset.y <= 100) {
            self.bgView.frame = CGRectMake(0, -200, self.view.frame.size.width, 300);
             self.titleView.frame=CGRectMake(0, 200, self.view.frame.size.width, 100);
             _collectionView.contentInset= UIEdgeInsetsMake(300, 0, 0, 0);
        }
    }
}

- (void)dealloc {
    [_collectionView removeObserver:self forKeyPath:@"contentOffset"];
}
@end
