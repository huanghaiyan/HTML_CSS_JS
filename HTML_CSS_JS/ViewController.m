//
//  ViewController.m
//  HTML_CSS_JS
//
//  Created by fans on 15/11/29.
//  Copyright © 2015年 FF. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()<UIWebViewDelegate>

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.webView.delegate = self;
    NSURL * baseUrl = [NSURL fileURLWithPath:[[NSBundle mainBundle] bundlePath]];
    NSString * path = [[NSBundle mainBundle] pathForResource:@"index" ofType:@"html"];
    NSString * html = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
    [self.webView loadHTMLString:html baseURL:baseUrl];// web View 加载本地文件

// ************** web ***************
//    NSURL * webURL = [NSURL URLWithString:@"http://localhost/www/"];
//    NSURLRequest * request  =[NSURLRequest requestWithURL:webURL];
//    [self.webView loadRequest:request];

}
- (void)webViewDidStartLoad:(UIWebView *)webView{
    NSLog(@"web request start!");
}
- (void)webViewDidFinishLoad:(UIWebView *)webView{
    NSLog(@"finished!");

}
- (void)webView:(UIWebView *)webView didFailLoadWithError:(nullable NSError *)error{
    NSLog(@"did faild with error\n%@!",error);
}

// 异步操作 JS调用OC代码
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{

    NSURL * url = [request URL];
    if ([[url scheme] isEqualToString:@"devzeng"])  {
         //处理JavaScript和Objective-C交互
        if ([[url host] isEqualToString:@"login"]) {
            NSDictionary * parameters = [self getPramas:[url query]];
            BOOL status = [self login:[parameters objectForKey:@"name"] password:[parameters objectForKey:@"password"]];
            if (status) {
                //调用JS回调
                // 同步操作 OC调用JS代码
                [self.webView stringByEvaluatingJavaScriptFromString:@"confirm('登录成功')"];
                [self.webView stringByEvaluatingJavaScriptFromString:@"confirm('登录成功')"];
            }else{
                [self.webView stringByEvaluatingJavaScriptFromString:@"alert('登录失败')"];
            }
        }
        
        [self normalJSMothed:webView];
        return NO;
    }
    return YES;
}
- (void)normalJSMothed:(UIWebView *)webView{
// 获取页面title
    NSString * title = [webView stringByEvaluatingJavaScriptFromString:@"document.title"];
    NSLog(@"web view title is ==>%@",title);
    
    NSString * url = [webView stringByEvaluatingJavaScriptFromString:@"document.location.href"];
    NSLog(@"the web view url is ==> %@",url);
}
- (NSDictionary*)getPramas:(NSString*)dic{
    return nil;
}
- (BOOL)login:(NSString*)name password:(NSString *)password{
    return YES;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)runAction:(id)sender {
}
@end
