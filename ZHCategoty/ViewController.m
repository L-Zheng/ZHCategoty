//
//  ViewController.m
//  ZHCategoty
//
//  Created by 李保征 on 2017/6/22.
//  Copyright © 2017年 李保征. All rights reserved.
//

#import "ViewController.h"
#import "ZHCategoryHeader.h"
#import <CoreText/CoreText.h>
#import <WebKit/WebKit.h>

@interface ViewController ()<UITextFieldDelegate>
@property (nonatomic,strong) UILabel *label;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //依赖#import <CoreText/CoreText.h>框架
    
    UIView *coverView = [[UIView alloc] initWithFrame:self.view.bounds];
    coverView.backgroundColor = [UIColor blueColor];
    
    UIView *view1 = [[UIView alloc] initWithFrame:self.view.bounds];
    view1.backgroundColor = [UIColor orangeColor];
    
    UIView *view2 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 50, 50)];
    view2.backgroundColor = [UIColor cyanColor];
    
    WKWebView *webView = [[WKWebView alloc] initWithFrame:CGRectMake(0, 60, self.view.bounds.size.width, self.view.bounds.size.height - 60)];
    [webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"https://www.baidu.com"]]];
    
    UIView *view3 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 50, 50)];
    view3.backgroundColor = [UIColor redColor];
    
    
    [webView addSubview:view3];
    [view1 addSubview:view2];
    [view1 addSubview:webView];
    [self.view addSubview:view1];
    [self.view addSubview:coverView];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        UIImage *image = [UIImage zh_captureImageWithView:view1];
        NSLog(@"--------------------");
    });
    
    
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
