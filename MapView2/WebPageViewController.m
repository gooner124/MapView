//
//  WebPageViewController.m
//  MapView2
//
//  Created by Matthew Paravati on 1/28/16.
//  Copyright © 2016 TurnToTech. All rights reserved.
//

#import "WebPageViewController.h"

@interface WebPageViewController ()


@end


@implementation WebPageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    NSURL *urlToLoad = self.annotationURl;
    NSURLRequest *request = [NSURLRequest requestWithURL:urlToLoad];
    
    WKWebViewConfiguration *theConfiguration = [[WKWebViewConfiguration alloc] init];
    WKWebView *wkWebView = [[WKWebView alloc] initWithFrame:[[UIScreen mainScreen] bounds] configuration:theConfiguration];
    wkWebView.navigationDelegate = self;
    
    [wkWebView loadRequest: request];
    
    [self.view addSubview:wkWebView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
