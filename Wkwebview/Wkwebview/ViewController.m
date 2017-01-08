//
//  ViewController.m
//  Wkwebview
//
//  Created by hu lianghai on 2017/1/8.
//  Copyright © 2017年 hu lianghai. All rights reserved.
//

#import "ViewController.h"
#import <WebKit/WebKit.h>
#import <SDWebImage/UIImageView+WebCache.h>

@interface ViewController ()<WKNavigationDelegate>
@property(nonatomic,strong) WKWebView *webView;
@property(nonatomic,strong) UIImageView *imageView;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initWebView];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources wkthat can be recreated.
}


- (void)initWebView {
    self.webView = [[WKWebView alloc]initWithFrame:self.view.bounds];
    [self.view addSubview:self.webView];
    
    NSURL *url = [NSURL URLWithString:@"https://www.xiongmaojinku.com/frontend/article/484"];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [self.webView loadRequest:request];
    self.webView.navigationDelegate = self;
    
    // ImageView
//    self.imageView = [[UIImageView alloc] initWithFrame:self.view.bounds];
//    [self.view addSubview:self.imageView];
//    self.imageView.alpha = 0.f;

}

- (void)tapAction:(id)sender {
    [UIView animateWithDuration:0.2f animations:^{
        [self.imageView removeFromSuperview];
    }];
}

#pragma mark wknavigationDelegate 
- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler {
    NSURLRequest *request = navigationAction.request;
    if ([request.URL.scheme isEqualToString:@"image-preview"]) {
        // 获得图片地址
        NSString *path = [request.URL.absoluteString substringFromIndex:[@"image-preview:" length]];
        

        self.imageView = [[UIImageView alloc] initWithFrame:self.view.bounds];
        self.imageView.backgroundColor = [UIColor blackColor];
        self.imageView.contentMode = UIViewContentModeCenter;
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
        [self.imageView addGestureRecognizer:tapGesture];
        self.imageView.userInteractionEnabled = YES;
        
        [self.imageView sd_setImageWithURL:[NSURL URLWithString:path] placeholderImage:[UIImage imageNamed:@"default"] completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
            [UIView animateWithDuration:0.2f animations:^{
                [self.view addSubview:self.imageView];
            }];
        }];
     
    }
    decisionHandler(WKNavigationActionPolicyAllow);
}

- (void)webView:(WKWebView *)webView didFinishNavigation:(null_unspecified WKNavigation *)navigation {
    [self.webView evaluateJavaScript:@"function assignImageClickAction(){var imgs=document.getElementsByTagName('img');var length=imgs.length;for(var i=0;i<length;i++){img=imgs[i];img.onclick=function(){window.location.href='image-preview:'+this.src}}}" completionHandler:nil];
    
    [self.webView evaluateJavaScript:@"assignImageClickAction();" completionHandler:nil];
}

@end
