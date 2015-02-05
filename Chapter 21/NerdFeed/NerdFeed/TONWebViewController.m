//
//  TONWebViewController.m
//  NerdFeed
//
//  Created by Tawatchai Sunarat on 2/5/15.
//  Copyright (c) 2015 pddk. All rights reserved.
//

#import "TONWebViewController.h"

@interface TONWebViewController ()

@end

@implementation TONWebViewController

#pragma mark - Initail

-(void)loadView
{
    UIWebView *webView = [[UIWebView alloc] init];
    webView.scalesPageToFit = YES;
    self.view = webView;
}

#pragma mark - web view

-(void)setUrl:(NSURL *)url
{
    _url = url;
    
    if (_url) {
        
        NSURLRequest *req = [NSURLRequest requestWithURL:_url];
        [(UIWebView *)self.view loadRequest:req];
    }
}

@end
