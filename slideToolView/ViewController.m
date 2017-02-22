//
//  ViewController.m
//  slideToolView
//
//  Created by 张辉男 on 17/2/20.
//  Copyright © 2017年 zhn. All rights reserved.
//

#import "ViewController.h"
#import "ZHNSlideToolView.h"
@interface ViewController ()
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    UIScrollView *contentScrollView = [[UIScrollView alloc]init];
    contentScrollView.backgroundColor = [UIColor yellowColor];
    [self.view addSubview:contentScrollView];
    contentScrollView.frame = CGRectMake(10, 200, 200, 100);
    contentScrollView.contentSize = CGSizeMake(1000, 100);
    contentScrollView.pagingEnabled = YES;
    
    ZHNSlideToolView *toolView = [ZHNSlideToolView slideWithContentScrollView:contentScrollView sliderTitleArray:@[@"dadada",@"3131",@"1313131",@"1",@"3333kkkk"]];
//    toolView.isAutoPaddingAndInset = YES;
    toolView.isSliderFitTitleSize = YES;
    toolView.padding = 50;
    toolView.titleFont = 20;
    toolView.LeftRightcontentInset = 30;
    toolView.sliderColor = [UIColor blueColor];
    toolView.sliderPadding = 10;
    toolView.normalTitleColor = (ZHNslideCustomColor){100,200,150};
    toolView.highlightTitleColor = (ZHNslideCustomColor){200,200,200};
    [self.view addSubview:toolView];
    toolView.frame = CGRectMake(100, 100, 200, 50);
    toolView.backgroundColor = [UIColor redColor];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
