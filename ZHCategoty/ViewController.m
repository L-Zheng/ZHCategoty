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

@interface ViewController ()<UITextFieldDelegate>
@property (nonatomic,strong) UILabel *label;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //依赖#import <CoreText/CoreText.h>框架
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
