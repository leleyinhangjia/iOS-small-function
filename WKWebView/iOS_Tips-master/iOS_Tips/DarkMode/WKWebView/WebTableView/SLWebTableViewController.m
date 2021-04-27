//
//  SLWebTableViewController.m
//  DarkMode
//
//  Created by wsl on 2020/5/22.
//  Copyright © 2020 https://github.com/wsl2ls   ----- . All rights reserved.
//

#import "SLWebTableViewController.h"
#import <WebKit/WebKit.h>

@interface SLWebTableViewController ()<UIWebViewDelegate,UIScrollViewDelegate>
@property (strong, nonatomic) UIWebView *webView;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *goBackBtn;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *goForwardBtn;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *freshBtn;
//<UITableViewDelegate,UITableViewDataSource>
//
//@property (nonatomic, strong) WKWebView * webView;
//@property (nonatomic, strong) UITableView *tableView;
/////网页加载进度视图
//@property (nonatomic, strong) UIProgressView * progressView;
///// WKWebView 内容的高度  默认屏幕高
//@property (nonatomic, assign) CGFloat webContentHeight;

@end

@implementation SLWebTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.webView =[[UIWebView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    self.webView.scrollView.scrollEnabled = YES;
    self.webView.scrollView.bounces = NO;
    self.webView.scrollView.delegate = self;
    self.webView.dataDetectorTypes = UIDataDetectorTypeLink;
       [self.webView setScalesPageToFit:YES];
       [self.webView setBackgroundColor:[UIColor whiteColor]];
       [self.webView.scrollView setShowsVerticalScrollIndicator:YES];
       [self.webView.scrollView setShowsHorizontalScrollIndicator:YES];
       [self.webView setAllowsInlineMediaPlayback:YES];
       [self.webView setMediaPlaybackRequiresUserAction:NO];
       
    [self.view addSubview:self.webView];
    
    // Do any additional setup after loading the view, typically from a nib.
    NSURL *url = [NSURL URLWithString:@"http://wxkf.wdxuexi.com:8010/upload/file/202010/CourseWareFile/20201016171255287508a43ba8c855c63c68/index.pdf"];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    // 加载网站
    [self.webView loadRequest:request];
    // 设置代理
    self.webView.delegate = self;

}
//
// - (void)viewDidLayoutSubviews
//{
//    NSArray* a = [self.webView.scrollView subviews];
//    for (UIView* view in a) {
//        if ([view isKindOfClass:NSClassFromString(@"UIWebPDFView")]) {
//            NSArray* b = view.subviews;
//
//            UIView* last = [b firstObject];
//            if ([last isKindOfClass:NSClassFromString(@"UIPDFPageView")]) {
//                //add an sign view in front of pdf page
//                CGRect newRect = [view convertRect:last.bounds fromView:last];
//                [self.signView setFrame:newRect];
//                [view addSubview:self.signView];
//            }
//        }
//    }
//
//    [self.okBtn setEnabled:YES];
//    [self.signPdfBtn setEnabled:YES];
//    self.content_hetght = self.webView.scrollView.contentSize.height;
//    self.content_num = [self getTotalPDFPages:self.fileName];
//    self.page_height = self.content_hetght / self.content_num;
//}


- (IBAction)backBtnClick:(id)sender {
    [self.webView goBack];
}
- (IBAction)goForwardBtnClick:(id)sender {
    [self.webView goForward];
}
- (IBAction)freshBtnClick:(id)sender {
    [self.webView reload];
}

#pragma mark - UIWebViewDelegate
// 开始加载网页的时候调用
- (void)webViewDidStartLoad:(UIWebView *)webView
{
    NSLog(@"%s", __func__);
}
// 加载完成的时候调用
- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    NSLog(@"%s", __func__);
    self.goBackBtn.enabled = webView.canGoBack;
    self.goForwardBtn.enabled = webView.canGoForward;
    int count = self.webView.pageCount;
    
     // 禁用用户选择
     [webView stringByEvaluatingJavaScriptFromString:@"document.documentElement.style.webkitUserSelect='none';"];
     
     // 禁用长按弹出框
     [webView stringByEvaluatingJavaScriptFromString:@"document.documentElement.style.webkitTouchCallout='none';"];
}
// 加载失败的时候调用
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    NSLog(@"%s", __func__);
}
// 即将加载某个请求的时候调用
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    NSLog(@"%@", request.URL.absoluteString);
    NSString *strM = request.URL.absoluteString;
    if ( [strM containsString:@"image"] )
    {
        return NO;
    }
    return YES;
}



//- (void)viewDidLoad {
//    [super viewDidLoad];
//    [self setupUi];
//    [self addKVO];
//}
//- (void)viewWillDisappear:(BOOL)animated {
//    [super viewWillDisappear:animated];
//    [self.progressView removeFromSuperview];
//}
//- (void)dealloc {
//    [self removeKVO];
//}
//
//#pragma mark - SetupUI
//- (void)setupUi {
//    self.title = @"WKWebView+UITableView（方案1）";
//    self.view.backgroundColor = [UIColor whiteColor];
//    [self.view addSubview:self.tableView];
//    [self configureWebTable];
//}
//- (void)configureWebTable {
//    self.webView.sl_height = _webContentHeight == 0 ? SL_kScreenHeight : _webContentHeight;
//    self.tableView.tableHeaderView = self.webView;
//}
//
//#pragma mark - Getter
//- (UITableView *)tableView {
//    if (_tableView == nil) {
//        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SL_kScreenWidth, SL_kScreenHeight) style:UITableViewStyleGrouped];
//        _tableView.delegate = self;
//        _tableView.dataSource = self;
//        _tableView.estimatedRowHeight = 1;
//        if (@available(iOS 11.0, *)) {
//            _tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
//        } else {
//            self.automaticallyAdjustsScrollViewInsets = NO;
//        }
//    }
//    return _tableView;
//}
//- (WKWebView *)webView {
//    if(_webView == nil){
//        //创建网页配置
//        WKWebViewConfiguration *config = [[WKWebViewConfiguration alloc] init];
//        _webView = [[WKWebView alloc] initWithFrame:CGRectMake(0, 0, SL_kScreenWidth, SL_kScreenHeight) configuration:config];
//        if (@available(iOS 11.0, *)) {
//            _webView.scrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
//        } else {
//            self.automaticallyAdjustsScrollViewInsets = NO;
//        }
//        NSString *path = [[NSBundle mainBundle] pathForResource:@"WebTableView.html" ofType:nil];
//        NSString *htmlString = [[NSString alloc]initWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
//        [_webView loadHTMLString:htmlString baseURL:[NSURL fileURLWithPath:[[NSBundle mainBundle] bundlePath]]];
//    }
//    return _webView;
//}
//- (UIProgressView *)progressView {
//    if (!_progressView){
//        _progressView = [[UIProgressView alloc] initWithFrame:CGRectMake(0, 0, SL_kScreenWidth, 2)];
//        _progressView.tintColor = [UIColor blueColor];
//        _progressView.trackTintColor = [UIColor clearColor];
//    }
//    if (_progressView.superview == nil) {
//        [self.navigationController.navigationBar addSubview:_progressView];
//    }
//    return _progressView;
//}
//
//#pragma mark - KVO
/////添加键值对监听
//- (void)addKVO {
//    //监听网页加载进度
//    [self.webView addObserver:self
//                   forKeyPath:NSStringFromSelector(@selector(estimatedProgress))
//                      options:NSKeyValueObservingOptionNew
//                      context:nil];
//    //监听网页内容高度
//    [self.webView.scrollView addObserver:self
//                              forKeyPath:@"contentSize"
//                                 options:NSKeyValueObservingOptionNew
//                                 context:nil];
//}
/////移除监听
//- (void)removeKVO {
//    //移除观察者
//    [_webView removeObserver:self
//                  forKeyPath:NSStringFromSelector(@selector(estimatedProgress))];
//    [_webView.scrollView removeObserver:self
//                             forKeyPath:NSStringFromSelector(@selector(contentSize))];
//}
////kvo监听 必须实现此方法
//-(void)observeValueForKeyPath:(NSString *)keyPath
//                     ofObject:(id)object
//                       change:(NSDictionary<NSKeyValueChangeKey,id> *)change
//                      context:(void *)context{
//
//    if ([keyPath isEqualToString:NSStringFromSelector(@selector(estimatedProgress))]
//        && object == _webView) {
//        //        NSLog(@"网页加载进度 = %f",_webView.estimatedProgress);
//        self.progressView.progress = _webView.estimatedProgress;
//        if (_webView.estimatedProgress >= 1.0f) {
//            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//                self.progressView.progress = 0;
//            });
//        }
//    }else if ([keyPath isEqualToString:NSStringFromSelector(@selector(contentSize))]
//              && object == _webView.scrollView && _webContentHeight != _webView.scrollView.contentSize.height) {
//        _webContentHeight = _webView.scrollView.contentSize.height;
//        [self configureWebTable];
//        NSLog(@"WebViewContentSize = %@",NSStringFromCGSize(_webView.scrollView.contentSize))
//    }
//}
//
//#pragma mark - UIScrollViewDelegate
//- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
//}
//#pragma mark - UITableViewDelegate,UITableViewDataSource
//- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
//    return 1;
//}
//- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//    return 20;
//}
//- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
//    return 44;
//}
//- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
//    return 0.1;
//}
//- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
//    return nil;
//}
//- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
//    UILabel *label = [UILabel new];
//    label.text = @"评论";
//    label.textColor = UIColor.whiteColor;
//    label.textAlignment = NSTextAlignmentCenter;
//    label.backgroundColor = [UIColor orangeColor];
//    return label;
//}
//- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
//    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cellId"];
//    if (!cell) {
//        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cellId"];
//    }
//    cell.detailTextLabel.numberOfLines = 0;
//    cell.textLabel.text = [NSString stringWithFormat:@"第%ld条评论",(long)indexPath.row];
//    cell.detailTextLabel.text = @"方案1：WebView作为TableView的Header, 撑开webView，显示渲染全部内容，当内容过多时，比如大量图片时，容易造成内存暴涨（不建议使用）";
//    return cell;
//}
//- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
//    [tableView deselectRowAtIndexPath:indexPath animated:YES];
//}

@end
